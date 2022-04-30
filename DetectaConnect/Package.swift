// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DetectaConnect",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DetectaConnect",
            targets: ["DetectaConnect"])
    ],
    dependencies: [
        .package(url: "https://github.com/truebucha/BlueSwift.git", from: "1.0.4"),
        .package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf.git", from: "1.17.0"),
        .package(url: "https://github.com/danielgindi/Charts.git", .exact("3.6.0")),
        .package(name: "Sentry", url: "https://github.com/getsentry/sentry-cocoa", from: "7.10.0"),
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DetectaConnect",
            dependencies: [
                "BlueSwift",
                .product(name: "SwiftProtobuf", package: "SwiftProtobuf"),
                "Charts",
                "Sentry"
            ],
            exclude: ["Classes/Protobuf/dAir.proto"],
            resources: [.process("Assets/unit_models.json")])
    ]
)
