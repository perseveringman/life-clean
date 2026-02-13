// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LifeClean",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "LifeClean",
            targets: ["App"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "App",
            dependencies: [],
            path: "Sources"
        )
    ]
)
