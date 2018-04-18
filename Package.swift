// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TravisClient",
    products: [
        .library(
            name: "TravisClient",
            targets: ["TravisClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/antitypical/Result", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "TravisClient",
            dependencies: ["Result"]),
        .testTarget(
            name: "TravisClientTests",
            dependencies: ["TravisClient"]),
    ]
)
