/// Included when the resource is returned as part of another resource
public struct MinimalRepository: Codable, Minimal {
    public let id: Int
    public let name: String
    public let slug: String

    public typealias Full = Repository
}

public struct Repository: Codable {
    public let id: Int
    public let name: String
    public let slug: String
    public let active: Bool

    public let description: String?
    public let githubLanguage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case active
        case description
        case githubLanguage = "github_language"
    }
}
