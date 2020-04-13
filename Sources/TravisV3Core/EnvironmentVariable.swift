/// Included when the resource is returned as part of another resource
public struct MinimalEnvironmentVariable: Codable {
    /// The environment variable id
    public let id: String

    /// The environment variable name, e.g. FOO
    public let name: String

    /// The environment variable's value, e.g. bar
    public let value: String
}

/// Included when the resource is the main response of a request
public struct EnvironmentVariable: Codable {
    /// The environment variable id
    public let id: String

    /// The environment variable name, e.g. FOO
    public let name: String

    /// The environment variable's value, e.g. bar
    public let value: String

    /// Whether this environment variable should be publicly visible or not
    public let isPublic: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case value
        case isPublic = "public"
    }
}

/// The data to be sent to travis to Create or Update an environment variable
public struct EnvironmentVariableRequest: Codable {
    let name: String
    let value: String
    let isPublic: Bool

    enum CodingKeys: String, CodingKey {
        case name = "env_var.name"
        case value = "env_var.value"
        case isPublic = "env_var.public"
    }
}
