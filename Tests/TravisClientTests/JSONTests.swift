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
        let result = try decoder.decode(Metadata<[Job]>.self, from: data)
        XCTAssertNotNil(result)
    }

    func testRestartJobs() throws {
        url = path.appendingPathComponent("build-restart.json")
        let result = try decoder.decode(Action<MinimalBuild>.self, from: data)
        XCTAssertNotNil(result)
    }

    func testBuilds() throws {
        url = path.appendingPathComponent("builds.json")
        let result = try decoder.decode(Metadata<[Build]>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 25)
    }

    func testRepoActivate() throws {
        url = path.appendingPathComponent("repo-activate.json")
        let result = try decoder.decode(Metadata<Repository>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.id, 18_391_368)
    }

    func testRepoBranches() throws {
        url = path.appendingPathComponent("repo-branches.json")
        let result = try decoder.decode(Metadata<[Branch]>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 8)
    }

    func testRepoSettings() throws {
        url = path.appendingPathComponent("repo-settings.json")
        let result = try decoder.decode(Metadata<[Setting]>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 6)
    }

    func testLogs() throws {
        url = path.appendingPathComponent("job-log.json")
        let result = try decoder.decode(Metadata<Log>.self, from: data)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.id, 266_982_558)
        XCTAssertEqual(result.content.lengthOfBytes(using: .utf8), 36483)
    }

    func testObjectSubscripting() throws {
        url = path.appendingPathComponent("build-restart.json")
        let build = try decoder.decode(Action<MinimalBuild>.self, from: data)
        XCTAssertEqual(build.id, 359_741_180)
        XCTAssertEqual(build.number, "25")
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
