//
//  JSONTests.swift
//  TravisClientTests
//
//  Created by iainsmith on 17/04/2018.
//

import XCTest
import TravisClient

let file = #file
let path = URL(fileURLWithPath: NSString(string: file).deletingLastPathComponent.appending("/../../Samples"))


@available(OSX 10.12, *)
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
        XCTAssertEqual(result[\Repository.id], 18391368)
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
        XCTAssertEqual(result[\.id], 266982558)
        XCTAssertEqual(result[\.content].lengthOfBytes(using: .utf8), 36483)
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
