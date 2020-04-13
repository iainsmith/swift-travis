import ArgumentParser
import Foundation
import NIO
import TravisNIO

struct TravisCLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "travis",
        abstract: "travis-ci cli",
        subcommands: [ListCommand.self],
        defaultSubcommand: ListCommand.self
    )
}

struct ListCommand: ParsableCommand {
    @Option(name: .shortAndLong)
    var token: String

    @Option(name: .shortAndLong)
    var repo: String

    func run() throws {
        let host = TravisEndpoint.org
        let client = TravisClient(token: token, host: host)
        let builds = try client.builds(forRepository: repo).wait()
        let output = builds.prefix(3).map { "id: \($0.id) status: \($0.state) title: \($0.number))" }
        print(output.joined(separator: "\n"))
    }
}
