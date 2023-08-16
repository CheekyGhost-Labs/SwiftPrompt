// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPrompt",
    platforms: [.macOS(.v10_13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftPrompt",
            targets: ["SwiftPrompt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", exact: Version("0.4.0")),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "4.0.1"),
        .package(url: "https://github.com/pakLebah/ANSITerminal", from: "0.0.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftPrompt",
            dependencies: [
                "Rainbow",
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
                .product(name: "ANSITerminal", package: "ANSITerminal")
            ]
        ),
        .executableTarget(name: "SwiftPromptExample", dependencies: ["SwiftPrompt"]),
        .testTarget(
            name: "SwiftPromptTests",
            dependencies: ["SwiftPrompt"]),
    ]
)
