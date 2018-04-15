public struct EnvironmentVariable: Codable {
    public let id: String
    public let name: String
    public let value: String
    public let isPublic: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case value
        case isPublic = "public"
    }
}

public struct MinimalEnvironmentVariable: Codable {
    public let id: String
    public let name: String
    public let value: String
}

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
