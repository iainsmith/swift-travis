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
        .package(url: "https://github.com/pitiphong-p/URLQueryItemEncoder", from: "0.2.1"),
    ],
    targets: [
        .target(
            name: "TravisClient",
            dependencies: ["Result", "URLQueryItemEncoder"]),
        .testTarget(
            name: "TravisClientTests",
            dependencies: ["TravisClient"]),
    ]
)
