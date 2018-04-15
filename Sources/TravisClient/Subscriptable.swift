public protocol ObjectSubscriptable {
    associatedtype Object

    var object: Object { get }

    subscript<V>(_: KeyPath<Object, V>) -> V { get }
}

extension ObjectSubscriptable {
    public subscript<V>(_ keyPath: KeyPath<Object, V>) -> V {
        return object[keyPath: keyPath]
    }
}
