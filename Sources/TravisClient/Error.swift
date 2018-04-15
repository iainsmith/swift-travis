import Foundation

public enum TravisError: Error {
    case notPathEscapable
    case noData
    case unableToDecode(error: Error)
}
