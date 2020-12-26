// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DukascopyDecoder",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DukascopyDecoder",
            targets: ["DukascopyDecoder"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vitali-kurlovich/DukascopyModel.git", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "DukascopyDecoder",
            dependencies: ["DukascopyModel"]
        ),

        .testTarget(
            name: "DukascopyDecoderTests",
            dependencies: ["DukascopyDecoder"]
        ),
    ]
)
