import Result

#if swift(>=4.1)
extension Result: ObjectSubscriptable where T: ObjectSubscriptable {
    public typealias Object = T.Object?

    public var object: T.Object? {
        return self.value?.object
    }

    public subscript<V>(_ keyPath: KeyPath<T.Object, V>) -> V {
        return object![keyPath: keyPath]
    }
}
#endif
