/// The log output from a job
public struct Log: Codable {
    /// The id of this log
    public let id: Int

    /// The content of this log
    public let content: String
}
