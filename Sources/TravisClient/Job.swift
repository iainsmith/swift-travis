import Foundation

/// Included when the resource is returned as part of another resource
public struct MinimalJob: Codable, Minimal {
    public let id: Int

    public typealias Full = Job
}

/// Included when the resource is the main response of a request
public struct Job: Codable {

    /// Value uniquely identifying the job
    public let id: Int

    /// The job's allow_failure
    public let allow_failure: Bool

    /// Incremental number for a repository's builds
    public let number: String

    /// Current state of the job
    public let state: String

    /// When the job started
    public let started_at: String

    /// When the job finished
    public let finished_at: String

    /// The build the job is associated with
    public let build: Embed<MinimalBuild>

    /// Worker queue this job is/was scheduled on
    public let queue: String

    /// The commit the job is associated with
    public let commit: Embed<MinimalCommit>

    /// GitHub user or organization the job belongs to
    public let repository: Embed<MinimalRepository>

    /// When the job was created
    public let created_at: String

    /// When the job was updated.
    public let updated_at: String
}
