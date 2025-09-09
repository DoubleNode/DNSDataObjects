//
//  DAOEventTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOEventTests: XCTestCase {
    
    // MARK: - Properties -
    var sampleEvent: DAOEvent!
    
    // MARK: - Setup and Teardown -
    override func setUp() {
        super.setUp()
        sampleEvent = createSampleEvent()
    }
    
    override func tearDown() {
        sampleEvent = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods -
    private func createSampleEvent() -> DAOEvent {
        let event = DAOEvent(id: "sample_event_123")
        event.title = DNSString(with: "Sample Event")
        event.body = DNSString(with: "Sample event body")
        event.enabled = true
        return event
    }
    
    // MARK: - Initialization Tests -
    func testDefaultInitialization() {
        let event = DAOEvent()
        
        XCTAssertFalse(event.id.isEmpty, "Should have auto-generated ID")
        XCTAssertNotNil(event.meta, "Should have metadata")
        XCTAssertNotNil(event.analyticsData, "Should have analytics data array")
        XCTAssertTrue(event.analyticsData.isEmpty, "Should have empty analytics data array by default")
    }
    
    func testInitializationWithID() {
        let testID = "custom_event_id"
        let event = DAOEvent(id: testID)
        
        XCTAssertEqual(event.id, testID, "Should initialize with provided ID")
        validateDAOBaseFunctionality(event)
    }
    
    func testInitializationFromObject() {
        let original = createSampleEvent()
        let copy = DAOEvent(from: original)
        
        XCTAssertEqual(copy.id, original.id, "Copy should have same ID")
        XCTAssertFalse(copy === original, "Copy should be different instance")
    }
    
    func testInitializationFromDictionary() {
        let testData: DNSDataDictionary = [
            "id": "dict_event_id",
            "meta": [
                "uid": UUID().uuidString,
                "status": "active"
            ],
            "analyticsData": []
        ]
        
        guard let event = DAOEvent(from: testData) else {
            XCTFail("Should create event from dictionary")
            return
        }
        
        XCTAssertEqual(event.id, "dict_event_id", "Should have ID from dictionary")
    }
    
    func testInitializationFromEmptyDictionary() {
        let emptyDictionary: DNSDataDictionary = [:]
        let event = DAOEvent(from: emptyDictionary)
        XCTAssertNil(event, "Should return nil for empty dictionary")
    }
    
    // MARK: - Copy Methods Tests -
    func testCopyMethod() {
        let original = createSampleEvent()
        let copy = original.copy() as! DAOEvent
        
        XCTAssertFalse(original === copy, "Copy should be different instance")
        XCTAssertFalse(original.isDiffFrom(copy), "Copy should be equal to original")
        XCTAssertEqual(copy.id, original.id, "Copy should have same ID")
    }
    
    func testUpdateMethod() {
        let event1 = DAOEvent()
        let event2 = createSampleEvent()
        
        event1.update(from: event2)
        
        XCTAssertEqual(event1.id, event2.id, "Should update ID")
    }
    
    // MARK: - Dictionary Translation Tests -
    func testDictionaryTranslation() {
        let event = createSampleEvent()
        let dictionary = event.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?, "Dictionary should contain id")
        XCTAssertNotNil(dictionary["meta"] as Any?, "Dictionary should contain meta")
        XCTAssertNotNil(dictionary["analyticsData"] as Any?, "Dictionary should contain analyticsData")
        
        XCTAssertEqual(dictionary["id"] as? String, event.id, "Dictionary id should match object id")
    }
    
    // MARK: - Codable Tests -
    func testCodableRoundTrip() {
        let original = createSampleEvent()
        validateCodableFunctionality(original)
        
        do {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            
            let jsonData = try encoder.encode(original)
            let decoded = try decoder.decode(DAOEvent.self, from: jsonData)
            
            XCTAssertFalse(decoded.id.isEmpty, "Decoded should have non-empty id")
        } catch {
            XCTFail("Codable round-trip failed: \(error)")
        }
    }
    
    // MARK: - Equality and Difference Tests -
    func testEqualityOperators() {
        let event1 = createSampleEvent()
        let event2 = DAOEvent(from: event1)
        let event3 = DAOEvent()
        
        XCTAssertTrue(event1 == event2, "Identical events should be equal")
        XCTAssertFalse(event1 != event2, "Identical events should not be unequal")
        XCTAssertFalse(event1 == event3, "Different events should not be equal")
        XCTAssertTrue(event1 != event3, "Different events should be unequal")
    }
    
    func testIsDiffFrom() {
        let event1 = createSampleEvent()
        let event2 = DAOEvent(from: event1)
        let event3 = DAOEvent()
        
        XCTAssertFalse(event1.isDiffFrom(event2), "Identical events should not be different")
        XCTAssertTrue(event1.isDiffFrom(event3), "Different events should be different")
        XCTAssertTrue(event1.isDiffFrom(nil), "Event should be different from nil")
        XCTAssertTrue(event1.isDiffFrom("not an event"), "Event should be different from different type")
    }
    
    // MARK: - Performance Tests -
    func testObjectCreationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOEvent()
            }
        }
    }
    
    func testCopyingPerformance() {
        let event = createSampleEvent()
        
        measure {
            for _ in 0..<1000 {
                _ = event.copy()
            }
        }
    }
    
    // MARK: - Memory Management Tests -
    func testMemoryManagement() {
        DAOTestHelpers.validateNoMemoryLeaks {
            return createSampleEvent()
        }
    }
    
    // MARK: - Factory Tests -
    func testMockFactory() {
        let event = MockDAOEventFactory.createMock()
        XCTAssertNotNil(event)
        XCTAssertEqual(event.title.asString, "Mock Event")
        XCTAssertEqual(event.body.asString, "Mock event description")
        XCTAssertTrue(event.enabled)
    }
    
    func testMockFactoryWithTestData() {
        let event = MockDAOEventFactory.createMockWithTestData()
        XCTAssertNotNil(event)
        XCTAssertEqual(event.id, "event_test_data")
        XCTAssertEqual(event.title.asString, "Test Event with Data")
        XCTAssertEqual(event.days.count, 2)
    }
    
    func testMockFactoryArray() {
        let events = MockDAOEventFactory.createMockArray(count: 3)
        XCTAssertEqual(events.count, 3)
        XCTAssertEqual(events[0].title.asString, "Event 1")
        XCTAssertEqual(events[1].title.asString, "Event 2")
        XCTAssertEqual(events[2].title.asString, "Event 3")
        XCTAssertTrue(events[0].enabled) // First is enabled
        XCTAssertFalse(events[1].enabled) // Second is disabled
    }
    
    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithID", testInitializationWithID),
        ("testInitializationFromObject", testInitializationFromObject),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testCopyMethod", testCopyMethod),
        ("testUpdateMethod", testUpdateMethod),
        ("testDictionaryTranslation", testDictionaryTranslation),
        ("testCodableRoundTrip", testCodableRoundTrip),
        ("testEqualityOperators", testEqualityOperators),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testObjectCreationPerformance", testObjectCreationPerformance),
        ("testCopyingPerformance", testCopyingPerformance),
        ("testMemoryManagement", testMemoryManagement),
        ("testMockFactory", testMockFactory),
        ("testMockFactoryWithTestData", testMockFactoryWithTestData),
        ("testMockFactoryArray", testMockFactoryArray),
    ]
}