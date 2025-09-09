//
//  DAOPricingSeasonTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOPricingSeasonTests: XCTestCase {
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInit() {
        let pricingSeason = DAOPricingSeason()
        
        XCTAssertNotNil(pricingSeason.id)
        XCTAssertFalse(pricingSeason.id.isEmpty)
        XCTAssertEqual(pricingSeason.endTime, DAOPricingSeason.C.defaultEndTime)
        XCTAssertEqual(pricingSeason.startTime, DAOPricingSeason.C.defaultStartTime)
        XCTAssertEqual(pricingSeason.priority, DNSPriority.normal)
        XCTAssertTrue(pricingSeason.items.isEmpty)
    }
    
    func testInitWithId() {
        let testId = "test_pricing_season_id"
        let pricingSeason = DAOPricingSeason(id: testId)
        
        XCTAssertEqual(pricingSeason.id, testId)
        XCTAssertEqual(pricingSeason.endTime, DAOPricingSeason.C.defaultEndTime)
        XCTAssertEqual(pricingSeason.startTime, DAOPricingSeason.C.defaultStartTime)
        XCTAssertEqual(pricingSeason.priority, DNSPriority.normal)
        XCTAssertTrue(pricingSeason.items.isEmpty)
    }
    
    func testInitFromObject() {
        let originalSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        let copiedSeason = DAOPricingSeason(from: originalSeason)
        
        XCTAssertEqual(copiedSeason.id, originalSeason.id)
        XCTAssertEqual(copiedSeason.endTime, originalSeason.endTime)
        XCTAssertEqual(copiedSeason.startTime, originalSeason.startTime)
        XCTAssertEqual(copiedSeason.priority, originalSeason.priority)
        XCTAssertEqual(copiedSeason.items.count, originalSeason.items.count)
        XCTAssertFalse(copiedSeason === originalSeason) // Different instances
    }
    
    // MARK: - Property Tests
    
    func testEndTimeProperty() {
        let pricingSeason = DAOPricingSeason()
        let testEndTime = Date().addingTimeInterval(86400 * 365) // 1 year from now
        
        pricingSeason.endTime = testEndTime
        XCTAssertEqual(pricingSeason.endTime, testEndTime)
    }
    
    func testStartTimeProperty() {
        let pricingSeason = DAOPricingSeason()
        let testStartTime = Date().addingTimeInterval(-86400 * 30) // 30 days ago
        
        pricingSeason.startTime = testStartTime
        XCTAssertEqual(pricingSeason.startTime, testStartTime)
    }
    
    func testPriorityProperty() {
        let pricingSeason = DAOPricingSeason()
        
        // Test normal priority
        pricingSeason.priority = DNSPriority.high
        XCTAssertEqual(pricingSeason.priority, DNSPriority.high)
        
        // Test minimum boundary
        pricingSeason.priority = DNSPriority.none - 10
        XCTAssertEqual(pricingSeason.priority, DNSPriority.none)
        
        // Test maximum boundary
        pricingSeason.priority = DNSPriority.highest + 10
        XCTAssertEqual(pricingSeason.priority, DNSPriority.highest)
    }
    
    func testItemsProperty() {
        let pricingSeason = DAOPricingSeason()
        let testItems = MockDAOPricingSeasonFactory.createMockArray(count: 3).first?.items ?? []
        
        XCTAssertTrue(pricingSeason.items.isEmpty)
        pricingSeason.items = testItems
        XCTAssertEqual(pricingSeason.items.count, testItems.count)
    }
    
    // MARK: - isActive Tests
    
    func testIsActiveWithDefaultTimes() {
        let pricingSeason = DAOPricingSeason()
        // Default times should make it always active
        XCTAssertTrue(pricingSeason.isActive)
        XCTAssertTrue(pricingSeason.isActive(for: Date()))
        XCTAssertTrue(pricingSeason.isActive(for: Date().addingTimeInterval(-86400))) // Yesterday
        XCTAssertTrue(pricingSeason.isActive(for: Date().addingTimeInterval(86400))) // Tomorrow
    }
    
    func testIsActiveWithOnlyStartTime() {
        let pricingSeason = DAOPricingSeason()
        let pastTime = Date().addingTimeInterval(-86400 * 30) // 30 days ago
        pricingSeason.startTime = pastTime
        
        XCTAssertTrue(pricingSeason.isActive(for: Date())) // Current time > start time
        XCTAssertFalse(pricingSeason.isActive(for: pastTime.addingTimeInterval(-86400))) // Before start
    }
    
    func testIsActiveWithOnlyEndTime() {
        let pricingSeason = DAOPricingSeason()
        let futureTime = Date().addingTimeInterval(86400 * 30) // 30 days from now
        pricingSeason.endTime = futureTime
        
        XCTAssertTrue(pricingSeason.isActive(for: Date())) // Current time < end time
        XCTAssertFalse(pricingSeason.isActive(for: futureTime.addingTimeInterval(86400))) // After end
    }
    
    func testIsActiveWithBothTimes() {
        let pricingSeason = DAOPricingSeason()
        let startTime = Date().addingTimeInterval(-86400 * 30) // 30 days ago
        let endTime = Date().addingTimeInterval(86400 * 30) // 30 days from now
        
        pricingSeason.startTime = startTime
        pricingSeason.endTime = endTime
        
        XCTAssertTrue(pricingSeason.isActive(for: Date())) // Within range
        XCTAssertFalse(pricingSeason.isActive(for: startTime.addingTimeInterval(-86400))) // Before start
        XCTAssertFalse(pricingSeason.isActive(for: endTime.addingTimeInterval(86400))) // After end
    }
    
    func testIsActiveWithInactivePeriod() {
        let pricingSeason = DAOPricingSeason()
        let startTime = Date().addingTimeInterval(86400 * 10) // 10 days from now
        let endTime = Date().addingTimeInterval(86400 * 30) // 30 days from now
        
        pricingSeason.startTime = startTime
        pricingSeason.endTime = endTime
        
        XCTAssertFalse(pricingSeason.isActive(for: Date())) // Current time before start
    }
    
    // MARK: - item() and price() Tests
    
    func testItemWithEmptyItems() {
        let pricingSeason = DAOPricingSeason()
        XCTAssertNil(pricingSeason.item)
        XCTAssertNil(pricingSeason.item(for: Date()))
    }
    
    func testItemWithSingleItem() {
        let pricingSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        let currentTime = Date()
        
        let foundItem = pricingSeason.item(for: currentTime)
        XCTAssertNotNil(foundItem)
        // Should return the highest priority item that has a price for the given time
    }
    
    func testItemSortsByPriority() {
        let pricingSeason = DAOPricingSeason()
        
        // Create items with different priorities
        let lowPriorityItem = DAOPricingItem()
        lowPriorityItem.priority = DNSPriority.low
        let priceDefault1 = DAOPricingPrice()
        let price1 = DNSPrice()
        price1.price = 50.0
        price1.priority = DNSPriority.normal
        priceDefault1.prices = [price1]
        lowPriorityItem.priceDefault = priceDefault1
        
        let highPriorityItem = DAOPricingItem()
        highPriorityItem.priority = DNSPriority.high
        let priceDefault2 = DAOPricingPrice()
        let price2 = DNSPrice()
        price2.price = 100.0
        price2.priority = DNSPriority.normal
        priceDefault2.prices = [price2]
        highPriorityItem.priceDefault = priceDefault2
        
        pricingSeason.items = [lowPriorityItem, highPriorityItem]
        
        let foundItem = pricingSeason.item(for: Date())
        XCTAssertNotNil(foundItem)
        XCTAssertEqual(foundItem?.priority, DNSPriority.high)
    }
    
    func testPriceWithEmptyItems() {
        let pricingSeason = DAOPricingSeason()
        XCTAssertNil(pricingSeason.price)
        XCTAssertNil(pricingSeason.price(for: Date()))
    }
    
    func testPriceWithValidItems() {
        let pricingSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        let currentTime = Date()
        
        let foundPrice = pricingSeason.price(for: currentTime)
        XCTAssertNotNil(foundPrice)
        // Should return the price from the highest priority item
    }
    
    // MARK: - Update Tests
    
    func testUpdateFromObject() {
        let originalSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        let targetSeason = DAOPricingSeason()
        
        let originalId = targetSeason.id
        targetSeason.update(from: originalSeason)
        
        XCTAssertEqual(targetSeason.id, originalId) // ID should not change during update
        XCTAssertEqual(targetSeason.endTime, originalSeason.endTime)
        XCTAssertEqual(targetSeason.startTime, originalSeason.startTime)
        XCTAssertEqual(targetSeason.priority, originalSeason.priority)
        XCTAssertEqual(targetSeason.items.count, originalSeason.items.count)
    }
    
    // MARK: - Dictionary Translation Tests
    
    func testInitFromDictionary() {
        let testData: DNSDataDictionary = [
            "id": "test_season_id",
            "endTime": Date().addingTimeInterval(86400 * 90),
            "startTime": Date().addingTimeInterval(-86400 * 30),
            "priority": DNSPriority.high,
            "items": []
        ]
        
        let pricingSeason = DAOPricingSeason(from: testData)
        XCTAssertNotNil(pricingSeason)
        XCTAssertEqual(pricingSeason?.id, "test_season_id")
        XCTAssertEqual(pricingSeason?.priority, DNSPriority.high)
    }
    
    func testInitFromEmptyDictionary() {
        let pricingSeason = DAOPricingSeason(from: [:])
        XCTAssertNil(pricingSeason)
    }
    
    func testAsDictionary() {
        let pricingSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        let dictionary = pricingSeason.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["endTime"] as Any?)
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertNotNil(dictionary["priority"] as Any?)
        XCTAssertNotNil(dictionary["items"] as Any?)
        
        if let items = dictionary["items"] as? [[String: Any]] {
            XCTAssertEqual(items.count, pricingSeason.items.count)
        } else {
            XCTFail("Items should be converted to array of dictionaries")
        }
    }
    
    // MARK: - Codable Tests
    
    func testCodableEncodeDecode() throws {
        let originalSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalSeason)
        
        let decoder = JSONDecoder()
        let decodedSeason = try decoder.decode(DAOPricingSeason.self, from: data)
        
        XCTAssertEqual(decodedSeason.id, originalSeason.id)
        XCTAssertEqual(decodedSeason.endTime.timeIntervalSince1970, originalSeason.endTime.timeIntervalSince1970, accuracy: 1.0)
        XCTAssertEqual(decodedSeason.startTime.timeIntervalSince1970, originalSeason.startTime.timeIntervalSince1970, accuracy: 1.0)
        XCTAssertEqual(decodedSeason.priority, originalSeason.priority)
        XCTAssertEqual(decodedSeason.items.count, originalSeason.items.count)
    }
    
    func testCodableWithMinimalData() throws {
        let pricingSeason = DAOPricingSeason()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(pricingSeason)
        
        let decoder = JSONDecoder()
        let decodedSeason = try decoder.decode(DAOPricingSeason.self, from: data)
        
        XCTAssertEqual(decodedSeason.id, pricingSeason.id)
        XCTAssertEqual(decodedSeason.priority, pricingSeason.priority)
        XCTAssertTrue(decodedSeason.items.isEmpty)
    }
    
    // MARK: - Copy Tests
    
    func testCopy() {
        let originalSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        let copiedSeason = originalSeason.copy() as! DAOPricingSeason
        
        XCTAssertEqual(copiedSeason.id, originalSeason.id)
        XCTAssertEqual(copiedSeason.endTime, originalSeason.endTime)
        XCTAssertEqual(copiedSeason.startTime, originalSeason.startTime)
        XCTAssertEqual(copiedSeason.priority, originalSeason.priority)
        XCTAssertEqual(copiedSeason.items.count, originalSeason.items.count)
        XCTAssertFalse(copiedSeason === originalSeason) // Different instances
    }
    
    func testNSCopyingProtocol() {
        let originalSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        let copiedSeason = originalSeason.copy(with: nil) as! DAOPricingSeason
        
        XCTAssertEqual(copiedSeason.id, originalSeason.id)
        XCTAssertEqual(copiedSeason.endTime, originalSeason.endTime)
        XCTAssertEqual(copiedSeason.startTime, originalSeason.startTime)
        XCTAssertEqual(copiedSeason.priority, originalSeason.priority)
        XCTAssertEqual(copiedSeason.items.count, originalSeason.items.count)
    }
    
    // MARK: - Equality Tests
    
    func testEquality() {
        let season1 = MockDAOPricingSeasonFactory.createMockWithTestData()
        let season2 = DAOPricingSeason(from: season1)
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(season1.id, season2.id)
        XCTAssertEqual(season1.endTime, season2.endTime)
        XCTAssertEqual(season1.startTime, season2.startTime)
        XCTAssertEqual(season1.priority, season2.priority)
        XCTAssertEqual(season1.items.count, season2.items.count)
        XCTAssertFalse(season1.isDiffFrom(season2))
    }
    
    func testInequalityDifferentEndTime() {
        let season1 = MockDAOPricingSeasonFactory.createMockWithTestData()
        let season2 = DAOPricingSeason(from: season1)
        season2.endTime = Date().addingTimeInterval(86400 * 365)
        
        XCTAssertNotEqual(season1, season2)
        XCTAssertTrue(season1.isDiffFrom(season2))
    }
    
    func testInequalityDifferentStartTime() {
        let season1 = MockDAOPricingSeasonFactory.createMockWithTestData()
        let season2 = DAOPricingSeason(from: season1)
        season2.startTime = Date().addingTimeInterval(-86400 * 365)
        
        XCTAssertNotEqual(season1, season2)
        XCTAssertTrue(season1.isDiffFrom(season2))
    }
    
    func testInequalityDifferentPriority() {
        let season1 = MockDAOPricingSeasonFactory.createMockWithTestData()
        let season2 = DAOPricingSeason(from: season1)
        season2.priority = DNSPriority.low
        
        XCTAssertNotEqual(season1, season2)
        XCTAssertTrue(season1.isDiffFrom(season2))
    }
    
    func testInequalityDifferentItems() {
        let season1 = MockDAOPricingSeasonFactory.createMockWithTestData()
        let season2 = DAOPricingSeason(from: season1)
        season2.items = []
        
        XCTAssertNotEqual(season1, season2)
        XCTAssertTrue(season1.isDiffFrom(season2))
    }
    
    func testInequalityWithNil() {
        let season = MockDAOPricingSeasonFactory.createMockWithTestData()
        
        XCTAssertTrue(season.isDiffFrom(nil))
        XCTAssertTrue(season.isDiffFrom("not a pricing season"))
    }
    
    func testEqualityWithSameInstance() {
        let season = MockDAOPricingSeasonFactory.createMockWithTestData()
        
        XCTAssertEqual(season, season)
        XCTAssertFalse(season.isDiffFrom(season))
    }
    
    // MARK: - Edge Cases and Error Handling
    
    func testPriorityBoundaries() {
        let pricingSeason = DAOPricingSeason()
        
        // Test setting below minimum
        pricingSeason.priority = -100
        XCTAssertEqual(pricingSeason.priority, DNSPriority.none)
        
        // Test setting above maximum
        pricingSeason.priority = 1000
        XCTAssertEqual(pricingSeason.priority, DNSPriority.highest)
        
        // Test setting exact boundaries
        pricingSeason.priority = DNSPriority.none
        XCTAssertEqual(pricingSeason.priority, DNSPriority.none)
        
        pricingSeason.priority = DNSPriority.highest
        XCTAssertEqual(pricingSeason.priority, DNSPriority.highest)
    }
    
    func testItemsWithNoValidPrices() {
        let pricingSeason = DAOPricingSeason()
        
        // Create items without valid prices
        let item1 = DAOPricingItem()
        item1.priority = DNSPriority.high
        // No priceDefault set
        
        let item2 = DAOPricingItem()
        item2.priority = DNSPriority.normal
        // No priceDefault set
        
        pricingSeason.items = [item1, item2]
        
        XCTAssertNil(pricingSeason.item)
        XCTAssertNil(pricingSeason.price)
    }
    
    func testCodingKeysCompleteness() {
        // Test that all CodingKeys are present by checking the enum cases manually
        let endTimeKey = DAOPricingSeason.CodingKeys.endTime
        let itemsKey = DAOPricingSeason.CodingKeys.items
        let priorityKey = DAOPricingSeason.CodingKeys.priority
        let startTimeKey = DAOPricingSeason.CodingKeys.startTime
        
        XCTAssertEqual(endTimeKey.rawValue, "endTime")
        XCTAssertEqual(itemsKey.rawValue, "items")
        XCTAssertEqual(priorityKey.rawValue, "priority")
        XCTAssertEqual(startTimeKey.rawValue, "startTime")
    }
    
    // MARK: - Factory Method Tests
    
    func testCreatePricingItem() {
        let pricingItem = DAOPricingSeason.createPricingItem()
        XCTAssertNotNil(pricingItem)
        XCTAssertTrue(type(of: pricingItem) == DAOPricingItem.self)
    }
    
    func testCreatePricingItemFromObject() {
        let originalItem = DAOPricingItem()
        originalItem.priority = DNSPriority.high
        
        let newItem = DAOPricingSeason.createPricingItem(from: originalItem)
        XCTAssertNotNil(newItem)
        XCTAssertEqual(newItem.priority, originalItem.priority)
        XCTAssertFalse(newItem === originalItem)
    }
    
    func testCreatePricingSeason() {
        let pricingSeason = DAOPricingSeason.createPricingSeason()
        XCTAssertNotNil(pricingSeason)
        XCTAssertTrue(type(of: pricingSeason) == DAOPricingSeason.self)
    }
    
    func testCreatePricingSeasonFromObject() {
        let originalSeason = MockDAOPricingSeasonFactory.createMockWithTestData()
        let newSeason = DAOPricingSeason.createPricingSeason(from: originalSeason)
        
        XCTAssertNotNil(newSeason)
        XCTAssertEqual(newSeason.id, originalSeason.id)
        XCTAssertEqual(newSeason.priority, originalSeason.priority)
        XCTAssertFalse(newSeason === originalSeason)
    }
    
    static var allTests = [
        ("testInit", testInit),
        ("testInitWithId", testInitWithId),
        ("testInitFromObject", testInitFromObject),
        ("testEndTimeProperty", testEndTimeProperty),
        ("testStartTimeProperty", testStartTimeProperty),
        ("testPriorityProperty", testPriorityProperty),
        ("testItemsProperty", testItemsProperty),
        ("testIsActiveWithDefaultTimes", testIsActiveWithDefaultTimes),
        ("testIsActiveWithOnlyStartTime", testIsActiveWithOnlyStartTime),
        ("testIsActiveWithOnlyEndTime", testIsActiveWithOnlyEndTime),
        ("testIsActiveWithBothTimes", testIsActiveWithBothTimes),
        ("testIsActiveWithInactivePeriod", testIsActiveWithInactivePeriod),
        ("testItemWithEmptyItems", testItemWithEmptyItems),
        ("testItemWithSingleItem", testItemWithSingleItem),
        ("testItemSortsByPriority", testItemSortsByPriority),
        ("testPriceWithEmptyItems", testPriceWithEmptyItems),
        ("testPriceWithValidItems", testPriceWithValidItems),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testInitFromDictionary", testInitFromDictionary),
        ("testInitFromEmptyDictionary", testInitFromEmptyDictionary),
        ("testAsDictionary", testAsDictionary),
        ("testCodableEncodeDecode", testCodableEncodeDecode),
        ("testCodableWithMinimalData", testCodableWithMinimalData),
        ("testCopy", testCopy),
        ("testNSCopyingProtocol", testNSCopyingProtocol),
        ("testEquality", testEquality),
        ("testInequalityDifferentEndTime", testInequalityDifferentEndTime),
        ("testInequalityDifferentStartTime", testInequalityDifferentStartTime),
        ("testInequalityDifferentPriority", testInequalityDifferentPriority),
        ("testInequalityDifferentItems", testInequalityDifferentItems),
        ("testInequalityWithNil", testInequalityWithNil),
        ("testEqualityWithSameInstance", testEqualityWithSameInstance),
        ("testPriorityBoundaries", testPriorityBoundaries),
        ("testItemsWithNoValidPrices", testItemsWithNoValidPrices),
        ("testCodingKeysCompleteness", testCodingKeysCompleteness),
        ("testCreatePricingItem", testCreatePricingItem),
        ("testCreatePricingItemFromObject", testCreatePricingItemFromObject),
        ("testCreatePricingSeason", testCreatePricingSeason),
        ("testCreatePricingSeasonFromObject", testCreatePricingSeasonFromObject),
    ]
}
