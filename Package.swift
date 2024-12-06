// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DukascopyDecoder",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DukascopyDecoder",
            targets: ["DukascopyDecoder"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vitali-kurlovich/DukascopyModel.git", from: "1.19.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.77.0"),

    ],
    targets: [
        .target(
            name: "DukascopyDecoder",
            dependencies: [
                "DukascopyModel",
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
            ]
        ),

        .testTarget(
            name: "DukascopyDecoderTests",
            dependencies: ["DukascopyDecoder"]
        ),
    ]
)
