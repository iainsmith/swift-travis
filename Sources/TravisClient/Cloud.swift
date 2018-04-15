import Foundation

public enum TravisCloud {
    case pro
    case org
    case enterprise(String)

    var host: String {
        switch self {
        case .org: return "api.travis-ci.org"
        case .pro: return "api.travis-ci.com"
        case let .enterprise(host): return host
        }
    }
}
