// swift-tools-version:5.7
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSDataObjects",
    platforms: [
        .iOS(.v16),
        .tvOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13),
        .watchOS(.v9),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSDataObjects",
            type: .static,
            targets: ["DNSDataObjects"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/DoubleNode/DNSCore.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSCoreThreading.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSDataContracts.git", .upToNextMajor(from: "1.12.1")),
        .package(url: "https://github.com/DoubleNode/DNSDataTypes.git", .upToNextMajor(from: "1.12.2")),
        .package(url: "https://github.com/DoubleNode/DNSError.git", .upToNextMajor(from: "1.12.0")),
//        .package(path: "../DNSCore"),
//        .package(path: "../DNSCoreThreading"),
//        .package(path: "../DNSDataContracts"),
//        .package(path: "../DNSDataTypes"),
//        .package(path: "../DNSError"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSDataObjects",
            dependencies: ["DNSCore", "DNSCoreThreading", "DNSDataContracts", "DNSDataTypes", "DNSError"]
        ),
        .testTarget(
            name: "DNSDataObjectsTests",
            dependencies: ["DNSDataObjects"],
            exclude: ["README.md"]),
    ],
    swiftLanguageVersions: [.v5]
)
