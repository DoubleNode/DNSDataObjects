// swift-tools-version:6.0
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
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18),
        .tvOS(.v18),
        .macCatalyst(.v18),
        .macOS(.v15),
        .watchOS(.v11),
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
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.2"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.3.0"),
        .package(url: "https://github.com/DoubleNode/DNSBaseTheme.git", from: "2.0.1"),
        .package(url: "https://github.com/DoubleNode/DNSCore.git", from: "2.0.2"),
        .package(url: "https://github.com/DoubleNode/DNSCoreThreading.git", from: "2.0.3"),
        .package(url: "https://github.com/DoubleNode/DNSError.git", from: "2.0.1"),
        .package(url: "https://github.com/kaishin/Gifu.git", from: "3.5.1"),
        .package(url: "https://github.com/dgrzeszczak/KeyedCodable.git", from: "3.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSDataObjects",
            dependencies: ["Alamofire", "AlamofireImage", "DNSBaseTheme",
                           "DNSCore", "DNSCoreThreading", "DNSError",
                           "Gifu", "KeyedCodable"],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImportObjcForwardDeclarations"),
                .enableUpcomingFeature("DisableOutwardActorInference"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency"),
                .enableUpcomingFeature("GlobalConcurrency")
            ]
        ),
        .testTarget(
            name: "DNSDataObjectsTests",
            dependencies: ["DNSDataObjects"],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImportObjcForwardDeclarations"),
                .enableUpcomingFeature("DisableOutwardActorInference"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency"),
                .enableUpcomingFeature("GlobalConcurrency")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
