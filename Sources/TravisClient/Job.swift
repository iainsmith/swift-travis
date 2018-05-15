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
    public let allowFailure: Bool

    /// Incremental number for a repository's builds
    public let number: String

    /// Current state of the job
    public let state: String

    /// When the job started
    public let startedAt: Date

    /// When the job finished
    public let finishedAt: Date

    /// The build the job is associated with
    public let build: Embed<MinimalBuild>

    /// Worker queue this job is/was scheduled on
    public let queue: String

    /// The commit the job is associated with
    public let commit: Embed<MinimalCommit>

    /// GitHub user or organization the job belongs to
    public let repository: Embed<MinimalRepository>

    /// When the job was created
    public let createdAt: Date

    /// When the job was updated.
    public let updatedAt: Date

    public let owner: Embed<MinimalUser>

    enum CodingKeys: String, CodingKey {
        case id
        case allowFailure = "allow_failure"
        case number
        case state
        case startedAt = "started_at"
        case finishedAt = "finished_at"
        case build
        case queue
        case commit
        case repository
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case owner
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        allowFailure = try container.decode(Bool.self, forKey: .allowFailure)
        number = try container.decode(String.self, forKey: .number)
        state = try container.decode(String.self, forKey: .state)
        build = try container.decode(Embed<MinimalBuild>.self, forKey: .build)
        queue = try container.decode(String.self, forKey: .queue)
        commit = try container.decode(Embed<MinimalCommit>.self, forKey: .commit)
        owner = try container.decode(Embed<MinimalUser>.self, forKey: .owner)
        repository = try container.decode(Embed<MinimalRepository>.self, forKey: .repository)

        startedAt = try container.decode(Date.self, forKey: .startedAt)
        finishedAt = try container.decode(Date.self, forKey: .finishedAt)

        let formatter = DateFormatter.iso8601Full
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)

        guard let createdAtDate = formatter.date(from: createdAtString),
            let updatedAtDate = formatter.date(from: updatedAtString) else {
            throw TravisError.noData
        }

        createdAt = createdAtDate
        updatedAt = updatedAtDate
    }
}

public extension Job {
    var duration: Int {
        return Int(finishedAt.timeIntervalSinceReferenceDate - startedAt.timeIntervalSinceReferenceDate)
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
