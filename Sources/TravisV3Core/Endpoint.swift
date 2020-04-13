/// The Traivs
public enum TravisEndpoint {
    case pro
    case org
    case enterprise(String)

    public var host: String {
        switch self {
        case .org: return "api.travis-ci.org"
        case .pro: return "api.travis-ci.com"
        case let .enterprise(host): return host
        }
    }
}
