/// Pagination
public struct Pagination<T: Codable>: Codable {
    public let limit: Int
    public let offset: Int
    public let count: Int
    public let isFirst: Bool
    public let isLast: Bool
    public let next: Page<T>?
    public let first: Page<T>?
    public let last: Page<T>?

    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case count
        case isFirst = "is_first"
        case isLast = "is_last"
        case next
        case first
        case last
    }
}

public struct Link<T: Codable>: RawRepresentable, Hashable, Equatable, Codable {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public var hashValue: Int { return rawValue.hashValue }
    public static func == (lhs: Link, rhs: Link) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

public struct Page<T: Codable>: Codable {
    public let path: Link<T>
    public let offset: Int
    public let limit: Int

    enum CodingKeys: String, CodingKey {
        case path = "@href"
        case offset
        case limit
    }
}
