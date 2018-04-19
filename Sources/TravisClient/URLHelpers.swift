import Dispatch
import Foundation

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

func onQueue<T: Codable>(_ queue: DispatchQueue?, completion: @escaping ResultCompletion<T>, result: Result<T, TravisError>) {
    if let theQueue = queue {
        theQueue.async { completion(result) }
    } else {
        completion(result)
    }
}
