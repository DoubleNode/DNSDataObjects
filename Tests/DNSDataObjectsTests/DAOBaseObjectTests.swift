//
//  DAOBaseObjectTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOBaseObjectTests: XCTestCase {
    
    // MARK: - Properties -
    var sampleBaseObject: DAOBaseObject!
    
    // MARK: - Setup and Teardown -
    override func setUp() {
        super.setUp()
        sampleBaseObject = createSampleBaseObject()
    }
    
    override func tearDown() {
        sampleBaseObject = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods -
    private func createSampleBaseObject() -> DAOBaseObject {
        let baseObject = DAOBaseObject()
        baseObject.id = "test_base_object_id"
        
        // Add sample analytics data
        let analyticsData = DAOAnalyticsData()
        analyticsData.id = "analytics_1"
        baseObject.analyticsData = [analyticsData]
        
        return baseObject
    }
    
    // MARK: - Initialization Tests -
    func testDefaultInitialization() {
        let baseObject = DAOBaseObject()
        
        XCTAssertFalse(baseObject.id.isEmpty, "Should have auto-generated ID")
        XCTAssertNotNil(baseObject.meta, "Should have metadata")
        XCTAssertNotNil(baseObject.analyticsData, "Should have analytics data array")
        XCTAssertTrue(baseObject.analyticsData.isEmpty, "Should have empty analytics data array by default")
    }
    
    func testInitializationWithID() {
        let testID = "custom_base_object_id"
        let baseObject = DAOBaseObject(id: testID)
        
        XCTAssertEqual(baseObject.id, testID, "Should initialize with provided ID")
        XCTAssertNotNil(baseObject.meta, "Should have metadata")
        XCTAssertNotNil(baseObject.analyticsData, "Should have analytics data array")
    }
    
    func testInitializationFromObject() {
        let original = createSampleBaseObject()
        let copy = DAOBaseObject(from: original)
        
        XCTAssertEqual(copy.id, original.id, "Copy should have same ID")
        XCTAssertEqual(copy.analyticsData.count, original.analyticsData.count, "Copy should have same analytics data count")
        
        // Test that objects are different instances
        XCTAssertFalse(copy === original, "Copy should be different instance")
    }
    
    func testInitializationFromDictionary() {
        let testData: DNSDataDictionary = [
            "id": "dictionary_test_id",
            "meta": [
                "uid": UUID().uuidString,
                "status": "active"
            ],
            "analyticsData": []
        ]
        
        guard let baseObject = DAOBaseObject(from: testData) else {
            XCTFail("Should create base object from dictionary")
            return
        }
        
        XCTAssertEqual(baseObject.id, "dictionary_test_id", "Should have ID from dictionary")
    }
    
    func testInitializationFromEmptyDictionary() {
        let baseObject = DAOBaseObject(from: [:])
        XCTAssertNil(baseObject, "Should return nil for empty dictionary")
    }
    
    // MARK: - Property Tests -
    func testPropertyAssignments() {
        let baseObject = DAOBaseObject()
        let testID = "new_test_id"
        
        baseObject.id = testID
        XCTAssertEqual(baseObject.id, testID, "Should set ID")
        
        let analyticsData = DAOAnalyticsData()
        analyticsData.id = "analytics_test"
        baseObject.analyticsData = [analyticsData]
        
        XCTAssertEqual(baseObject.analyticsData.count, 1, "Should set analytics data")
        XCTAssertEqual((baseObject.analyticsData.first as? DAOAnalyticsData)?.id, "analytics_test", "Should maintain analytics data ID")
    }
    
    // MARK: - Copy Methods Tests -
    func testCopyMethod() {
        let original = createSampleBaseObject()
        let copy = original.copy() as! DAOBaseObject
        
        XCTAssertFalse(original === copy, "Copy should be different instance")
        XCTAssertFalse(original.isDiffFrom(copy), "Copy should be equal to original")
        
        XCTAssertEqual(copy.id, original.id, "Copy should have same ID")
        XCTAssertEqual(copy.analyticsData.count, original.analyticsData.count, "Copy should have same analytics data count")
    }
    
    func testUpdateMethod() {
        let baseObject1 = DAOBaseObject()
        let baseObject2 = createSampleBaseObject()
        
        baseObject1.update(from: baseObject2)
        
        XCTAssertEqual(baseObject1.id, baseObject2.id, "Should update ID")
        XCTAssertEqual(baseObject1.analyticsData.count, baseObject2.analyticsData.count, "Should update analytics data")
    }
    
    // MARK: - Dictionary Translation Tests -
    func testDictionaryTranslation() {
        let baseObject = createSampleBaseObject()
        let dictionary = baseObject.asDictionary
        
        // Test that dictionary contains expected fields
        XCTAssertNotNil(dictionary["id"] as Any?, "Dictionary should contain id")
        XCTAssertNotNil(dictionary["meta"] as Any?, "Dictionary should contain meta")
        XCTAssertNotNil(dictionary["analyticsData"] as Any?, "Dictionary should contain analyticsData")
        
        XCTAssertEqual(dictionary["id"] as? String, baseObject.id, "Dictionary id should match object id")
    }
    
    // MARK: - Codable Tests -
    func testCodableRoundTrip() {
        let original = createSampleBaseObject()
        validateCodableFunctionality(original)
        
        do {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            
            let jsonData = try encoder.encode(original)
            let decoded = try decoder.decode(DAOBaseObject.self, from: jsonData)
            
            XCTAssertFalse(decoded.id.isEmpty, "Decoded should have non-empty id")
            XCTAssertEqual(decoded.analyticsData.count, original.analyticsData.count, "Decoded should have same analytics data count")
        } catch {
            XCTFail("Codable round-trip failed: \(error)")
        }
    }
    
    // MARK: - Equality and Difference Tests -
    func testEqualityOperators() {
        let baseObject1 = createSampleBaseObject()
        let baseObject2 = DAOBaseObject(from: baseObject1)
        let baseObject3 = DAOBaseObject()
        
        XCTAssertTrue(baseObject1 == baseObject2, "Identical base objects should be equal")
        XCTAssertFalse(baseObject1 != baseObject2, "Identical base objects should not be unequal")
        XCTAssertFalse(baseObject1 == baseObject3, "Different base objects should not be equal")
        XCTAssertTrue(baseObject1 != baseObject3, "Different base objects should be unequal")
    }
    
    func testIsDiffFrom() {
        let baseObject1 = createSampleBaseObject()
        let baseObject2 = DAOBaseObject(from: baseObject1)
        let baseObject3 = DAOBaseObject()
        
        XCTAssertFalse(baseObject1.isDiffFrom(baseObject2), "Identical base objects should not be different")
        XCTAssertTrue(baseObject1.isDiffFrom(baseObject3), "Different base objects should be different")
        XCTAssertTrue(baseObject1.isDiffFrom(nil), "Base object should be different from nil")
        XCTAssertTrue(baseObject1.isDiffFrom("not a base object"), "Base object should be different from different type")
    }
    
    func testDifferenceDetection() {
        let baseObject1 = createSampleBaseObject()
        let baseObject2 = DAOBaseObject(from: baseObject1)
        
        // Test ID differences
        baseObject2.id = "different_id"
        XCTAssertTrue(baseObject1.isDiffFrom(baseObject2), "Should detect ID difference")
        
        baseObject2.id = baseObject1.id
        
        // Test analytics data differences
        let newAnalyticsData = DAOAnalyticsData()
        newAnalyticsData.id = "different_analytics"
        baseObject2.analyticsData = [newAnalyticsData]
        XCTAssertTrue(baseObject1.isDiffFrom(baseObject2), "Should detect analytics data difference")
    }
    
    // MARK: - Performance Tests -
    func testObjectCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOBaseObject()
            }
        }
    }
    
    func testCopyingPerformance() {
        let baseObject = createSampleBaseObject()
        
        measure {
            for _ in 0..<1000 {
                _ = baseObject.copy()
            }
        }
    }
    
    func testDictionaryConversionPerformance() {
        let baseObject = createSampleBaseObject()
        
        measure {
            for _ in 0..<1000 {
                _ = baseObject.asDictionary
            }
        }
    }
    
    // MARK: - Memory Management Tests -
    func testMemoryManagement() {
        DAOTestHelpers.validateNoMemoryLeaks {
            return createSampleBaseObject()
        }
    }
    
    // MARK: - Static Test List -
    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithID", testInitializationWithID),
        ("testInitializationFromObject", testInitializationFromObject),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testPropertyAssignments", testPropertyAssignments),
        ("testCopyMethod", testCopyMethod),
        ("testUpdateMethod", testUpdateMethod),
        ("testDictionaryTranslation", testDictionaryTranslation),
        ("testCodableRoundTrip", testCodableRoundTrip),
        ("testEqualityOperators", testEqualityOperators),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testDifferenceDetection", testDifferenceDetection),
        ("testObjectCreationPerformance", testObjectCreationPerformance),
        ("testCopyingPerformance", testCopyingPerformance),
        ("testDictionaryConversionPerformance", testDictionaryConversionPerformance),
        ("testMemoryManagement", testMemoryManagement),
    ]
}
