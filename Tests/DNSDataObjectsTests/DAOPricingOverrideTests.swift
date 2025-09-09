//
//  DAOPricingOverrideTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOPricingOverrideTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitDefault() {
        let override = DAOPricingOverride()
        
        XCTAssertEqual(override.enabled, false)
        XCTAssertEqual(override.endTime, DAOPricingOverride.C.defaultEndTime)
        XCTAssertTrue(override.items.isEmpty)
        XCTAssertEqual(override.priority, DNSPriority.normal)
        XCTAssertEqual(override.startTime, DAOPricingOverride.C.defaultStartTime)
        XCTAssertEqual(override.title, DNSString())
    }
    
    func testInitWithId() {
        let override = DAOPricingOverride(id: "test_id")
        
        XCTAssertEqual(override.id, "test_id")
        XCTAssertEqual(override.enabled, false)
        XCTAssertEqual(override.endTime, DAOPricingOverride.C.defaultEndTime)
        XCTAssertTrue(override.items.isEmpty)
        XCTAssertEqual(override.priority, DNSPriority.normal)
        XCTAssertEqual(override.startTime, DAOPricingOverride.C.defaultStartTime)
        XCTAssertEqual(override.title, DNSString())
    }
    
    func testInitFromObject() {
        let original = MockDAOPricingOverrideFactory.createMockWithTestData()
        let copy = DAOPricingOverride(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.enabled, original.enabled)
        XCTAssertEqual(copy.endTime, original.endTime)
        XCTAssertEqual(copy.items.count, original.items.count)
        XCTAssertEqual(copy.priority, original.priority)
        XCTAssertEqual(copy.startTime, original.startTime)
        XCTAssertEqual(copy.title.asString, original.title.asString)
    }
    
    func testInitFromEmptyData() {
        let emptyData: DNSDataDictionary = [:]
        let override = DAOPricingOverride(from: emptyData)
        
        XCTAssertNil(override)
    }
    
    func testInitFromValidData() {
        let data: DNSDataDictionary = [
            "id": "test_id",
            "enabled": true,
            "priority": DNSPriority.high,
            "title": "Test Override",
            "items": []
        ]
        
        let override = DAOPricingOverride(from: data)
        
        XCTAssertNotNil(override)
        XCTAssertEqual(override?.id, "test_id")
        XCTAssertEqual(override?.enabled, true)
        XCTAssertEqual(override?.priority, DNSPriority.high)
        XCTAssertEqual(override?.title.asString, "Test Override")
        XCTAssertTrue(override?.items.isEmpty ?? false)
    }
    
    // MARK: - Property Tests
    
    func testEnabledProperty() {
        let override = DAOPricingOverride()
        
        XCTAssertFalse(override.enabled)
        
        override.enabled = true
        XCTAssertTrue(override.enabled)
        
        override.enabled = false
        XCTAssertFalse(override.enabled)
    }
    
    func testEndTimeProperty() {
        let override = DAOPricingOverride()
        let testDate = Date()
        
        XCTAssertEqual(override.endTime, DAOPricingOverride.C.defaultEndTime)
        
        override.endTime = testDate
        XCTAssertEqual(override.endTime, testDate)
    }
    
    func testItemsProperty() {
        let override = DAOPricingOverride()
        let item1 = DAOPricingItem()
        let item2 = DAOPricingItem(id: "item2")
        
        XCTAssertTrue(override.items.isEmpty)
        
        override.items = [item1, item2]
        XCTAssertEqual(override.items.count, 2)
        XCTAssertEqual(override.items[1].id, "item2")
    }
    
    func testPriorityProperty() {
        let override = DAOPricingOverride()
        
        XCTAssertEqual(override.priority, DNSPriority.normal)
        
        override.priority = DNSPriority.high
        XCTAssertEqual(override.priority, DNSPriority.high)
    }
    
    func testPriorityClampingToHighest() {
        let override = DAOPricingOverride()
        
        override.priority = DNSPriority.highest + 10
        XCTAssertEqual(override.priority, DNSPriority.highest)
    }
    
    func testPriorityClampingToNone() {
        let override = DAOPricingOverride()
        
        override.priority = DNSPriority.none - 10
        XCTAssertEqual(override.priority, DNSPriority.none)
    }
    
    func testStartTimeProperty() {
        let override = DAOPricingOverride()
        let testDate = Date()
        
        XCTAssertEqual(override.startTime, DAOPricingOverride.C.defaultStartTime)
        
        override.startTime = testDate
        XCTAssertEqual(override.startTime, testDate)
    }
    
    func testTitleProperty() {
        let override = DAOPricingOverride()
        let testTitle = DNSString(with: "Test Title")
        
        XCTAssertEqual(override.title, DNSString())
        
        override.title = testTitle
        XCTAssertEqual(override.title, testTitle)
    }
    
    // MARK: - Business Logic Tests
    
    func testIsActiveWhenDisabled() {
        let override = DAOPricingOverride()
        override.enabled = false
        
        XCTAssertFalse(override.isActive)
        XCTAssertFalse(override.isActive(for: Date()))
    }
    
    func testIsActiveWhenEnabledWithDefaultTimes() {
        let override = DAOPricingOverride()
        override.enabled = true
        // Start and end times are default values
        
        XCTAssertTrue(override.isActive)
        XCTAssertTrue(override.isActive(for: Date()))
    }
    
    func testIsActiveWithStartTimeOnly() {
        let override = DAOPricingOverride()
        override.enabled = true
        override.startTime = Date().addingTimeInterval(-3600) // 1 hour ago
        override.endTime = DAOPricingOverride.C.defaultEndTime
        
        let now = Date()
        XCTAssertTrue(override.isActive(for: now))
        
        let past = Date().addingTimeInterval(-7200) // 2 hours ago
        XCTAssertFalse(override.isActive(for: past))
    }
    
    func testIsActiveWithEndTimeOnly() {
        let override = DAOPricingOverride()
        override.enabled = true
        override.startTime = DAOPricingOverride.C.defaultStartTime
        override.endTime = Date().addingTimeInterval(3600) // 1 hour from now
        
        let now = Date()
        XCTAssertTrue(override.isActive(for: now))
        
        let future = Date().addingTimeInterval(7200) // 2 hours from now
        XCTAssertFalse(override.isActive(for: future))
    }
    
    func testIsActiveWithinTimeRange() {
        let override = DAOPricingOverride()
        override.enabled = true
        override.startTime = Date().addingTimeInterval(-3600) // 1 hour ago
        override.endTime = Date().addingTimeInterval(3600) // 1 hour from now
        
        let now = Date()
        XCTAssertTrue(override.isActive(for: now))
        
        let past = Date().addingTimeInterval(-7200) // 2 hours ago
        XCTAssertFalse(override.isActive(for: past))
        
        let future = Date().addingTimeInterval(7200) // 2 hours from now
        XCTAssertFalse(override.isActive(for: future))
    }
    
    func testItemWithNoItems() {
        let override = DAOPricingOverride()
        
        XCTAssertNil(override.item)
        XCTAssertNil(override.item(for: Date()))
    }
    
    func testPriceWithNoItems() {
        let override = DAOPricingOverride()
        
        XCTAssertNil(override.price)
        XCTAssertNil(override.price(for: Date()))
    }
    
    // MARK: - Update Tests
    
    func testUpdateFromObject() {
        let original = DAOPricingOverride()
        original.enabled = false
        original.priority = DNSPriority.low
        original.title = DNSString(with: "Original")
        
        let updated = MockDAOPricingOverrideFactory.createMockWithTestData()
        original.update(from: updated)
        
        XCTAssertEqual(original.enabled, updated.enabled)
        XCTAssertEqual(original.endTime, updated.endTime)
        XCTAssertEqual(original.items.count, updated.items.count)
        XCTAssertEqual(original.priority, updated.priority)
        XCTAssertEqual(original.startTime, updated.startTime)
        XCTAssertEqual(original.title.asString, updated.title.asString)
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testAsDictionaryContainsAllProperties() {
        let override = MockDAOPricingOverrideFactory.createMockWithTestData()
        let dictionary = override.asDictionary
        
        XCTAssertNotNil(dictionary["enabled"] as Any?)
        XCTAssertNotNil(dictionary["endTime"] as Any?)
        XCTAssertNotNil(dictionary["items"] as Any?)
        XCTAssertNotNil(dictionary["priority"] as Any?)
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertNotNil(dictionary["title"] as Any?)
    }
    
    func testDictionaryRoundTrip() {
        let original = MockDAOPricingOverrideFactory.createMockWithTestData()
        let dictionary = original.asDictionary
        let recreated = DAOPricingOverride(from: dictionary)
        
        XCTAssertNotNil(recreated)
        XCTAssertEqual(recreated?.enabled, original.enabled)
        XCTAssertEqual(recreated?.priority, original.priority)
        XCTAssertEqual(recreated?.title.asString, original.title.asString)
    }
    
    // MARK: - Codable Tests
    
    func testEncodingDecoding() throws {
        let original = MockDAOPricingOverrideFactory.createMockWithTestData()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOPricingOverride.self, from: data)
        
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.enabled, original.enabled)
        XCTAssertEqual(decoded.priority, original.priority)
        XCTAssertEqual(decoded.title.asString, original.title.asString)
    }
    
    func testDecodingWithMissingOptionalFields() throws {
        let json = """
        {
            "id": "test_id",
            "enabled": true,
            "priority": 50
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOPricingOverride.self, from: data)
        
        XCTAssertEqual(decoded.id, "test_id")
        XCTAssertEqual(decoded.enabled, true)
        XCTAssertEqual(decoded.priority, 50)
        XCTAssertEqual(decoded.title, DNSString())
    }
    
    // MARK: - NSCopying Tests
    
    func testCopy() {
        let original = MockDAOPricingOverrideFactory.createMockWithTestData()
        let copy = original.copy() as! DAOPricingOverride
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.enabled, original.enabled)
        XCTAssertEqual(copy.endTime, original.endTime)
        XCTAssertEqual(copy.items.count, original.items.count)
        XCTAssertEqual(copy.priority, original.priority)
        XCTAssertEqual(copy.startTime, original.startTime)
        XCTAssertEqual(copy.title.asString, original.title.asString)
        
        // Verify they are different instances
        XCTAssertTrue(copy !== original)
    }
    
    // MARK: - Difference Detection Tests
    
    func testIsDiffFromSameObject() {
        let override = MockDAOPricingOverrideFactory.createMockWithTestData()
        
        XCTAssertFalse(override.isDiffFrom(override))
    }
    
    func testIsDiffFromNil() {
        let override = MockDAOPricingOverrideFactory.createMockWithTestData()
        
        XCTAssertTrue(override.isDiffFrom(nil))
    }
    
    func testIsDiffFromDifferentType() {
        let override = MockDAOPricingOverrideFactory.createMockWithTestData()
        let other = "not an override"
        
        XCTAssertTrue(override.isDiffFrom(other))
    }
    
    func testIsDiffFromEqualObject() {
        let override1 = MockDAOPricingOverrideFactory.createMockWithTestData()
        let override2 = DAOPricingOverride(from: override1)
        
        XCTAssertFalse(override1.isDiffFrom(override2))
        XCTAssertFalse(override2.isDiffFrom(override1))
    }
    
    func testIsDiffFromDifferentEnabled() {
        let override1 = MockDAOPricingOverrideFactory.createMockWithTestData()
        let override2 = DAOPricingOverride(from: override1)
        override2.enabled = !override1.enabled
        
        XCTAssertTrue(override1.isDiffFrom(override2))
    }
    
    func testIsDiffFromDifferentEndTime() {
        let override1 = MockDAOPricingOverrideFactory.createMockWithTestData()
        let override2 = DAOPricingOverride(from: override1)
        override2.endTime = Date().addingTimeInterval(7200)
        
        XCTAssertTrue(override1.isDiffFrom(override2))
    }
    
    func testIsDiffFromDifferentPriority() {
        let override1 = MockDAOPricingOverrideFactory.createMockWithTestData()
        let override2 = DAOPricingOverride(from: override1)
        override2.priority = DNSPriority.low
        
        XCTAssertTrue(override1.isDiffFrom(override2))
    }
    
    func testIsDiffFromDifferentStartTime() {
        let override1 = MockDAOPricingOverrideFactory.createMockWithTestData()
        let override2 = DAOPricingOverride(from: override1)
        override2.startTime = Date().addingTimeInterval(-7200)
        
        XCTAssertTrue(override1.isDiffFrom(override2))
    }
    
    func testIsDiffFromDifferentTitle() {
        let override1 = MockDAOPricingOverrideFactory.createMockWithTestData()
        let override2 = DAOPricingOverride(from: override1)
        override2.title = DNSString(with: "Different Title")
        
        XCTAssertTrue(override1.isDiffFrom(override2))
    }
    
    // MARK: - Equatable Tests
    
    func testEquality() {
        let override1 = MockDAOPricingOverrideFactory.createMockWithTestData()
        let override2 = DAOPricingOverride(from: override1)
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(override1.id, override2.id)
        XCTAssertEqual(override1.enabled, override2.enabled)
        XCTAssertEqual(override1.priority, override2.priority)
        XCTAssertEqual(override1.title.asString, override2.title.asString)
        XCTAssertEqual(override1.items.count, override2.items.count)
        XCTAssertFalse(override1 != override2)
    }
    
    func testInequality() {
        let override1 = MockDAOPricingOverrideFactory.createMockWithTestData()
        let override2 = MockDAOPricingOverrideFactory.createMockWithEdgeCases()
        
        XCTAssertNotEqual(override1, override2)
        XCTAssertTrue(override1 != override2)
    }
    
    // MARK: - Factory Method Tests
    
    func testCreatePricingItem() {
        let item = DAOPricingOverride.createPricingItem()
        
        XCTAssertNotNil(item)
        XCTAssertTrue(item is DAOPricingItem)
    }
    
    func testCreatePricingItemFromObject() {
        let original = DAOPricingItem()
        let copy = DAOPricingOverride.createPricingItem(from: original)
        
        XCTAssertNotNil(copy)
        XCTAssertEqual(copy.id, original.id)
    }
    
    func testCreatePricingOverride() {
        let override = DAOPricingOverride.createPricingOverride()
        
        XCTAssertNotNil(override)
        XCTAssertTrue(override is DAOPricingOverride)
    }
    
    func testCreatePricingOverrideFromObject() {
        let original = MockDAOPricingOverrideFactory.createMockWithTestData()
        let copy = DAOPricingOverride.createPricingOverride(from: original)
        
        XCTAssertNotNil(copy)
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.enabled, original.enabled)
    }
    
    // MARK: - Edge Case Tests
    
    func testDefaultConstants() {
        let defaultEndTime = DAOPricingOverride.C.defaultEndTime
        let defaultStartTime = DAOPricingOverride.C.defaultStartTime
        
        XCTAssertEqual(defaultStartTime, Date(timeIntervalSinceReferenceDate: 0.0))
        XCTAssertEqual(defaultEndTime, Date(timeIntervalSinceReferenceDate: Date.Seconds.deltaOneYear * 30.0))
    }
    
    func testEmptyItemsArray() {
        let override = DAOPricingOverride()
        override.items = []
        
        XCTAssertTrue(override.items.isEmpty)
        XCTAssertNil(override.item)
        XCTAssertNil(override.price)
    }
    
    func testPriorityBoundaryValues() {
        let override = DAOPricingOverride()
        
        override.priority = DNSPriority.none
        XCTAssertEqual(override.priority, DNSPriority.none)
        
        override.priority = DNSPriority.highest
        XCTAssertEqual(override.priority, DNSPriority.highest)
    }
    
    static var allTests = [
        ("testInitDefault", testInitDefault),
        ("testInitWithId", testInitWithId),
        ("testInitFromObject", testInitFromObject),
        ("testInitFromEmptyData", testInitFromEmptyData),
        ("testInitFromValidData", testInitFromValidData),
        ("testEnabledProperty", testEnabledProperty),
        ("testEndTimeProperty", testEndTimeProperty),
        ("testItemsProperty", testItemsProperty),
        ("testPriorityProperty", testPriorityProperty),
        ("testPriorityClampingToHighest", testPriorityClampingToHighest),
        ("testPriorityClampingToNone", testPriorityClampingToNone),
        ("testStartTimeProperty", testStartTimeProperty),
        ("testTitleProperty", testTitleProperty),
        ("testIsActiveWhenDisabled", testIsActiveWhenDisabled),
        ("testIsActiveWhenEnabledWithDefaultTimes", testIsActiveWhenEnabledWithDefaultTimes),
        ("testIsActiveWithStartTimeOnly", testIsActiveWithStartTimeOnly),
        ("testIsActiveWithEndTimeOnly", testIsActiveWithEndTimeOnly),
        ("testIsActiveWithinTimeRange", testIsActiveWithinTimeRange),
        ("testItemWithNoItems", testItemWithNoItems),
        ("testPriceWithNoItems", testPriceWithNoItems),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testAsDictionaryContainsAllProperties", testAsDictionaryContainsAllProperties),
        ("testDictionaryRoundTrip", testDictionaryRoundTrip),
        ("testEncodingDecoding", testEncodingDecoding),
        ("testDecodingWithMissingOptionalFields", testDecodingWithMissingOptionalFields),
        ("testCopy", testCopy),
        ("testIsDiffFromSameObject", testIsDiffFromSameObject),
        ("testIsDiffFromNil", testIsDiffFromNil),
        ("testIsDiffFromDifferentType", testIsDiffFromDifferentType),
        ("testIsDiffFromEqualObject", testIsDiffFromEqualObject),
        ("testIsDiffFromDifferentEnabled", testIsDiffFromDifferentEnabled),
        ("testIsDiffFromDifferentEndTime", testIsDiffFromDifferentEndTime),
        ("testIsDiffFromDifferentPriority", testIsDiffFromDifferentPriority),
        ("testIsDiffFromDifferentStartTime", testIsDiffFromDifferentStartTime),
        ("testIsDiffFromDifferentTitle", testIsDiffFromDifferentTitle),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testCreatePricingItem", testCreatePricingItem),
        ("testCreatePricingItemFromObject", testCreatePricingItemFromObject),
        ("testCreatePricingOverride", testCreatePricingOverride),
        ("testCreatePricingOverrideFromObject", testCreatePricingOverrideFromObject),
        ("testDefaultConstants", testDefaultConstants),
        ("testEmptyItemsArray", testEmptyItemsArray),
        ("testPriorityBoundaryValues", testPriorityBoundaryValues),
    ]
}
