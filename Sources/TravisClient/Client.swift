import Foundation
@_exported import Result

@available(OSX 10.12, *)
public class TravisClient {
    let session: URLSession
    let travis: TravisCloud

    public init(token: String, host: TravisCloud = .org, session: URLSession? = nil) {
        travis = host
        self.session = session ?? URLSession(configuration: TravisClient.makeConfiguration(withToken: token))
    }

    // MARK: Repositories

    public func repositories(forOwner owner: String, completion: @escaping Completion<[Repository]>) {
        let url = makeURL(path: "/owner/\(owner.pathEscape())/repos")
        request(url, completion: completion)
    }

    public func userRepositories(completion: @escaping Completion<[Repository]>) {
        let url = makeURL(path: "/repos")
        request(url, completion: completion)
    }

    // MARK: Active

    public func activeBuilds(completion: @escaping Completion<[Build]>) {
        let url = makeURL(path: "/active")
        request(url, completion: completion)
    }

    // MARK: Jobs

    public func jobs(forBuild identfier: String, completion: @escaping Completion<[Job]>) {
        let url = makeURL(path: "/build/\(identfier.pathEscape())/jobs")
        request(url, completion: completion)
    }

    public func job(withIdentifier identifier: String, completion: @escaping Completion<Job>) {
        let url = makeURL(path: "/job/\(identifier)")
        request(url, completion: completion)
    }

    // TODO: Add restart & cancel job

    // MARK: Branches

    public func branches(forBuild identfier: String, completion: @escaping Completion<[Branch]>) {
        let url = makeURL(path: "/repo/\(identfier.pathEscape())/branchs")
        request(url, completion: completion)
    }

    public func branch(forRepo repoIdentifier: String,
                       withIdentifier identifier: String,
                       completion: @escaping Completion<Branch>) {
        let url = makeURL(path: "/repo/\(repoIdentifier.pathEscape())/branch/\(identifier.pathEscape())")
        request(url, completion: completion)
    }

    // MARK: Repository

    public func repository(_ idOrSlug: String, completion: @escaping Completion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())", method: .post)
        request(url, completion: completion)
    }

    public func activateRepository(_ idOrSlug: String, completion: @escaping Completion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/activate", method: .post)
        request(url, completion: completion)
    }

    public func deactivateRepository(_ idOrSlug: String, completion: @escaping Completion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/deactivate", method: .post)
        request(url, completion: completion)
    }

    public func starRepository(_ idOrSlug: String, completion: @escaping Completion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/star", method: .post)
        request(url, completion: completion)
    }

    public func unstarRepository(_ idOrSlug: String, completion: @escaping Completion<Repository>) {
        let url = makeURL(path: "/repo/\(idOrSlug.pathEscape())/unstar", method: .post)
        request(url, completion: completion)
    }

    // MARK: Builds

    public func userBuilds(completion: @escaping Completion<[Build]>) {
        let url = makeURL(path: "/builds")
        request(url, completion: completion)
    }

    public func builds(forRepository repoIdOrSlug: String, completion: @escaping Completion<[Build]>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/builds")
        request(url, completion: completion)
    }

    public func log(forJob jobIdentifier: String, completion: @escaping Completion<Log>) {
        let url = makeURL(path: "/job/\(jobIdentifier.pathEscape())/log")
        request(url, completion: completion)
    }

    // MARK: Build

    public func build(identifier: String, completion: @escaping Completion<Build>) {
        let url = makeURL(path: "/build/\(identifier)")
        request(url, completion: completion)
    }

    public func restartBuild(identifier: String, completion: @escaping ActionCompletion<MinimalBuild>) {
        let url = makeURL(path: "/build/\(identifier)/restart", method: .post)
        request(url, completion: completion)
    }

    public func cancelBuild(identifier: String, completion: @escaping Completion<MinimalBuild>) {
        let url = makeURL(path: "/build/\(identifier)/cancel", method: .post)
        request(url, completion: completion)
    }

    // MARK: Env variables

    public func environmentVariables(forRepository repoIdOrSlug: String, completion: @escaping Completion<[EnvironmentVariable]>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_vars")
        request(url, completion: completion)
    }

    public func create(_ variable: EnvironmentVariableRequest,
                       forRepository repoIdOrSlug: String,
                       completion: @escaping Completion<EnvironmentVariable>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_vars", method: .post)
        request(url, completion: completion)
    }

    public func update(_ variable: EnvironmentVariableRequest,
                       environmentVariableIdentifier: String,
                       forRepository repoIdOrSlug: String,
                       completion: @escaping Completion<EnvironmentVariable>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_var/\(environmentVariableIdentifier)", method: .patch)
        request(url, completion: completion)
    }


    public func delete(environmentVariableIdentifier: String,
                       forRepository repoIdOrSlug: String,
                       completion: @escaping Completion<EnvironmentVariable>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/env_var/\(environmentVariableIdentifier)", method: .delete)
        request(url, completion: completion)
    }

    // MARK: Settings

    public func settings(forRepository repoIdOrSlug: String,
                         completion: @escaping Completion<[Setting]>) {
        let url = makeURL(path: "/repo/\(repoIdOrSlug.pathEscape())/settings")
        request(url, completion: completion)
    }

    // MARK: Links

    public func follow<T: Minimal>(embed: Embed<T>, completion: @escaping Completion<T.Full>) {
        guard let path = embed.path else { return }
        let url = makeURL(path: path)
        request(url, completion: completion)
    }

    // MARK: Requests

    func request<T>(_ url: URLRequest, completion: @escaping Completion<T>) {
        concreteRequest(url, completion: completion)
    }

    func request<T>(_ url: URLRequest, completion: @escaping ActionCompletion<T>) {
        concreteRequest(url, completion: completion)
    }

    func concreteRequest<T: Codable>(_ url: URLRequest, completion: @escaping ResultCompletion<T>) {
        session.dataTask(with: url) { data, _, _ in
            guard let someData = data else {
                let result: Result<T, TravisError> = Result(error: .noData)
                onMain(completion: completion, result: result)
                return
            }

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let result = try jsonDecoder.decode(T.self, from: someData)
                onMain(completion: completion, result: .init(result))
            } catch {
                let wrappedError: TravisError
                if let travisMessage = try? jsonDecoder.decode(TravisErrorMessage.self, from: someData) {
                    wrappedError = TravisError.travis(travisMessage)
                } else {
                    wrappedError = TravisError.unableToDecode(error: error)
                }
                let result: Result<T, TravisError> = Result(error: wrappedError)
                onMain(completion: completion, result: result)
            }
        }.resume()
    }
}


@available(OSX 10.12, *)
extension TravisClient {
    public static func makeConfiguration(withToken token: String) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Travis-API-Version": "3",
            "Authorization": "token \(token)",
            "User-Agent": "API Explorer",
        ]

        return configuration
    }
}

@available(OSX 10.12, *)
extension TravisClient {
    func makeURL(path: String, query: [URLQueryItem]? = nil, method: HTTPMethod = .get) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = travis.host
        components.percentEncodedPath = path
        components.queryItems = query

        var request = URLRequest(url: components.url!)
        request.httpMethod = method.method
//        if case let .post(encodable) = method {
//            request.httpBody = try? JSONEncoder().encode(encodable)
//        }
        return request
    }
}
