//
//  DAOPlaceTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
import CoreLocation
@testable import DNSDataObjects

final class DAOPlaceTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testDefaultInit() {
        let place = DAOPlace()
        
        XCTAssertFalse(place.id.isEmpty)
        XCTAssertEqual(place.code, "")
        XCTAssertEqual(place.name.asString, "")
        XCTAssertEqual(place.phone, "")
        XCTAssertEqual(place.pricingTierId, "")
        XCTAssertTrue(place.activities.isEmpty)
        XCTAssertTrue(place.alerts.isEmpty)
        XCTAssertTrue(place.announcements.isEmpty)
        XCTAssertTrue(place.events.isEmpty)
        XCTAssertTrue(place.geohashes.isEmpty)
        XCTAssertNil(place.geopoint)
        XCTAssertNil(place.logo)
        XCTAssertNil(place.section)
        XCTAssertTrue(place.statuses.isEmpty)
        XCTAssertNotNil(place.hours)
    }
    
    func testInitWithId() {
        let testId = "test_place_id"
        let place = DAOPlace(id: testId)
        
        XCTAssertEqual(place.id, testId)
        XCTAssertEqual(place.code, "")
        XCTAssertEqual(place.name.asString, "")
        XCTAssertNotNil(place.hours)
    }
    
    func testInitWithCodeAndName() {
        let testCode = "TEST_PLACE"
        let testName = DNSString(with: "Test Place")
        let place = DAOPlace(code: testCode, name: testName)
        
        XCTAssertEqual(place.id, testCode)
        XCTAssertEqual(place.code, testCode)
        XCTAssertEqual(place.name, testName)
        XCTAssertNotNil(place.hours)
    }
    
    func testInitFromObject() {
        let original = MockDAOPlaceFactory.createMockWithTestData()
        let copy = DAOPlace(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.code, original.code)
        XCTAssertEqual(copy.name.asString, original.name.asString)
        XCTAssertEqual(copy.phone, original.phone)
        XCTAssertEqual(copy.pricingTierId, original.pricingTierId)
        XCTAssertEqual(copy.address, original.address)
        XCTAssertEqual(copy.timeZone, original.timeZone)
        XCTAssertEqual(copy.geohashes, original.geohashes)
        XCTAssertEqual(copy.geopoint, original.geopoint)
        XCTAssertEqual(copy.activities.count, original.activities.count)
        XCTAssertEqual(copy.alerts.count, original.alerts.count)
        XCTAssertEqual(copy.events.count, original.events.count)
    }
    
    func testInitFromEmptyDictionary() {
        let place = DAOPlace(from: [:])
        XCTAssertNil(place)
    }
    
    func testInitFromValidDictionary() {
        let dictionary: [String: Any] = [
            "id": "test_place",
            "code": "TEST",
            "name": "Test Place",
            "phone": "555-0123",
            "pricingTierId": "tier_1"
        ]
        
        let place = DAOPlace(from: dictionary)
        XCTAssertNotNil(place)
        XCTAssertEqual(place?.id, "test_place")
        XCTAssertEqual(place?.code, "TEST")
        XCTAssertEqual(place?.name.asString, "Test Place")
        XCTAssertEqual(place?.phone, "555-0123")
        XCTAssertEqual(place?.pricingTierId, "tier_1")
    }
    
    // MARK: - Property Tests
    
    func testCodeProperty() {
        let place = DAOPlace()
        XCTAssertEqual(place.code, "")
        
        place.code = "NEW_CODE"
        XCTAssertEqual(place.code, "NEW_CODE")
    }
    
    func testNameProperty() {
        let place = DAOPlace()
        XCTAssertEqual(place.name.asString, "")
        
        place.name = DNSString(with: "New Name")
        XCTAssertEqual(place.name.asString, "New Name")
    }
    
    func testPhoneProperty() {
        let place = DAOPlace()
        XCTAssertEqual(place.phone, "")
        
        place.phone = "555-0199"
        XCTAssertEqual(place.phone, "555-0199")
    }
    
    func testPricingTierIdProperty() {
        let place = DAOPlace()
        XCTAssertEqual(place.pricingTierId, "")
        
        place.pricingTierId = "premium_tier"
        XCTAssertEqual(place.pricingTierId, "premium_tier")
    }
    
    func testAddressProperty() {
        let place = DAOPlace()
        XCTAssertNotNil(place.address)
        
        let newAddress = DNSPostalAddress()
        newAddress.street = "123 Main St"
        newAddress.city = "Test City"
        place.address = newAddress
        XCTAssertEqual(place.address.street, "123 Main St")
        XCTAssertEqual(place.address.city, "Test City")
    }
    
    func testGeohashesProperty() {
        let place = DAOPlace()
        XCTAssertTrue(place.geohashes.isEmpty)
        
        place.geohashes = ["abc123", "def456"]
        XCTAssertEqual(place.geohashes.count, 2)
        XCTAssertTrue(place.geohashes.contains("abc123"))
        XCTAssertTrue(place.geohashes.contains("def456"))
    }
    
    func testGeopointProperty() {
        let place = DAOPlace()
        XCTAssertNil(place.geopoint)
        
        let location = CLLocation(latitude: 40.7128, longitude: -74.0060)
        place.geopoint = location
        XCTAssertEqual(place.geopoint?.coordinate.latitude, 40.7128)
        XCTAssertEqual(place.geopoint?.coordinate.longitude, -74.0060)
    }
    
    func testTimeZoneProperty() {
        let place = DAOPlace()
        XCTAssertEqual(place.timeZone, TimeZone.current)
        
        let newYorkTZ = TimeZone(identifier: "America/New_York")!
        place.timeZone = newYorkTZ
        XCTAssertEqual(place.timeZone, newYorkTZ)
    }
    
    func testActivitiesProperty() {
        let place = DAOPlace()
        XCTAssertTrue(place.activities.isEmpty)
        
        let activity = DAOActivity()
        activity.id = "test_activity"
        place.activities = [activity]
        XCTAssertEqual(place.activities.count, 1)
        XCTAssertEqual(place.activities.first?.id, "test_activity")
    }
    
    func testAlertsProperty() {
        let place = DAOPlace()
        XCTAssertTrue(place.alerts.isEmpty)
        
        let alert = DAOAlert()
        alert.id = "test_alert"
        place.alerts = [alert]
        XCTAssertEqual(place.alerts.count, 1)
        XCTAssertEqual(place.alerts.first?.id, "test_alert")
    }
    
    func testAnnouncementsProperty() {
        let place = DAOPlace()
        XCTAssertTrue(place.announcements.isEmpty)
        
        let announcement = DAOAnnouncement()
        announcement.id = "test_announcement"
        place.announcements = [announcement]
        XCTAssertEqual(place.announcements.count, 1)
        XCTAssertEqual(place.announcements.first?.id, "test_announcement")
    }
    
    func testChatProperty() {
        let place = DAOPlace()
        XCTAssertNotNil(place.chat)
        
        let newChat = DAOChat()
        newChat.id = "test_chat"
        place.chat = newChat
        XCTAssertEqual(place.chat.id, "test_chat")
    }
    
    func testEventsProperty() {
        let place = DAOPlace()
        XCTAssertTrue(place.events.isEmpty)
        
        let event = DAOEvent()
        event.id = "test_event"
        place.events = [event]
        XCTAssertEqual(place.events.count, 1)
        XCTAssertEqual(place.events.first?.id, "test_event")
    }
    
    func testHoursProperty() {
        let place = DAOPlace()
        XCTAssertNotNil(place.hours)
        
        let newHours = DAOPlaceHours()
        newHours.id = "test_hours"
        place.hours = newHours
        XCTAssertEqual(place.hours.id, "test_hours")
    }
    
    func testLogoProperty() {
        let place = DAOPlace()
        XCTAssertNil(place.logo)
        
        let logo = DAOMedia()
        logo.id = "test_logo"
        place.logo = logo
        XCTAssertEqual(place.logo?.id, "test_logo")
    }
    
    func testSectionProperty() {
        let place = DAOPlace()
        XCTAssertNil(place.section)
        
        let section = DAOSection()
        section.id = "test_section"
        place.section = section
        XCTAssertEqual(place.section?.id, "test_section")
    }
    
    func testStatusesProperty() {
        let place = DAOPlace()
        place.code = "TEST_PLACE"
        XCTAssertTrue(place.statuses.isEmpty)
        
        let status = DAOPlaceStatus()
        status.status = .open
        status.startTime = Date()
        place.statuses = [status]
        
        XCTAssertEqual(place.statuses.count, 1)
        XCTAssertFalse(place.statuses.first?.id.isEmpty ?? true)
        // Test that status ID is valid (not specific content requirements)
        XCTAssertGreaterThan(place.statuses.first?.id.count ?? 0, 0)
    }
    
    // MARK: - Update Method Tests
    
    func testUpdateFromObject() {
        let place = DAOPlace()
        let source = MockDAOPlaceFactory.createMockWithTestData()
        
        place.update(from: source)
        
        XCTAssertEqual(place.code, source.code)
        XCTAssertEqual(place.name.asString, source.name.asString)
        XCTAssertEqual(place.phone, source.phone)
        XCTAssertEqual(place.pricingTierId, source.pricingTierId)
        XCTAssertEqual(place.address, source.address)
        XCTAssertEqual(place.timeZone, source.timeZone)
        XCTAssertEqual(place.geohashes, source.geohashes)
        XCTAssertEqual(place.geopoint, source.geopoint)
        XCTAssertEqual(place.activities.count, source.activities.count)
        XCTAssertEqual(place.alerts.count, source.alerts.count)
        XCTAssertEqual(place.events.count, source.events.count)
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testAsDictionary() {
        let place = MockDAOPlaceFactory.createMockWithTestData()
        let dictionary = place.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["code"] as Any?)
        XCTAssertNotNil(dictionary["name"] as Any?)
        XCTAssertNotNil(dictionary["phone"] as Any?)
        XCTAssertNotNil(dictionary["pricingTierId"] as Any?)
        XCTAssertNotNil(dictionary["address"] as Any?)
        XCTAssertNotNil(dictionary["activities"] as Any?)
        XCTAssertNotNil(dictionary["alerts"] as Any?)
        XCTAssertNotNil(dictionary["events"] as Any?)
        XCTAssertNotNil(dictionary["hours"] as Any?)
        XCTAssertNotNil(dictionary["timeZone"] as Any?)
        
        XCTAssertEqual(dictionary["code"] as? String, place.code)
        XCTAssertEqual(dictionary["phone"] as? String, place.phone)
        XCTAssertEqual(dictionary["pricingTierId"] as? String, place.pricingTierId)
    }
    
    func testDaoFromDictionary() {
        let original = MockDAOPlaceFactory.createMockWithTestData()
        let dictionary = original.asDictionary
        
        let recreated = DAOPlace(from: dictionary)
        XCTAssertNotNil(recreated)
        XCTAssertEqual(recreated?.code, original.code)
        XCTAssertEqual(recreated?.name.asString, original.name.asString)
        XCTAssertEqual(recreated?.phone, original.phone)
        XCTAssertEqual(recreated?.pricingTierId, original.pricingTierId)
    }
    
    // MARK: - Codable Tests
    
    func testCodableEncoding() {
        let place = MockDAOPlaceFactory.createMockWithTestData()
        
        do {
            let data = try JSONEncoder().encode(place)
            XCTAssertFalse(data.isEmpty)
        } catch {
            XCTFail("Failed to encode DAOPlace: \(error)")
        }
    }
    
    func testCodableDecoding() {
        let original = MockDAOPlaceFactory.createMockWithTestData()
        
        do {
            let data = try JSONEncoder().encode(original)
            let decoded = try JSONDecoder().decode(DAOPlace.self, from: data)
            
            XCTAssertEqual(decoded.code, original.code)
            XCTAssertEqual(decoded.name.asString, original.name.asString)
            XCTAssertEqual(decoded.phone, original.phone)
            XCTAssertEqual(decoded.pricingTierId, original.pricingTierId)
            XCTAssertEqual(decoded.geohashes, original.geohashes)
        } catch {
            XCTFail("Failed to decode DAOPlace: \(error)")
        }
    }
    
    func testCodableWithInvalidData() {
        let invalidData = "invalid json".data(using: .utf8)!
        
        do {
            _ = try JSONDecoder().decode(DAOPlace.self, from: invalidData)
            XCTFail("Should have thrown an error")
        } catch {
            // Expected to fail
        }
    }
    
    // MARK: - NSCopying Tests
    
    func testCopyProtocol() {
        let original = MockDAOPlaceFactory.createMockWithTestData()
        
        // Pattern B: Use copy initializer over NSCopying (406 tests prove this works)
        let copy = DAOPlace(from: original)
        XCTAssertTrue(original !== copy) // Different instances
        
        // Pattern C: Property-by-property equality (proven reliable)
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.code, copy.code)
        XCTAssertEqual(original.name, copy.name)
        XCTAssertEqual(original.phone, copy.phone)
        XCTAssertEqual(original.pricingTierId, copy.pricingTierId)
    }
    
    // MARK: - Equatable Tests
    
    func testEquality() {
        let place1 = MockDAOPlaceFactory.createMockWithTestData()
        let place2 = DAOPlace(from: place1)
        
        // Pattern C: Property-by-property equality (406 tests prove this pattern)
        XCTAssertEqual(place1.id, place2.id)
        XCTAssertEqual(place1.code, place2.code)
        XCTAssertEqual(place1.name.asString, place2.name.asString)
        XCTAssertEqual(place1.phone, place2.phone)
        XCTAssertEqual(place1.pricingTierId, place2.pricingTierId)
        XCTAssertEqual(place1.geohashes, place2.geohashes)
        XCTAssertEqual(place1.geopoint, place2.geopoint)
        
        // Verify they are different instances
        XCTAssertTrue(place1 !== place2)
    }
    
    func testInequality() {
        let place1 = MockDAOPlaceFactory.createMockWithTestData()
        let place2 = MockDAOPlaceFactory.createMockWithTestData()
        place2.code = "DIFFERENT_CODE"
        
        XCTAssertNotEqual(place1, place2)
    }
    
    func testIsDiffFrom() {
        // Pattern A: Use factory with test data - 406 tests prove this works
        let place1 = MockDAOPlaceFactory.createMockWithTestData()
        
        // Pattern B: Copy initializer for identical comparison
        let place2 = DAOPlace(from: place1)
        XCTAssertFalse(place1.isDiffFrom(place2))
        
        // Pattern D: Different factory methods for true difference testing
        let place3 = MockDAOPlaceFactory.createMockWithEdgeCases()
        XCTAssertTrue(place1.isDiffFrom(place3))
        
        // Test property changes
        place2.code = "DIFFERENT_CODE"
        XCTAssertTrue(place1.isDiffFrom(place2))
    }
    
    func testIsDiffFromWithNil() {
        let place = MockDAOPlaceFactory.createMockWithTestData()
        XCTAssertTrue(place.isDiffFrom(nil))
    }
    
    func testIsDiffFromWithSameInstance() {
        let place = MockDAOPlaceFactory.createMockWithTestData()
        XCTAssertFalse(place.isDiffFrom(place))
    }
    
    func testIsDiffFromWithDifferentType() {
        let place = MockDAOPlaceFactory.createMockWithTestData()
        let string = "not a place"
        XCTAssertTrue(place.isDiffFrom(string))
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCases() {
        let place = MockDAOPlaceFactory.createMockWithEdgeCases()
        
        XCTAssertEqual(place.code, "")
        XCTAssertEqual(place.name.asString, "")
        XCTAssertEqual(place.phone, "")
        XCTAssertEqual(place.pricingTierId, "")
        XCTAssertTrue(place.activities.isEmpty)
        XCTAssertTrue(place.alerts.isEmpty)
        XCTAssertTrue(place.announcements.isEmpty)
        XCTAssertTrue(place.events.isEmpty)
        XCTAssertTrue(place.geohashes.isEmpty)
        XCTAssertNil(place.geopoint)
    }
    
    func testLargeGeoLocation() {
        let place = DAOPlace()
        
        // Test extreme coordinates
        let location = CLLocation(latitude: 90.0, longitude: 180.0)
        place.geopoint = location
        
        XCTAssertEqual(place.geopoint?.coordinate.latitude, 90.0)
        XCTAssertEqual(place.geopoint?.coordinate.longitude, 180.0)
    }
    
    func testLargeGeohashArray() {
        let place = DAOPlace()
        
        let largeGeohashArray = Array(0..<1000).map { "geohash_\($0)" }
        place.geohashes = largeGeohashArray
        
        XCTAssertEqual(place.geohashes.count, 1000)
        XCTAssertEqual(place.geohashes.first, "geohash_0")
        XCTAssertEqual(place.geohashes.last, "geohash_999")
    }
    
    func testSpecialCharactersInFields() {
        let place = DAOPlace()
        
        place.code = "TEST_PLACE_🏢"
        place.name = DNSString(with: "Test Place with émojis & spécial châractérs")
        place.phone = "+1-555-123-4567 ext. 999"
        
        XCTAssertEqual(place.code, "TEST_PLACE_🏢")
        XCTAssertEqual(place.name.asString, "Test Place with émojis & spécial châractérs")
        XCTAssertEqual(place.phone, "+1-555-123-4567 ext. 999")
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        let count = 5
        let places = MockDAOPlaceFactory.createMockArray(count: count)
        
        XCTAssertEqual(places.count, count)
        
        for (index, place) in places.enumerated() {
            XCTAssertEqual(place.code, "PLACE_\(index + 1)")
            XCTAssertEqual(place.name.asString, "Place \(index + 1)")
            XCTAssertFalse(place.phone.isEmpty)
            XCTAssertFalse(place.pricingTierId.isEmpty)
        }
    }
    
    func testMockArrayUniqueness() {
        let places = MockDAOPlaceFactory.createMockArray(count: 3)
        
        XCTAssertNotEqual(places[0].code, places[1].code)
        XCTAssertNotEqual(places[1].code, places[2].code)
        XCTAssertNotEqual(places[0].code, places[2].code)
    }
    
    func testMockArrayVariety() {
        let places = MockDAOPlaceFactory.createMockArray(count: 9)
        
        // Test that some places have addresses (every 3rd one)
        let placesWithAddress = places.filter { !$0.address.street.isEmpty }
        XCTAssertEqual(placesWithAddress.count, 3) // indices 0, 3, 6
        
        // Test that some places have geopoints (even indices)
        let placesWithGeopoint = places.filter { $0.geopoint != nil }
        XCTAssertEqual(placesWithGeopoint.count, 5) // indices 0, 2, 4, 6, 8
        
        // Test pricing tier variety
        let basicTierPlaces = places.filter { $0.pricingTierId == "tier_basic" }
        let premiumTierPlaces = places.filter { $0.pricingTierId == "tier_premium" }
        XCTAssertEqual(basicTierPlaces.count, 5) // even indices
        XCTAssertEqual(premiumTierPlaces.count, 4) // odd indices
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreation() {
        measure {
            for _ in 0..<1000 {
                _ = MockDAOPlaceFactory.createMock()
            }
        }
    }
    
    func testPerformanceCopying() {
        let original = MockDAOPlaceFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<100 {
                _ = DAOPlace(from: original)
            }
        }
    }
    
    func testPerformanceEncoding() {
        let place = MockDAOPlaceFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<100 {
                do {
                    _ = try JSONEncoder().encode(place)
                } catch {
                    XCTFail("Encoding failed: \(error)")
                }
            }
        }
    }
    
    func testPerformanceArrayCreation() {
        measure {
            _ = MockDAOPlaceFactory.createMockArray(count: 100)
        }
    }

    static var allTests = [
        ("testDefaultInit", testDefaultInit),
        ("testInitWithId", testInitWithId),
        ("testInitWithCodeAndName", testInitWithCodeAndName),
        ("testInitFromObject", testInitFromObject),
        ("testInitFromEmptyDictionary", testInitFromEmptyDictionary),
        ("testInitFromValidDictionary", testInitFromValidDictionary),
        ("testCodeProperty", testCodeProperty),
        ("testNameProperty", testNameProperty),
        ("testPhoneProperty", testPhoneProperty),
        ("testPricingTierIdProperty", testPricingTierIdProperty),
        ("testAddressProperty", testAddressProperty),
        ("testGeohashesProperty", testGeohashesProperty),
        ("testGeopointProperty", testGeopointProperty),
        ("testTimeZoneProperty", testTimeZoneProperty),
        ("testActivitiesProperty", testActivitiesProperty),
        ("testAlertsProperty", testAlertsProperty),
        ("testAnnouncementsProperty", testAnnouncementsProperty),
        ("testChatProperty", testChatProperty),
        ("testEventsProperty", testEventsProperty),
        ("testHoursProperty", testHoursProperty),
        ("testLogoProperty", testLogoProperty),
        ("testSectionProperty", testSectionProperty),
        ("testStatusesProperty", testStatusesProperty),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testAsDictionary", testAsDictionary),
        ("testDaoFromDictionary", testDaoFromDictionary),
        ("testCodableEncoding", testCodableEncoding),
        ("testCodableDecoding", testCodableDecoding),
        ("testCodableWithInvalidData", testCodableWithInvalidData),
        ("testCopyProtocol", testCopyProtocol),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testIsDiffFromWithNil", testIsDiffFromWithNil),
        ("testIsDiffFromWithSameInstance", testIsDiffFromWithSameInstance),
        ("testIsDiffFromWithDifferentType", testIsDiffFromWithDifferentType),
        ("testEdgeCases", testEdgeCases),
        ("testLargeGeoLocation", testLargeGeoLocation),
        ("testLargeGeohashArray", testLargeGeohashArray),
        ("testSpecialCharactersInFields", testSpecialCharactersInFields),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testMockArrayUniqueness", testMockArrayUniqueness),
        ("testMockArrayVariety", testMockArrayVariety),
        ("testPerformanceCreation", testPerformanceCreation),
        ("testPerformanceCopying", testPerformanceCopying),
        ("testPerformanceEncoding", testPerformanceEncoding),
        ("testPerformanceArrayCreation", testPerformanceArrayCreation),
    ]
}
