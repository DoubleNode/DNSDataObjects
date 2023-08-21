// swift-tools-version:5.7
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
        .iOS(.v16),
        .tvOS(.v16),
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
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.7.1"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/DoubleNode/DNSBaseTheme.git", from: "1.11.0"),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", from: "1.11.0"),
        .package(url: "https://github.com/DoubleNode/DNSCoreThreading.git", from: "1.11.0"),
        .package(url: "https://github.com/DoubleNode/DNSError.git", from: "1.11.0"),
        .package(url: "https://github.com/kaishin/Gifu.git", from: "3.4.1"),
        .package(url: "https://github.com/dgrzeszczak/KeyedCodable.git", from: "3.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSDataObjects",
            dependencies: ["Alamofire", "AlamofireImage", "DNSBaseTheme",
                           "DNSCore", "DNSCoreThreading", "DNSError",
                           "Gifu", "KeyedCodable"]
        ),
        .testTarget(
            name: "DNSDataObjectsTests",
            dependencies: ["DNSDataObjects"]),
    ],
    swiftLanguageVersions: [.v5]
)
