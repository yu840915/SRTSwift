// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SRTSwift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SRTSwift",
            targets: ["SRTSwift"])
    ],
    targets: [
        .binaryTarget(
            name: "libSRT",
            path: "libSRT.xcframework",
        ),
        .target(
            name: "SRTInterface",
            dependencies: ["libSRT"],
            publicHeadersPath: "include"
        ),
        .target(
            name: "SRTSwift",
            dependencies: ["SRTInterface"]
        ),
        .testTarget(
            name: "SRTSwiftTests",
            dependencies: ["SRTSwift"]
        ),
    ]
)
