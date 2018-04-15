import TravisClient
import XCTest

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
            if case let .success(builds) = result {
                let buildLink = builds.object[0].build
                self?.client.follow(embed: buildLink) { result in
                    if case let .success(build) = result {
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
