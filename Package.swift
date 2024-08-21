// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorVideo",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorVideo",
            targets: ["VideoRecorderPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "VideoRecorderPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/VideoRecorderPlugin"),
        .testTarget(
            name: "VideoRecorderPluginTests",
            dependencies: ["VideoRecorderPlugin"],
            path: "ios/Tests/VideoRecorderPluginTests")
    ]
)