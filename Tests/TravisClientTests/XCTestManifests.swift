import XCTest

#if !os(macOS)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(TravisClientTests.allTests),
            testCase(JSONTests.allTests),
        ]
    }
#endif
