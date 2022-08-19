// swift-tools-version:5.3
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSDataObjects",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
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
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.1"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", from: "1.9.25"),
        .package(url: "https://github.com/DoubleNode/DNSCoreThreading.git", from: "1.9.0"),
        .package(url: "https://github.com/DoubleNode/DNSError.git", from: "1.9.1"),
        .package(url: "https://github.com/kaishin/Gifu.git", from: "3.3.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSDataObjects",
            dependencies: ["Alamofire", "AlamofireImage",
                           "DNSCore", "DNSCoreThreading", "DNSError", "Gifu"]
        ),
        .testTarget(
            name: "DNSDataObjectsTests",
            dependencies: ["DNSDataObjects"]),
    ],
    swiftLanguageVersions: [.v5]
)
