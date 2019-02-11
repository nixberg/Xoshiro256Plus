// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Xoshiro256Plus",
    products: [
        .library(
            name: "Xoshiro256Plus",
            targets: ["Xoshiro256Plus"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Xoshiro256Plus",
            dependencies: []),
        .testTarget(
            name: "Xoshiro256PlusTests",
            dependencies: ["Xoshiro256Plus"]),
    ]
)
