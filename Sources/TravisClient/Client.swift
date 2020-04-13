import Dispatch
import Foundation
@_exported import TravisV3Core
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// API Client for talking to the travis v3 api.
public class TravisClient {
    public typealias MetadataCompletion<T: Codable> = (Result<Metadata<T>, TravisError>) -> Void
    public typealias ActionCompletion<T: Codable> = (Result<Action<T>, TravisError>) -> Void

    typealias ResultCompletion<T: Codable> = (Result<T, TravisError>) -> Void

    private let session: URLSession
    private let host: TravisEndpoint
    private let completionQueue: DispatchQueue

    /// Create a TravisClient to interact with the API
    ///
    /// - Parameters:
    ///   - token: Your travis api token
    ///   - host: .org, .pro or .enterprise("custom.url")
    ///   - session: Optional URLSession for dependency injection
    public init(token: String, host: TravisEndpoint = .org, session: URLSession? = nil, queue: DispatchQueue = .main) {
        self.host = host
        self.session = session ?? URLSession(configuration: TravisClient.makeConfiguration(withToken: token))
        completionQueue = queue
    }

    // MARK: Repositories

    /// Fetch the repositories for a github user.
    ///
    /// - Parameters:
    ///   - owner: The github username or ID
    ///   - completion: Either a Meta<[Repository]> or a TravisError
    public func repositories(forOwner owner: String, query: GeneralQuery? = nil, completion: @escaping MetadataCompletion<[Repository]>) {
        let url = makeURL(path: "/owner/\(owner.pathEscape())/repos", query: query)
        request(url, completion: completion)
    }

    /// Fetch the repositories for the current user
    ///
    /// - Parameter completion: Either a Meta<[Repository]> or a TravisError
    public func userRepositories(query: GeneralQuery? = nil, completion: @escaping MetadataCompletion<[Repository]>) {
        let url = makeURL(path: "/repos", query: query)
        request(url, completion: completion)
    }

    // MARK: Active

    /// Fetch the active builds for the current user
    ///
    /// - Parameter completion: Either a Meta<[Build]> or a TravisError
    public func userActiveBuilds(query: BuildQuery?, completion: @escaping MetadataCompletion<[Build]>) {
        let url = makeURL(path: "/active", query: query)
        request(url, completion: completion)
    }

    // MARK: Jobs

    public func jobs(forBuild identfier: String, query: GeneralQuery? = nil, completion: @escaping MetadataCompletion<[Job]>) {
        let url = makeURL(path: "/build/\(identfier.pathEscape())/jobs", query: query)
        request(url, completion: completion)
    }

    public func job(withIdentifier identifier: String, completion: @escaping MetadataCompletion<Job>) {
        let url = makeURL(path: "/job/\(identifier)")
        request(url, completion: completion)
    }

    // TODO: Add restart & cancel job

    // MARK: Branches

    public func branches(forBuild identfier: String, query: GeneralQuery? = nil, completion: @escaping MetadataCompletion<[Branch]>) {
        let url = makeURL(path: "/repo/\(identfier.pathEscape())/branchs", query: query)
        request(url, completion: completion)
    }

    public func branch(forRepo repoIdentifier: String,
                       withIdentifier identifier: String,
                       completion: @escaping MetadataCompletion<Branch>) {
        let url = makeURL(path: "/repo/\(repoIdentifier.pathEscape())/branch/\(identifier.pathEscape())")
        request(url, completion: completion)
    }

    // MARK: Repository

    public func repository(_ idOrSlug: String, completion: @escaping MetadataCompletion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())", method: .post)
        request(url, completion: completion)
    }

    public func activateRepository(_ idOrSlug: String, completion: @escaping MetadataCompletion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/activate", method: .post)
        request(url, completion: completion)
    }

    public func deactivateRepository(_ idOrSlug: String, completion: @escaping MetadataCompletion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/deactivate", method: .post)
        request(url, completion: completion)
    }

    public func starRepository(_ idOrSlug: String, completion: @escaping MetadataCompletion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/star", method: .post)
        request(url, completion: completion)
    }

    public func unstarRepository(_ idOrSlug: String, completion: @escaping MetadataCompletion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/unstar", method: .post)
        request(url, completion: completion)
    }

    // MARK: Builds

    public func userBuilds(query: BuildQuery? = nil, completion: @escaping MetadataCompletion<[Build]>) {
        let url = makeURL(path: "/builds", query: query)
        request(url, completion: completion)
    }

    public func builds(forRepository repoIdOrSlug: String, query: BuildQuery? = nil, completion: @escaping MetadataCompletion<[Build]>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/builds", query: query)
        request(url, completion: completion)
    }

    public func log(forJob jobIdentifier: String, completion: @escaping MetadataCompletion<Log>) {
        let url = makeURL(path: "/job/\(jobIdentifier.pathEscape())/log")
        request(url, completion: completion)
    }

    // MARK: Build

    public func build(identifier: String, completion: @escaping MetadataCompletion<Build>) {
        let url = makeURL(path: "/build/\(identifier)")
        request(url, completion: completion)
    }

    public func restartBuild(identifier: String, completion: @escaping ActionCompletion<MinimalBuild>) {
        let url = makeURL(path: "/build/\(identifier)/restart", method: .post)
        request(url, completion: completion)
    }

    public func cancelBuild(identifier: String, completion: @escaping MetadataCompletion<MinimalBuild>) {
        let url = makeURL(path: "/build/\(identifier)/cancel", method: .post)
        request(url, completion: completion)
    }

    // MARK: Env variables

    public func environmentVariables(forRepository repoIdOrSlug: String, completion: @escaping MetadataCompletion<[EnvironmentVariable]>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_vars")
        request(url, completion: completion)
    }

    public func create(_ env: EnvironmentVariableRequest,
                       forRepository repoIdOrSlug: String,
                       completion: @escaping MetadataCompletion<EnvironmentVariable>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_vars",
                          method: .post,
                          encodable: env)
        request(url, completion: completion)
    }

    public func update(_ env: EnvironmentVariableRequest,
                       environmentVariableIdentifier: String,
                       forRepository repoIdOrSlug: String,
                       completion: @escaping MetadataCompletion<EnvironmentVariable>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_var/\(environmentVariableIdentifier)", method: .patch, encodable: env)
        request(url, completion: completion)
    }

    public func delete(environmentVariableIdentifier: String,
                       forRepository repoIdOrSlug: String,
                       completion: @escaping MetadataCompletion<EnvironmentVariable>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_var/\(environmentVariableIdentifier)", method: .delete)
        request(url, completion: completion)
    }

    // MARK: Settings

    public func settings(forRepository repoIdOrSlug: String,
                         completion: @escaping MetadataCompletion<[Setting]>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/settings")
        request(url, completion: completion)
    }

    // MARK: Links

    public func follow<T: Minimal>(embed: Embed<T>, completion: @escaping MetadataCompletion<T.Full>) {
        guard let path = embed.path else { return }
        let url = makeURL(path: path)
        request(url, completion: completion)
    }

    public func follow<T>(page: Page<T>, completion: @escaping MetadataCompletion<T>) {
        guard let components = URLComponents(string: page.path.rawValue) else {
            let result = Result<Metadata<T>, TravisError>.failure(.notPathEscapable)
            onQueue(completionQueue, completion: completion, result: result)
            return
        }

        let url = makeURL(path: components.percentEncodedPath, query: components.queryItems)
        request(url, completion: completion)
    }

    // MARK: Requests

    func request<T>(_ url: URLRequest, completion: @escaping MetadataCompletion<T>) {
        concreteRequest(url, completion: completion)
    }

    func request<T>(_ url: URLRequest, completion: @escaping ActionCompletion<T>) {
        concreteRequest(url, completion: completion)
    }

    func concreteRequest<T: Codable>(_ url: URLRequest, completion: @escaping ResultCompletion<T>) {
        session.dataTask(with: url) { [weak self] data, _, _ in
            guard let someData = data else {
                let result: Result<T, TravisError> = .failure(.noData)
                onQueue(self?.completionQueue, completion: completion, result: result)
                return
            }

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601

            do {
                let result = try jsonDecoder.decode(T.self, from: someData)
                onQueue(self?.completionQueue, completion: completion, result: .success(result))
            } catch {
                let wrappedError: TravisError
                if let travisMessage = try? jsonDecoder.decode(TravisErrorMessage.self, from: someData) {
                    wrappedError = TravisError.travis(travisMessage)
                } else {
                    wrappedError = TravisError.unableToDecode(error: error)
                }
                let result: Result<T, TravisError> = .failure(wrappedError)
                onQueue(self?.completionQueue, completion: completion, result: result)
            }
        }.resume()
    }
}

extension TravisClient {
    public static func makeConfiguration(withToken token: String) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Travis-API-Version": "3",
            "Authorization": "token \(token)",
            "User-Agent": "TravisClientSwift",
        ]

        return configuration
    }
}

extension TravisClient {
    func makeURL<Query: QueryConvertible>(path: String, query: Query? = nil, method: HTTPMethod = .get) -> URLRequest {
        let queryItems = query?.queryItems
        return makeURL(path: path, query: queryItems, method: method)
    }

    func makeURL<T: Encodable>(path: String, method: HTTPMethod = .get, encodable: T) -> URLRequest {
        var request = makeURL(path: path, method: method)
        request.httpBody = try? JSONEncoder().encode(encodable)
        return request
    }

    func makeURL(path: String, query: [URLQueryItem]? = nil, method: HTTPMethod = .get) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.host
        components.percentEncodedPath = path
        components.queryItems = query

        var request = URLRequest(url: components.url!)
        request.httpMethod = method.method
        return request
    }
}

enum HTTPMethod {
    case get
    case post
    case patch
    case delete

    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        }
    }
}

extension String {
    func pathEscape() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}

func onQueue<T: Codable>(_ queue: DispatchQueue?, completion: @escaping TravisClient.ResultCompletion<T>, result: Result<T, TravisError>) {
    if let theQueue = queue {
        theQueue.async { completion(result) }
    } else {
        completion(result)
    }
}
