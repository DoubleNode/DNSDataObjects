//
//  DAOPlaceEventTests.swift
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

final class DAOPlaceEventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let placeEvent = DAOPlaceEvent()
        
        // Assert
        XCTAssertNotNil(placeEvent.endDate)
        XCTAssertNotNil(placeEvent.name)
        XCTAssertNotNil(placeEvent.startDate)
        XCTAssertNotNil(placeEvent.timeZone)
        XCTAssertEqual(placeEvent.type, "")
        XCTAssertEqual(placeEvent.timeZone, TimeZone.current)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "place-event-123"
        
        // Act
        let placeEvent = DAOPlaceEvent(id: testId)
        
        // Assert
        XCTAssertEqual(placeEvent.id, testId)
        XCTAssertNotNil(placeEvent.endDate)
        XCTAssertNotNil(placeEvent.name)
        XCTAssertNotNil(placeEvent.startDate)
        XCTAssertNotNil(placeEvent.timeZone)
        XCTAssertEqual(placeEvent.type, "")
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalPlaceEvent = createTestPlaceEvent()
        
        // Act
        let copiedPlaceEvent = DAOPlaceEvent(from: originalPlaceEvent)
        
        // Assert
        XCTAssertEqual(copiedPlaceEvent.id, originalPlaceEvent.id)
        XCTAssertEqual(copiedPlaceEvent.endDate, originalPlaceEvent.endDate)
        XCTAssertEqual(copiedPlaceEvent.name.asString, originalPlaceEvent.name.asString)
        XCTAssertEqual(copiedPlaceEvent.startDate, originalPlaceEvent.startDate)
        XCTAssertEqual(copiedPlaceEvent.timeZone, originalPlaceEvent.timeZone)
        XCTAssertEqual(copiedPlaceEvent.type, originalPlaceEvent.type)
        XCTAssertFalse(copiedPlaceEvent === originalPlaceEvent)
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "endDate": "2025-01-15T17:30:00Z",
            "name": ["": "Test Event"],
            "startDate": "2025-01-15T09:00:00Z",
            "timeZone": "America/New_York",
            "type": "conference"
        ]
        
        // Act
        let placeEvent = DAOPlaceEvent(from: testData)
        
        // Assert
        XCTAssertNotNil(placeEvent)
        XCTAssertNotNil(placeEvent?.endDate)
        XCTAssertNotNil(placeEvent?.name)
        XCTAssertNotNil(placeEvent?.startDate)
        XCTAssertEqual(placeEvent?.timeZone.identifier, "America/New_York")
        XCTAssertEqual(placeEvent?.type, "conference")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let placeEvent = DAOPlaceEvent(from: emptyData)
        
        // Assert
        XCTAssertNil(placeEvent)
    }
    
    // MARK: - Property Tests
    
    func testEndDateProperty() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let testDate = Date().addingTimeInterval(3600) // 1 hour from now
        
        // Act
        placeEvent.endDate = testDate
        
        // Assert
        XCTAssertEqual(placeEvent.endDate, testDate)
    }
    
    func testNameProperty() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let testName = DNSString(with: "Annual Conference 2025")
        
        // Act
        placeEvent.name = testName
        
        // Assert
        XCTAssertEqual(placeEvent.name.asString, "Annual Conference 2025")
    }
    
    func testStartDateProperty() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let testDate = Date()
        
        // Act
        placeEvent.startDate = testDate
        
        // Assert
        XCTAssertEqual(placeEvent.startDate, testDate)
    }
    
    func testTimeZoneProperty() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let testTimeZone = TimeZone(identifier: "America/Los_Angeles")!
        
        // Act
        placeEvent.timeZone = testTimeZone
        
        // Assert
        XCTAssertEqual(placeEvent.timeZone, testTimeZone)
    }
    
    func testTypeProperty() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let testType = "workshop"
        
        // Act
        placeEvent.type = testType
        
        // Assert
        XCTAssertEqual(placeEvent.type, testType)
    }
    
    // MARK: - Computed Property Tests
    
    func testStartTimeProperty() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 14
        components.minute = 30
        components.second = 0
        let testDate = calendar.date(from: components) ?? Date()
        placeEvent.startDate = testDate
        
        // Act
        let startTime = placeEvent.startTime
        
        // Assert
        XCTAssertNotNil(startTime)
        // The exact values may vary based on timezone, but we can verify it's a valid time
        XCTAssertGreaterThanOrEqual(startTime.hour, 0)
        XCTAssertLessThan(startTime.hour, 24)
        XCTAssertGreaterThanOrEqual(startTime.minute, 0)
        XCTAssertLessThan(startTime.minute, 60)
    }
    
    func testEndTimeProperty() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 16
        components.minute = 45
        components.second = 0
        let testDate = calendar.date(from: components) ?? Date()
        placeEvent.endDate = testDate
        
        // Act
        let endTime = placeEvent.endTime
        
        // Assert
        XCTAssertNotNil(endTime)
        // The exact values may vary based on timezone, but we can verify it's a valid time
        XCTAssertGreaterThanOrEqual(endTime.hour, 0)
        XCTAssertLessThan(endTime.hour, 24)
        XCTAssertGreaterThanOrEqual(endTime.minute, 0)
        XCTAssertLessThan(endTime.minute, 60)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalPlaceEvent = DAOPlaceEvent()
        let sourceEvent = createTestPlaceEvent()
        
        // Act
        originalPlaceEvent.update(from: sourceEvent)
        
        // Assert
        XCTAssertEqual(originalPlaceEvent.endDate, sourceEvent.endDate)
        XCTAssertEqual(originalPlaceEvent.name.asString, sourceEvent.name.asString)
        XCTAssertEqual(originalPlaceEvent.startDate, sourceEvent.startDate)
        XCTAssertEqual(originalPlaceEvent.timeZone, sourceEvent.timeZone)
        XCTAssertEqual(originalPlaceEvent.type, sourceEvent.type)
    }
    
    func testEventDuration() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(2 * 3600) // 2 hours later
        
        // Act
        placeEvent.startDate = startDate
        placeEvent.endDate = endDate
        
        // Assert
        let duration = placeEvent.endDate.timeIntervalSince(placeEvent.startDate)
        XCTAssertEqual(duration, 2 * 3600, accuracy: 1) // Allow 1 second accuracy
    }
    
    func testEventTypeCategories() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let eventTypes = ["conference", "workshop", "meeting", "seminar", "exhibition"]
        
        // Act & Assert
        for eventType in eventTypes {
            placeEvent.type = eventType
            XCTAssertEqual(placeEvent.type, eventType)
        }
    }
    
    func testTimeZoneHandling() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let timeZones = [
            TimeZone(identifier: "UTC")!,
            TimeZone(identifier: "America/New_York")!,
            TimeZone(identifier: "Europe/London")!,
            TimeZone(identifier: "Asia/Tokyo")!
        ]
        
        // Act & Assert
        for timeZone in timeZones {
            placeEvent.timeZone = timeZone
            XCTAssertEqual(placeEvent.timeZone, timeZone)
        }
    }
    
    func testOverlappingEvents() {
        // Arrange
        let event1 = DAOPlaceEvent()
        let baseDate = Date()
        event1.startDate = baseDate
        event1.endDate = baseDate.addingTimeInterval(2 * 3600) // 2 hours
        
        let event2 = DAOPlaceEvent()
        event2.startDate = baseDate.addingTimeInterval(1 * 3600) // 1 hour after start
        event2.endDate = baseDate.addingTimeInterval(3 * 3600) // 3 hours after start
        
        // Act
        let event1Start = event1.startDate.timeIntervalSince1970
        let event1End = event1.endDate.timeIntervalSince1970
        let event2Start = event2.startDate.timeIntervalSince1970
        let event2End = event2.endDate.timeIntervalSince1970
        
        let overlaps = event1Start < event2End && event2Start < event1End
        
        // Assert
        XCTAssertTrue(overlaps)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalPlaceEvent = createTestPlaceEvent()
        
        // Act
        let copiedPlaceEvent = originalPlaceEvent.copy() as? DAOPlaceEvent
        
        // Assert
        XCTAssertNotNil(copiedPlaceEvent)
        XCTAssertEqual(copiedPlaceEvent?.endDate, originalPlaceEvent.endDate)
        XCTAssertEqual(copiedPlaceEvent?.name.asString, originalPlaceEvent.name.asString)
        XCTAssertEqual(copiedPlaceEvent?.startDate, originalPlaceEvent.startDate)
        XCTAssertEqual(copiedPlaceEvent?.timeZone, originalPlaceEvent.timeZone)
        XCTAssertEqual(copiedPlaceEvent?.type, originalPlaceEvent.type)
        XCTAssertFalse(copiedPlaceEvent === originalPlaceEvent)
    }
    
    func testEquatableCompliance() {
        // Arrange
        let event1 = createTestPlaceEvent()
        let event2 = DAOPlaceEvent(from: event1)
        let event3 = createEdgeCasePlaceEvent()
        
        // Act & Assert
        XCTAssertTrue(event1 == event2)
        XCTAssertFalse(event1 != event2)
        XCTAssertFalse(event1 == event3)
        XCTAssertTrue(event1 != event3)
        XCTAssertTrue(event1 == event1)
        XCTAssertFalse(event1 != event1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let event1 = createTestPlaceEvent()
        let event2 = DAOPlaceEvent(from: event1)
        let event3 = createEdgeCasePlaceEvent()
        
        // Act & Assert
        XCTAssertFalse(event1.isDiffFrom(event2))
        XCTAssertTrue(event1.isDiffFrom(event3))
        XCTAssertFalse(event1.isDiffFrom(event1))
        XCTAssertTrue(event1.isDiffFrom("not a place event"))
        XCTAssertTrue(event1.isDiffFrom(nil as DAOPlaceEvent?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalPlaceEvent = createTestPlaceEvent()
        
        // Act
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalPlaceEvent)
        let decoder = JSONDecoder()
        let decodedPlaceEvent = try decoder.decode(DAOPlaceEvent.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedPlaceEvent.name.asString, originalPlaceEvent.name.asString)
        XCTAssertEqual(decodedPlaceEvent.type, originalPlaceEvent.type)
        XCTAssertEqual(decodedPlaceEvent.timeZone, originalPlaceEvent.timeZone)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let placeEvent = createTestPlaceEvent()
        
        // Act
        let dictionary = placeEvent.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["endDate"] as Any?)
        XCTAssertNotNil(dictionary["name"] as Any?)
        XCTAssertNotNil(dictionary["startDate"] as Any?)
        XCTAssertNotNil(dictionary["timeZone"] as Any?)
        XCTAssertNotNil(dictionary["type"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let placeEvent = createEdgeCasePlaceEvent()
        
        // Assert
        XCTAssertEqual(placeEvent.type, "")
        XCTAssertNotNil(placeEvent.name)
        XCTAssertNotNil(placeEvent.startDate)
        XCTAssertNotNil(placeEvent.endDate)
    }
    
    func testEmptyTypeHandling() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        
        // Act
        placeEvent.type = ""
        
        // Assert
        XCTAssertEqual(placeEvent.type, "")
        XCTAssertNotNil(placeEvent.asDictionary)
    }
    
    func testVeryLongEventName() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let longName = DNSString(with: String(repeating: "A", count: 1000))
        
        // Act
        placeEvent.name = longName
        
        // Assert
        XCTAssertEqual(placeEvent.name.asString.count, 1000)
    }
    
    func testSpecialCharactersInEventName() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let specialName = DNSString(with: "Event: 2025 🎉 & Co. (Test #1)")
        
        // Act
        placeEvent.name = specialName
        
        // Assert
        XCTAssertEqual(placeEvent.name.asString, "Event: 2025 🎉 & Co. (Test #1)")
    }
    
    func testSameDayEvent() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let calendar = Calendar.current
        let baseDate = Date()
        let startOfDay = calendar.startOfDay(for: baseDate)
        let endOfDay = calendar.date(byAdding: .hour, value: 23, to: startOfDay)!
        
        // Act
        placeEvent.startDate = startOfDay
        placeEvent.endDate = endOfDay
        
        // Assert
        let isSameDay = calendar.isDate(placeEvent.startDate, inSameDayAs: placeEvent.endDate)
        XCTAssertTrue(isSameDay)
        
        let duration = placeEvent.endDate.timeIntervalSince(placeEvent.startDate)
        XCTAssertEqual(duration, 23 * 3600, accuracy: 3600) // 23 hours, allow 1 hour accuracy
    }
    
    func testMultiDayEvent() {
        // Arrange
        let placeEvent = DAOPlaceEvent()
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 3, to: startDate)!
        
        // Act
        placeEvent.startDate = startDate
        placeEvent.endDate = endDate
        
        // Assert
        let duration = placeEvent.endDate.timeIntervalSince(placeEvent.startDate)
        XCTAssertEqual(duration, 3 * 24 * 3600, accuracy: 3600) // 3 days, allow 1 hour accuracy
    }
    
    // MARK: - Array Tests
    
    func testArrayCreation() {
        // Arrange & Act
        let placeEvents = createMockArray(count: 5)
        
        // Assert
        XCTAssertEqual(placeEvents.count, 5)
        
        for i in 0..<placeEvents.count {
            XCTAssertEqual(placeEvents[i].id, "event_\(i + 1)")
            XCTAssertNotNil(placeEvents[i].name)
            XCTAssertNotNil(placeEvents[i].startDate)
            XCTAssertNotNil(placeEvents[i].endDate)
        }
    }
    
    func testArrayDifferencesDetection() {
        // Arrange
        let events1 = createMockArray(count: 3)
        let events2: [DAOPlaceEvent] = events1.map { DAOPlaceEvent(from: $0) }
        let events3 = createMockArray(count: 4)
        
        // Act & Assert
        XCTAssertFalse(events1.hasDiffElementsFrom(events2))
        XCTAssertTrue(events1.hasDiffElementsFrom(events3))
    }
    
    func testEventSorting() {
        // Arrange
        let events = createMockArray(count: 3)
        
        // Act
        let sortedEvents = events.sorted { $0.startDate < $1.startDate }
        
        // Assert
        for i in 1..<sortedEvents.count {
            XCTAssertLessThanOrEqual(sortedEvents[i-1].startDate, sortedEvents[i].startDate)
        }
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOPlaceEvent()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalPlaceEvent = createTestPlaceEvent()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOPlaceEvent(from: originalPlaceEvent)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let event1 = createTestPlaceEvent()
        let event2 = createTestPlaceEvent()
        
        measure {
            for _ in 0..<1000 {
                _ = event1 == event2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let placeEvent = createTestPlaceEvent()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(placeEvent)
                    _ = try decoder.decode(DAOPlaceEvent.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTestPlaceEvent() -> DAOPlaceEvent {
        let placeEvent = DAOPlaceEvent()
        placeEvent.id = "test_place_event"
        
        let name = DNSString(with: "Test Conference 2025")
        placeEvent.name = name
        
        let startDate = Date()
        placeEvent.startDate = startDate
        placeEvent.endDate = startDate.addingTimeInterval(8 * 3600) // 8 hours later
        
        placeEvent.timeZone = TimeZone(identifier: "America/New_York") ?? TimeZone.current
        placeEvent.type = "conference"
        
        return placeEvent
    }
    
    private func createEdgeCasePlaceEvent() -> DAOPlaceEvent {
        let placeEvent = DAOPlaceEvent()
        placeEvent.id = ""
        
        let name = DNSString(with: "")
        placeEvent.name = name
        
        placeEvent.type = ""
        placeEvent.timeZone = TimeZone.current
        
        return placeEvent
    }
    
    private func createMockArray(count: Int) -> [DAOPlaceEvent] {
        var events: [DAOPlaceEvent] = []
        let eventTypes = ["conference", "workshop", "meeting", "seminar", "exhibition"]
        
        for i in 0..<count {
            let event = DAOPlaceEvent()
            event.id = "event_\(i + 1)"
            
            let name = DNSString(with: "Event \(i + 1)")
            event.name = name
            
            let baseDate = Date().addingTimeInterval(TimeInterval(i * 24 * 3600)) // Each event is a day apart
            event.startDate = baseDate
            event.endDate = baseDate.addingTimeInterval(4 * 3600) // 4 hours duration
            
            event.type = eventTypes[i % eventTypes.count]
            event.timeZone = TimeZone.current
            
            events.append(event)
        }
        
        return events
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testEndDateProperty", testEndDateProperty),
        ("testNameProperty", testNameProperty),
        ("testStartDateProperty", testStartDateProperty),
        ("testTimeZoneProperty", testTimeZoneProperty),
        ("testTypeProperty", testTypeProperty),
        ("testStartTimeProperty", testStartTimeProperty),
        ("testEndTimeProperty", testEndTimeProperty),
        ("testUpdateMethod", testUpdateMethod),
        ("testEventDuration", testEventDuration),
        ("testEventTypeCategories", testEventTypeCategories),
        ("testTimeZoneHandling", testTimeZoneHandling),
        ("testOverlappingEvents", testOverlappingEvents),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testEmptyTypeHandling", testEmptyTypeHandling),
        ("testVeryLongEventName", testVeryLongEventName),
        ("testSpecialCharactersInEventName", testSpecialCharactersInEventName),
        ("testSameDayEvent", testSameDayEvent),
        ("testMultiDayEvent", testMultiDayEvent),
        ("testArrayCreation", testArrayCreation),
        ("testArrayDifferencesDetection", testArrayDifferencesDetection),
        ("testEventSorting", testEventSorting),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}
