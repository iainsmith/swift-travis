import Foundation

public struct Action<Object: Codable>: Codable, ObjectSubscriptable {
    public let type: String
    public let resource_type: String
    public let state_change: String
    public let object: Object

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case resource_type
        case state_change
    }

    public init(from decoder: Decoder) throws {
        let standardContainer = try decoder.container(keyedBy: CodingKeys.self)
        type = try standardContainer.decode(String.self, forKey: .type)
        let resource_type = try standardContainer.decode(String.self, forKey: .resource_type)
        self.resource_type = resource_type
        state_change = try standardContainer.decode(String.self, forKey: .state_change)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKey.self)
        object = try dynamicContainer.decode(Object.self, forKey: DynamicKey(stringValue: resource_type)!)
    }
}
