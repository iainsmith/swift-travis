import Foundation

/// Included when the resource is returned as part of another resource
public struct MinimalBuild: Codable, Minimal {
    /// Value uniquely identifying the build
    public let id: Int

    /// Incremental number for a repository's builds
    public let number: String

    /// Current state of the build
    public let state: String

    /// Wall clock time in seconds
    public let duration: Int?

    /// Event that triggered the build
    public let eventType: String

    /// State of the previous build (useful to see if state changed)
    public let previousState: String?

    /// Title of the build's pull request
    public let pullRequestTitle: String?

    /// Number of the build's pull request
    public let pullRequestNumber: Int?

    /// When the build started
    public let startedAt: Date?

    /// When the build finished
    public let finishedAt: Date?

    public typealias Full = Build

    enum CodingKeys: String, CodingKey {
        case id
        case number
        case state
        case duration
        case eventType = "event_type"
        case previousState = "previous_state"
        case pullRequestTitle = "pull_request_title"
        case pullRequestNumber = "pull_request_number"
        case startedAt = "started_at"
        case finishedAt = "finished_at"
    }
}

/// Included when the resource is the main response of a request
public struct Build: Codable {
    /// Value uniquely identifying the build
    public let id: Int

    /// Incremental number for a repository's builds
    public let number: String

    /// Current state of the build
    public let state: String

    /// Wall clock time in seconds
    public let duration: Int?

    /// Event that triggered the build
    public let eventType: String

    /// State of the previous build (useful to see if state changed)
    public let previousState: String?

    /// Title of the build's pull request
    public let pullRequestTitle: String?

    /// Number of the build's pull request
    public let pullRequestNumber: Int?

    /// When the build started
    public let startedAt: Date?

    /// When the build finished
    public let finishedAt: Date?

    /// GitHub user or organization the build belongs to.
    public let repository: Embed<MinimalRepository>

    /// The branch the build is associated with
    public let branch: Embed<MinimalBranch>

    /// The commit the build is associated with
    public let commit: Embed<MinimalCommit>

    /// List of jobs that are part of the build's matrix
    public let jobs: [Embed<MinimalJob>]?

    /// The build's updated_at
    ///
    /// - Note: This should be a date, but currently the built in iso8601 does not handle this format
    public let updatedAt: String

    public let createdBy: Embed<MinimalUser>

    enum CodingKeys: String, CodingKey {
        case id
        case number
        case state
        case duration
        case eventType = "event_type"
        case previousState = "previous_state"
        case pullRequestTitle = "pull_request_title"
        case pullRequestNumber = "pull_request_number"
        case startedAt = "started_at"
        case finishedAt = "finished_at"

        case repository
        case branch
        case commit
        case jobs
        case updatedAt = "updated_at"
        case createdBy = "created_by"
    }
}
