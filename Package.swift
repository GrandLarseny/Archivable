// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Archivable",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Archivable",
                 targets: ["Archivable"]),
    ],
    targets: [
        .target(
            name: "Archivable",
            path: "Sources"),
        .testTarget(
            name: "ArchivableTests",
            dependencies: ["Archivable"],
            path: "Tests"),
    ]
)
