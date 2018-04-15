public struct MinimalBranch: Codable, Minimal {
    public typealias Full = Branch

    public let name: String
}

public struct Branch: Codable {
    public let name: String
    public let repository: Embed<MinimalRepository>
    public let defaultBranch: Bool
    public let existsOnGithub: Bool
    public let lastBuild: Embed<MinimalBuild>

    enum CodingKeys: String, CodingKey {
        case name
        case repository
        case defaultBranch = "default_branch"
        case existsOnGithub = "exists_on_github"
        case lastBuild = "last_build"
    }
}
