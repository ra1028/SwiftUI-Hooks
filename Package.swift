// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Hooks",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "Hooks", targets: ["Hooks"]),
    ],
    targets: [
        .target(name: "Hooks")
    ],
    swiftLanguageVersions: [.v5]
)
