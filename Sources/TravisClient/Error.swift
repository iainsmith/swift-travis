public enum TravisError: Error {
    case travis(TravisErrorMessage)
    case notPathEscapable
    case noData
    case unableToDecode(error: Error)
}

public struct TravisErrorMessage: Codable {
    let type: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case type = "error_type"
        case message = "error_message"
    }
}
