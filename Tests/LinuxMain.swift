import TravisClientTests
import XCTest

var tests = [XCTestCaseEntry]()
tests += TravisClientTests.allTests()
tests += JSONTests.allTests()
XCTMain(tests)
