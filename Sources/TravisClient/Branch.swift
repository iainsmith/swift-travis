
/// The branch of a GitHub repository. Useful for obtaining information about the last build on a given branch.
/// Included when the resource is returned as part of another resource.
///
/// - Link: https://developer.travis-ci.org/resource/branch
public struct MinimalBranch: Codable, Minimal {
    public typealias Full = Branch

    /// Name of the git branch
    public let name: String
}

public struct Branch: Codable {
    /// Name of the git branch
    public let name: String

    /// GitHub user or organization the branch belongs to.
    public let repository: Embed<MinimalRepository>

    /// Whether or not this is the resposiotry's default branch.
    public let defaultBranch: Bool

    /// Whether or not the branch still exists on GitHub.
    public let existsOnGithub: Bool

    /// Last build on the branch.
    public let lastBuild: Embed<MinimalBuild>

    enum CodingKeys: String, CodingKey {
        case name
        case repository
        case defaultBranch = "default_branch"
        case existsOnGithub = "exists_on_github"
        case lastBuild = "last_build"
    }
}
