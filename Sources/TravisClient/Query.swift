import Foundation

protocol QueryConvertible {
    var queryItems: [URLQueryItem]? { get }
}

public struct Query<T: CustomStringConvertible>: Encodable, QueryConvertible {
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

    var queryItems: [URLQueryItem]? {
        var items = [URLQueryItem]()
        if let limit = limit {
            items.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }

        if let offset = offset {
            items.append(URLQueryItem(name: "offset", value: "\(offset)"))
        }

        if let sortBy = sortBy {
            items.append(URLQueryItem(name: "sort_by", value: sortBy.description))
        }

        return items.isEmpty ? nil : items
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
