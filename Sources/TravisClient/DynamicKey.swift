import Foundation

struct DynamicKey: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue _: Int) {
        return nil
    }
}
