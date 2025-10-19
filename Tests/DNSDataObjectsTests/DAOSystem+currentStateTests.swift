//
//  DAOSystem+currentStateTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOSystemCurrentStateExtensionTests: XCTestCase {

    // MARK: - DAOSystem Extension Tests -

    func testDAOSystemConfidenceExtension() {
        let system = DAOSystem()
        system.currentState.confidence = .high

        XCTAssertEqual(system.confidence, .high)

        system.currentState.confidence = .medium
        XCTAssertEqual(system.confidence, .medium)
    }

    func testDAOSystemStateExtension() {
        let system = DAOSystem()
        system.currentState.state = .red

        XCTAssertEqual(system.state, .red)

        system.currentState.state = .green
        XCTAssertEqual(system.state, .green)
    }

    func testDAOSystemStateAndroidExtension() {
        let system = DAOSystem()
        system.currentState.stateAndroid = .yellow

        XCTAssertEqual(system.stateAndroid, .yellow)

        system.currentState.stateAndroid = .red
        XCTAssertEqual(system.stateAndroid, .red)
    }

    func testDAOSystemStateIOSExtension() {
        let system = DAOSystem()
        system.currentState.stateIOS = .green

        XCTAssertEqual(system.stateIOS, .green)

        system.currentState.stateIOS = .yellow
        XCTAssertEqual(system.stateIOS, .yellow)
    }

    func testDAOSystemStateOverrideExtension() {
        let system = DAOSystem()
        system.currentState.stateOverride = .red

        XCTAssertEqual(system.stateOverride, .red)

        system.currentState.stateOverride = .none
        XCTAssertEqual(system.stateOverride, .none)
    }

    func testDAOSystemFailureCodesExtension() {
        let system = DAOSystem()
        var failureCodeData = DNSDataDictionary()
        failureCodeData["count"] = 10
        failureCodeData["total"] = 100
        failureCodeData["percentage"] = 10.0

        let failureCodes = [
            "HTTP_500": DNSAnalyticsNumbers(from: failureCodeData)
        ]
        system.currentState.failureCodes = failureCodes

        XCTAssertEqual(system.failureCodes.count, 1)
        XCTAssertNotNil(system.failureCodes["HTTP_500"])
    }

    func testDAOSystemFailureRateExtension() {
        let system = DAOSystem()
        var analyticsData = DNSDataDictionary()
        analyticsData["count"] = 25
        analyticsData["total"] = 100
        analyticsData["percentage"] = 25.0
        let analytics = DNSAnalyticsNumbers(from: analyticsData)

        system.currentState.failureRate = analytics

        XCTAssertEqual(system.failureRate, analytics)
    }

    func testDAOSystemTotalPointsExtension() {
        let system = DAOSystem()
        var analyticsData = DNSDataDictionary()
        analyticsData["count"] = 750
        analyticsData["total"] = 1000
        analyticsData["percentage"] = 75.0
        let analytics = DNSAnalyticsNumbers(from: analyticsData)

        system.currentState.totalPoints = analytics

        XCTAssertEqual(system.totalPoints, analytics)
    }

    func testDAOSystemAllExtensionsWithTestData() {
        let system = DAOSystem()
        system.currentState.confidence = .high
        system.currentState.state = .green
        system.currentState.stateAndroid = .yellow
        system.currentState.stateIOS = .red
        system.currentState.stateOverride = .none

        // Verify all extensions work together
        XCTAssertEqual(system.confidence, .high)
        XCTAssertEqual(system.state, .green)
        XCTAssertEqual(system.stateAndroid, .yellow)
        XCTAssertEqual(system.stateIOS, .red)
        XCTAssertEqual(system.stateOverride, .none)
    }

    // MARK: - DAOSystemEndPoint Extension Tests -

    func testDAOSystemEndPointConfidenceExtension() {
        let endPoint = DAOSystemEndPoint()
        endPoint.currentState.confidence = .medium

        XCTAssertEqual(endPoint.confidence, .medium)

        endPoint.currentState.confidence = .low
        XCTAssertEqual(endPoint.confidence, .low)
    }

    func testDAOSystemEndPointStateExtension() {
        let endPoint = DAOSystemEndPoint()
        endPoint.currentState.state = .yellow

        XCTAssertEqual(endPoint.state, .yellow)

        endPoint.currentState.state = .red
        XCTAssertEqual(endPoint.state, .red)
    }

    func testDAOSystemEndPointStateAndroidExtension() {
        let endPoint = DAOSystemEndPoint()
        endPoint.currentState.stateAndroid = .green

        XCTAssertEqual(endPoint.stateAndroid, .green)

        endPoint.currentState.stateAndroid = .yellow
        XCTAssertEqual(endPoint.stateAndroid, .yellow)
    }

    func testDAOSystemEndPointStateIOSExtension() {
        let endPoint = DAOSystemEndPoint()
        endPoint.currentState.stateIOS = .red

        XCTAssertEqual(endPoint.stateIOS, .red)

        endPoint.currentState.stateIOS = .green
        XCTAssertEqual(endPoint.stateIOS, .green)
    }

    func testDAOSystemEndPointStateOverrideExtension() {
        let endPoint = DAOSystemEndPoint()
        endPoint.currentState.stateOverride = .yellow

        XCTAssertEqual(endPoint.stateOverride, .yellow)

        endPoint.currentState.stateOverride = .none
        XCTAssertEqual(endPoint.stateOverride, .none)
    }

    func testDAOSystemEndPointFailureCodesExtension() {
        let endPoint = DAOSystemEndPoint()
        var failureCodeData = DNSDataDictionary()
        failureCodeData["count"] = 15
        failureCodeData["total"] = 100
        failureCodeData["percentage"] = 15.0

        let failureCodes = [
            "TIMEOUT": DNSAnalyticsNumbers(from: failureCodeData)
        ]
        endPoint.currentState.failureCodes = failureCodes

        XCTAssertEqual(endPoint.failureCodes.count, 1)
        XCTAssertNotNil(endPoint.failureCodes["TIMEOUT"])
    }

    func testDAOSystemEndPointFailureRateExtension() {
        let endPoint = DAOSystemEndPoint()
        var analyticsData = DNSDataDictionary()
        analyticsData["count"] = 35
        analyticsData["total"] = 100
        analyticsData["percentage"] = 35.0
        let analytics = DNSAnalyticsNumbers(from: analyticsData)

        endPoint.currentState.failureRate = analytics

        XCTAssertEqual(endPoint.failureRate, analytics)
    }

    func testDAOSystemEndPointTotalPointsExtension() {
        let endPoint = DAOSystemEndPoint()
        var analyticsData = DNSDataDictionary()
        analyticsData["count"] = 850
        analyticsData["total"] = 1000
        analyticsData["percentage"] = 85.0
        let analytics = DNSAnalyticsNumbers(from: analyticsData)

        endPoint.currentState.totalPoints = analytics

        XCTAssertEqual(endPoint.totalPoints, analytics)
    }

    func testDAOSystemEndPointAllExtensionsWithTestData() {
        let endPoint = DAOSystemEndPoint()
        endPoint.currentState.confidence = .low
        endPoint.currentState.state = .red
        endPoint.currentState.stateAndroid = .green
        endPoint.currentState.stateIOS = .yellow
        endPoint.currentState.stateOverride = .red

        // Verify all extensions work together
        XCTAssertEqual(endPoint.confidence, .low)
        XCTAssertEqual(endPoint.state, .red)
        XCTAssertEqual(endPoint.stateAndroid, .green)
        XCTAssertEqual(endPoint.stateIOS, .yellow)
        XCTAssertEqual(endPoint.stateOverride, .red)
    }

    // MARK: - Platform-Specific State Tests -

    func testDAOSystemPlatformSpecificStates() {
        let system = DAOSystem()

        // Set different states for each platform
        system.currentState.state = .green
        system.currentState.stateAndroid = .yellow
        system.currentState.stateIOS = .red

        // Verify they are accessible and different
        XCTAssertEqual(system.state, .green)
        XCTAssertEqual(system.stateAndroid, .yellow)
        XCTAssertEqual(system.stateIOS, .red)
        XCTAssertNotEqual(system.state, system.stateAndroid)
        XCTAssertNotEqual(system.stateAndroid, system.stateIOS)
    }

    func testDAOSystemEndPointPlatformSpecificStates() {
        let endPoint = DAOSystemEndPoint()

        // Set different states for each platform
        endPoint.currentState.state = .yellow
        endPoint.currentState.stateAndroid = .green
        endPoint.currentState.stateIOS = .red

        // Verify they are accessible and different
        XCTAssertEqual(endPoint.state, .yellow)
        XCTAssertEqual(endPoint.stateAndroid, .green)
        XCTAssertEqual(endPoint.stateIOS, .red)
        XCTAssertNotEqual(endPoint.state, endPoint.stateAndroid)
        XCTAssertNotEqual(endPoint.stateAndroid, endPoint.stateIOS)
    }

    static var allTests = [
        ("testDAOSystemConfidenceExtension", testDAOSystemConfidenceExtension),
        ("testDAOSystemStateExtension", testDAOSystemStateExtension),
        ("testDAOSystemStateAndroidExtension", testDAOSystemStateAndroidExtension),
        ("testDAOSystemStateIOSExtension", testDAOSystemStateIOSExtension),
        ("testDAOSystemStateOverrideExtension", testDAOSystemStateOverrideExtension),
        ("testDAOSystemFailureCodesExtension", testDAOSystemFailureCodesExtension),
        ("testDAOSystemFailureRateExtension", testDAOSystemFailureRateExtension),
        ("testDAOSystemTotalPointsExtension", testDAOSystemTotalPointsExtension),
        ("testDAOSystemAllExtensionsWithTestData", testDAOSystemAllExtensionsWithTestData),
        ("testDAOSystemEndPointConfidenceExtension", testDAOSystemEndPointConfidenceExtension),
        ("testDAOSystemEndPointStateExtension", testDAOSystemEndPointStateExtension),
        ("testDAOSystemEndPointStateAndroidExtension", testDAOSystemEndPointStateAndroidExtension),
        ("testDAOSystemEndPointStateIOSExtension", testDAOSystemEndPointStateIOSExtension),
        ("testDAOSystemEndPointStateOverrideExtension", testDAOSystemEndPointStateOverrideExtension),
        ("testDAOSystemEndPointFailureCodesExtension", testDAOSystemEndPointFailureCodesExtension),
        ("testDAOSystemEndPointFailureRateExtension", testDAOSystemEndPointFailureRateExtension),
        ("testDAOSystemEndPointTotalPointsExtension", testDAOSystemEndPointTotalPointsExtension),
        ("testDAOSystemEndPointAllExtensionsWithTestData", testDAOSystemEndPointAllExtensionsWithTestData),
        ("testDAOSystemPlatformSpecificStates", testDAOSystemPlatformSpecificStates),
        ("testDAOSystemEndPointPlatformSpecificStates", testDAOSystemEndPointPlatformSpecificStates),
    ]
}
