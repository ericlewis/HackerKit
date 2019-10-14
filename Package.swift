// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "HackerKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "HackerKit",
            targets: ["HackerKit"]),
    ],
    targets: [
        .target(
            name: "HackerKit",
            dependencies: []),
        .testTarget(
            name: "HackerKitTests",
            dependencies: ["HackerKit"]),
    ]
)
