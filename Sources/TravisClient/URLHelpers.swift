import Foundation

enum HTTPMethod {
    case get
    case post
    case patch
    case delete

    var method: String {
        switch self {
        case .get:      return "GET"
        case .post:     return "POST"
        case .delete:   return "DELETE"
        case .patch:    return "PATCH"
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
