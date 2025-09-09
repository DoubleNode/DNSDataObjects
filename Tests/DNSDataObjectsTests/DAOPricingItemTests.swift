//
//  DAOPricingItemTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOPricingItemTests: XCTestCase {
    
    // MARK: - Initialization Tests -
    
    func testInitialization() {
        let pricingItem = DAOPricingItem()
        XCTAssertEqual(pricingItem.priority, DNSPriority.normal)
        XCTAssertNil(pricingItem.priceDefault)
        XCTAssertNil(pricingItem.priceMonday)
        XCTAssertNil(pricingItem.priceTuesday)
        XCTAssertNil(pricingItem.priceWednesday)
        XCTAssertNil(pricingItem.priceThursday)
        XCTAssertNil(pricingItem.priceFriday)
        XCTAssertNil(pricingItem.priceSaturday)
        XCTAssertNil(pricingItem.priceSunday)
        XCTAssertNil(pricingItem.price)
    }
    
    func testInitializationWithId() {
        let id = "test-pricing-item"
        let pricingItem = DAOPricingItem(id: id)
        XCTAssertEqual(pricingItem.id, id)
        XCTAssertEqual(pricingItem.priority, DNSPriority.normal)
    }
    
    func testInitializationFromObject() {
        let original = MockDAOPricingItemFactory.createFull()
        let copy = DAOPricingItem(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.priority, original.priority)
        XCTAssertEqual(copy.priceDefault?.id, original.priceDefault?.id)
        XCTAssertEqual(copy.priceMonday?.id, original.priceMonday?.id)
        XCTAssertEqual(copy.priceTuesday?.id, original.priceTuesday?.id)
        XCTAssertEqual(copy.priceWednesday?.id, original.priceWednesday?.id)
        XCTAssertEqual(copy.priceThursday?.id, original.priceThursday?.id)
        XCTAssertEqual(copy.priceFriday?.id, original.priceFriday?.id)
        XCTAssertEqual(copy.priceSaturday?.id, original.priceSaturday?.id)
        XCTAssertEqual(copy.priceSunday?.id, original.priceSunday?.id)
    }
    
    func testInitializationFromEmptyDictionary() {
        let pricingItem = DAOPricingItem(from: [:])
        XCTAssertNil(pricingItem)
    }
    
    func testInitializationFromValidDictionary() {
        let dictionary: DNSDataDictionary = [
            "id": "test-pricing",
            "priority": DNSPriority.high,
            "priceDefault": [
                "id": "default-price",
                "prices": [
                    ["value": 10.00, "currency": "USD"]
                ]
            ]
        ]
        
        let pricingItem = DAOPricingItem(from: dictionary)
        XCTAssertNotNil(pricingItem)
        XCTAssertEqual(pricingItem?.id, "test-pricing")
        XCTAssertEqual(pricingItem?.priority, DNSPriority.high)
        XCTAssertNotNil(pricingItem?.priceDefault)
    }
    
    // MARK: - Priority Tests -
    
    func testPriorityValidRange() {
        let pricingItem = DAOPricingItem()
        
        pricingItem.priority = DNSPriority.none
        XCTAssertEqual(pricingItem.priority, DNSPriority.none)
        
        pricingItem.priority = DNSPriority.low
        XCTAssertEqual(pricingItem.priority, DNSPriority.low)
        
        pricingItem.priority = DNSPriority.normal
        XCTAssertEqual(pricingItem.priority, DNSPriority.normal)
        
        pricingItem.priority = DNSPriority.high
        XCTAssertEqual(pricingItem.priority, DNSPriority.high)
        
        pricingItem.priority = DNSPriority.highest
        XCTAssertEqual(pricingItem.priority, DNSPriority.highest)
    }
    
    func testPriorityClampingAboveMaximum() {
        let pricingItem = DAOPricingItem()
        pricingItem.priority = DNSPriority.highest + 1
        XCTAssertEqual(pricingItem.priority, DNSPriority.highest)
    }
    
    func testPriorityClampingBelowMinimum() {
        let pricingItem = DAOPricingItem()
        pricingItem.priority = DNSPriority.none - 1
        XCTAssertEqual(pricingItem.priority, DNSPriority.none)
    }
    
    // MARK: - Price Property Tests -
    
    func testPricePropertyWithDefaultOnly() {
        let pricingItem = MockDAOPricingItemFactory.createDefaultOnly()
        XCTAssertNotNil(pricingItem.price)
        XCTAssertEqual(pricingItem.price?.price, 25.00)
    }
    
    func testPricePropertyWithNoPrices() {
        let pricingItem = MockDAOPricingItemFactory.createEmpty()
        XCTAssertNil(pricingItem.price)
    }
    
    func testPricePropertyWithNilPrices() {
        let pricingItem = MockDAOPricingItemFactory.createWithNilPrices()
        XCTAssertNil(pricingItem.price)
    }
    
    func testPricePropertyWithEmptyPrices() {
        let pricingItem = MockDAOPricingItemFactory.createWithEmptyPrices()
        XCTAssertNil(pricingItem.price)
    }
    
    // MARK: - Day-Specific Price Tests -
    
    func testPriceForMondayWithSpecificPrice() {
        let pricingItem = MockDAOPricingItemFactory.createWeekdaysOnly()
        
        // Create a Monday date
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 8) // This is a Monday
        let mondayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: mondayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 20.00) // Weekday price
    }
    
    func testPriceForTuesdayWithSpecificPrice() {
        let pricingItem = MockDAOPricingItemFactory.createWeekdaysOnly()
        
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 9) // This is a Tuesday
        let tuesdayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: tuesdayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 20.00) // Weekday price
    }
    
    func testPriceForWednesdayWithSpecificPrice() {
        let pricingItem = MockDAOPricingItemFactory.createWeekdaysOnly()
        
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 10) // This is a Wednesday
        let wednesdayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: wednesdayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 20.00) // Weekday price
    }
    
    func testPriceForThursdayWithSpecificPrice() {
        let pricingItem = MockDAOPricingItemFactory.createWeekdaysOnly()
        
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 11) // This is a Thursday
        let thursdayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: thursdayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 20.00) // Weekday price
    }
    
    func testPriceForFridayWithSpecificPrice() {
        let pricingItem = MockDAOPricingItemFactory.createWeekdaysOnly()
        
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 12) // This is a Friday
        let fridayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: fridayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 20.00) // Weekday price
    }
    
    func testPriceForSaturdayWithSpecificPrice() {
        let pricingItem = MockDAOPricingItemFactory.createWeekendsOnly()
        
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 13) // This is a Saturday
        let saturdayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: saturdayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 30.00) // Weekend price
    }
    
    func testPriceForSundayWithSpecificPrice() {
        let pricingItem = MockDAOPricingItemFactory.createWeekendsOnly()
        
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 14) // This is a Sunday
        let sundayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: sundayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 30.00) // Weekend price
    }
    
    func testPriceForWeekendWithoutSpecificPriceFallsBackToDefault() {
        let pricingItem = MockDAOPricingItemFactory.createWeekdaysOnly()
        
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 13) // This is a Saturday
        let saturdayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: saturdayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 10.00) // Default price since no Saturday price set
    }
    
    func testPriceForWeekdayWithoutSpecificPriceFallsBackToDefault() {
        let pricingItem = MockDAOPricingItemFactory.createWeekendsOnly()
        
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 1, day: 8) // This is a Monday
        let mondayDate = calendar.date(from: components)!
        
        let price = pricingItem.price(for: mondayDate)
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 10.00) // Default price since no Monday price set
    }
    
    // MARK: - Update Tests -
    
    func testUpdateFromObject() {
        let original = MockDAOPricingItemFactory.createBasic()
        let updated = MockDAOPricingItemFactory.createFull()
        
        original.update(from: updated)
        
        XCTAssertEqual(original.id, updated.id)
        XCTAssertEqual(original.priority, updated.priority)
        XCTAssertEqual(original.priceDefault?.id, updated.priceDefault?.id)
        XCTAssertEqual(original.priceMonday?.id, updated.priceMonday?.id)
        XCTAssertEqual(original.priceTuesday?.id, updated.priceTuesday?.id)
        XCTAssertEqual(original.priceWednesday?.id, updated.priceWednesday?.id)
        XCTAssertEqual(original.priceThursday?.id, updated.priceThursday?.id)
        XCTAssertEqual(original.priceFriday?.id, updated.priceFriday?.id)
        XCTAssertEqual(original.priceSaturday?.id, updated.priceSaturday?.id)
        XCTAssertEqual(original.priceSunday?.id, updated.priceSunday?.id)
    }
    
    func testUpdateFromObjectWithNilValues() {
        let original = MockDAOPricingItemFactory.createFull()
        let nilObject = MockDAOPricingItemFactory.createWithNilPrices()
        
        original.update(from: nilObject)
        
        XCTAssertNil(original.priceDefault)
        XCTAssertNil(original.priceMonday)
        XCTAssertNil(original.priceTuesday)
        XCTAssertNil(original.priceWednesday)
        XCTAssertNil(original.priceThursday)
        XCTAssertNil(original.priceFriday)
        XCTAssertNil(original.priceSaturday)
        XCTAssertNil(original.priceSunday)
    }
    
    // MARK: - Dictionary Conversion Tests -
    
    func testAsDictionaryWithFullData() {
        let pricingItem = MockDAOPricingItemFactory.createFull()
        let dictionary = pricingItem.asDictionary
        
        XCTAssertEqual(dictionary["id"] as? String, pricingItem.id)
        XCTAssertEqual(dictionary["priority"] as? Int, pricingItem.priority)
        XCTAssertNotNil(dictionary["priceDefault"] as Any?)
        XCTAssertNotNil(dictionary["priceMonday"] as Any?)
        XCTAssertNotNil(dictionary["priceTuesday"] as Any?)
        XCTAssertNotNil(dictionary["priceWednesday"] as Any?)
        XCTAssertNotNil(dictionary["priceThursday"] as Any?)
        XCTAssertNotNil(dictionary["priceFriday"] as Any?)
        XCTAssertNotNil(dictionary["priceSaturday"] as Any?)
        XCTAssertNotNil(dictionary["priceSunday"] as Any?)
    }
    
    func testAsDictionaryWithMinimalData() {
        let pricingItem = MockDAOPricingItemFactory.createEmpty()
        let dictionary = pricingItem.asDictionary
        
        XCTAssertEqual(dictionary["id"] as? String, pricingItem.id)
        XCTAssertEqual(dictionary["priority"] as? Int, pricingItem.priority)
        XCTAssertNil(dictionary["priceDefault"] as Any?)
        XCTAssertNil(dictionary["priceMonday"] as Any?)
        XCTAssertNil(dictionary["priceTuesday"] as Any?)
        XCTAssertNil(dictionary["priceWednesday"] as Any?)
        XCTAssertNil(dictionary["priceThursday"] as Any?)
        XCTAssertNil(dictionary["priceFriday"] as Any?)
        XCTAssertNil(dictionary["priceSaturday"] as Any?)
        XCTAssertNil(dictionary["priceSunday"] as Any?)
    }
    
    // MARK: - Copy Tests -
    
    func testCopyCreatesIndependentObject() {
        let original = MockDAOPricingItemFactory.createFull()
        let copy = original.copy() as! DAOPricingItem
        
        XCTAssertFalse(original === copy)
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.priority, copy.priority)
        
        // Modify copy and ensure original is unchanged
        copy.priority = DNSPriority.low
        XCTAssertNotEqual(original.priority, copy.priority)
    }
    
    func testCopyWithZone() {
        let original = MockDAOPricingItemFactory.createBasic()
        let copy = original.copy(with: nil) as! DAOPricingItem
        
        XCTAssertFalse(original === copy)
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.priority, copy.priority)
    }
    
    // MARK: - Difference Detection Tests -
    
    func testIsDiffFromSameObject() {
        let pricingItem = MockDAOPricingItemFactory.createBasic()
        XCTAssertFalse(pricingItem.isDiffFrom(pricingItem))
    }
    
    func testIsDiffFromIdenticalObject() {
        let original = MockDAOPricingItemFactory.createBasic()
        let copy = DAOPricingItem(from: original)
        XCTAssertFalse(original.isDiffFrom(copy))
    }
    
    func testIsDiffFromDifferentPriority() {
        let first = MockDAOPricingItemFactory.createBasic()
        let second = MockDAOPricingItemFactory.createBasic()
        second.priority = DNSPriority.high
        
        XCTAssertTrue(first.isDiffFrom(second))
    }
    
    func testIsDiffFromDifferentPriceDefault() {
        let first = MockDAOPricingItemFactory.createBasic()
        let second = MockDAOPricingItemFactory.createBasic()
        second.priceDefault = MockDAOPricingPriceFactory.createWeekend()
        
        XCTAssertTrue(first.isDiffFrom(second))
    }
    
    func testIsDiffFromDifferentDayPrices() {
        let first = MockDAOPricingItemFactory.createWeekdaysOnly()
        let second = MockDAOPricingItemFactory.createWeekendsOnly()
        
        XCTAssertTrue(first.isDiffFrom(second))
    }
    
    func testIsDiffFromNilObject() {
        let pricingItem = MockDAOPricingItemFactory.createBasic()
        XCTAssertTrue(pricingItem.isDiffFrom(nil))
    }
    
    func testIsDiffFromDifferentType() {
        let pricingItem = MockDAOPricingItemFactory.createBasic()
        let otherObject = "Not a DAOPricingItem"
        XCTAssertTrue(pricingItem.isDiffFrom(otherObject))
    }
    
    // MARK: - Equality Tests -
    
    func testEqualityOperator() {
        let first = MockDAOPricingItemFactory.createBasic()
        let second = DAOPricingItem(from: first)
        
        XCTAssertTrue(first == second)
        
        second.priority = DNSPriority.high
        XCTAssertFalse(first == second)
    }
    
    func testInequalityOperator() {
        let first = MockDAOPricingItemFactory.createBasic()
        let second = MockDAOPricingItemFactory.createFull()
        
        XCTAssertTrue(first != second)
        
        let third = DAOPricingItem(from: first)
        XCTAssertFalse(first != third)
    }
    
    // MARK: - Codable Tests -
    
    func testEncodingAndDecoding() throws {
        let original = MockDAOPricingItemFactory.createFull()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOPricingItem.self, from: data)
        
        XCTAssertEqual(original.id, decoded.id)
        XCTAssertEqual(original.priority, decoded.priority)
        XCTAssertEqual(original.priceDefault?.id, decoded.priceDefault?.id)
        XCTAssertEqual(original.priceMonday?.id, decoded.priceMonday?.id)
        XCTAssertEqual(original.priceTuesday?.id, decoded.priceTuesday?.id)
        XCTAssertEqual(original.priceWednesday?.id, decoded.priceWednesday?.id)
        XCTAssertEqual(original.priceThursday?.id, decoded.priceThursday?.id)
        XCTAssertEqual(original.priceFriday?.id, decoded.priceFriday?.id)
        XCTAssertEqual(original.priceSaturday?.id, decoded.priceSaturday?.id)
        XCTAssertEqual(original.priceSunday?.id, decoded.priceSunday?.id)
    }
    
    func testEncodingWithMinimalData() throws {
        let original = MockDAOPricingItemFactory.createEmpty()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOPricingItem.self, from: data)
        
        XCTAssertEqual(original.id, decoded.id)
        XCTAssertEqual(original.priority, decoded.priority)
        XCTAssertNil(decoded.priceDefault)
        XCTAssertNil(decoded.priceMonday)
        XCTAssertNil(decoded.priceTuesday)
        XCTAssertNil(decoded.priceWednesday)
        XCTAssertNil(decoded.priceThursday)
        XCTAssertNil(decoded.priceFriday)
        XCTAssertNil(decoded.priceSaturday)
        XCTAssertNil(decoded.priceSunday)
    }
    
    // MARK: - Factory Method Tests -
    
    func testCreatePricingItem() {
        let pricingItem = DAOPricingItem.createPricingItem()
        XCTAssertNotNil(pricingItem)
        XCTAssertEqual(pricingItem.priority, DNSPriority.normal)
    }
    
    func testCreatePricingItemFromObject() {
        let original = MockDAOPricingItemFactory.createBasic()
        let created = DAOPricingItem.createPricingItem(from: original)
        
        XCTAssertEqual(created.id, original.id)
        XCTAssertEqual(created.priority, original.priority)
        XCTAssertFalse(created === original)
    }
    
    func testCreatePricingItemFromDictionary() {
        let dictionary: DNSDataDictionary = [
            "id": "test-pricing",
            "priority": DNSPriority.high
        ]
        
        let pricingItem = DAOPricingItem.createPricingItem(from: dictionary)
        XCTAssertNotNil(pricingItem)
        XCTAssertEqual(pricingItem?.id, "test-pricing")
        XCTAssertEqual(pricingItem?.priority, DNSPriority.high)
    }
    
    func testCreatePricingItemFromEmptyDictionary() {
        let pricingItem = DAOPricingItem.createPricingItem(from: [:])
        XCTAssertNil(pricingItem)
    }
    
    func testCreatePricingPrice() {
        let pricingPrice = DAOPricingItem.createPricingPrice()
        XCTAssertNotNil(pricingPrice)
        XCTAssertTrue(pricingPrice.prices.isEmpty)
    }
    
    func testCreatePricingPriceFromObject() {
        let original = MockDAOPricingPriceFactory.createBasic()
        let created = DAOPricingItem.createPricingPrice(from: original)
        
        XCTAssertEqual(created.id, original.id)
        XCTAssertEqual(created.prices.count, original.prices.count)
        XCTAssertFalse(created === original)
    }
    
    func testCreatePricingPriceFromDictionary() {
        let dictionary: DNSDataDictionary = [
            "id": "test-price",
            "prices": [
                ["value": 15.00, "currency": "USD"]
            ]
        ]
        
        let pricingPrice = DAOPricingItem.createPricingPrice(from: dictionary)
        XCTAssertNotNil(pricingPrice)
        XCTAssertEqual(pricingPrice?.id, "test-price")
        XCTAssertEqual(pricingPrice?.prices.count, 1)
    }
    
    // MARK: - Edge Case Tests -
    
    func testPriceCalculationWithTimeRanges() {
        let pricingItem = MockDAOPricingItemFactory.createWithTimeRanges()
        
        // Test with current time (should get active price)
        let currentPrice = pricingItem.price()
        XCTAssertNotNil(currentPrice)
        XCTAssertEqual(currentPrice?.price, 12.50)
        
        // Test with past time
        let pastDate = Date().addingTimeInterval(-7200) // 2 hours ago
        let pastPrice = pricingItem.price(for: pastDate)
        XCTAssertNil(pastPrice) // Should be nil as the time range prices are expired/future
    }
    
    func testPriceCalculationWithMultiplePriorities() {
        let pricingItem = MockDAOPricingItemFactory.createWithHighPriority()
        let price = pricingItem.price()
        
        XCTAssertNotNil(price)
        // Should return the highest priority price (20.00)
        XCTAssertEqual(price?.price, 20.00)
    }

    static var allTests = [
        ("testInitialization", testInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testInitializationFromObject", testInitializationFromObject),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testInitializationFromValidDictionary", testInitializationFromValidDictionary),
        ("testPriorityValidRange", testPriorityValidRange),
        ("testPriorityClampingAboveMaximum", testPriorityClampingAboveMaximum),
        ("testPriorityClampingBelowMinimum", testPriorityClampingBelowMinimum),
        ("testPricePropertyWithDefaultOnly", testPricePropertyWithDefaultOnly),
        ("testPricePropertyWithNoPrices", testPricePropertyWithNoPrices),
        ("testPricePropertyWithNilPrices", testPricePropertyWithNilPrices),
        ("testPricePropertyWithEmptyPrices", testPricePropertyWithEmptyPrices),
        ("testPriceForMondayWithSpecificPrice", testPriceForMondayWithSpecificPrice),
        ("testPriceForTuesdayWithSpecificPrice", testPriceForTuesdayWithSpecificPrice),
        ("testPriceForWednesdayWithSpecificPrice", testPriceForWednesdayWithSpecificPrice),
        ("testPriceForThursdayWithSpecificPrice", testPriceForThursdayWithSpecificPrice),
        ("testPriceForFridayWithSpecificPrice", testPriceForFridayWithSpecificPrice),
        ("testPriceForSaturdayWithSpecificPrice", testPriceForSaturdayWithSpecificPrice),
        ("testPriceForSundayWithSpecificPrice", testPriceForSundayWithSpecificPrice),
        ("testPriceForWeekendWithoutSpecificPriceFallsBackToDefault", testPriceForWeekendWithoutSpecificPriceFallsBackToDefault),
        ("testPriceForWeekdayWithoutSpecificPriceFallsBackToDefault", testPriceForWeekdayWithoutSpecificPriceFallsBackToDefault),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testUpdateFromObjectWithNilValues", testUpdateFromObjectWithNilValues),
        ("testAsDictionaryWithFullData", testAsDictionaryWithFullData),
        ("testAsDictionaryWithMinimalData", testAsDictionaryWithMinimalData),
        ("testCopyCreatesIndependentObject", testCopyCreatesIndependentObject),
        ("testCopyWithZone", testCopyWithZone),
        ("testIsDiffFromSameObject", testIsDiffFromSameObject),
        ("testIsDiffFromIdenticalObject", testIsDiffFromIdenticalObject),
        ("testIsDiffFromDifferentPriority", testIsDiffFromDifferentPriority),
        ("testIsDiffFromDifferentPriceDefault", testIsDiffFromDifferentPriceDefault),
        ("testIsDiffFromDifferentDayPrices", testIsDiffFromDifferentDayPrices),
        ("testIsDiffFromNilObject", testIsDiffFromNilObject),
        ("testIsDiffFromDifferentType", testIsDiffFromDifferentType),
        ("testEqualityOperator", testEqualityOperator),
        ("testInequalityOperator", testInequalityOperator),
        ("testEncodingAndDecoding", testEncodingAndDecoding),
        ("testEncodingWithMinimalData", testEncodingWithMinimalData),
        ("testCreatePricingItem", testCreatePricingItem),
        ("testCreatePricingItemFromObject", testCreatePricingItemFromObject),
        ("testCreatePricingItemFromDictionary", testCreatePricingItemFromDictionary),
        ("testCreatePricingItemFromEmptyDictionary", testCreatePricingItemFromEmptyDictionary),
        ("testCreatePricingPrice", testCreatePricingPrice),
        ("testCreatePricingPriceFromObject", testCreatePricingPriceFromObject),
        ("testCreatePricingPriceFromDictionary", testCreatePricingPriceFromDictionary),
        ("testPriceCalculationWithTimeRanges", testPriceCalculationWithTimeRanges),
        ("testPriceCalculationWithMultiplePriorities", testPriceCalculationWithMultiplePriorities)
    ]
}
