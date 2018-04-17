import Foundation

/// Included when the resource is returned as part of another resource
public struct MinimalCommit: Codable {

    /// Value uniquely identifying the commit
    public let id: Int

    /// Checksum the commit has in git and is identified by
    public let sha: String

    /// Named reference the commit has in git
    public let ref: String

    /// Commit mesage
    public let message: String

    /// URL to the commit's diff on GitHub
    public let compareURL: String?

    /// Commit date from git
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
