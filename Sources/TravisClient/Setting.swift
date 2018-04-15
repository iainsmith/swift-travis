public struct Setting: Codable {
    public let name: String
    public let value: Value
}

extension Setting {
    public enum Value: Codable {
        case bool(Bool)
        case int(Int)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let boolValue = try? container.decode(Bool.self) {
                self = .bool(boolValue)
                return
            }

            if let intvalue = try? container.decode(Int.self) {
                self = .int(intvalue)
                return
            }

            throw TravisError.noData
        }

        public func encode(to _: Encoder) throws {
        }
    }
}
