//
//  DAOEventDayItemTests.swift
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

final class DAOEventDayItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let item = DAOEventDayItem()
        
        // Assert
        XCTAssertNil(item.address)
        XCTAssertEqual(item.distribution, .everyone)
        XCTAssertNotNil(item.endTime)
        XCTAssertNil(item.geopoint)
        XCTAssertNotNil(item.startTime)
        XCTAssertNotNil(item.subtitle)
        XCTAssertNotNil(item.title)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "event-item-123"
        
        // Act
        let item = DAOEventDayItem(id: testId)
        
        // Assert
        XCTAssertEqual(item.id, testId)
        XCTAssertNil(item.address)
        XCTAssertEqual(item.distribution, .everyone)
        XCTAssertNotNil(item.endTime)
        XCTAssertNil(item.geopoint)
        XCTAssertNotNil(item.startTime)
        XCTAssertNotNil(item.subtitle)
        XCTAssertNotNil(item.title)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalItem = createTestEventDayItem()
        
        // Act
        let copiedItem = DAOEventDayItem(from: originalItem)
        
        // Assert
        XCTAssertEqual(copiedItem.id, originalItem.id)
        XCTAssertEqual(copiedItem.distribution, originalItem.distribution)
        XCTAssertEqual(copiedItem.endTime, originalItem.endTime)
        XCTAssertEqual(copiedItem.startTime, originalItem.startTime)
        XCTAssertEqual(copiedItem.title.asString, originalItem.title.asString)
        XCTAssertEqual(copiedItem.subtitle, originalItem.subtitle)
        XCTAssertFalse(copiedItem === originalItem)
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "distribution": "members",
            "endTime": "17:30",
            "startTime": "09:00",
            "title": ["": "Test Event"],
            "subtitle": ["": "Test Description"]
        ]
        
        // Act
        let item = DAOEventDayItem(from: testData)
        
        // Assert
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.distribution, .everyone)
        XCTAssertNotNil(item?.endTime)
        XCTAssertNotNil(item?.startTime)
        XCTAssertNotNil(item?.title)
        XCTAssertNotNil(item?.subtitle)
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let item = DAOEventDayItem(from: emptyData)
        
        // Assert
        XCTAssertNil(item)
    }
    
    // MARK: - Property Tests
    
    func testAddressProperty() {
        // Arrange
        let item = DAOEventDayItem()
        let testAddress = DNSPostalAddress()
        testAddress.street = "123 Main St"
        testAddress.city = "Test City"
        
        // Act
        item.address = testAddress
        
        // Assert
        XCTAssertNotNil(item.address)
        XCTAssertEqual(item.address?.street, "123 Main St")
        XCTAssertEqual(item.address?.city, "Test City")
    }
    
    func testDistributionProperty() {
        // Arrange
        let item = DAOEventDayItem()
        
        // Act & Assert
        item.distribution = .everyone
        XCTAssertEqual(item.distribution, .everyone)
        
        item.distribution = .staffOnly
        XCTAssertEqual(item.distribution, .staffOnly)
        
        item.distribution = .adminOnly
        XCTAssertEqual(item.distribution, .adminOnly)
        
        item.distribution = .adultsOnly
        XCTAssertEqual(item.distribution, .adultsOnly)
    }
    
    func testTimeProperties() {
        // Arrange
        let item = DAOEventDayItem()
        let startTime = DNSTimeOfDay(hour: 9, minute: 0)
        let endTime = DNSTimeOfDay(hour: 17, minute: 30)
        
        // Act
        item.startTime = startTime
        item.endTime = endTime
        
        // Assert
        XCTAssertEqual(item.startTime.hour, 9)
        XCTAssertEqual(item.startTime.minute, 0)
        XCTAssertEqual(item.endTime.hour, 17)
        XCTAssertEqual(item.endTime.minute, 30)
    }
    
    func testGeopointProperty() {
        // Arrange
        let item = DAOEventDayItem()
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        
        // Act
        item.geopoint = location
        
        // Assert
        XCTAssertNotNil(item.geopoint)
        XCTAssertEqual(item.geopoint?.coordinate.latitude ?? 0.0, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(item.geopoint?.coordinate.longitude ?? 0.0, -122.4194, accuracy: 0.0001)
    }
    
    func testTitleAndSubtitleProperties() {
        // Arrange
        let item = DAOEventDayItem()
        let title = DNSString(with: "Test Event Title")
        let subtitle = DNSString(with: "Test Event Description")
        
        // Act
        item.title = title
        item.subtitle = subtitle
        
        // Assert
        XCTAssertEqual(item.title.asString, "Test Event Title")
        XCTAssertEqual(item.subtitle.asString, "Test Event Description")
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalItem = MockDAOEventDayItemFactory.createMock()
        let sourceItem = createTestEventDayItem()
        
        // Act
        originalItem.update(from: sourceItem)
        
        // Assert
        XCTAssertEqual(originalItem.distribution, sourceItem.distribution)
        XCTAssertEqual(originalItem.endTime, sourceItem.endTime)
        XCTAssertEqual(originalItem.startTime, sourceItem.startTime)
        XCTAssertEqual(originalItem.title.asString, sourceItem.title.asString)
        XCTAssertEqual(originalItem.subtitle, sourceItem.subtitle)
    }
    
    func testEventDuration() {
        // Arrange
        let item = DAOEventDayItem()
        item.startTime = DNSTimeOfDay(hour: 9, minute: 0)
        item.endTime = DNSTimeOfDay(hour: 17, minute: 30)
        
        // Act
        let startMinutes = item.startTime.hour * 60 + item.startTime.minute
        let endMinutes = item.endTime.hour * 60 + item.endTime.minute
        let durationMinutes = endMinutes - startMinutes
        
        // Assert
        XCTAssertEqual(durationMinutes, 510) // 8.5 hours = 510 minutes
    }
    
    func testOverlappingTimeRanges() {
        // Arrange
        let item1 = DAOEventDayItem()
        item1.startTime = DNSTimeOfDay(hour: 9, minute: 0)
        item1.endTime = DNSTimeOfDay(hour: 12, minute: 0)
        
        let item2 = DAOEventDayItem()
        item2.startTime = DNSTimeOfDay(hour: 11, minute: 0)
        item2.endTime = DNSTimeOfDay(hour: 14, minute: 0)
        
        // Act
        let start1Minutes = item1.startTime.hour * 60 + item1.startTime.minute
        let end1Minutes = item1.endTime.hour * 60 + item1.endTime.minute
        let start2Minutes = item2.startTime.hour * 60 + item2.startTime.minute
        let end2Minutes = item2.endTime.hour * 60 + item2.endTime.minute
        
        let overlaps = start1Minutes < end2Minutes && start2Minutes < end1Minutes
        
        // Assert
        XCTAssertTrue(overlaps)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalItem = createTestEventDayItem()
        
        // Act
        let copiedItem = originalItem.copy() as? DAOEventDayItem
        
        // Assert
        XCTAssertNotNil(copiedItem)
        XCTAssertEqual(copiedItem?.distribution, originalItem.distribution)
        XCTAssertEqual(copiedItem?.title.asString, originalItem.title.asString)
        XCTAssertEqual(copiedItem?.subtitle, originalItem.subtitle)
        XCTAssertFalse(copiedItem === originalItem)
    }
    
    func testEquatableCompliance() {
        // Arrange
        let item1 = MockDAOEventDayItemFactory.createMockWithTestData()
        let item2 = DAOEventDayItem(from: item1)
        let item3 = MockDAOEventDayItemFactory.createMockWithEdgeCases()
        
        // Act & Assert
        XCTAssertTrue(item1 == item2)
        XCTAssertFalse(item1 != item2)
        XCTAssertFalse(item1 == item3)
        XCTAssertTrue(item1 != item3)
        XCTAssertTrue(item1 == item1)
        XCTAssertFalse(item1 != item1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let item1 = MockDAOEventDayItemFactory.createMockWithTestData()
        let item2 = DAOEventDayItem(from: item1)
        let item3 = MockDAOEventDayItemFactory.createMockWithEdgeCases()
        
        // Act & Assert
        XCTAssertFalse(item1.isDiffFrom(item2))
        XCTAssertTrue(item1.isDiffFrom(item3))
        XCTAssertFalse(item1.isDiffFrom(item1))
        XCTAssertTrue(item1.isDiffFrom("not an event day item"))
        XCTAssertTrue(item1.isDiffFrom(nil as DAOEventDayItem?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalItem = MockDAOEventDayItemFactory.createMockWithTestData()
        
        // Act
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalItem)
        let decoder = JSONDecoder()
        let decodedItem = try decoder.decode(DAOEventDayItem.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedItem.distribution, originalItem.distribution)
        XCTAssertEqual(decodedItem.title.asString, originalItem.title.asString)
        XCTAssertEqual(decodedItem.subtitle.asString, originalItem.subtitle.asString)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let item = createTestEventDayItem()
        
        // Act
        let dictionary = item.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["distribution"] as Any?)
        XCTAssertNotNil(dictionary["endTime"] as Any?)
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertNotNil(dictionary["title"] as Any?)
        XCTAssertNotNil(dictionary["subtitle"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let item = MockDAOEventDayItemFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertEqual(item.id, "")
        XCTAssertNil(item.address)
        XCTAssertEqual(item.distribution, .everyone)
        XCTAssertNotNil(item.title)
        XCTAssertNotNil(item.subtitle)
    }
    
    func testMidnightTimeHandling() {
        // Arrange
        let item = DAOEventDayItem()
        let midnightStart = DNSTimeOfDay(hour: 0, minute: 0)
        let lateEnd = DNSTimeOfDay(hour: 23, minute: 59)
        
        // Act
        item.startTime = midnightStart
        item.endTime = lateEnd
        
        // Assert
        XCTAssertEqual(item.startTime.hour, 0)
        XCTAssertEqual(item.startTime.minute, 0)
        XCTAssertEqual(item.endTime.hour, 23)
        XCTAssertEqual(item.endTime.minute, 59)
    }
    
    func testNullAddressHandling() {
        // Arrange
        let item = DAOEventDayItem()
        
        // Act
        item.address = nil
        
        // Assert
        XCTAssertNil(item.address)
        XCTAssertNotNil(item.asDictionary) // Should still convert to dictionary
    }
    
    func testNullGeopointHandling() {
        // Arrange
        let item = DAOEventDayItem()
        
        // Act
        item.geopoint = nil
        
        // Assert
        XCTAssertNil(item.geopoint)
        XCTAssertNotNil(item.asDictionary) // Should still convert to dictionary
    }
    
    func testExtremeCoordinates() {
        // Arrange
        let item = DAOEventDayItem()
        let extremeLocation = CLLocation(latitude: 90.0, longitude: 180.0)
        
        // Act
        item.geopoint = extremeLocation
        
        // Assert
        XCTAssertEqual(item.geopoint?.coordinate.latitude, 90.0)
        XCTAssertEqual(item.geopoint?.coordinate.longitude, 180.0)
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let items = MockDAOEventDayItemFactory.createMockArray(count: 5)
        
        // Assert
        XCTAssertEqual(items.count, 5)
        
        for i in 0..<items.count {
            XCTAssertEqual(items[i].id, "event_day_item_\(i + 1)")
            XCTAssertEqual(items[i].distribution, .everyone)
            XCTAssertNotNil(items[i].title)
            XCTAssertNotNil(items[i].subtitle)
        }
    }
    
    func testArrayDifferencesDetection() {
        // Arrange
        let items1 = MockDAOEventDayItemFactory.createMockArray(count: 3)
        let items2: [DAOEventDayItem] = items1.map { DAOEventDayItem(from: $0) }
        let items3 = MockDAOEventDayItemFactory.createMockArray(count: 4)
        
        // Act & Assert
        XCTAssertFalse(items1.hasDiffElementsFrom(items2))
        XCTAssertTrue(items1.hasDiffElementsFrom(items3))
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOEventDayItem()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalItem = createTestEventDayItem()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOEventDayItem(from: originalItem)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let item1 = createTestEventDayItem()
        let item2 = createTestEventDayItem()
        
        measure {
            for _ in 0..<1000 {
                _ = item1 == item2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let item = createTestEventDayItem()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(item)
                    _ = try decoder.decode(DAOEventDayItem.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func createTestEventDayItem() -> DAOEventDayItem {
        let item = DAOEventDayItem()
        item.id = "test_event_item"
        
        let address = DNSPostalAddress()
        address.street = "456 Event St"
        address.city = "Event City"
        item.address = address
        
        item.distribution = .everyone
        item.startTime = DNSTimeOfDay(hour: 10, minute: 0)
        item.endTime = DNSTimeOfDay(hour: 16, minute: 0)
        
        item.geopoint = CLLocation(latitude: 37.7749, longitude: -122.4194)
        
        let title = DNSString(with: "Test Event")
        item.title = title
        
        let subtitle = DNSString(with: "Test Description")
        item.subtitle = subtitle
        
        return item
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testAddressProperty", testAddressProperty),
        ("testDistributionProperty", testDistributionProperty),
        ("testTimeProperties", testTimeProperties),
        ("testGeopointProperty", testGeopointProperty),
        ("testTitleAndSubtitleProperties", testTitleAndSubtitleProperties),
        ("testUpdateMethod", testUpdateMethod),
        ("testEventDuration", testEventDuration),
        ("testOverlappingTimeRanges", testOverlappingTimeRanges),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testMidnightTimeHandling", testMidnightTimeHandling),
        ("testNullAddressHandling", testNullAddressHandling),
        ("testNullGeopointHandling", testNullGeopointHandling),
        ("testExtremeCoordinates", testExtremeCoordinates),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testArrayDifferencesDetection", testArrayDifferencesDetection),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}
