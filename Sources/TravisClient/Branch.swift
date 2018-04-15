public struct MinimalBranch: Codable, Minimal {
    public typealias Full = Branch

    public let name: String
}

public struct Branch: Codable {
    public let name: String
    public let repository: Embed<MinimalRepository>
    public let default_branch: Bool
    public let exists_on_github: Bool
    public let last_build: Embed<MinimalBuild>
}
