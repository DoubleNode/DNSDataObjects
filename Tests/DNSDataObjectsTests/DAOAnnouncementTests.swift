//
//  DAOAnnouncementTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOAnnouncementTests: XCTestCase {
    
    // MARK: - Basic Initialization Tests
    
    func testDefaultInitialization() {
        let announcement = DAOAnnouncement()
        
        XCTAssertNotNil(announcement.id)
        XCTAssertFalse(announcement.id.isEmpty)
        
        // Test default values
        XCTAssertEqual(announcement.body.asString, "")
        XCTAssertEqual(announcement.distribution, DNSVisibility.everyone)
        XCTAssertEqual(announcement.subtitle.asString, "")
        XCTAssertEqual(announcement.title.asString, "")
        
        // Test that dates are set
        XCTAssertNotNil(announcement.startTime)
        XCTAssertNotNil(announcement.endTime)
        XCTAssertTrue(announcement.startTime <= announcement.endTime)
        
        // Test dependent objects are initialized
        XCTAssertNotNil(announcement.attachments)
        XCTAssertNotNil(announcement.chat)
        XCTAssertNotNil(announcement.mediaItems)
        XCTAssertEqual(announcement.attachments.count, 0)
        XCTAssertEqual(announcement.mediaItems.count, 0)
    }
    
    func testInitializationWithId() {
        let testId = "test-announcement-123"
        let announcement = DAOAnnouncement(id: testId)
        
        XCTAssertEqual(announcement.id, testId)
        
        // Verify default values are still set
        XCTAssertEqual(announcement.distribution, DNSVisibility.everyone)
        XCTAssertNotNil(announcement.startTime)
        XCTAssertNotNil(announcement.endTime)
    }
    
    // MARK: - Property Assignment Tests
    
    func testPropertyAssignment() {
        let announcement = MockDAOAnnouncementFactory.createMockAnnouncement()
        
        XCTAssertEqual(announcement.body.asString, "This is the body of the announcement")
        XCTAssertEqual(announcement.distribution, DNSVisibility.everyone)
        XCTAssertEqual(announcement.subtitle.asString, "Announcement Subtitle")
        XCTAssertEqual(announcement.title.asString, "Important Announcement")
        
        // Test that dates are properly set
        XCTAssertTrue(announcement.startTime <= announcement.endTime)
        
        // Test dependent objects
        XCTAssertGreaterThan(announcement.attachments.count, 0)
        XCTAssertGreaterThan(announcement.mediaItems.count, 0)
        XCTAssertNotNil(announcement.chat)
    }
    
    func testVisibilityEnumValues() {
        let announcements = MockDAOAnnouncementFactory.createMockAnnouncementWithAllVisibilityTypes()
        
        XCTAssertEqual(announcements.count, 3)
        
        let visibilityValues = announcements.map { $0.distribution }
        XCTAssertTrue(visibilityValues.contains(.everyone))
        XCTAssertTrue(visibilityValues.contains(DNSVisibility.adultsOnly))
        XCTAssertTrue(visibilityValues.contains(DNSVisibility.staffOnly))
    }
    
    // MARK: - Copy and Update Tests
    
    func testCopyInitialization() {
        let original = MockDAOAnnouncementFactory.createMockAnnouncement()
        let copy = DAOAnnouncement(from: original)
        
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.body.asString, copy.body.asString)
        XCTAssertEqual(original.distribution, copy.distribution)
        XCTAssertEqual(original.title.asString, copy.title.asString)
        XCTAssertEqual(original.subtitle.asString, copy.subtitle.asString)
        XCTAssertEqual(original.startTime, copy.startTime)
        XCTAssertEqual(original.endTime, copy.endTime)
        
        // Verify they are different instances
        XCTAssertTrue(original !== copy)
    }
    
    func testUpdateFromObject() {
        let announcement1 = DAOAnnouncement()
        let announcement2 = MockDAOAnnouncementFactory.createMockAnnouncement()
        
        announcement1.update(from: announcement2)
        
        XCTAssertEqual(announcement1.body.asString, announcement2.body.asString)
        XCTAssertEqual(announcement1.distribution, announcement2.distribution)
        XCTAssertEqual(announcement1.title.asString, announcement2.title.asString)
        XCTAssertEqual(announcement1.subtitle.asString, announcement2.subtitle.asString)
        XCTAssertEqual(announcement1.startTime, announcement2.startTime)
        XCTAssertEqual(announcement1.endTime, announcement2.endTime)
    }
    
    func testNSCopying() {
        let original = MockDAOAnnouncementFactory.createMockAnnouncement()
        let copy = original.copy() as! DAOAnnouncement
        
        XCTAssertTrue(MockDAOAnnouncementFactory.validateAnnouncementEquality(original, copy))
        XCTAssertTrue(original !== copy) // Different instances
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testInitializationFromDictionary() {
        let dictionary = MockDAOAnnouncementFactory.createMockAnnouncementDictionary()
        let announcement = DAOAnnouncement(from: dictionary)
        
        XCTAssertNotNil(announcement)
        XCTAssertEqual(announcement?.id, "announcement123")
        XCTAssertEqual(announcement?.body.asString, "This is the body of the announcement")
        XCTAssertEqual(announcement?.distribution, .everyone)
        XCTAssertEqual(announcement?.title.asString, "Important Announcement")
        XCTAssertEqual(announcement?.subtitle.asString, "Announcement Subtitle")
    }
    
    func testInitializationFromEmptyDictionary() {
        let emptyDictionary: DNSDataDictionary = [:]
        let announcement = DAOAnnouncement(from: emptyDictionary)
        
        XCTAssertNil(announcement)
    }
    
    func testAsDictionary() {
        let announcement = MockDAOAnnouncementFactory.createMockAnnouncement()
        let dictionary = announcement.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["body"] as Any?)
        XCTAssertNotNil(dictionary["distribution"] as Any?)
        XCTAssertNotNil(dictionary["title"] as Any?)
        XCTAssertNotNil(dictionary["subtitle"] as Any?)
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertNotNil(dictionary["endTime"] as Any?)
        XCTAssertNotNil(dictionary["attachments"] as Any?)
        XCTAssertNotNil(dictionary["chat"] as Any?)
        XCTAssertNotNil(dictionary["mediaItems"] as Any?)
        
        // Verify distribution is stored as raw value
        XCTAssertEqual(dictionary["distribution"] as? String, announcement.distribution.rawValue)
    }
    
    // MARK: - Equality and Comparison Tests
    
    func testEquality() {
        let announcement1 = MockDAOAnnouncementFactory.createMockAnnouncement()
        let announcement2 = DAOAnnouncement(from: announcement1)
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(announcement1.id, announcement2.id)
        XCTAssertEqual(announcement1.body.asString, announcement2.body.asString)
        XCTAssertEqual(announcement1.distribution, announcement2.distribution)
        XCTAssertEqual(announcement1.title.asString, announcement2.title.asString)
        XCTAssertEqual(announcement1.subtitle.asString, announcement2.subtitle.asString)
        XCTAssertEqual(announcement1.startTime, announcement2.startTime)
        XCTAssertEqual(announcement1.endTime, announcement2.endTime)
        XCTAssertFalse(announcement1 != announcement2)
    }
    
    func testInequality() {
        let announcement1 = MockDAOAnnouncementFactory.createMockAnnouncement()
        let announcement2 = MockDAOAnnouncementFactory.createMockAnnouncement()
        announcement2.title = DNSString(with: "Different Title")
        
        XCTAssertNotEqual(announcement1, announcement2)
        XCTAssertTrue(announcement1 != announcement2)
    }
    
    func testIsDiffFrom() {
        let announcement1 = MockDAOAnnouncementFactory.createMockAnnouncement()
        let announcement2 = DAOAnnouncement(from: announcement1)
        let announcement3 = MockDAOAnnouncementFactory.createMockAnnouncement()
        announcement3.body = DNSString(with: "Different body")
        
        XCTAssertFalse(announcement1.isDiffFrom(announcement2))
        XCTAssertTrue(announcement1.isDiffFrom(announcement3))
        XCTAssertTrue(announcement1.isDiffFrom(nil as DAOAnnouncement?))
        XCTAssertTrue(announcement1.isDiffFrom("not an announcement"))
    }
    
    func testSelfComparison() {
        let announcement = MockDAOAnnouncementFactory.createMockAnnouncement()
        
        XCTAssertFalse(announcement.isDiffFrom(announcement))
        XCTAssertEqual(announcement, announcement)
    }
    
    // MARK: - Time-based Tests
    
    func testTimeRangeValidation() {
        let announcements = MockDAOAnnouncementFactory.createMockAnnouncementWithTimeRanges()
        
        XCTAssertEqual(announcements.count, 3)
        
        for announcement in announcements {
            XCTAssertTrue(announcement.startTime <= announcement.endTime, 
                         "Start time should be before or equal to end time")
        }
        
        // Test the extension properties
        let pastAnnouncement = announcements[0]
        let currentAnnouncement = announcements[1]
        let futureAnnouncement = announcements[2]
        
        XCTAssertTrue(pastAnnouncement.isPast)
        XCTAssertFalse(pastAnnouncement.isActive)
        XCTAssertFalse(pastAnnouncement.isFuture)
        
        XCTAssertFalse(currentAnnouncement.isPast)
        XCTAssertTrue(currentAnnouncement.isActive)
        XCTAssertFalse(currentAnnouncement.isFuture)
        
        XCTAssertFalse(futureAnnouncement.isPast)
        XCTAssertFalse(futureAnnouncement.isActive)
        XCTAssertTrue(futureAnnouncement.isFuture)
    }
    
    // MARK: - Validation Tests
    
    func testValidationHelper() {
        let validAnnouncement = MockDAOAnnouncementFactory.createMockAnnouncement()
        XCTAssertTrue(MockDAOAnnouncementFactory.validateAnnouncementProperties(validAnnouncement))
        
        let invalidAnnouncement = DAOAnnouncement()
        invalidAnnouncement.title = DNSString(with: "") // Empty title
        XCTAssertFalse(MockDAOAnnouncementFactory.validateAnnouncementProperties(invalidAnnouncement))
        
        let invalidTimeAnnouncement = MockDAOAnnouncementFactory.createMockAnnouncement()
        invalidTimeAnnouncement.endTime = invalidTimeAnnouncement.startTime.addingTimeInterval(-3600) // End before start
        XCTAssertFalse(MockDAOAnnouncementFactory.validateAnnouncementProperties(invalidTimeAnnouncement))
    }
    
    // MARK: - Array Tests
    
    func testAnnouncementArray() {
        let announcements = MockDAOAnnouncementFactory.createMockAnnouncementArray(count: 5)
        
        XCTAssertEqual(announcements.count, 5)
        
        for (index, announcement) in announcements.enumerated() {
            XCTAssertEqual(announcement.id, "announcement\(index)")
            XCTAssertTrue(MockDAOAnnouncementFactory.validateAnnouncementProperties(announcement))
        }
    }
    
    // MARK: - Edge Cases
    
    func testMinimalDataAnnouncement() {
        let announcement = MockDAOAnnouncementFactory.createMockAnnouncementWithMinimalData()
        
        XCTAssertNotNil(announcement)
        XCTAssertEqual(announcement.title.asString, "Minimal Announcement")
        XCTAssertEqual(announcement.distribution, DNSVisibility.everyone) // Default value
    }
    
    func testInvalidDictionaryHandling() {
        let invalidDict = MockDAOAnnouncementFactory.createInvalidAnnouncementDictionary()
        let announcement = DAOAnnouncement(from: invalidDict)
        
        // Should still create object but with default values
        XCTAssertNotNil(announcement)
        if let announcement = announcement {
            XCTAssertEqual(announcement.distribution, DNSVisibility.everyone) // Should fall back to default
        }
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateAnnouncement() {
        measure {
            for _ in 0..<1000 {
                let _ = MockDAOAnnouncementFactory.createMockAnnouncement()
            }
        }
    }
    
    func testPerformanceCopyAnnouncement() {
        let announcement = MockDAOAnnouncementFactory.createMockAnnouncement()
        
        measure {
            for _ in 0..<1000 {
                let _ = DAOAnnouncement(from: announcement)
            }
        }
    }
    
    func testPerformanceDictionaryConversion() {
        let announcement = MockDAOAnnouncementFactory.createMockAnnouncement()
        
        measure {
            for _ in 0..<1000 {
                let _ = announcement.asDictionary
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testPropertyAssignment", testPropertyAssignment),
        ("testVisibilityEnumValues", testVisibilityEnumValues),
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
        ("testValidationHelper", testValidationHelper),
        ("testAnnouncementArray", testAnnouncementArray),
        ("testMinimalDataAnnouncement", testMinimalDataAnnouncement),
        ("testInvalidDictionaryHandling", testInvalidDictionaryHandling),
        ("testPerformanceCreateAnnouncement", testPerformanceCreateAnnouncement),
        ("testPerformanceCopyAnnouncement", testPerformanceCopyAnnouncement),
        ("testPerformanceDictionaryConversion", testPerformanceDictionaryConversion),
    ]
}
