import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

extension String {
    func pathEscape() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}

func onMain<T: Decodable>(completion: @escaping ResultCompletion<T>, result: Result<T, TravisError>) {
    DispatchQueue.main.async {
        completion(result)
    }
}
