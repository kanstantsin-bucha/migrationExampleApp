// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExampleAppMain",
    defaultLocalization: "en",
    platforms: [
        .iOS("14.5")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ExampleMain",
            targets: ["ExampleMain"])
    ],
    dependencies: [
        .package(url: "https://github.com/kanstantsin-bucha/charts-fork.git", from: "100.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ExampleMain",
            dependencies: [
                .product(name: "Charts", package: "charts-fork")
            ],
            resources: [.process("Resources/environment.json")]),
        .testTarget(
            name: "ExampleMainTests",
            dependencies: ["ExampleMain"])
    ]
)
