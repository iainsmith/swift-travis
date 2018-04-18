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

public struct Query<T: CustomStringConvertible>: Encodable {
    public var limit: Int?
    public var offset: Int?
    public var sortBy: T?

    public init(limit: Int? = nil, offset: Int? = nil, sortBy: T? = nil) {
        self.limit = limit
        self.offset = offset
        self.sortBy = sortBy
    }

    enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case sortBy = "sort_by"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(offset, forKey: .offset)
        try container.encodeIfPresent(sortBy?.description, forKey: .sortBy)
    }
}

public typealias GeneralQuery = Query<String>
public typealias BuildQuery = Query<BuildSortable>

public enum BuildSortable: String, Codable, CustomStringConvertible {
    case id
    case startedAt = "started_at"
    case finishedAt = "finished_at"

    public var description: String {
        return rawValue
    }
}
