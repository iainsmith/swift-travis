import Foundation

public typealias Completion<T: Codable> = (Result<Meta<T>, TravisError>) -> Void
public typealias ActionCompletion<T: Codable> = (Result<Action<T>, TravisError>) -> Void

typealias ResultCompletion<T: Codable> = (Result<T, TravisError>) -> Void

public protocol Minimal {
    associatedtype Full: Codable
}
