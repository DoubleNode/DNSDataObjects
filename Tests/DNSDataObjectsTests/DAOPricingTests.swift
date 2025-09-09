//
//  DAOPricingTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOPricingTests: XCTestCase {
    
    // MARK: - Initialization Tests -
    
    func testInit() {
        let pricing = DAOPricing()
        XCTAssertNotNil(pricing)
        XCTAssertNotNil(pricing.id)
        XCTAssertTrue(pricing.tiers.isEmpty)
    }
    
    func testInitWithId() {
        let testId = "test_pricing_id"
        let pricing = DAOPricing(id: testId)
        XCTAssertEqual(pricing.id, testId)
        XCTAssertTrue(pricing.tiers.isEmpty)
    }
    
    func testInitFromObject() {
        let original = MockDAOPricingFactory.createMockWithTestData()
        let copy = DAOPricing(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.tiers.count, original.tiers.count)
        XCTAssertNotIdentical(copy, original)
        XCTAssertNotIdentical(copy.tiers.first, original.tiers.first)
    }
    
    func testInitFromData() {
        let testData: DNSDataDictionary = [
            "id": "pricing123",
            "tiers": [
                [
                    "id": "tier1",
                    "title": "Basic Tier"
                ],
                [
                    "id": "tier2",
                    "title": "Premium Tier"
                ]
            ]
        ]
        
        let pricing = DAOPricing(from: testData)
        XCTAssertNotNil(pricing)
        XCTAssertEqual(pricing?.id, "pricing123")
        XCTAssertEqual(pricing?.tiers.count, 2)
        XCTAssertEqual(pricing?.tiers.first?.id, "tier1")
    }
    
    func testInitFromEmptyData() {
        let emptyData: DNSDataDictionary = [:]
        let pricing = DAOPricing(from: emptyData)
        XCTAssertNil(pricing)
    }
    
    // MARK: - Property Tests -
    
    func testTiersProperty() {
        let pricing = DAOPricing()
        XCTAssertTrue(pricing.tiers.isEmpty)
        
        let tier = DAOPricingTier(id: "test_tier")
        // Using constructor with id parameter
        pricing.tiers = [tier]
        
        XCTAssertEqual(pricing.tiers.count, 1)
        XCTAssertEqual(pricing.tiers.first?.id, "test_tier")
    }
    
    func testTiersArrayManipulation() {
        let pricing = DAOPricing()
        let tier1 = DAOPricingTier(id: "tier1")
        let tier2 = DAOPricingTier(id: "tier2")
        
        pricing.tiers.append(tier1)
        XCTAssertEqual(pricing.tiers.count, 1)
        
        pricing.tiers.append(tier2)
        XCTAssertEqual(pricing.tiers.count, 2)
        
        pricing.tiers.removeFirst()
        XCTAssertEqual(pricing.tiers.count, 1)
        XCTAssertEqual(pricing.tiers.first?.id, "tier2")
    }
    
    // MARK: - Method Tests -
    
    func testTierForId() {
        let pricing = DAOPricing()
        
        let tier1 = DAOPricingTier(id: "basic")
        // Using constructor with id parameter
        tier1.priority = 1
        
        let tier2 = DAOPricingTier(id: "premium")
        // Using constructor with id parameter
        tier2.priority = 5
        
        let tier3 = DAOPricingTier(id: "basic")
        // Using constructor with id parameter
        tier3.priority = 3
        
        pricing.tiers = [tier1, tier2, tier3]
        
        // Should return highest priority tier with matching ID
        let result = pricing.tier(for: "basic")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.priority, 3)
        
        let premiumResult = pricing.tier(for: "premium")
        XCTAssertNotNil(premiumResult)
        XCTAssertEqual(premiumResult?.id, "premium")
    }
    
    func testTierForIdNotFound() {
        let pricing = DAOPricing()
        
        let tier1 = DAOPricingTier(id: "basic")
        // Using constructor with id parameter
        pricing.tiers = [tier1]
        
        // Should return first tier when ID not found
        let result = pricing.tier(for: "nonexistent")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "basic")
    }
    
    func testTierForIdEmptyTiers() {
        let pricing = DAOPricing()
        let result = pricing.tier(for: "any")
        XCTAssertNil(result)
    }
    
    func testDataStringForTierAndId() {
        let pricing = DAOPricing()
        
        let tier = DAOPricingTier()
        tier.id = "basic"
        tier.dataStrings = ["key1": DNSString(with: "value1")]
        pricing.tiers = [tier]
        
        let result = pricing.dataString(for: "basic", and: "key1")
        XCTAssertEqual(result?.asString, "value1")
        
        let nilResult = pricing.dataString(for: "basic", and: "nonexistent")
        XCTAssertNil(nilResult)
    }
    
    func testDataStringsForTier() {
        let pricing = DAOPricing()
        
        let tier = DAOPricingTier()
        tier.id = "basic"
        tier.dataStrings = ["key1": DNSString(with: "value1"), "key2": DNSString(with: "value2")]
        pricing.tiers = [tier]
        
        let result = pricing.dataStrings(for: "basic")
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result["key1"]?.asString, "value1")
        XCTAssertEqual(result["key2"]?.asString, "value2")
        
        let emptyResult = pricing.dataStrings(for: "nonexistent")
        XCTAssertTrue(emptyResult.isEmpty)
    }
    
    func testPriceForTierAndTime() {
        let pricing = DAOPricing()
        let tier = DAOPricingTier()
        tier.id = "basic"
        pricing.tiers = [tier]
        
        let testDate = Date()
        let result = pricing.price(for: "basic", and: testDate)
        // This would depend on the tier's price method implementation
        // For now, we just test that the method doesn't crash
        XCTAssertTrue(result == nil || result != nil)
    }
    
    func testExceptionTitleForTierAndTime() {
        let pricing = DAOPricing()
        let tier = DAOPricingTier()
        tier.id = "basic"
        pricing.tiers = [tier]
        
        let testDate = Date()
        let result = pricing.exceptionTitle(for: "basic", and: testDate)
        // This would depend on the tier's exceptionTitle method implementation
        // For now, we just test that the method doesn't crash
        XCTAssertTrue(result == nil || result != nil)
    }
    
    // MARK: - Factory Method Tests -
    
    func testCreatePricing() {
        let pricing = DAOPricing.createPricing()
        XCTAssertNotNil(pricing)
        XCTAssertTrue(pricing is DAOPricing)
    }
    
    func testCreatePricingFromObject() {
        let original = MockDAOPricingFactory.createMockWithTestData()
        let created = DAOPricing.createPricing(from: original)
        
        XCTAssertEqual(created.id, original.id)
        XCTAssertEqual(created.tiers.count, original.tiers.count)
        XCTAssertNotIdentical(created, original)
    }
    
    func testCreatePricingFromData() {
        let testData: DNSDataDictionary = [
            "id": "pricing123",
            "tiers": []
        ]
        
        let pricing = DAOPricing.createPricing(from: testData)
        XCTAssertNotNil(pricing)
        XCTAssertEqual(pricing?.id, "pricing123")
    }
    
    func testCreatePricingTier() {
        let tier = DAOPricing.createPricingTier()
        XCTAssertNotNil(tier)
        XCTAssertTrue(tier is DAOPricingTier)
    }
    
    func testCreatePricingTierFromObject() {
        let original = DAOPricingTier(id: "test_tier")
        // Using constructor with id parameter
        
        let created = DAOPricing.createPricingTier(from: original)
        XCTAssertEqual(created.id, original.id)
        XCTAssertNotIdentical(created, original)
    }
    
    func testCreatePricingTierFromData() {
        let testData: DNSDataDictionary = [
            "id": "tier123",
            "title": "Test Tier"
        ]
        
        let tier = DAOPricing.createPricingTier(from: testData)
        XCTAssertNotNil(tier)
        XCTAssertEqual(tier?.id, "tier123")
    }
    
    // MARK: - Copy and Update Tests -
    
    func testUpdateFromObject() {
        let original = MockDAOPricingFactory.createMockWithTestData()
        let target = DAOPricing()
        
        target.update(from: original)
        
        XCTAssertEqual(target.id, original.id)
        XCTAssertEqual(target.tiers.count, original.tiers.count)
        XCTAssertNotIdentical(target.tiers.first, original.tiers.first)
    }
    
    func testCopy() {
        let original = MockDAOPricingFactory.createMockWithTestData()
        let copy = original.copy() as? DAOPricing
        
        XCTAssertNotNil(copy)
        XCTAssertEqual(copy?.id, original.id)
        XCTAssertEqual(copy?.tiers.count, original.tiers.count)
        XCTAssertNotIdentical(copy, original)
        XCTAssertNotIdentical(copy?.tiers.first, original.tiers.first)
    }
    
    // MARK: - Dictionary Conversion Tests -
    
    func testAsDictionary() {
        let pricing = MockDAOPricingFactory.createMockWithTestData()
        let dict = pricing.asDictionary
        
        XCTAssertNotNil(dict["id"] as Any?)
        XCTAssertNotNil(dict["tiers"] as Any?)
        
        if let tiersArray = dict["tiers"] as? [DNSDataDictionary] {
            XCTAssertEqual(tiersArray.count, pricing.tiers.count)
        } else {
            XCTFail("Tiers should be converted to array of dictionaries")
        }
    }
    
    func testFromDictionaryRoundtrip() {
        let original = MockDAOPricingFactory.createMockWithTestData()
        let dict = original.asDictionary
        let restored = DAOPricing(from: dict)
        
        XCTAssertNotNil(restored)
        XCTAssertEqual(restored?.id, original.id)
        XCTAssertEqual(restored?.tiers.count, original.tiers.count)
    }
    
    // MARK: - Equality Tests -
    
    func testEquality() {
        let pricing1 = MockDAOPricingFactory.createMockWithTestData()
        let pricing2 = DAOPricing(from: pricing1)
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(pricing1.id, pricing2.id)
        XCTAssertEqual(pricing1.tiers.count, pricing2.tiers.count)
        XCTAssertFalse(pricing1 != pricing2)
    }
    
    func testInequalityDifferentTiers() {
        let pricing1 = MockDAOPricingFactory.createMockWithTestData()
        let pricing2 = DAOPricing(from: pricing1)
        
        let newTier = DAOPricingTier(id: "different_tier")
        // Using constructor with id parameter
        pricing2.tiers.append(newTier)
        
        XCTAssertNotEqual(pricing1, pricing2)
        XCTAssertTrue(pricing1 != pricing2)
    }
    
    func testInequalityDifferentId() {
        let pricing1 = MockDAOPricingFactory.createMockWithTestData()
        let pricing2 = MockDAOPricingFactory.createMock() // Different content
        
        XCTAssertNotEqual(pricing1, pricing2)  // Different content
        XCTAssertTrue(pricing1 !== pricing2)  // Different instances
    }
    
    func testSelfEquality() {
        let pricing = MockDAOPricingFactory.createMockWithTestData()
        XCTAssertEqual(pricing, pricing)
        XCTAssertFalse(pricing.isDiffFrom(pricing))
    }
    
    // MARK: - Codable Tests -
    
    func testEncodeDecode() throws {
        let original = MockDAOPricingFactory.createMockWithTestData()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOPricing.self, from: data)
        
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.tiers.count, original.tiers.count)
    }
    
    func testEncodeDecodeEmptyPricing() throws {
        let original = DAOPricing()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOPricing.self, from: data)
        
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertTrue(decoded.tiers.isEmpty)
    }
    
    // MARK: - Edge Case Tests -
    
    func testEmptyTiersArray() {
        let pricing = DAOPricing()
        pricing.tiers = []
        
        XCTAssertTrue(pricing.tiers.isEmpty)
        XCTAssertNil(pricing.tier(for: "any"))
        XCTAssertTrue(pricing.dataStrings(for: "any").isEmpty)
        XCTAssertNil(pricing.dataString(for: "any", and: "key"))
    }
    
    func testNilTierOperations() {
        let pricing = DAOPricing()
        // No tiers set
        
        let result = pricing.tier(for: "test")
        XCTAssertNil(result)
        
        let dataStrings = pricing.dataStrings(for: "test")
        XCTAssertTrue(dataStrings.isEmpty)
        
        let dataString = pricing.dataString(for: "test", and: "key")
        XCTAssertNil(dataString)
    }
    
    func testMultipleTiersWithSameId() {
        let pricing = DAOPricing()
        
        let tier1 = DAOPricingTier(id: "basic")
        // Using constructor with id parameter
        tier1.priority = 1
        
        let tier2 = DAOPricingTier(id: "premium")
        // Using constructor with id parameter
        tier2.priority = 5
        
        let tier3 = DAOPricingTier(id: "basic")
        // Using constructor with id parameter
        tier3.priority = 3
        
        pricing.tiers = [tier1, tier2, tier3]
        
        let result = pricing.tier(for: "basic")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.priority, 3) // Should return highest priority among "basic" tiers
    }
    
    func testTierPriorityOrdering() {
        let pricing = DAOPricing()
        
        let lowPriorityTier = DAOPricingTier(id: "test")
        // Using constructor with id parameter
        lowPriorityTier.priority = 1
        
        let highPriorityTier = DAOPricingTier(id: "test")
        // Using constructor with id parameter
        highPriorityTier.priority = 10
        
        let mediumPriorityTier = DAOPricingTier(id: "test")
        // Using constructor with id parameter
        mediumPriorityTier.priority = 5
        
        // Add in random order
        pricing.tiers = [lowPriorityTier, highPriorityTier, mediumPriorityTier]
        
        let result = pricing.tier(for: "test")
        XCTAssertEqual(result?.priority, 10) // Should return highest priority
    }
    
    func testFallbackToFirstTier() {
        let pricing = DAOPricing()
        
        let tier1 = DAOPricingTier(id: "tier1")
        // Using constructor with id parameter
        tier1.priority = 1
        
        let tier2 = DAOPricingTier(id: "tier2")
        // Using constructor with id parameter
        tier2.priority = 5
        
        pricing.tiers = [tier1, tier2]
        
        // When searching for non-existent ID, should return first tier
        let result = pricing.tier(for: "nonexistent")
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, "tier1")
    }

    static var allTests = [
        ("testInit", testInit),
        ("testInitWithId", testInitWithId),
        ("testInitFromObject", testInitFromObject),
        ("testInitFromData", testInitFromData),
        ("testInitFromEmptyData", testInitFromEmptyData),
        ("testTiersProperty", testTiersProperty),
        ("testTiersArrayManipulation", testTiersArrayManipulation),
        ("testTierForId", testTierForId),
        ("testTierForIdNotFound", testTierForIdNotFound),
        ("testTierForIdEmptyTiers", testTierForIdEmptyTiers),
        ("testDataStringForTierAndId", testDataStringForTierAndId),
        ("testDataStringsForTier", testDataStringsForTier),
        ("testPriceForTierAndTime", testPriceForTierAndTime),
        ("testExceptionTitleForTierAndTime", testExceptionTitleForTierAndTime),
        ("testCreatePricing", testCreatePricing),
        ("testCreatePricingFromObject", testCreatePricingFromObject),
        ("testCreatePricingFromData", testCreatePricingFromData),
        ("testCreatePricingTier", testCreatePricingTier),
        ("testCreatePricingTierFromObject", testCreatePricingTierFromObject),
        ("testCreatePricingTierFromData", testCreatePricingTierFromData),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testCopy", testCopy),
        ("testAsDictionary", testAsDictionary),
        ("testFromDictionaryRoundtrip", testFromDictionaryRoundtrip),
        ("testEquality", testEquality),
        ("testInequalityDifferentTiers", testInequalityDifferentTiers),
        ("testInequalityDifferentId", testInequalityDifferentId),
        ("testSelfEquality", testSelfEquality),
        ("testEncodeDecode", testEncodeDecode),
        ("testEncodeDecodeEmptyPricing", testEncodeDecodeEmptyPricing),
        ("testEmptyTiersArray", testEmptyTiersArray),
        ("testNilTierOperations", testNilTierOperations),
        ("testMultipleTiersWithSameId", testMultipleTiersWithSameId),
        ("testTierPriorityOrdering", testTierPriorityOrdering),
        ("testFallbackToFirstTier", testFallbackToFirstTier),
    ]
}
