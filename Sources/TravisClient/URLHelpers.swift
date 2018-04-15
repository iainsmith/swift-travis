import Foundation

enum HTTPMethod {
    case get
    case post(Encodable?)

    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

extension String {
    func pathEscape() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}

func onMain<T: Codable>(completion: @escaping ResultCompletion<T>, result: Result<T, TravisError>) {
    DispatchQueue.main.async {
        completion(result)
    }
}
