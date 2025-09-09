//
//  DAOSystemStateTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOSystemStateTests: XCTestCase {
    
    // MARK: - Basic Initialization Tests -
    
    func testInitialization() {
        let systemState = DAOSystemState()
        
        XCTAssertNotNil(systemState)
        XCTAssertEqual(systemState.state, .green)
        XCTAssertEqual(systemState.stateOverride, .none)
        XCTAssertNotNil(systemState.failureRate)
        XCTAssertNotNil(systemState.totalPoints)
        XCTAssertTrue(systemState.failureCodes.isEmpty)
    }
    
    func testInitializationWithId() {
        let testId = "test_system_state_123"
        let systemState = DAOSystemState(id: testId)
        
        XCTAssertEqual(systemState.id, testId)
        XCTAssertEqual(systemState.state, .green)
        XCTAssertEqual(systemState.stateOverride, .none)
        XCTAssertNotNil(systemState.failureRate)
        XCTAssertNotNil(systemState.totalPoints)
        XCTAssertTrue(systemState.failureCodes.isEmpty)
    }
    
    func testCopyInitialization() {
        let original = MockDAOSystemStateFactory.createMockWithTestData()
        let copy = DAOSystemState(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.state, original.state)
        XCTAssertEqual(copy.stateOverride, original.stateOverride)
        XCTAssertEqual(copy.failureRate, original.failureRate)
        XCTAssertEqual(copy.totalPoints, original.totalPoints)
        XCTAssertEqual(copy.failureCodes.count, original.failureCodes.count)
        
        // Verify it's a copy, not the same instance
        XCTAssertTrue(copy !== original)
    }
    
    // MARK: - Property Assignment Tests -
    
    func testStateAssignment() {
        let systemState = DAOSystemState()
        
        systemState.state = .red
        XCTAssertEqual(systemState.state, .red)
        
        systemState.state = .yellow
        XCTAssertEqual(systemState.state, .yellow)
        
        systemState.state = .green
        XCTAssertEqual(systemState.state, .green)
        
        systemState.state = .none
        XCTAssertEqual(systemState.state, .none)
    }
    
    func testStateOverrideAssignment() {
        let systemState = DAOSystemState()
        
        systemState.stateOverride = .red
        XCTAssertEqual(systemState.stateOverride, .red)
        
        systemState.stateOverride = .yellow
        XCTAssertEqual(systemState.stateOverride, .yellow)
        
        systemState.stateOverride = .green
        XCTAssertEqual(systemState.stateOverride, .green)
        
        systemState.stateOverride = .none
        XCTAssertEqual(systemState.stateOverride, .none)
    }
    
    func testFailureRateAssignment() {
        let systemState = DAOSystemState()
        var analyticsData = DNSDataDictionary()
        analyticsData["count"] = 25
        analyticsData["total"] = 100
        analyticsData["percentage"] = 25.0
        let analytics = DNSAnalyticsNumbers(from: analyticsData)
        
        systemState.failureRate = analytics
        XCTAssertEqual(systemState.failureRate, analytics)
    }
    
    func testTotalPointsAssignment() {
        let systemState = DAOSystemState()
        var analyticsData = DNSDataDictionary()
        analyticsData["count"] = 750
        analyticsData["total"] = 1000
        analyticsData["percentage"] = 75.0
        let analytics = DNSAnalyticsNumbers(from: analyticsData)
        
        systemState.totalPoints = analytics
        XCTAssertEqual(systemState.totalPoints, analytics)
    }
    
    func testFailureCodesAssignment() {
        let systemState = DAOSystemState()
        
        var failureCode1Data = DNSDataDictionary()
        failureCode1Data["count"] = 3
        failureCode1Data["total"] = 100
        failureCode1Data["percentage"] = 3.0
        
        var failureCode2Data = DNSDataDictionary()
        failureCode2Data["count"] = 7
        failureCode2Data["total"] = 100
        failureCode2Data["percentage"] = 7.0
        
        let failureCodes = [
            "HTTP_404": DNSAnalyticsNumbers(from: failureCode1Data),
            "NETWORK_ERROR": DNSAnalyticsNumbers(from: failureCode2Data)
        ]
        
        systemState.failureCodes = failureCodes
        XCTAssertEqual(systemState.failureCodes.count, 2)
        XCTAssertNotNil(systemState.failureCodes["HTTP_404"])
        XCTAssertNotNil(systemState.failureCodes["NETWORK_ERROR"])
    }
    
    // MARK: - Update Method Tests -
    
    func testUpdateFromObject() {
        let systemState1 = DAOSystemState()
        let systemState2 = MockDAOSystemStateFactory.createMockWithTestData()
        
        systemState1.update(from: systemState2)
        
        XCTAssertEqual(systemState1.state, systemState2.state)
        XCTAssertEqual(systemState1.stateOverride, systemState2.stateOverride)
        XCTAssertEqual(systemState1.failureRate, systemState2.failureRate)
        XCTAssertEqual(systemState1.totalPoints, systemState2.totalPoints)
        XCTAssertEqual(systemState1.failureCodes.count, systemState2.failureCodes.count)
    }
    
    func testUpdateFromObjectWithEmptyData() {
        let systemState1 = MockDAOSystemStateFactory.createMockWithTestData()
        let systemState2 = DAOSystemState()
        
        systemState1.update(from: systemState2)
        
        XCTAssertEqual(systemState1.state, .green)
        XCTAssertEqual(systemState1.stateOverride, .none)
        XCTAssertNotNil(systemState1.failureRate)
        XCTAssertNotNil(systemState1.totalPoints)
        XCTAssertTrue(systemState1.failureCodes.isEmpty)
    }
    
    // MARK: - Dictionary Translation Tests -
    
    func testInitializationFromDictionary() {
        var data = DNSDataDictionary()
        data["id"] = "dict_test_id"
        data["state"] = "yellow"
        data["stateOverride"] = "red"
        
        var failureRateData = DNSDataDictionary()
        failureRateData["count"] = 20
        failureRateData["total"] = 100
        failureRateData["percentage"] = 20.0
        data["failureRate"] = failureRateData
        
        var totalPointsData = DNSDataDictionary()
        totalPointsData["count"] = 800
        totalPointsData["total"] = 1000
        totalPointsData["percentage"] = 80.0
        data["totalPoints"] = totalPointsData
        
        var failureCode1Data = DNSDataDictionary()
        failureCode1Data["count"] = 5
        failureCode1Data["total"] = 100
        failureCode1Data["percentage"] = 5.0
        
        let failureCodesData: [String: DNSDataDictionary] = [
            "TIMEOUT": failureCode1Data
        ]
        data["failureCodes"] = failureCodesData
        
        let systemState = DAOSystemState(from: data)
        
        XCTAssertNotNil(systemState)
        XCTAssertEqual(systemState?.id, "dict_test_id")
        XCTAssertEqual(systemState?.state, .yellow)
        XCTAssertEqual(systemState?.stateOverride, .red)
        XCTAssertNotNil(systemState?.failureRate)
        XCTAssertNotNil(systemState?.totalPoints)
        XCTAssertEqual(systemState?.failureCodes.count, 1)
        XCTAssertNotNil(systemState?.failureCodes["TIMEOUT"])
    }
    
    func testInitializationFromEmptyDictionary() {
        let data = DNSDataDictionary()
        let systemState = DAOSystemState(from: data)
        
        XCTAssertNil(systemState)
    }
    
    func testDictionaryConversion() {
        let systemState = MockDAOSystemStateFactory.createMockWithTestData()
        let dictionary = systemState.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["state"] as Any?)
        XCTAssertNotNil(dictionary["stateOverride"] as Any?)
        XCTAssertNotNil(dictionary["failureRate"] as Any?)
        XCTAssertNotNil(dictionary["totalPoints"] as Any?)
        XCTAssertNotNil(dictionary["failureCodes"] as Any?)
        
        // Verify state values
        XCTAssertEqual(dictionary["state"] as? String, systemState.state.rawValue)
        XCTAssertEqual(dictionary["stateOverride"] as? String, systemState.stateOverride.rawValue)
    }
    
    func testDictionaryRoundTrip() {
        let original = MockDAOSystemStateFactory.createMockWithTestData()
        let dictionary = original.asDictionary
        let restored = DAOSystemState(from: dictionary)
        
        XCTAssertNotNil(restored)
        XCTAssertEqual(restored?.id, original.id)
        XCTAssertEqual(restored?.state, original.state)
        XCTAssertEqual(restored?.stateOverride, original.stateOverride)
        // Note: DNSAnalyticsNumbers equality may need special handling
        XCTAssertEqual(restored?.failureCodes.count, original.failureCodes.count)
    }
    
    // MARK: - Codable Tests -
    
    func testEncodingDecoding() throws {
        let original = MockDAOSystemStateFactory.createMockWithTestData()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOSystemState.self, from: data)
        
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.state, original.state)
        XCTAssertEqual(decoded.stateOverride, original.stateOverride)
        XCTAssertEqual(decoded.failureCodes.count, original.failureCodes.count)
    }
    
    func testEncodingDecodingWithEmptyData() throws {
        let original = DAOSystemState()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOSystemState.self, from: data)
        
        XCTAssertEqual(decoded.state, .green)
        XCTAssertEqual(decoded.stateOverride, .none)
        XCTAssertTrue(decoded.failureCodes.isEmpty)
    }
    
    // MARK: - NSCopying Tests -
    
    func testCopy() {
        let original = MockDAOSystemStateFactory.createMockWithTestData()
        let copy = original.copy() as! DAOSystemState
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.state, original.state)
        XCTAssertEqual(copy.stateOverride, original.stateOverride)
        XCTAssertEqual(copy.failureRate, original.failureRate)
        XCTAssertEqual(copy.totalPoints, original.totalPoints)
        XCTAssertEqual(copy.failureCodes.count, original.failureCodes.count)
        
        // Verify it's a copy, not the same instance
        XCTAssertTrue(copy !== original)
    }
    
    func testCopyWithZone() {
        let original = MockDAOSystemStateFactory.createMockWithTestData()
        let copy = original.copy(with: nil) as! DAOSystemState
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.state, original.state)
        XCTAssertEqual(copy.stateOverride, original.stateOverride)
        XCTAssertTrue(copy !== original)
    }
    
    // MARK: - Difference Detection Tests -
    
    func testIsDiffFromSameObject() {
        let systemState = MockDAOSystemStateFactory.createMockWithTestData()
        XCTAssertFalse(systemState.isDiffFrom(systemState))
    }
    
    func testIsDiffFromEqualObject() {
        let systemState1 = MockDAOSystemStateFactory.createMockWithTestData()
        let systemState2 = DAOSystemState(from: systemState1)
        
        XCTAssertFalse(systemState1.isDiffFrom(systemState2))
        XCTAssertFalse(systemState2.isDiffFrom(systemState1))
    }
    
    func testIsDiffFromDifferentState() {
        let systemState1 = MockDAOSystemStateFactory.createMockWithTestData()
        let systemState2 = DAOSystemState(from: systemState1)
        systemState2.state = .green
        
        XCTAssertTrue(systemState1.isDiffFrom(systemState2))
        XCTAssertTrue(systemState2.isDiffFrom(systemState1))
    }
    
    func testIsDiffFromDifferentStateOverride() {
        let systemState1 = MockDAOSystemStateFactory.createMockWithTestData()
        let systemState2 = DAOSystemState(from: systemState1)
        systemState2.stateOverride = .green
        
        XCTAssertTrue(systemState1.isDiffFrom(systemState2))
        XCTAssertTrue(systemState2.isDiffFrom(systemState1))
    }
    
    func testIsDiffFromDifferentFailureCodes() {
        let systemState1 = MockDAOSystemStateFactory.createMockWithTestData()
        let systemState2 = DAOSystemState(from: systemState1)
        systemState2.failureCodes = [:]
        
        XCTAssertTrue(systemState1.isDiffFrom(systemState2))
        XCTAssertTrue(systemState2.isDiffFrom(systemState1))
    }
    
    func testIsDiffFromNilObject() {
        let systemState = MockDAOSystemStateFactory.createMockWithTestData()
        XCTAssertTrue(systemState.isDiffFrom(nil))
    }
    
    func testIsDiffFromDifferentType() {
        let systemState = MockDAOSystemStateFactory.createMockWithTestData()
        let differentObject = "not a system state"
        XCTAssertTrue(systemState.isDiffFrom(differentObject))
    }
    
    // MARK: - Equatable Tests -
    
    func testEquality() {
        let systemState1 = MockDAOSystemStateFactory.createMockWithTestData()
        let systemState2 = DAOSystemState(from: systemState1)
        
        XCTAssertTrue(systemState1 == systemState2)
        XCTAssertFalse(systemState1 != systemState2)
    }
    
    func testInequality() {
        let systemState1 = MockDAOSystemStateFactory.createMockWithTestData()
        let systemState2 = DAOSystemState()
        
        XCTAssertFalse(systemState1 == systemState2)
        XCTAssertTrue(systemState1 != systemState2)
    }
    
    // MARK: - Edge Case Tests -
    
    func testEmptySystemState() {
        let systemState = MockDAOSystemStateFactory.createMockWithEdgeCases()
        
        XCTAssertEqual(systemState.state, .none)
        XCTAssertEqual(systemState.stateOverride, .none)
        XCTAssertNotNil(systemState.failureRate)
        XCTAssertNotNil(systemState.totalPoints)
        XCTAssertTrue(systemState.failureCodes.isEmpty)
    }
    
    func testValidStatesAssignment() {
        let systemState = DAOSystemState()
        let validStates: [DNSSystemState] = [.green, .yellow, .red, .none]
        
        for state in validStates {
            systemState.state = state
            XCTAssertEqual(systemState.state, state)
            
            systemState.stateOverride = state
            XCTAssertEqual(systemState.stateOverride, state)
        }
    }
    
    func testFailureCodesWithEmptyAnalytics() {
        let systemState = DAOSystemState()
        let emptyAnalytics = DNSAnalyticsNumbers()
        
        systemState.failureCodes = [
            "EMPTY_1": emptyAnalytics,
            "EMPTY_2": emptyAnalytics
        ]
        
        XCTAssertEqual(systemState.failureCodes.count, 2)
        XCTAssertNotNil(systemState.failureCodes["EMPTY_1"])
        XCTAssertNotNil(systemState.failureCodes["EMPTY_2"])
    }
    
    func testLargeFailureCodesCollection() {
        let systemState = DAOSystemState()
        var failureCodes: [String: DNSAnalyticsNumbers] = [:]
        
        for i in 0..<100 {
            var analyticsData = DNSDataDictionary()
            analyticsData["count"] = i
            analyticsData["total"] = 1000
            analyticsData["percentage"] = Double(i) / 10.0
            failureCodes["ERROR_\(i)"] = DNSAnalyticsNumbers(from: analyticsData)
        }
        
        systemState.failureCodes = failureCodes
        XCTAssertEqual(systemState.failureCodes.count, 100)
    }
    
    func testDictionaryWithInvalidStateStrings() {
        var data = DNSDataDictionary()
        data["id"] = "invalid_state_test"
        data["state"] = "invalid_state_value"
        data["stateOverride"] = "another_invalid_state"
        
        let systemState = DAOSystemState(from: data)
        
        XCTAssertNotNil(systemState)
        // Should fall back to default values when invalid strings are provided
        XCTAssertEqual(systemState?.state, .green) // Default value
        XCTAssertEqual(systemState?.stateOverride, DNSSystemState.none) // Default value after invalid input
    }

    static var allTests = [
        ("testInitialization", testInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCopyInitialization", testCopyInitialization),
        ("testStateAssignment", testStateAssignment),
        ("testStateOverrideAssignment", testStateOverrideAssignment),
        ("testFailureRateAssignment", testFailureRateAssignment),
        ("testTotalPointsAssignment", testTotalPointsAssignment),
        ("testFailureCodesAssignment", testFailureCodesAssignment),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testUpdateFromObjectWithEmptyData", testUpdateFromObjectWithEmptyData),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testDictionaryConversion", testDictionaryConversion),
        ("testDictionaryRoundTrip", testDictionaryRoundTrip),
        ("testEncodingDecoding", testEncodingDecoding),
        ("testEncodingDecodingWithEmptyData", testEncodingDecodingWithEmptyData),
        ("testCopy", testCopy),
        ("testCopyWithZone", testCopyWithZone),
        ("testIsDiffFromSameObject", testIsDiffFromSameObject),
        ("testIsDiffFromEqualObject", testIsDiffFromEqualObject),
        ("testIsDiffFromDifferentState", testIsDiffFromDifferentState),
        ("testIsDiffFromDifferentStateOverride", testIsDiffFromDifferentStateOverride),
        ("testIsDiffFromDifferentFailureCodes", testIsDiffFromDifferentFailureCodes),
        ("testIsDiffFromNilObject", testIsDiffFromNilObject),
        ("testIsDiffFromDifferentType", testIsDiffFromDifferentType),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testEmptySystemState", testEmptySystemState),
        ("testValidStatesAssignment", testValidStatesAssignment),
        ("testFailureCodesWithEmptyAnalytics", testFailureCodesWithEmptyAnalytics),
        ("testLargeFailureCodesCollection", testLargeFailureCodesCollection),
        ("testDictionaryWithInvalidStateStrings", testDictionaryWithInvalidStateStrings),
    ]
}
