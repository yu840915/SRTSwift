// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SRTSwift",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .watchOS(.v8),
        .tvOS(.v15),
        .visionOS(.v2),
    ],
    products: [
        .library(
            name: "SRTSwift",
            targets: ["SRTSwift"],
        )
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/OpenSSL-Package.git", from: "3.3.2000")
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
            dependencies: [
                "SRTInterface",
                .product(name: "OpenSSL", package: "OpenSSL-Package"),
            ],
            swiftSettings: [
                .interoperabilityMode(.Cxx)  // Enable C++ interoperability
            ],
        ),
        .testTarget(
            name: "SRTSwiftTests",
            dependencies: ["SRTSwift"],
            swiftSettings: [
                .interoperabilityMode(.Cxx)  // Enable C++ interoperability
            ],
        ),
    ]
)
