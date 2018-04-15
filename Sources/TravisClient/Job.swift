import Foundation

public struct MinimalJob: Codable, Minimal {
    public let id: Int

    public typealias Full = Job
}

public struct Job: Codable {
    public let id: Int
    public let allow_failure: Bool
    public let number: String
    public let state: String
    public let started_at: String
    public let finished_at: String
    public let build: Embed<MinimalBuild>
    public let queue: String
    public let commit: Embed<MinimalCommit>
    public let repository: Embed<MinimalRepository>
    public let created_at: String
    public let updated_at: String
}
