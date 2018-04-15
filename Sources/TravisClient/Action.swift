import Foundation

public struct Action<Object: Codable>: Codable, ObjectSubscriptable {
    public let type: String
    public let resourceType: String
    public let stateChange: String
    public let object: Object

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case resourceType = "resource_type"
        case stateChange = "state_change"
    }

    public init(from decoder: Decoder) throws {
        let standardContainer = try decoder.container(keyedBy: CodingKeys.self)
        type = try standardContainer.decode(String.self, forKey: .type)
        let resource = try standardContainer.decode(String.self, forKey: .resourceType)
        resourceType = resource
        stateChange = try standardContainer.decode(String.self, forKey: .stateChange)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKey.self)
        object = try dynamicContainer.decode(Object.self, forKey: DynamicKey(stringValue: resource)!)
    }
}
