//
//  DAOAppEventTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects
import Foundation

final class DAOAppEventTests: XCTestCase {
    
    // MARK: - Basic Initialization Tests
    
    func testDefaultInitialization() {
        let appEvent = DAOAppEvent()
        
        XCTAssertNotNil(appEvent.id)
        XCTAssertFalse(appEvent.id.isEmpty)
        
        // Test default values
        XCTAssertEqual(appEvent.endTime, DAOAppEvent.C.defaultEndTime)
        XCTAssertEqual(appEvent.priority, DNSPriority.normal)
        XCTAssertEqual(appEvent.startTime, DAOAppEvent.C.defaultStartTime)
        XCTAssertEqual(appEvent.title.asString, "")
    }
    
    func testInitializationWithId() {
        let testId = "test-appevent-123"
        let appEvent = DAOAppEvent(id: testId)
        
        XCTAssertEqual(appEvent.id, testId)
        
        // Verify default values are still set
        XCTAssertEqual(appEvent.priority, DNSPriority.normal)
        XCTAssertEqual(appEvent.endTime, DAOAppEvent.C.defaultEndTime)
        XCTAssertEqual(appEvent.startTime, DAOAppEvent.C.defaultStartTime)
    }
    
    func testCustomInitializer() {
        let title = DNSString(with: "Custom Event")
        let startTime = Date()
        let endTime = Date().addingTimeInterval(3600)
        
        let appEvent = DAOAppEvent(title: title, startTime: startTime, endTime: endTime)
        
        XCTAssertEqual(appEvent.title.asString, "Custom Event")
        XCTAssertEqual(appEvent.startTime, startTime)
        XCTAssertEqual(appEvent.endTime, endTime)
        XCTAssertEqual(appEvent.priority, DNSPriority.normal) // Default priority
    }
    
    // MARK: - Property Assignment Tests
    
    func testPropertyAssignment() {
        let appEvent = MockDAOAppEventFactory.createMockAppEvent()
        
        XCTAssertEqual(appEvent.title.asString, "Mock App Event")
        XCTAssertEqual(appEvent.priority, DNSPriority.normal)
        
        // Test that dates are properly set
        XCTAssertTrue(appEvent.startTime <= appEvent.endTime)
    }
    
    func testPriorityValidation() {
        let appEvent = DAOAppEvent()
        
        // Test valid priorities
        appEvent.priority = DNSPriority.low
        XCTAssertEqual(appEvent.priority, DNSPriority.low)
        
        appEvent.priority = DNSPriority.high
        XCTAssertEqual(appEvent.priority, DNSPriority.high)
        
        // Test boundary validation in didSet
        appEvent.priority = DNSPriority.highest + 1 // Should clamp to highest
        XCTAssertEqual(appEvent.priority, DNSPriority.highest)
        
        appEvent.priority = DNSPriority.none - 1 // Should clamp to none
        XCTAssertEqual(appEvent.priority, DNSPriority.none)
    }
    
    func testPriorityEnumValues() {
        let appEvents = MockDAOAppEventFactory.createMockAppEventWithAllPriorityLevels()
        
        XCTAssertEqual(appEvents.count, 5)
        
        let priorities = appEvents.map { $0.priority }
        XCTAssertTrue(priorities.contains(DNSPriority.none))
        XCTAssertTrue(priorities.contains(DNSPriority.low))
        XCTAssertTrue(priorities.contains(DNSPriority.normal))
        XCTAssertTrue(priorities.contains(DNSPriority.high))
        XCTAssertTrue(priorities.contains(DNSPriority.highest))
    }
    
    // MARK: - Copy and Update Tests
    
    func testCopyInitialization() {
        let original = MockDAOAppEventFactory.createMockAppEvent()
        let copy = DAOAppEvent(from: original)
        
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.endTime, copy.endTime)
        XCTAssertEqual(original.priority, copy.priority)
        XCTAssertEqual(original.startTime, copy.startTime)
        XCTAssertEqual(original.title.asString, copy.title.asString)
        
        // Verify they are different instances
        XCTAssertTrue(original !== copy)
    }
    
    func testUpdateFromObject() {
        let appEvent1 = DAOAppEvent()
        let appEvent2 = MockDAOAppEventFactory.createMockAppEvent()
        
        appEvent1.update(from: appEvent2)
        
        XCTAssertEqual(appEvent1.endTime, appEvent2.endTime)
        XCTAssertEqual(appEvent1.priority, appEvent2.priority)
        XCTAssertEqual(appEvent1.startTime, appEvent2.startTime)
        XCTAssertEqual(appEvent1.title.asString, appEvent2.title.asString)
    }
    
    func testNSCopying() {
        let original = MockDAOAppEventFactory.createMockAppEvent()
        let copy = original.copy() as! DAOAppEvent
        
        XCTAssertTrue(MockDAOAppEventFactory.validateAppEventEquality(original, copy))
        XCTAssertTrue(original !== copy) // Different instances
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testInitializationFromDictionary() {
        let dictionary = MockDAOAppEventFactory.createMockAppEventDictionary()
        let appEvent = DAOAppEvent(from: dictionary)
        
        XCTAssertNotNil(appEvent)
        XCTAssertEqual(appEvent?.id, "appevent123")
        XCTAssertEqual(appEvent?.priority, DNSPriority.normal)
        XCTAssertEqual(appEvent?.title.asString, "Mock App Event")
    }
    
    func testInitializationFromEmptyDictionary() {
        let emptyDictionary: DNSDataDictionary = [:]
        let appEvent = DAOAppEvent(from: emptyDictionary)
        
        XCTAssertNil(appEvent)
    }
    
    func testAsDictionary() {
        let appEvent = MockDAOAppEventFactory.createMockAppEvent()
        let dictionary = appEvent.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["endTime"] as Any?)
        XCTAssertNotNil(dictionary["priority"] as Any?)
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertNotNil(dictionary["title"] as Any?)
        
        // Verify priority is stored as integer
        XCTAssertEqual(dictionary["priority"] as? Int, appEvent.priority)
    }
    
    // MARK: - Equality and Comparison Tests
    
    func testEquality() {
        let appEvent1 = MockDAOAppEventFactory.createMockAppEvent()
        let appEvent2 = DAOAppEvent(from: appEvent1)
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(appEvent1.id, appEvent2.id)
        XCTAssertEqual(appEvent1.endTime, appEvent2.endTime)
        XCTAssertEqual(appEvent1.priority, appEvent2.priority)
        XCTAssertEqual(appEvent1.startTime, appEvent2.startTime)
        XCTAssertEqual(appEvent1.title.asString, appEvent2.title.asString)
        XCTAssertFalse(appEvent1 != appEvent2)
    }
    
    func testInequality() {
        let appEvent1 = MockDAOAppEventFactory.createMockAppEvent()
        let appEvent2 = MockDAOAppEventFactory.createMockAppEvent()
        appEvent2.priority = DNSPriority.high
        
        XCTAssertNotEqual(appEvent1, appEvent2)
        XCTAssertTrue(appEvent1 != appEvent2)
    }
    
    func testIsDiffFrom() {
        let appEvent1 = MockDAOAppEventFactory.createMockAppEvent()
        let appEvent2 = DAOAppEvent(from: appEvent1)
        let appEvent3 = MockDAOAppEventFactory.createMockAppEvent()
        appEvent3.title = DNSString(with: "Different Title")
        
        XCTAssertFalse(appEvent1.isDiffFrom(appEvent2))
        XCTAssertTrue(appEvent1.isDiffFrom(appEvent3))
        XCTAssertTrue(appEvent1.isDiffFrom(nil))
        XCTAssertTrue(appEvent1.isDiffFrom("not an app event"))
    }
    
    func testSelfComparison() {
        let appEvent = MockDAOAppEventFactory.createMockAppEvent()
        
        XCTAssertFalse(appEvent.isDiffFrom(appEvent))
        XCTAssertEqual(appEvent, appEvent)
    }
    
    // MARK: - Time-based Tests
    
    func testTimeRangeValidation() {
        let appEvents = MockDAOAppEventFactory.createMockAppEventWithTimeRanges()
        
        XCTAssertEqual(appEvents.count, 3)
        
        for appEvent in appEvents {
            XCTAssertTrue(appEvent.startTime <= appEvent.endTime, 
                         "Start time should be before or equal to end time")
        }
        
        // Test the extension properties
        let pastEvent = appEvents[0]
        let currentEvent = appEvents[1]
        let futureEvent = appEvents[2]
        
        XCTAssertTrue(pastEvent.isPast)
        XCTAssertFalse(pastEvent.isActive)
        XCTAssertFalse(pastEvent.isFuture)
        
        XCTAssertFalse(currentEvent.isPast)
        XCTAssertTrue(currentEvent.isActive)
        XCTAssertFalse(currentEvent.isFuture)
        
        XCTAssertFalse(futureEvent.isPast)
        XCTAssertFalse(futureEvent.isActive)
        XCTAssertTrue(futureEvent.isFuture)
    }
    
    func testDurationCalculation() {
        let appEvent = MockDAOAppEventFactory.createMockAppEvent()
        let duration = appEvent.duration
        
        XCTAssertGreaterThan(duration, 0)
        XCTAssertEqual(duration, appEvent.endTime.timeIntervalSince(appEvent.startTime))
    }
    
    // MARK: - Priority-based Tests
    
    func testPriorityClassification() {
        let appEvents = MockDAOAppEventFactory.createMockAppEventWithAllPriorityLevels()
        
        for appEvent in appEvents {
            switch appEvent.priority {
            case DNSPriority.high, DNSPriority.highest:
                XCTAssertTrue(appEvent.isHighPriority)
            default:
                XCTAssertFalse(appEvent.isHighPriority)
            }
            
            // Test priority name
            XCTAssertFalse(appEvent.priorityName.isEmpty)
            XCTAssertNotEqual(appEvent.priorityName, "Unknown")
        }
    }
    
    func testBoundaryPriorityValidation() {
        let appEvents = MockDAOAppEventFactory.createMockAppEventWithBoundaryPriorities()
        
        for appEvent in appEvents {
            // All priorities should be within valid range after didSet validation
            XCTAssertGreaterThanOrEqual(appEvent.priority, DNSPriority.none)
            XCTAssertLessThanOrEqual(appEvent.priority, DNSPriority.highest)
        }
    }
    
    // MARK: - Validation Tests
    
    func testValidationHelper() {
        let validAppEvent = MockDAOAppEventFactory.createMockAppEvent()
        XCTAssertTrue(MockDAOAppEventFactory.validateAppEventProperties(validAppEvent))
        
        let invalidAppEvent = DAOAppEvent()
        invalidAppEvent.title = DNSString(with: "") // Empty title
        XCTAssertFalse(MockDAOAppEventFactory.validateAppEventProperties(invalidAppEvent))
        
        let invalidTimeAppEvent = MockDAOAppEventFactory.createMockAppEvent()
        invalidTimeAppEvent.endTime = invalidTimeAppEvent.startTime.addingTimeInterval(-3600) // End before start
        XCTAssertFalse(MockDAOAppEventFactory.validateAppEventProperties(invalidTimeAppEvent))
    }
    
    // MARK: - Array Tests
    
    func testAppEventArray() {
        let appEvents = MockDAOAppEventFactory.createMockAppEventArray(count: 5)
        
        XCTAssertEqual(appEvents.count, 5)
        
        for (index, appEvent) in appEvents.enumerated() {
            XCTAssertEqual(appEvent.id, "appevent\(index)")
            XCTAssertTrue(MockDAOAppEventFactory.validateAppEventProperties(appEvent))
        }
    }
    
    // MARK: - Edge Cases
    
    func testMinimalDataAppEvent() {
        let appEvent = MockDAOAppEventFactory.createMockAppEventWithMinimalData()
        
        XCTAssertNotNil(appEvent)
        XCTAssertEqual(appEvent.title.asString, "Minimal Event")
        XCTAssertEqual(appEvent.priority, DNSPriority.normal) // Default value
    }
    
    func testDefaultConstantValues() {
        // Test that the default constants are reasonable
        let defaultStart = DAOAppEvent.C.defaultStartTime
        let defaultEnd = DAOAppEvent.C.defaultEndTime
        
        XCTAssertTrue(defaultStart < defaultEnd)
        
        // Verify defaults are far in the future/past as intended
        let now = Date()
        XCTAssertTrue(defaultStart < now) // Default start is in the past
        XCTAssertTrue(defaultEnd > now)   // Default end is in the future
    }
    
    func testCustomInitializerWithDefaults() {
        let appEvent = MockDAOAppEventFactory.createMockAppEventWithCustomInitializer()
        
        XCTAssertEqual(appEvent.title.asString, "Custom Initialized Event")
        XCTAssertTrue(appEvent.startTime < appEvent.endTime)
        XCTAssertEqual(appEvent.priority, DNSPriority.normal) // Should still be default
    }
    
    func testInvalidDictionaryHandling() {
        let invalidDict = MockDAOAppEventFactory.createInvalidAppEventDictionary()
        let appEvent = DAOAppEvent(from: invalidDict)
        
        // Should still create object but with default values
        XCTAssertNotNil(appEvent)
        if let appEvent = appEvent {
            XCTAssertEqual(appEvent.priority, DNSPriority.normal) // Should fall back to default
        }
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateAppEvent() {
        measure {
            for _ in 0..<1000 {
                let _ = MockDAOAppEventFactory.createMockAppEvent()
            }
        }
    }
    
    func testPerformanceCopyAppEvent() {
        let appEvent = MockDAOAppEventFactory.createMockAppEvent()
        
        measure {
            for _ in 0..<1000 {
                let _ = DAOAppEvent(from: appEvent)
            }
        }
    }
    
    func testPerformanceDictionaryConversion() {
        let appEvent = MockDAOAppEventFactory.createMockAppEvent()
        
        measure {
            for _ in 0..<1000 {
                let _ = appEvent.asDictionary
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCustomInitializer", testCustomInitializer),
        ("testPropertyAssignment", testPropertyAssignment),
        ("testPriorityValidation", testPriorityValidation),
        ("testPriorityEnumValues", testPriorityEnumValues),
        ("testCopyInitialization", testCopyInitialization),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testNSCopying", testNSCopying),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testAsDictionary", testAsDictionary),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testSelfComparison", testSelfComparison),
        ("testTimeRangeValidation", testTimeRangeValidation),
        ("testDurationCalculation", testDurationCalculation),
        ("testPriorityClassification", testPriorityClassification),
        ("testBoundaryPriorityValidation", testBoundaryPriorityValidation),
        ("testValidationHelper", testValidationHelper),
        ("testAppEventArray", testAppEventArray),
        ("testMinimalDataAppEvent", testMinimalDataAppEvent),
        ("testDefaultConstantValues", testDefaultConstantValues),
        ("testCustomInitializerWithDefaults", testCustomInitializerWithDefaults),
        ("testInvalidDictionaryHandling", testInvalidDictionaryHandling),
        ("testPerformanceCreateAppEvent", testPerformanceCreateAppEvent),
        ("testPerformanceCopyAppEvent", testPerformanceCopyAppEvent),
        ("testPerformanceDictionaryConversion", testPerformanceDictionaryConversion),
    ]
}
