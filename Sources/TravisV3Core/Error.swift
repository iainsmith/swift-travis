/// The errors produced by TravisClient
public enum TravisError: Error {
    case travis(TravisErrorMessage)
    case notPathEscapable
    case noData
    case unableToDecode(error: Error)
}

/// The travis error message
public struct TravisErrorMessage: Codable {
    public let type: String
    public let message: String

    enum CodingKeys: String, CodingKey {
        case type = "error_type"
        case message = "error_message"
    }
}
