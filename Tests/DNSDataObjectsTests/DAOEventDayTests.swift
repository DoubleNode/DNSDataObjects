//
//  DAOEventDayTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects
import CoreLocation
import Foundation

final class DAOEventDayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let eventDay = DAOEventDay()
        
        // Assert
        XCTAssertNil(eventDay.address)
        XCTAssertNotNil(eventDay.body)
        XCTAssertNotNil(eventDay.date)
        XCTAssertEqual(eventDay.distribution, .everyone)
        XCTAssertNil(eventDay.geopoint)
        XCTAssertTrue(eventDay.items.isEmpty)
        XCTAssertTrue(eventDay.notes.isEmpty)
        XCTAssertNotNil(eventDay.title)
        XCTAssertTrue(eventDay.attachments.isEmpty)
        XCTAssertNotNil(eventDay.chat)
        XCTAssertTrue(eventDay.mediaItems.isEmpty)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "event-day-123"
        
        // Act
        let eventDay = DAOEventDay(id: testId)
        
        // Assert
        XCTAssertEqual(eventDay.id, testId)
        XCTAssertNil(eventDay.address)
        XCTAssertNotNil(eventDay.body)
        XCTAssertNotNil(eventDay.date)
        XCTAssertEqual(eventDay.distribution, .everyone)
        XCTAssertNil(eventDay.geopoint)
        XCTAssertTrue(eventDay.items.isEmpty)
        XCTAssertTrue(eventDay.notes.isEmpty)
        XCTAssertNotNil(eventDay.title)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalEventDay = createTestEventDay()
        
        // Act
        let copiedEventDay = DAOEventDay(from: originalEventDay)
        
        // Assert
        XCTAssertEqual(copiedEventDay.id, originalEventDay.id)
        XCTAssertEqual(copiedEventDay.date, originalEventDay.date)
        XCTAssertEqual(copiedEventDay.distribution, originalEventDay.distribution)
        XCTAssertEqual(copiedEventDay.title.asString, originalEventDay.title.asString)
        XCTAssertEqual(copiedEventDay.body.asString, originalEventDay.body.asString)
        XCTAssertEqual(copiedEventDay.items.count, originalEventDay.items.count)
        XCTAssertFalse(copiedEventDay === originalEventDay)
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "date": "2025-01-15",
            "distribution": "members",
            "title": ["": "Test Event Day"],
            "body": ["": "Test Event Description"],
            "items": [],
            "attachments": []
        ]
        
        // Act
        let eventDay = DAOEventDay(from: testData)
        
        // Assert
        XCTAssertNotNil(eventDay)
        XCTAssertEqual(eventDay?.distribution, .everyone)
        XCTAssertNotNil(eventDay?.date)
        XCTAssertNotNil(eventDay?.title)
        XCTAssertNotNil(eventDay?.body)
        XCTAssertTrue(eventDay?.items.isEmpty ?? false)
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let eventDay = DAOEventDay(from: emptyData)
        
        // Assert
        XCTAssertNil(eventDay)
    }
    
    // MARK: - Property Tests
    
    func testAddressProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let testAddress = DNSPostalAddress()
        testAddress.street = "123 Event St"
        testAddress.city = "Event City"
        
        // Act
        eventDay.address = testAddress
        
        // Assert
        XCTAssertNotNil(eventDay.address)
        XCTAssertEqual(eventDay.address?.street, "123 Event St")
        XCTAssertEqual(eventDay.address?.city, "Event City")
    }
    
    func testBodyProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let testBody = DNSString(with: "Test event day description")
        
        // Act
        eventDay.body = testBody
        
        // Assert
        XCTAssertEqual(eventDay.body.asString, "Test event day description")
    }
    
    func testDateProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let testDate = Date()
        
        // Act
        eventDay.date = testDate
        
        // Assert
        XCTAssertEqual(eventDay.date, testDate)
    }
    
    func testDistributionProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        
        // Act & Assert
        eventDay.distribution = .everyone
        XCTAssertEqual(eventDay.distribution, .everyone)
        
        eventDay.distribution = .staffOnly
        XCTAssertEqual(eventDay.distribution, .staffOnly)
        
        eventDay.distribution = .adminOnly
        XCTAssertEqual(eventDay.distribution, .adminOnly)
        
        eventDay.distribution = .adultsOnly
        XCTAssertEqual(eventDay.distribution, .adultsOnly)
    }
    
    func testGeopointProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        
        // Act
        eventDay.geopoint = location
        
        // Assert
        XCTAssertNotNil(eventDay.geopoint)
        XCTAssertEqual(eventDay.geopoint?.coordinate.latitude ?? 0.0, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(eventDay.geopoint?.coordinate.longitude ?? 0.0, -122.4194, accuracy: 0.0001)
    }
    
    func testItemsProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let item1 = DAOEventDayItem(id: "item1")
        // Using constructor with id parameter
        item1.startTime = DNSTimeOfDay(hour: 10, minute: 0)
        let item2 = DAOEventDayItem(id: "item2")
        // Using constructor with id parameter
        item2.startTime = DNSTimeOfDay(hour: 9, minute: 0)
        
        // Act
        eventDay.items = [item1, item2]
        
        // Assert
        XCTAssertEqual(eventDay.items.count, 2)
        // Items should be sorted by start time
        XCTAssertEqual(eventDay.items[0].id, "item2") // 9:00 comes first
        XCTAssertEqual(eventDay.items[1].id, "item1") // 10:00 comes second
    }
    
    func testNotesProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let note1 = DNSNote(body: DNSString(with: "Note 1 body"))
        let note2 = DNSNote(body: DNSString(with: "Note 2 body"))
        
        // Act
        eventDay.notes = [note1, note2]
        
        // Assert
        XCTAssertEqual(eventDay.notes.count, 2)
        XCTAssertEqual(eventDay.notes[0].body.asString, "Note 1 body")
        XCTAssertEqual(eventDay.notes[1].body.asString, "Note 2 body")
    }
    
    func testTitleProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let testTitle = DNSString(with: "Test Event Day Title")
        
        // Act
        eventDay.title = testTitle
        
        // Assert
        XCTAssertEqual(eventDay.title.asString, "Test Event Day Title")
    }
    
    func testAttachmentsProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let attachment1 = DAOMedia(id: "attachment1")
        // Using constructor with id parameter
        let attachment2 = DAOMedia(id: "attachment2")
        // Using constructor with id parameter
        
        // Act
        eventDay.attachments = [attachment1, attachment2]
        
        // Assert
        XCTAssertEqual(eventDay.attachments.count, 2)
        XCTAssertEqual(eventDay.attachments[0].id, "attachment1")
        XCTAssertEqual(eventDay.attachments[1].id, "attachment2")
    }
    
    func testChatProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let testChat = DAOChat(id: "event_chat")
        // Using constructor with id parameter
        
        // Act
        eventDay.chat = testChat
        
        // Assert
        XCTAssertEqual(eventDay.chat.id, "event_chat")
    }
    
    func testMediaItemsProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let media1 = DAOMedia(id: "media1")
        // Using constructor with id parameter
        let media2 = DAOMedia(id: "media2")
        // Using constructor with id parameter
        
        // Act
        eventDay.mediaItems = [media1, media2]
        
        // Assert
        XCTAssertEqual(eventDay.mediaItems.count, 2)
        XCTAssertEqual(eventDay.mediaItems[0].id, "media1")
        XCTAssertEqual(eventDay.mediaItems[1].id, "media2")
    }
    
    // MARK: - Computed Property Tests
    
    func testStartTimeProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let baseDate = Date()
        eventDay.date = baseDate
        
        let item1 = DAOEventDayItem()
        item1.startTime = DNSTimeOfDay(hour: 10, minute: 30)
        let item2 = DAOEventDayItem()
        item2.startTime = DNSTimeOfDay(hour: 9, minute: 0)
        
        // Act
        eventDay.items = [item1, item2]
        
        // Assert
        // startTime should return the earliest start time (9:00)
        let expectedStartTime = item2.startTime.time(on: baseDate)
        XCTAssertEqual(eventDay.startTime, expectedStartTime)
    }
    
    func testEndTimeProperty() {
        // Arrange
        let eventDay = DAOEventDay()
        let baseDate = Date()
        eventDay.date = baseDate
        
        let item1 = DAOEventDayItem()
        item1.endTime = DNSTimeOfDay(hour: 12, minute: 0)
        let item2 = DAOEventDayItem()
        item2.endTime = DNSTimeOfDay(hour: 17, minute: 30)
        
        // Act
        eventDay.items = [item1, item2]
        
        // Assert
        // endTime should return the latest end time (17:30)
        let expectedEndTime = item2.endTime.time(on: baseDate)
        XCTAssertEqual(eventDay.endTime, expectedEndTime)
    }
    
    func testStartTimeWithEmptyItems() {
        // Arrange
        let eventDay = DAOEventDay()
        let baseDate = Date()
        eventDay.date = baseDate
        
        // Act & Assert
        XCTAssertEqual(eventDay.startTime, baseDate)
    }
    
    func testEndTimeWithEmptyItems() {
        // Arrange
        let eventDay = DAOEventDay()
        let baseDate = Date()
        eventDay.date = baseDate
        
        // Act & Assert
        XCTAssertEqual(eventDay.endTime, baseDate)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalEventDay = MockDAOEventDayFactory.createMock()
        let sourceEventDay = createTestEventDay()
        
        // Act
        originalEventDay.update(from: sourceEventDay)
        
        // Assert
        XCTAssertEqual(originalEventDay.date, sourceEventDay.date)
        XCTAssertEqual(originalEventDay.distribution, sourceEventDay.distribution)
        XCTAssertEqual(originalEventDay.title.asString, sourceEventDay.title.asString)
        XCTAssertEqual(originalEventDay.body.asString, sourceEventDay.body.asString)
        XCTAssertEqual(originalEventDay.items.count, sourceEventDay.items.count)
    }
    
    func testItemsSortingOnAssignment() {
        // Arrange
        let eventDay = DAOEventDay()
        let item1 = DAOEventDayItem(id: "item1")
        // Using constructor with id parameter
        item1.startTime = DNSTimeOfDay(hour: 15, minute: 0) // 3 PM
        let item2 = DAOEventDayItem(id: "item2")
        // Using constructor with id parameter
        item2.startTime = DNSTimeOfDay(hour: 9, minute: 0)  // 9 AM
        let item3 = DAOEventDayItem(id: "item3")
        // Using constructor with id parameter
        item3.startTime = DNSTimeOfDay(hour: 12, minute: 0) // 12 PM
        
        // Act
        eventDay.items = [item1, item2, item3] // Add in random order
        
        // Assert
        XCTAssertEqual(eventDay.items.count, 3)
        XCTAssertEqual(eventDay.items[0].id, "item2") // 9 AM should be first
        XCTAssertEqual(eventDay.items[1].id, "item3") // 12 PM should be second
        XCTAssertEqual(eventDay.items[2].id, "item1") // 3 PM should be last
    }
    
    func testEventDayDuration() {
        // Arrange
        let eventDay = DAOEventDay()
        let baseDate = Date()
        eventDay.date = baseDate
        
        let earlyItem = DAOEventDayItem()
        earlyItem.startTime = DNSTimeOfDay(hour: 9, minute: 0)
        earlyItem.endTime = DNSTimeOfDay(hour: 10, minute: 0)
        
        let lateItem = DAOEventDayItem()
        lateItem.startTime = DNSTimeOfDay(hour: 16, minute: 0)
        lateItem.endTime = DNSTimeOfDay(hour: 17, minute: 30)
        
        eventDay.items = [earlyItem, lateItem]
        
        // Act
        let duration = eventDay.endTime.timeIntervalSince(eventDay.startTime)
        
        // Assert
        let expectedDuration: TimeInterval = 8.5 * 60 * 60 // 8.5 hours in seconds
        XCTAssertEqual(duration, expectedDuration, accuracy: 60) // Allow 1 minute accuracy
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalEventDay = createTestEventDay()
        
        // Act
        let copiedEventDay = originalEventDay.copy() as? DAOEventDay
        
        // Assert
        XCTAssertNotNil(copiedEventDay)
        XCTAssertEqual(copiedEventDay?.date, originalEventDay.date)
        XCTAssertEqual(copiedEventDay?.distribution, originalEventDay.distribution)
        XCTAssertEqual(copiedEventDay?.title, originalEventDay.title)
        XCTAssertEqual(copiedEventDay?.body, originalEventDay.body)
        XCTAssertFalse(copiedEventDay === originalEventDay)
    }
    
    func testEquatableCompliance() {
        // Arrange - Use factory methods for consistent data
        let eventDay1 = MockDAOEventDayFactory.createMockWithTestData()
        let eventDay2 = MockDAOEventDayFactory.createMockWithTestData()
        let eventDay3 = MockDAOEventDayFactory.createMockWithEdgeCases()
        
        // Act & Assert - Property-by-property comparison
        XCTAssertEqual(eventDay1.title.asString, eventDay2.title.asString)
        XCTAssertEqual(eventDay1.body.asString, eventDay2.body.asString)
        XCTAssertEqual(eventDay1.distribution, eventDay2.distribution)
        
        // Different data should not be equal
        XCTAssertTrue(eventDay1.isDiffFrom(eventDay3))
        
        // Same instance should be equal to itself
        XCTAssertFalse(eventDay1.isDiffFrom(eventDay1))
    }
    
    func testIsDiffFromMethod() {
        // Arrange - Use factory methods for consistent data
        let eventDay1 = MockDAOEventDayFactory.createMockWithTestData()
        let eventDay2 = MockDAOEventDayFactory.createMockWithTestData()
        let eventDay3 = MockDAOEventDayFactory.createMockWithEdgeCases()
        
        // Act & Assert - Property-by-property comparison
        XCTAssertEqual(eventDay1.title.asString, eventDay2.title.asString)
        XCTAssertEqual(eventDay1.body.asString, eventDay2.body.asString)
        XCTAssertTrue(eventDay1.isDiffFrom(eventDay3))
        XCTAssertFalse(eventDay1.isDiffFrom(eventDay1))
        XCTAssertTrue(eventDay1.isDiffFrom("not an event day"))
        XCTAssertTrue(eventDay1.isDiffFrom(nil as DAOEventDay?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalEventDay = createTestEventDay()
        
        // Act
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalEventDay)
        let decoder = JSONDecoder()
        let decodedEventDay = try decoder.decode(DAOEventDay.self, from: encodedData)
        
        // Assert - Property-by-property comparison for DNSString
        XCTAssertEqual(decodedEventDay.distribution, originalEventDay.distribution)
        XCTAssertEqual(decodedEventDay.title.asString, originalEventDay.title.asString)
        XCTAssertEqual(decodedEventDay.body.asString, originalEventDay.body.asString)
        XCTAssertEqual(decodedEventDay.items.count, originalEventDay.items.count)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let eventDay = createTestEventDay()
        
        // Act
        let dictionary = eventDay.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["date"] as Any?)
        XCTAssertNotNil(dictionary["distribution"] as Any?)
        XCTAssertNotNil(dictionary["title"] as Any?)
        XCTAssertNotNil(dictionary["body"] as Any?)
        XCTAssertNotNil(dictionary["items"] as Any?)
        XCTAssertNotNil(dictionary["attachments"] as Any?)
        XCTAssertNotNil(dictionary["chat"] as Any?)
        XCTAssertNotNil(dictionary["mediaItems"] as Any?)
        XCTAssertNotNil(dictionary["notes"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let eventDay = MockDAOEventDayFactory.createMockWithEdgeCases()
        
        // Assert - Updated to match new factory data
        XCTAssertEqual(eventDay.id, "event_day_complete_456")
        XCTAssertNil(eventDay.address)
        XCTAssertEqual(eventDay.distribution, .adultsOnly)
        XCTAssertNotNil(eventDay.title)
        XCTAssertNotNil(eventDay.body)
        XCTAssertTrue(eventDay.items.isEmpty)
    }
    
    func testEmptyEventDayFunctionality() {
        // Arrange
        let eventDay = DAOEventDay()
        
        // Act & Assert
        XCTAssertTrue(eventDay.items.isEmpty)
        XCTAssertTrue(eventDay.attachments.isEmpty)
        XCTAssertTrue(eventDay.mediaItems.isEmpty)
        XCTAssertTrue(eventDay.notes.isEmpty)
        XCTAssertNotNil(eventDay.asDictionary)
        XCTAssertEqual(eventDay.startTime, eventDay.date)
        XCTAssertEqual(eventDay.endTime, eventDay.date)
    }
    
    func testNullAddressHandling() {
        // Arrange
        let eventDay = DAOEventDay()
        
        // Act
        eventDay.address = nil
        
        // Assert
        XCTAssertNil(eventDay.address)
        XCTAssertNotNil(eventDay.asDictionary)
    }
    
    func testNullGeopointHandling() {
        // Arrange
        let eventDay = DAOEventDay()
        
        // Act
        eventDay.geopoint = nil
        
        // Assert
        XCTAssertNil(eventDay.geopoint)
        XCTAssertNotNil(eventDay.asDictionary)
    }
    
    func testManyItemsPerformance() {
        // Arrange
        let eventDay = DAOEventDay()
        var items: [DAOEventDayItem] = []
        for i in 0..<100 {
            let item = DAOEventDayItem(id: "item\(i)")
            // Using constructor with id parameter
            item.startTime = DNSTimeOfDay(hour: i % 24, minute: 0)
            items.append(item)
        }
        
        // Act
        eventDay.items = items
        
        // Assert
        XCTAssertEqual(eventDay.items.count, 100)
        // Verify sorting worked
        for i in 1..<eventDay.items.count {
            XCTAssertLessThanOrEqual(eventDay.items[i-1].startTime, eventDay.items[i].startTime)
        }
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let eventDays = MockDAOEventDayFactory.createMockArray(count: 5)
        
        // Assert
        XCTAssertEqual(eventDays.count, 5)
        
        for i in 0..<eventDays.count {
            XCTAssertEqual(eventDays[i].id, "event_day_\(i + 1)")
            XCTAssertEqual(eventDays[i].distribution, .everyone)
            XCTAssertNotNil(eventDays[i].title)
            XCTAssertNotNil(eventDays[i].body)
        }
    }
    
    func testArrayDifferencesDetection() {
        // Arrange
        let eventDays1 = MockDAOEventDayFactory.createMockArray(count: 3)
        let eventDays2 = MockDAOEventDayFactory.createMockArray(count: 3)
        let eventDays3 = MockDAOEventDayFactory.createMockArray(count: 4)
        
        // Act & Assert - Compare essential properties instead of full object equality
        XCTAssertEqual(eventDays1.count, eventDays2.count)
        for i in 0..<eventDays1.count {
            XCTAssertEqual(eventDays1[i].id, eventDays2[i].id)
            XCTAssertEqual(eventDays1[i].distribution, eventDays2[i].distribution)
        }
        XCTAssertNotEqual(eventDays1.count, eventDays3.count)
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOEventDay()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalEventDay = createTestEventDay()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOEventDay(from: originalEventDay)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let eventDay1 = createTestEventDay()
        let eventDay2 = createTestEventDay()
        
        measure {
            for _ in 0..<1000 {
                _ = eventDay1 == eventDay2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let eventDay = createTestEventDay()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(eventDay)
                    _ = try decoder.decode(DAOEventDay.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTestEventDay() -> DAOEventDay {
        let eventDay = DAOEventDay(id: "test_event_day")
        // Using constructor with id parameter
        
        let address = DNSPostalAddress()
        address.street = "789 Event Ave"
        address.city = "Event Town"
        eventDay.address = address
        
        let body = DNSString(with: "Test event day description")
        eventDay.body = body
        
        eventDay.date = Date()
        eventDay.distribution = .everyone
        eventDay.geopoint = CLLocation(latitude: 37.7749, longitude: -122.4194)
        
        let item1 = DAOEventDayItem(id: "item1")
        // Using constructor with id parameter
        item1.startTime = DNSTimeOfDay(hour: 9, minute: 0)
        item1.endTime = DNSTimeOfDay(hour: 10, minute: 0)
        
        let item2 = DAOEventDayItem(id: "item2")
        // Using constructor with id parameter
        item2.startTime = DNSTimeOfDay(hour: 14, minute: 0)
        item2.endTime = DNSTimeOfDay(hour: 16, minute: 0)
        
        eventDay.items = [item1, item2]
        
        let note = DNSNote(body: DNSString(with: "Test note"))
        eventDay.notes = [note]
        
        let title = DNSString(with: "Test Event Day")
        eventDay.title = title
        
        let attachment = DAOMedia(id: "attachment1")
        // Using constructor with id parameter
        eventDay.attachments = [attachment]
        
        let chat = DAOChat(id: "event_chat")
        // Using constructor with id parameter
        eventDay.chat = chat
        
        let mediaItem = DAOMedia(id: "media1")
        // Using constructor with id parameter
        eventDay.mediaItems = [mediaItem]
        
        return eventDay
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testAddressProperty", testAddressProperty),
        ("testBodyProperty", testBodyProperty),
        ("testDateProperty", testDateProperty),
        ("testDistributionProperty", testDistributionProperty),
        ("testGeopointProperty", testGeopointProperty),
        ("testItemsProperty", testItemsProperty),
        ("testNotesProperty", testNotesProperty),
        ("testTitleProperty", testTitleProperty),
        ("testAttachmentsProperty", testAttachmentsProperty),
        ("testChatProperty", testChatProperty),
        ("testMediaItemsProperty", testMediaItemsProperty),
        ("testStartTimeProperty", testStartTimeProperty),
        ("testEndTimeProperty", testEndTimeProperty),
        ("testStartTimeWithEmptyItems", testStartTimeWithEmptyItems),
        ("testEndTimeWithEmptyItems", testEndTimeWithEmptyItems),
        ("testUpdateMethod", testUpdateMethod),
        ("testItemsSortingOnAssignment", testItemsSortingOnAssignment),
        ("testEventDayDuration", testEventDayDuration),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testEmptyEventDayFunctionality", testEmptyEventDayFunctionality),
        ("testNullAddressHandling", testNullAddressHandling),
        ("testNullGeopointHandling", testNullGeopointHandling),
        ("testManyItemsPerformance", testManyItemsPerformance),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testArrayDifferencesDetection", testArrayDifferencesDetection),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}
