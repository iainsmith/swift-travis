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
    public let started_at: String?
    public let finished_at: String?

    public typealias Full = Build
}

public struct Build: Codable {
    public let id: Int
    public let number: String
    public let state: String
    public let duration: Int?
    public let event_type: String
    public let previous_state: String?
    public let pullRequestTitle: String?
    public let pullRequestNumber: Int?

    public let startedAt: String?
    public let finishedAt: String?

    public let repository: Embed<MinimalRepository>
    public let branch: Embed<MinimalBranch>
    public let commit: Embed<MinimalCommit>
    public let jobs: [Embed<MinimalJob>]?

    public let updated_at: String // should be a date

    enum CodingKey: String {
        case pullRequestTitle = "pull_request_title"
        case pullRequestNumber = "pull_request_number"
        case startedAt = "started_at"
        case finishedAt = "finished_at"
        case repository
        case branch
        case commit
    }
}
