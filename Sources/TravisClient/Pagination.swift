/// Pagination
public struct Pagination: Codable {
    public let limit: Int
    public let offset: Int
    public let count: Int
    public let isFirst: Bool
    public let isLast: Bool

    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case count
        case isFirst = "is_first"
        case isLast = "is_last"
    }
}
