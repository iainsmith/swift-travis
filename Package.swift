// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-travis",
    platforms: [
        .macOS(.v10_13), .iOS(.v11), .tvOS(.v11),
    ],
    products: [
        .library(
            name: "TravisNIO",
            targets: ["TravisNIO"]
        ),
        .library(
            name: "TravisClient",
            targets: ["TravisClient"]
        ),
        .library(
            name: "TravisV3Core",
            targets: ["TravisV3Core"]
        ),
        .executable(name: "travis-cli", targets: ["CLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/iainsmith/async-http-client.git", .branch("master")),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "TravisClient",
            dependencies: ["TravisV3Core"]
        ),
        .target(
            name: "TravisNIO",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                "TravisV3Core",
            ]
        ),
        .target(name: "TravisV3Core", dependencies: []),
        .target(
            name: "CLI",
            dependencies: [
                "TravisNIO",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "TravisClientTests",
            dependencies: ["TravisClient"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
