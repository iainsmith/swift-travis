import Foundation

public struct MinimalCommit: Codable {
    public let id: Int
    public let sha: String
    public let ref: String
    public let message: String
    public let compareURL: String?
    public let committedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sha
        case ref
        case message
        case compareURL = "compare_url"
        case committedAt = "committed_at"
    }
}
