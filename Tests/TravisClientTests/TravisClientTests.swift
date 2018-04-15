import TravisClient
import XCTest

@available(OSX 10.12, *)
final class TravisClientTests: XCTestCase {
    var client: TravisClient!

    override func setUp() {
        super.setUp()
        let key = ProcessInfo.processInfo.environment["TRAVIS_KEY"]!
        client = TravisClient(token: key)
    }

    func testUserBuilds() throws {
        let exp = expectation(description: "network")
        client.userBuilds { result in
            if case let .success(builds) = result {
                exp.fulfill()
            } else {
                XCTFail()
            }
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

    func testExampleBuildsRepo() throws {
        let exp = expectation(description: "network")
        client.builds(forRepository: "iainsmith/SwiftGherkin") { result in
            if case let .success(builds) = result {
                exp.fulfill()
            } else {
                XCTFail()
            }
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

    func testLoadingBuild() throws {
        let exp = expectation(description: "network")
        client.build(identifier: "365367401") { result in
            if case let .success(builds) = result {
                exp.fulfill()
            } else {
                XCTFail()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testJobsAndLink() throws {
        let exp = expectation(description: "network")
        client.jobs(forBuild: "365367401") { [weak self] result in
            if case let .success(jobs) = result {
                let firstBuild = \[Job][0].build
                let build = jobs[firstBuild]
                self?.client.follow(embed: build) { result in
                    if case let .success(build) = result {
                        XCTAssertEqual(build[\.id], 365_367_401)
                        XCTAssertEqual(build[\.state], "passed")
                        exp.fulfill()
                    } else {
                        XCTFail()
                    }
                }

            } else {
                XCTFail()
            }
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

    func testRestartBuild() throws {
        let exp = expectation(description: "network")
        client.restartBuild(identifier: "359741180") { result in
            if case let .success(build) = result {
                exp.fulfill()
            } else {
                XCTFail()
            }
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

    func testLogs() throws {
        let exp = expectation(description: "network")
        client.log(forJob: "365367403") { result in
            if case let .success(log) = result {
                let number = log[\.id]
                XCTAssertEqual(number, 266_982_558)
                exp.fulfill()
            } else {
                XCTFail()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSettings() throws {
        let exp = expectation(description: "network")
        client.settings(forRepository: "iainsmith/SwiftGherkin") { result in
            if case let .success(settings) = result {
                print(settings)
                exp.fulfill()
            } else {
                XCTFail()
            }
        }

        waitForExpectations(timeout: 20, handler: nil)
    }

    static var allTests = [
        ("testUserBuilds", testUserBuilds),
    ]
}
