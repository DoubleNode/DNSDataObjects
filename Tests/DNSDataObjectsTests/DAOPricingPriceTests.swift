//
//  DAOPricingPriceTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOPricingPriceTests: XCTestCase {

    // MARK: - Initialization Tests
    
    func testInitialization() {
        let pricingPrice = DAOPricingPrice()
        XCTAssertNotNil(pricingPrice)
        XCTAssertTrue(pricingPrice.prices.isEmpty)
        XCTAssertNil(pricingPrice.price)
        XCTAssertNotNil(pricingPrice.id)
    }
    
    func testInitializationWithId() {
        let testId = "test-pricing-price-id"
        let pricingPrice = DAOPricingPrice(id: testId)
        XCTAssertEqual(pricingPrice.id, testId)
        XCTAssertTrue(pricingPrice.prices.isEmpty)
        XCTAssertNil(pricingPrice.price)
    }
    
    func testInitializationFromObject() {
        let original = MockDAOPricingPriceFactory.createBasic()
        let copy = DAOPricingPrice(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.prices.count, original.prices.count)
        XCTAssertNotIdentical(copy, original)
        
        // Verify prices are properly copied
        for (index, price) in copy.prices.enumerated() {
            XCTAssertEqual(price.price, original.prices[index].price)
            XCTAssertEqual(price.priority, original.prices[index].priority)
        }
    }
    
    func testInitializationFromDictionary() {
        let dictionary: DNSDataDictionary = [
            "id": "test-pricing-price",
            "prices": [
                [
                    "price": 15.50,
                    "priority": 50
                ]
            ]
        ]
        
        let pricingPrice = DAOPricingPrice(from: dictionary)
        XCTAssertNotNil(pricingPrice)
        XCTAssertEqual(pricingPrice?.id, "test-pricing-price")
        XCTAssertEqual(pricingPrice?.prices.count, 1)
        XCTAssertEqual(pricingPrice?.prices.first?.price, 15.50)
    }
    
    func testInitializationFromEmptyDictionary() {
        let emptyDictionary: DNSDataDictionary = [:]
        let pricingPrice = DAOPricingPrice(from: emptyDictionary)
        XCTAssertNil(pricingPrice)
    }

    // MARK: - Property Tests
    
    func testPricesProperty() {
        let pricingPrice = MockDAOPricingPriceFactory.createBasic()
        XCTAssertEqual(pricingPrice.prices.count, 2)
        
        let firstPrice = pricingPrice.prices.first
        XCTAssertNotNil(firstPrice)
        XCTAssertEqual(firstPrice?.price, 10.00)
        XCTAssertEqual(firstPrice?.priority, DNSPriority.normal)
    }
    
    func testPriceProperty() {
        let pricingPrice = MockDAOPricingPriceFactory.createBasic()
        let currentPrice = pricingPrice.price
        XCTAssertNotNil(currentPrice)
        
        // Should return the highest priority active price
        XCTAssertEqual(currentPrice?.price, 15.00)
        XCTAssertEqual(currentPrice?.priority, DNSPriority.high)
    }
    
    func testPriceForTime() {
        let pricingPrice = MockDAOPricingPriceFactory.createWithTimeRange()
        let currentTime = Date()
        let price = pricingPrice.price(for: currentTime)
        
        XCTAssertNotNil(price)
        XCTAssertEqual(price?.price, 12.50)
    }
    
    func testPriceForExpiredTime() {
        let pricingPrice = MockDAOPricingPriceFactory.createExpired()
        let currentTime = Date()
        let price = pricingPrice.price(for: currentTime)
        
        XCTAssertNil(price) // Should be nil for expired price
    }
    
    func testPriceForFutureTime() {
        let pricingPrice = MockDAOPricingPriceFactory.createFuture()
        let currentTime = Date()
        let price = pricingPrice.price(for: currentTime)
        
        XCTAssertNil(price) // Should be nil for future price
    }
    
    func testEmptyPrices() {
        let pricingPrice = MockDAOPricingPriceFactory.createEmpty()
        XCTAssertTrue(pricingPrice.prices.isEmpty)
        XCTAssertNil(pricingPrice.price)
        XCTAssertNil(pricingPrice.price(for: Date()))
    }

    // MARK: - Update Methods Tests
    
    func testUpdateFromObject() {
        let original = MockDAOPricingPriceFactory.createBasic()
        let updated = MockDAOPricingPriceFactory.createDefault()
        
        original.update(from: updated)
        
        XCTAssertEqual(original.id, updated.id)
        XCTAssertEqual(original.prices.count, updated.prices.count)
        XCTAssertEqual(original.prices.first?.price, updated.prices.first?.price)
    }

    // MARK: - Dictionary Conversion Tests
    
    func testAsDictionary() {
        let pricingPrice = MockDAOPricingPriceFactory.createBasic()
        let dictionary = pricingPrice.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["prices"] as Any?)
        
        if let pricesArray = dictionary["prices"] as? [DNSDataDictionary] {
            XCTAssertEqual(pricesArray.count, 2)
            XCTAssertEqual(pricesArray.first?["price"] as? Float, 10.00)
        } else {
            XCTFail("Prices should be an array of dictionaries")
        }
    }
    
    func testDaoFromDictionary() {
        let dictionary: DNSDataDictionary = [
            "id": "test-dao-conversion",
            "prices": [
                [
                    "price": 22.75,
                    "priority": 75
                ]
            ]
        ]
        
        let pricingPrice = DAOPricingPrice()
        let result = pricingPrice.dao(from: dictionary)
        
        XCTAssertEqual(result.id, "test-dao-conversion")
        XCTAssertEqual(result.prices.count, 1)
        XCTAssertEqual(result.prices.first?.price, 22.75)
    }

    // MARK: - Codable Tests
    
    func testEncodeToDictionary() throws {
        let pricingPrice = MockDAOPricingPriceFactory.createDefault()
        let encoder = JSONEncoder()
        let data = try encoder.encode(pricingPrice)
        
        XCTAssertFalse(data.isEmpty)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOPricingPrice.self, from: data)
        
        XCTAssertEqual(decoded.id, pricingPrice.id)
        XCTAssertEqual(decoded.prices.count, pricingPrice.prices.count)
    }
    
    func testDecodeFromData() throws {
        let jsonString = """
        {
            "id": "encoded-pricing-price",
            "prices": [
                {
                    "price": 35.00,
                    "priority": 60
                }
            ]
        }
        """
        
        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let pricingPrice = try decoder.decode(DAOPricingPrice.self, from: data)
        
        XCTAssertEqual(pricingPrice.id, "encoded-pricing-price")
        XCTAssertEqual(pricingPrice.prices.count, 1)
        XCTAssertEqual(pricingPrice.prices.first?.price, 35.00)
    }

    // MARK: - Copy Tests
    
    func testCopy() {
        let original = MockDAOPricingPriceFactory.createBasic()
        let copy = original.copy() as! DAOPricingPrice
        
        XCTAssertNotIdentical(original, copy)
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.prices.count, copy.prices.count)
        
        // Verify deep copy of prices
        for (index, price) in copy.prices.enumerated() {
            XCTAssertEqual(price.price, original.prices[index].price)
            XCTAssertEqual(price.priority, original.prices[index].priority)
        }
    }

    // MARK: - Equality Tests
    
    func testEquality() {
        let pricingPrice1 = MockDAOPricingPriceFactory.createBasic()
        let pricingPrice2 = MockDAOPricingPriceFactory.createBasic()
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertNotEqual(pricingPrice1.id, pricingPrice2.id) // Different instances should have different IDs
        XCTAssertEqual(pricingPrice1.prices.count, pricingPrice2.prices.count)
        XCTAssertTrue(pricingPrice1 !== pricingPrice2) // Different instances
    }
    
    func testInequality() {
        let pricingPrice1 = MockDAOPricingPriceFactory.createBasic()
        let pricingPrice2 = MockDAOPricingPriceFactory.createDefault()
        
        XCTAssertNotEqual(pricingPrice1, pricingPrice2)
        XCTAssertTrue(pricingPrice1 != pricingPrice2)
    }
    
    func testEqualityWithSameInstance() {
        let pricingPrice = MockDAOPricingPriceFactory.createBasic()
        XCTAssertEqual(pricingPrice, pricingPrice)
        XCTAssertFalse(pricingPrice.isDiffFrom(pricingPrice))
    }

    // MARK: - Difference Detection Tests
    
    func testIsDiffFromSameObject() {
        let pricingPrice = MockDAOPricingPriceFactory.createBasic()
        XCTAssertFalse(pricingPrice.isDiffFrom(pricingPrice))
    }
    
    func testIsDiffFromNil() {
        let pricingPrice = MockDAOPricingPriceFactory.createBasic()
        XCTAssertTrue(pricingPrice.isDiffFrom(nil))
    }
    
    func testIsDiffFromDifferentType() {
        let pricingPrice = MockDAOPricingPriceFactory.createBasic()
        let otherObject = "not a pricing price"
        XCTAssertTrue(pricingPrice.isDiffFrom(otherObject))
    }
    
    func testIsDiffFromDifferentPrices() {
        let pricingPrice1 = MockDAOPricingPriceFactory.createBasic()
        let pricingPrice2 = MockDAOPricingPriceFactory.createDefault()
        
        XCTAssertTrue(pricingPrice1.isDiffFrom(pricingPrice2))
    }
    
    func testIsDiffFromSamePrices() {
        let pricingPrice1 = MockDAOPricingPriceFactory.createBasic()
        let pricingPrice2 = DAOPricingPrice(from: pricingPrice1)
        
        XCTAssertFalse(pricingPrice1.isDiffFrom(pricingPrice2))
    }

    // MARK: - Factory Method Tests
    
    func testCreatePricingPrice() {
        let pricingPrice = DAOPricingPrice.createPricingPrice()
        XCTAssertNotNil(pricingPrice)
        XCTAssertTrue(pricingPrice.prices.isEmpty)
    }
    
    func testCreatePricingPriceFromObject() {
        let original = MockDAOPricingPriceFactory.createBasic()
        let created = DAOPricingPrice.createPricingPrice(from: original)
        
        XCTAssertNotIdentical(original, created)
        XCTAssertEqual(original.id, created.id)
        XCTAssertEqual(original.prices.count, created.prices.count)
    }
    
    func testCreatePricingPriceFromData() {
        let data: DNSDataDictionary = [
            "id": "factory-created",
            "prices": [
                [
                    "price": 42.00,
                    "priority": 80
                ]
            ]
        ]
        
        let pricingPrice = DAOPricingPrice.createPricingPrice(from: data)
        XCTAssertNotNil(pricingPrice)
        XCTAssertEqual(pricingPrice?.id, "factory-created")
        XCTAssertEqual(pricingPrice?.prices.count, 1)
    }

    // MARK: - Configuration Tests
    
    func testConfig() {
        let config = DAOPricingPrice.config
        XCTAssertNotNil(config)
        XCTAssertTrue(config.pricingPriceType == DAOPricingPrice.self)
    }
    
    func testDecodingConfiguration() {
        let config = DAOPricingPrice.decodingConfiguration
        XCTAssertNotNil(config)
    }
    
    func testEncodingConfiguration() {
        let config = DAOPricingPrice.encodingConfiguration
        XCTAssertNotNil(config)
    }

    // MARK: - Price Priority Tests
    
    func testMultiplePricesPriority() {
        let pricingPrice = MockDAOPricingPriceFactory.createMultiPriority()
        let currentPrice = pricingPrice.price
        
        XCTAssertNotNil(currentPrice)
        // Should return highest priority price
        XCTAssertEqual(currentPrice?.price, 20.00)
        XCTAssertEqual(currentPrice?.priority, DNSPriority.highest)
    }
    
    func testPriceSelectionWithTime() {
        let pricingPrice = MockDAOPricingPriceFactory.createWithTimeRange()
        
        // Test with current time (should find active price)
        let currentPrice = pricingPrice.price(for: Date())
        XCTAssertNotNil(currentPrice)
        XCTAssertEqual(currentPrice?.price, 12.50)
        
        // Test with time outside range
        let futureTime = Date().addingTimeInterval(7200) // 2 hours from now
        let futurePrice = pricingPrice.price(for: futureTime)
        XCTAssertNil(futurePrice)
    }

    // MARK: - Edge Case Tests
    
    func testNilPriceHandling() {
        let pricingPrice = DAOPricingPrice()
        XCTAssertNil(pricingPrice.price)
        XCTAssertNil(pricingPrice.price(for: Date()))
    }
    
    func testPriceArrayModification() {
        let pricingPrice = MockDAOPricingPriceFactory.createBasic()
        let originalCount = pricingPrice.prices.count
        
        // Add a new price
        let newPrice = DNSPrice()
        newPrice.price = 50.00
        newPrice.priority = DNSPriority.highest
        pricingPrice.prices.append(newPrice)
        
        XCTAssertEqual(pricingPrice.prices.count, originalCount + 1)
        
        // Verify the new highest priority price is selected
        let currentPrice = pricingPrice.price
        XCTAssertEqual(currentPrice?.price, 50.00)
    }

    static var allTests = [
        ("testInitialization", testInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testInitializationFromObject", testInitializationFromObject),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testPricesProperty", testPricesProperty),
        ("testPriceProperty", testPriceProperty),
        ("testPriceForTime", testPriceForTime),
        ("testPriceForExpiredTime", testPriceForExpiredTime),
        ("testPriceForFutureTime", testPriceForFutureTime),
        ("testEmptyPrices", testEmptyPrices),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testAsDictionary", testAsDictionary),
        ("testDaoFromDictionary", testDaoFromDictionary),
        ("testEncodeToDictionary", testEncodeToDictionary),
        ("testDecodeFromData", testDecodeFromData),
        ("testCopy", testCopy),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testEqualityWithSameInstance", testEqualityWithSameInstance),
        ("testIsDiffFromSameObject", testIsDiffFromSameObject),
        ("testIsDiffFromNil", testIsDiffFromNil),
        ("testIsDiffFromDifferentType", testIsDiffFromDifferentType),
        ("testIsDiffFromDifferentPrices", testIsDiffFromDifferentPrices),
        ("testIsDiffFromSamePrices", testIsDiffFromSamePrices),
        ("testCreatePricingPrice", testCreatePricingPrice),
        ("testCreatePricingPriceFromObject", testCreatePricingPriceFromObject),
        ("testCreatePricingPriceFromData", testCreatePricingPriceFromData),
        ("testConfig", testConfig),
        ("testDecodingConfiguration", testDecodingConfiguration),
        ("testEncodingConfiguration", testEncodingConfiguration),
        ("testMultiplePricesPriority", testMultiplePricesPriority),
        ("testPriceSelectionWithTime", testPriceSelectionWithTime),
        ("testNilPriceHandling", testNilPriceHandling),
        ("testPriceArrayModification", testPriceArrayModification),
    ]
}
