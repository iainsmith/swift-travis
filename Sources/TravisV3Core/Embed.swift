/// Minimal Representations are embbeded into the main object returned from the API.
/// The Embed object contains the meta data
@dynamicMemberLookup
public struct Embed<Object: Codable>: Codable {
    public let type: String
    public let path: String?
    public let object: Object

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case path = "@href"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        path = try container.decodeIfPresent(String.self, forKey: .path)
        object = try Object(from: decoder)
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Object, T>) -> T {
        return object[keyPath: keyPath]
    }
}
