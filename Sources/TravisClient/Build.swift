import Foundation

public struct MinimalBuild: Codable, Minimal {
    public let id: Int
    public let number: String
    public let state: String
    public let duration: Int?
    public let event_type: String
    public let previous_state: String?
    public let pull_request_title: String?
    public let pull_request_number: Int?
    public let started_at: Date?
    public let finished_at: Date?

    public typealias Full = Build
}

public struct Build: Codable {
    public let id: Int
    public let number: String
    public let state: String
    public let duration: Int?
    public let eventType: String
    public let previousState: String?
    public let pullRequestTitle: String?
    public let pullRequestNumber: Int?

    public let startedAt: Date?
    public let finishedAt: Date?

    public let repository: Embed<MinimalRepository>
    public let branch: Embed<MinimalBranch>
    public let commit: Embed<MinimalCommit>
    public let jobs: [Embed<MinimalJob>]?

    public let updatedAt: String // should be a date, but currently the built in iso8601 does not handle this

    enum CodingKeys: String, CodingKey  {
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
    }
}
