public struct Repository: Codable {
    public let id: Int
    public let name: String
    public let slug: String
    public let active: Bool

    public let description: String?
    public let github_language: String?
}

public struct MinimalRepository: Codable, Minimal {
    public let id: Int
    public let name: String
    public let slug: String

    public typealias Full = Repository
}
