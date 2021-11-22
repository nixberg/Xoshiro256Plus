// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "xoshiro256plus-swift",
    products: [
        .library(
            name: "Xoshiro256Plus",
            targets: ["Xoshiro256Plus"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nixberg/seedable-swift", .branch("main")),
    ],
    targets: [
        .target(
            name: "Xoshiro256Plus",
            dependencies: [
                .product(name: "Seedable", package: "seedable-swift"),
            ]),
        .testTarget(
            name: "Xoshiro256PlusTests",
            dependencies: ["Xoshiro256Plus"]),
    ]
)
