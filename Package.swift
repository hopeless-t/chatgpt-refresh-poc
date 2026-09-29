// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ChatGPTRefreshPoC",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "RefreshCore", targets: ["RefreshCore"]),
        .executable(name: "refresh-demo", targets: ["RefreshDemo"])
    ],
    targets: [
        .target(name: "RefreshCore"),
        .executableTarget(name: "RefreshDemo", dependencies: ["RefreshCore"]),
        .testTarget(name: "RefreshCoreTests", dependencies: ["RefreshCore"])
    ]
)
