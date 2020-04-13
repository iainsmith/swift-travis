import AsyncHTTPClient
import Foundation
import NIO
import NIOHTTP1
@_exported import TravisV3Core
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// API Client for talking to the travis v3 api.
public class TravisClient {
    typealias Request = HTTPClient.Request
    public typealias TravisResult<T: Codable> = Result<T, TravisError>
    public typealias MetaDataFuture<T: Codable> = EventLoopFuture<Metadata<T>>
    public typealias ActionFuture<T: Codable> = EventLoopFuture<Action<T>>

    private let session: HTTPClient
    private let ownsEventLoop: Bool
    private let host: TravisEndpoint
    private let headers: [(String, String)]

    /// Create a TravisClient to interact with the API
    ///
    /// - Parameters:
    ///   - token: Your travis api token
    ///   - host: .org, .pro or .enterprise("custom.url")
    ///   - session: Optional HTTPClient for dependency injection
    public init(token: String, host: TravisEndpoint = .org, eventLoopGroup: EventLoopGroup? = nil) {
        self.host = host
        let provider: HTTPClient.EventLoopGroupProvider
        if let group = eventLoopGroup {
            provider = .shared(group)
            ownsEventLoop = false
        } else {
            provider = .createNew
            ownsEventLoop = true
        }
        session = HTTPClient(eventLoopGroupProvider: provider)
        headers = standardHeaders(token: token)
    }

    // MARK: Repositories

    /// Fetch the repositories for a github user.
    ///
    /// - Parameters:
    ///   - owner: The github username or ID
    public func repositories(forOwner owner: String, query: GeneralQuery? = nil) -> MetaDataFuture<[Repository]> {
        let url = makeURL(path: "/owner/\(owner.pathEscape())/repos", query: query)
        return request(url)
    }

    /// Fetch the repositories for the current user
    ///
    /// - Parameter completion: Either a Meta<[Repository]> or a TravisError
    public func userRepositories(query: GeneralQuery? = nil) -> MetaDataFuture<[Repository]> {
        let url = makeURL(path: "/repos", query: query)
        return request(url)
    }

    // MARK: Active

    /// Fetch the active builds for the current user
    ///
    /// - Parameter completion: Either a Meta<[Build]> or a TravisError
    public func userActiveBuilds(query: BuildQuery?) -> MetaDataFuture<[Build]> {
        let url = makeURL(path: "/active", query: query)
        return request(url)
    }

    // MARK: Jobs

    public func jobs(forBuild identfier: String, query: GeneralQuery? = nil) -> MetaDataFuture<[Job]> {
        let url = makeURL(path: "/build/\(identfier.pathEscape())/jobs", query: query)
        return request(url)
    }

    public func job(withIdentifier identifier: String) -> MetaDataFuture<Job> {
        let url = makeURL(path: "/job/\(identifier)")
        return request(url)
    }

    // TODO: Add restart & cancel job

    // MARK: Branches

    public func branches(forBuild identfier: String, query: GeneralQuery? = nil) -> MetaDataFuture<[Branch]> {
        let url = makeURL(path: "/repo/\(identfier.pathEscape())/branchs", query: query)
        return request(url)
    }

    public func branch(forRepo repoIdentifier: String,
                       withIdentifier identifier: String) -> MetaDataFuture<Branch> {
        let url = makeURL(path: "/repo/\(repoIdentifier.pathEscape())/branch/\(identifier.pathEscape())")
        return request(url)
    }

    // MARK: Repository

    public func repository(_ idOrSlug: String) -> MetaDataFuture<Repository> {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())", method: .POST)
        return request(url)
    }

    public func activateRepository(_ idOrSlug: String) -> MetaDataFuture<Repository> {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/activate", method: .POST)
        return request(url)
    }

    public func deactivateRepository(_ idOrSlug: String) -> MetaDataFuture<Repository> {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/deactivate", method: .POST)
        return request(url)
    }

    public func starRepository(_ idOrSlug: String) -> MetaDataFuture<Repository> {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/star", method: .POST)
        return request(url)
    }

    public func unstarRepository(_ idOrSlug: String) -> MetaDataFuture<Repository> {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/unstar", method: .POST)
        return request(url)
    }

    // MARK: Builds

    public func userBuilds(query: BuildQuery? = nil) -> MetaDataFuture<[Build]> {
        let url = makeURL(path: "/builds", query: query)
        return request(url)
    }

    public func builds(forRepository repoIdOrSlug: String, query: BuildQuery? = nil) -> MetaDataFuture<[Build]> {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/builds", query: query)
        return request(url)
    }

    public func log(forJob jobIdentifier: String) -> MetaDataFuture<Log> {
        let url = makeURL(path: "/job/\(jobIdentifier.pathEscape())/log")
        return request(url)
    }

    // MARK: Build

    public func build(identifier: String) -> MetaDataFuture<Build> {
        let url = makeURL(path: "/build/\(identifier)")
        return request(url)
    }

    public func restartBuild(identifier: String) -> ActionFuture<Build> {
        let url = makeURL(path: "/build/\(identifier)/restart", method: .POST)
        return request(url)
    }

    public func cancelBuild(identifier: String) -> MetaDataFuture<MinimalBuild> {
        let url = makeURL(path: "/build/\(identifier)/cancel", method: .POST)
        return request(url)
    }

    // MARK: Env variables

    public func environmentVariables(forRepository repoIdOrSlug: String) -> MetaDataFuture<[EnvironmentVariable]> {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_vars")
        return request(url)
    }

    public func create(_ env: EnvironmentVariableRequest,
                       forRepository repoIdOrSlug: String) -> MetaDataFuture<EnvironmentVariable> {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_vars",
                          method: .POST,
                          encodable: env)
        return request(url)
    }

    public func update(_ env: EnvironmentVariableRequest,
                       environmentVariableIdentifier: String,
                       forRepository repoIdOrSlug: String) -> MetaDataFuture<EnvironmentVariable> {
        let url = makeURL(
            path: "/repo/\(repoIdOrSlug.pathEscape())/env_var/\(environmentVariableIdentifier)",
            method: .PATCH,
            encodable: env
        )
        return request(url)
    }

    public func delete(
        environmentVariableIdentifier: String,
        forRepository repoIdOrSlug: String
    ) -> MetaDataFuture<EnvironmentVariable> {
        let url = makeURL(
            path: "/repo/\(repoIdOrSlug.pathEscape())/env_var/\(environmentVariableIdentifier)",
            method: .DELETE
        )
        return request(url)
    }

    // MARK: Settings

    public func settings(forRepository repoIdOrSlug: String) -> MetaDataFuture<[Setting]> {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/settings")
        return request(url)
    }

    // MARK: Links

    public func follow<T: Minimal>(embed: Embed<T>) throws -> MetaDataFuture<T.Full> {
        guard let path = embed.path else { throw TravisError.noData }
        let url = makeURL(path: path)
        return request(url)
    }

    public func follow<T>(page: Page<T>) throws -> MetaDataFuture<T> {
        guard let components = URLComponents(string: page.path.rawValue) else {
            throw TravisError.notPathEscapable
        }

        let url = makeURL(path: components.percentEncodedPath, query: components.queryItems)
        return request(url)
    }

    // MARK: Requests

    func request<T: Codable>(_ url: Request) -> MetaDataFuture<T> {
        concreteRequest(url)
    }

    func request<T: Codable>(_ url: Request) -> ActionFuture<T> {
        concreteRequest(url)
    }

    func concreteRequest<T: Codable>(_ request: Request) -> EventLoopFuture<T> {
        return session.execute(request: request).flatMapThrowing { (response) -> T in
            guard let body = response.body else {
                throw TravisError.noData
            }

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601

            do {
                return try jsonDecoder.decode(T.self, from: body)
            } catch {
                let wrappedError: TravisError
                if let travisMessage = try? jsonDecoder.decode(TravisErrorMessage.self, from: body) {
                    wrappedError = TravisError.travis(travisMessage)
                } else {
                    wrappedError = TravisError.unableToDecode(error: error)
                }
                throw wrappedError
            }
        }
    }

    deinit {
        if ownsEventLoop {
            try? session.syncShutdown()
        }
    }
}

func standardHeaders(token: String) -> [(String, String)] {
    [
        ("Travis-API-Version", "3"),
        ("Authorization", "token \(token)"),
        ("User-Agent", "API Explorer"),
    ]
}

extension TravisClient {
    func makeURL<Query: QueryConvertible>(path: String, query: Query? = nil, method: HTTPMethod = .GET) -> Request {
        let queryItems = query?.queryItems
        return makeURL(path: path, query: queryItems, method: method)
    }

    func makeURL<T: Encodable>(path: String, method: HTTPMethod = .GET, encodable: T) -> Request {
        var request = makeURL(path: path, method: method)
        let data = try! JSONEncoder().encode(encodable)
        request.body = HTTPClient.Body.data(data)
        return request
    }

    func makeURL(path: String, query: [URLQueryItem]? = nil, method: HTTPMethod = .GET) -> Request {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.host
        components.percentEncodedPath = path
        components.queryItems = query

        return try! Request(url: components.url!, method: method, headers: .init(headers), body: nil)
    }
}

extension String {
    func pathEscape() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
