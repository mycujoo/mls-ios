// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MLSPackage",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "MLSPackage",
            targets: ["MLSPackage"]),
    ],
    targets: [
        .target(
            name: "MLSPackage",
            dependencies: []),
        .testTarget(
            name: "MLSPackageTests",
            dependencies: ["MLSPackage"]),
    ]
)
