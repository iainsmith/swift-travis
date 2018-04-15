public struct Meta<Object: Codable>: Codable, ObjectSubscriptable {
    public let type: String
    public let path: String
    public let pagination: Pagination?
    public let object: Object

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case path = "@href"
        case pagination = "@pagination"
    }

    public init(from decoder: Decoder) throws {
        let standardContainer = try decoder.container(keyedBy: CodingKeys.self)
        let type = try standardContainer.decode(String.self, forKey: .type)
        self.type = type
        path = try standardContainer.decode(String.self, forKey: .path)
        pagination = try standardContainer.decodeIfPresent(Pagination.self, forKey: .pagination)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKey.self)

        let collectionKey = DynamicKey(stringValue: type)!

        let object = try dynamicContainer.decodeIfPresent(Object.self, forKey: collectionKey)
        if let collection = object {
            self.object = collection
        } else {
            self.object = try Object(from: decoder)
        }
    }
}
