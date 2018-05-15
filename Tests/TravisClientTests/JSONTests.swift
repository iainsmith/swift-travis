//
//  JSONTests.swift
//  TravisClientTests
//
//  Created by iainsmith on 17/04/2018.
//

import TravisClient
import XCTest

let file = #file
let path = URL(fileURLWithPath: NSString(string: file).deletingLastPathComponent.appending("/../../Samples"))

@available(OSX 10.12, *)
@available(iOS 10.0, *)
class JSONTests: XCTestCase {
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    var url: URL!
    lazy var data: Data! = { try! Data(contentsOf: url) }()

    override func tearDown() {
        super.tearDown()
        data = nil
    }

    func testJobs() throws {
        url = path.appendingPathComponent("build-jobs.json")
        let result = try decoder.decode(Meta<[Job]>.self, from: data)
        let duration = result[\[Job].first?.duration]
        XCTAssertEqual(duration, 65)
        XCTAssertNotNil(result)
    }

    func testRestartJobs() throws {
        url = path.appendingPathComponent("build-restart.json")
        let result = try decoder.decode(Action<MinimalBuild>.self, from: data)
        XCTAssertNotNil(result)
    }

    func testBuilds() throws {
        url = path.appendingPathComponent("builds.json")
        let result = try decoder.decode(Meta<[Build]>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result[\[Build].count], 89)
    }

    func testRepoActivate() throws {
        url = path.appendingPathComponent("repo-activate.json")
        let result = try decoder.decode(Meta<Repository>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result[\Repository.id], 18_391_368)
    }

    func testRepoBranches() throws {
        url = path.appendingPathComponent("repo-branches.json")
        let result = try decoder.decode(Meta<[Branch]>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result[\[Branch].count], 8)
    }

    func testRepoSettings() throws {
        url = path.appendingPathComponent("repo-settings.json")
        let result = try decoder.decode(Meta<[Setting]>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result[\[Setting].count], 6)
    }

    func testLogs() throws {
        url = path.appendingPathComponent("job-log.json")
        let result = try decoder.decode(Meta<Log>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result[\.id], 266_982_558)
        XCTAssertEqual(result[\.content].lengthOfBytes(using: .utf8), 36483)
    }

    func testObjectSubscripting() throws {
        url = path.appendingPathComponent("build-restart.json")
        let build = try decoder.decode(Action<MinimalBuild>.self, from: data)
        let result = Result<Action<MinimalBuild>, TravisError>.init(value: build)

        #if swift(>=4.1)
            let resultBuildNumber = result[\.id]
        #else
            let resultBuildNumber = result.value?[\.id]
        #endif

        let value = result.value
        let buildNumber = build[\.id]
        XCTAssertNotNil(value)
        XCTAssertEqual(resultBuildNumber, 359_741_180)
        XCTAssertEqual(buildNumber, 359_741_180)
    }

    static var allTests = [
        ("testJobs", testJobs),
        ("testRestartJobs", testRestartJobs),
        ("testBuilds", testBuilds),
        ("testRepoActivate", testRepoActivate),
        ("testRepoBranches", testRepoBranches),
        ("testRepoSettings", testRepoSettings),
        ("testLogs", testLogs),
    ]
}
