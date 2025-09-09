//
//  DAOActivityTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOActivityTests: XCTestCase {
    
    // MARK: - Properties -
    var sampleActivity: DAOActivity!
    
    // MARK: - Setup and Teardown -
    override func setUp() {
        super.setUp()
        sampleActivity = createSampleActivity()
    }
    
    override func tearDown() {
        sampleActivity = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods -
    private func createSampleActivity() -> DAOActivity {
        let activity = DAOActivity(
            code: "test_activity_001",
            name: DNSString(with: "Sample Activity")
        )
        
        // Add sample blackouts
        let blackout1 = DAOActivityBlackout()
        blackout1.id = "blackout_1"
        
        activity.blackouts = [blackout1]
        activity.bookingStartTime = Date()
        activity.bookingEndTime = Date().addingTimeInterval(3600)
        
        return activity
    }
    
    // MARK: - Initialization Tests -
    func testDefaultInitialization() {
        let activity = DAOActivity()
        
        // Test inherited properties
        XCTAssertFalse(activity.id.isEmpty, "Should have auto-generated ID")
        XCTAssertNotNil(activity.meta, "Should have metadata")
        XCTAssertNotNil(activity.analyticsData, "Should have analytics data array")
        
        // Test DAOActivity-specific properties
        XCTAssertNotNil(activity.baseType, "Should have base type")
        XCTAssertTrue(activity.blackouts.isEmpty, "Should have empty blackouts array by default")
        XCTAssertNil(activity.bookingStartTime, "Should have nil booking start time by default")
        XCTAssertNil(activity.bookingEndTime, "Should have nil booking end time by default")
        XCTAssertEqual(activity.code, "", "Should have empty code by default")
        XCTAssertEqual(activity.name.asString, "", "Should have empty name by default")
    }
    
    func testInitializationWithID() {
        let testID = "test_activity_id"
        let activity = DAOActivity(id: testID)
        
        XCTAssertEqual(activity.id, testID, "Should initialize with provided ID")
        validateDAOBaseFunctionality(activity)
    }
    
    func testInitializationWithCodeAndName() {
        let testCode = "TEST_CODE"
        let testName = DNSString(with: "Test Activity Name")
        let activity = DAOActivity(code: testCode, name: testName)
        
        XCTAssertEqual(activity.code, testCode, "Should set code")
        XCTAssertEqual(activity.name.asString, testName.asString, "Should set name")
        XCTAssertEqual(activity.id, testCode, "Should use code as ID")
        validateDAOBaseFunctionality(activity)
    }
    
    func testInitializationFromObject() {
        let original = createSampleActivity()
        let copy = DAOActivity(from: original)
        
        XCTAssertEqual(copy.id, original.id, "Copy should have same ID")
        XCTAssertEqual(copy.code, original.code, "Copy should have same code")
        XCTAssertEqual(copy.name.asString, original.name.asString, "Copy should have same name")
        XCTAssertEqual(copy.blackouts.count, original.blackouts.count, "Copy should have same blackouts count")
        XCTAssertEqual(copy.bookingStartTime, original.bookingStartTime, "Copy should have same booking start time")
        XCTAssertEqual(copy.bookingEndTime, original.bookingEndTime, "Copy should have same booking end time")
        
        // Test that objects are different instances
        XCTAssertFalse(copy === original, "Copy should be different instance")
        if !original.blackouts.isEmpty {
            XCTAssertFalse(copy.blackouts[0] === original.blackouts[0], "Blackouts should be deep copied")
        }
    }
    
    func testInitializationFromDictionary() {
        let testData: DNSDataDictionary = [
            "id": "dict_activity_id",
            "code": "DICT_CODE",
            "name": ["": "Dictionary Activity"],
            "baseType": [:],
            "blackouts": [],
            "bookingStartTime": Date(),
            "bookingEndTime": Date().addingTimeInterval(7200)
        ]
        
        guard let activity = DAOActivity(from: testData) else {
            XCTFail("Should create activity from dictionary")
            return
        }
        
        XCTAssertEqual(activity.id, "dict_activity_id", "Should have ID from dictionary")
        XCTAssertEqual(activity.code, "DICT_CODE", "Should have code from dictionary")
        XCTAssertEqual(activity.name.asString, "Dictionary Activity", "Should have name from dictionary")
    }
    
    func testInitializationFromEmptyDictionary() {
        let activity = DAOActivity(from: [:])
        XCTAssertNil(activity, "Should return nil for empty dictionary")
    }
    
    // MARK: - Property Tests -
    func testPropertyAssignments() {
        let activity = DAOActivity()
        let testCode = "NEW_CODE"
        let testName = DNSString(with: "New Activity Name")
        let testStartTime = Date()
        let testEndTime = Date().addingTimeInterval(1800)
        
        // Test simple properties
        activity.code = testCode
        activity.name = testName
        activity.bookingStartTime = testStartTime
        activity.bookingEndTime = testEndTime
        
        XCTAssertEqual(activity.code, testCode, "Should set code")
        XCTAssertEqual(activity.name.asString, testName.asString, "Should set name")
        XCTAssertEqual(activity.bookingStartTime, testStartTime, "Should set booking start time")
        XCTAssertEqual(activity.bookingEndTime, testEndTime, "Should set booking end time")
    }
    
    func testRelationshipProperties() {
        let activity = DAOActivity()
        
        // Test baseType property
        let baseType = DAOActivityType()
        baseType.id = "test_base_type"
        activity.baseType = baseType
        XCTAssertEqual(activity.baseType.id, "test_base_type", "Should set base type")
        
        // Test blackouts property
        let blackout1 = DAOActivityBlackout()
        blackout1.id = "blackout1"
        let blackout2 = DAOActivityBlackout()
        blackout2.id = "blackout2"
        activity.blackouts = [blackout1, blackout2]
        XCTAssertEqual(activity.blackouts.count, 2, "Should set blackouts array")
        XCTAssertEqual(activity.blackouts[0].id, "blackout1", "Should maintain blackout order")
    }
    
    // MARK: - Copy Methods Tests -
    func testCopyMethod() {
        let original = createSampleActivity()
        let copy = original.copy() as! DAOActivity
        
        XCTAssertFalse(original === copy, "Copy should be different instance")
        XCTAssertFalse(original.isDiffFrom(copy), "Copy should be equal to original")
        
        // Test deep copying of relationships
        XCTAssertFalse(original.baseType === copy.baseType, "Base type should be deep copied")
        
        XCTAssertEqual(copy.blackouts.count, original.blackouts.count, "Copy should have same number of blackouts")
        for (index, originalBlackout) in original.blackouts.enumerated() {
            XCTAssertFalse(originalBlackout === copy.blackouts[index], "Blackouts should be deep copied")
            XCTAssertEqual(originalBlackout.id, copy.blackouts[index].id, "Blackout IDs should match")
        }
    }
    
    func testUpdateMethod() {
        let activity1 = DAOActivity()
        let activity2 = createSampleActivity()
        
        activity1.update(from: activity2)
        
        XCTAssertEqual(activity1.code, activity2.code, "Should update code")
        XCTAssertEqual(activity1.name.asString, activity2.name.asString, "Should update name")
        XCTAssertEqual(activity1.bookingStartTime, activity2.bookingStartTime, "Should update booking start time")
        XCTAssertEqual(activity1.bookingEndTime, activity2.bookingEndTime, "Should update booking end time")
        XCTAssertEqual(activity1.blackouts.count, activity2.blackouts.count, "Should update blackouts")
    }
    
    // MARK: - Dictionary Translation Tests -
    func testDictionaryTranslation() {
        let activity = createSampleActivity()
        let dictionary = activity.asDictionary
        
        // Test that dictionary contains expected fields
        XCTAssertNotNil(dictionary["id"] as Any?, "Dictionary should contain id")
        XCTAssertNotNil(dictionary["meta"] as Any?, "Dictionary should contain meta")
        XCTAssertNotNil(dictionary["code"] as Any?, "Dictionary should contain code")
        XCTAssertNotNil(dictionary["name"] as Any?, "Dictionary should contain name")
        XCTAssertNotNil(dictionary["baseType"] as Any?, "Dictionary should contain baseType")
        XCTAssertNotNil(dictionary["blackouts"] as Any?, "Dictionary should contain blackouts")
        
        XCTAssertEqual(dictionary["code"] as? String, activity.code, "Dictionary code should match object code")
    }
    
    // MARK: - Codable Tests -
    func testCodableRoundTrip() {
        let original = createSampleActivity()
        validateCodableFunctionality(original)
        
        do {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            
            let jsonData = try encoder.encode(original)
            let decoded = try decoder.decode(DAOActivity.self, from: jsonData)
            
            XCTAssertFalse(decoded.id.isEmpty, "Decoded should have non-empty id")
            XCTAssertEqual(decoded.code, original.code, "Decoded should have same code")
            XCTAssertEqual(decoded.name.asString, original.name.asString, "Decoded should have same name")
            XCTAssertEqual(decoded.blackouts.count, original.blackouts.count, "Decoded should have same blackouts count")
        } catch {
            XCTFail("Codable round-trip failed: \(error)")
        }
    }
    
    // MARK: - Equality and Difference Tests -
    func testEqualityOperators() {
        let activity1 = createSampleActivity()
        let activity2 = DAOActivity(from: activity1)
        let activity3 = DAOActivity()
        
        XCTAssertTrue(activity1 == activity2, "Identical activities should be equal")
        XCTAssertFalse(activity1 != activity2, "Identical activities should not be unequal")
        XCTAssertFalse(activity1 == activity3, "Different activities should not be equal")
        XCTAssertTrue(activity1 != activity3, "Different activities should be unequal")
    }
    
    func testIsDiffFrom() {
        let activity1 = createSampleActivity()
        let activity2 = DAOActivity(from: activity1)
        let activity3 = DAOActivity()
        
        XCTAssertFalse(activity1.isDiffFrom(activity2), "Identical activities should not be different")
        XCTAssertTrue(activity1.isDiffFrom(activity3), "Different activities should be different")
        XCTAssertTrue(activity1.isDiffFrom(nil), "Activity should be different from nil")
        XCTAssertTrue(activity1.isDiffFrom("not an activity"), "Activity should be different from different type")
    }
    
    func testDifferenceDetection() {
        let activity1 = createSampleActivity()
        let activity2 = DAOActivity(from: activity1)
        
        // Test property differences
        activity2.code = "DIFFERENT_CODE"
        XCTAssertTrue(activity1.isDiffFrom(activity2), "Should detect code difference")
        
        activity2.code = activity1.code
        activity2.name = DNSString(with: "Different Name")
        XCTAssertTrue(activity1.isDiffFrom(activity2), "Should detect name difference")
    }
    
    // MARK: - Business Logic Tests -
    func testBookingTimeValidation() {
        let activity = DAOActivity()
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(3600)
        
        activity.bookingStartTime = startTime
        activity.bookingEndTime = endTime
        
        XCTAssertLessThan(activity.bookingStartTime!, activity.bookingEndTime!, "Booking start time should be before end time")
    }
    
    // MARK: - Edge Cases and Error Handling -
    func testNilPropertyHandling() {
        let activity = DAOActivity()
        
        // Test that nil properties don't cause crashes
        activity.bookingStartTime = nil
        XCTAssertNil(activity.bookingStartTime, "Should handle nil booking start time")
        
        activity.bookingEndTime = nil
        XCTAssertNil(activity.bookingEndTime, "Should handle nil booking end time")
    }
    
    // MARK: - Performance Tests -
    func testObjectCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOActivity()
            }
        }
    }
    
    func testCopyingPerformance() {
        let activity = createSampleActivity()
        
        measure {
            for _ in 0..<1000 {
                _ = activity.copy()
            }
        }
    }
    
    func testDictionaryConversionPerformance() {
        let activity = createSampleActivity()
        
        measure {
            for _ in 0..<1000 {
                _ = activity.asDictionary
            }
        }
    }
    
    // MARK: - Memory Management Tests -
    func testMemoryManagement() {
        DAOTestHelpers.validateNoMemoryLeaks {
            return createSampleActivity()
        }
    }
    
    // MARK: - Static Test List -
    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithID", testInitializationWithID),
        ("testInitializationWithCodeAndName", testInitializationWithCodeAndName),
        ("testInitializationFromObject", testInitializationFromObject),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testPropertyAssignments", testPropertyAssignments),
        ("testRelationshipProperties", testRelationshipProperties),
        ("testCopyMethod", testCopyMethod),
        ("testUpdateMethod", testUpdateMethod),
        ("testDictionaryTranslation", testDictionaryTranslation),
        ("testCodableRoundTrip", testCodableRoundTrip),
        ("testEqualityOperators", testEqualityOperators),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testDifferenceDetection", testDifferenceDetection),
        ("testBookingTimeValidation", testBookingTimeValidation),
        ("testNilPropertyHandling", testNilPropertyHandling),
        ("testObjectCreationPerformance", testObjectCreationPerformance),
        ("testCopyingPerformance", testCopyingPerformance),
        ("testDictionaryConversionPerformance", testDictionaryConversionPerformance),
        ("testMemoryManagement", testMemoryManagement),
    ]
}
