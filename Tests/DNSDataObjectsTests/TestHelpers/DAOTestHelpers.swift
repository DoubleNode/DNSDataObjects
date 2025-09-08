//
//  DAOTestHelpers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSDataObjects

// MARK: - MockDAOFactory Protocol -
protocol MockDAOFactory {
    associatedtype DAOType: DAOBaseObject
    
    static func createMock() -> DAOType
    static func createMockWithTestData() -> DAOType
    static func createMockWithEdgeCases() -> DAOType
    static func createMockArray(count: Int) -> [DAOType]
}

// MARK: - Test Helper Utilities -
struct DAOTestHelpers {
    
    // MARK: - Mock Creation Methods -
    
    static func createMockDNSMetadata(status: String = "active") -> DNSMetadata {
        let metadata = DNSMetadata()
        metadata.status = status
        metadata.createdBy = "TestUser"
        metadata.updatedBy = "TestUser"
        metadata.views = 42
        return metadata
    }
    
    static func createMockAnalyticsData(title: String = "Test Analytics",
                                       subtitle: String = "Test Subtitle") -> DAOAnalyticsData {
        let analytics = DAOAnalyticsData()
        analytics.title = title
        analytics.subtitle = subtitle
        return analytics
    }
    
    // MARK: - Validation Helper Methods -
    
    static func validateCodableRoundtrip<T: Codable>(_ object: T) throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let jsonData = try encoder.encode(object)
        let decodedObject = try decoder.decode(T.self, from: jsonData)
        
        // Note: We can't directly compare objects here without Equatable conformance
        // Individual tests should validate specific properties after round-trip
        XCTAssertNotNil(decodedObject, "Object should decode successfully")
    }
    
    static func validateDictionaryRoundtrip<T: DAOBaseObject>(_ object: T) {
        let dictionary = object.asDictionary
        XCTAssertNotNil(dictionary, "Object should convert to dictionary")
        XCTAssertFalse(dictionary.isEmpty, "Dictionary should not be empty")
        
        // Verify the dictionary contains expected base fields
        XCTAssertNotNil(dictionary["id"] as Any?, "Dictionary should contain id field")
        XCTAssertNotNil(dictionary["meta"] as Any?, "Dictionary should contain meta field")
    }
    
    static func validateNoMemoryLeaks<T>(_ createObject: () -> T) {
        weak var weakRef: AnyObject?
        
        autoreleasepool {
            let object = createObject() as AnyObject
            weakRef = object
            XCTAssertNotNil(weakRef, "Object should exist")
        }
        
        // Give some time for cleanup
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(weakRef, "Object should be deallocated after autoreleasepool")
        }
    }
    
    // MARK: - Mock Dictionary Creation -
    
    static func createMockBaseObjectDictionary(id: String? = nil) -> DNSDataDictionary {
        let testId = id ?? UUID().uuidString
        return [
            "id": testId,
            "meta": createMockMetadataDictionary(),
            "analyticsData": []
        ]
    }
    
    static func createMockMetadataDictionary() -> DNSDataDictionary {
        return [
            "uid": UUID().uuidString,
            "status": "active",
            "created": Date(),
            "updated": Date(),
            "createdBy": "TestUser",
            "updatedBy": "TestUser",
            "views": 42,
            "genericValues": [:],
            "reactions": [:],
            "reactionCounts": [:]
        ]
    }
    
    // MARK: - Performance Testing Helpers -
    
    static func measureObjectCreationPerformance<T>(_ createObject: () -> T, 
                                                   iterations: Int = 1000) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = createObject()
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return timeElapsed
    }
    
    static func measureCopyingPerformance<T: NSCopying>(_ object: T, 
                                                       iterations: Int = 1000) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = object.copy()
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return timeElapsed
    }
}

// MARK: - XCTestCase Extensions -
extension XCTestCase {
    
    func validateDAOBaseFunctionality<T: DAOBaseObject>(_ object: T) {
        // Test basic properties
        XCTAssertFalse(object.id.isEmpty, "DAO should have non-empty ID")
        XCTAssertNotNil(object.meta, "DAO should have metadata")
        XCTAssertNotNil(object.analyticsData, "DAO should have analytics data array")
        
        // Test NSCopying
        let copy = object.copy() as? T
        XCTAssertNotNil(copy, "DAO should be copyable")
        XCTAssertEqual(object.id, copy?.id, "Copy should have same ID")
        XCTAssertFalse(object === copy, "Copy should be different object instance")
        
        // Test dictionary conversion
        DAOTestHelpers.validateDictionaryRoundtrip(object)
    }
    
    func validateCodableFunctionality<T: Codable>(_ object: T) {
        do {
            try DAOTestHelpers.validateCodableRoundtrip(object)
        } catch {
            XCTFail("Codable round-trip failed: \(error)")
        }
    }
}

// MARK: - MockDAOAccountFactory -
struct MockDAOAccountFactory: MockDAOFactory {
    typealias DAOType = DAOAccount
    
    static func createMock() -> DAOAccount {
        let account = DAOAccount()
        // Basic valid object with minimal data
        account.name = PersonNameComponents.dnsBuildName(with: "Test User") ?? PersonNameComponents()
        account.emailNotifications = false
        account.pushNotifications = false
        return account
    }
    
    static func createMockWithTestData() -> DAOAccount {
        let account = DAOAccount()
        
        // Realistic test data
        account.name = PersonNameComponents.dnsBuildName(with: "John Michael Smith") ?? PersonNameComponents()
        account.dob = Calendar.current.date(from: DateComponents(year: 1985, month: 6, day: 15))
        account.emailNotifications = true
        account.pushNotifications = true
        account.pricingTierId = "tier_premium_123"
        
        // Create test avatar
        let avatar = DAOMedia()
        avatar.id = "avatar_media_id"
        account.avatar = avatar
        
        // Create test cards
        let card1 = DAOCard()
        card1.id = "card_1"
        let card2 = DAOCard()
        card2.id = "card_2"
        account.cards = [card1, card2]
        
        // Create test users
        let user1 = DAOUser()
        user1.id = "user_1"
        let user2 = DAOUser()
        user2.id = "user_2"
        account.users = [user1, user2]
        
        return account
    }
    
    static func createMockWithEdgeCases() -> DAOAccount {
        let account = DAOAccount()
        
        // Edge cases and boundary values
        account.name = PersonNameComponents() // Empty name
        account.dob = Date.distantPast // Very old date
        account.emailNotifications = true
        account.pushNotifications = false
        account.pricingTierId = "" // Empty pricing tier ID
        
        // nil avatar (edge case)
        account.avatar = nil
        
        // Empty collections (edge cases)
        account.cards = []
        account.users = []
        
        return account
    }
    
    static func createMockArray(count: Int) -> [DAOAccount] {
        var accounts: [DAOAccount] = []
        
        for i in 0..<count {
            let account = DAOAccount()
            account.name = PersonNameComponents.dnsBuildName(with: "User \(i + 1)") ?? PersonNameComponents()
            account.emailNotifications = (i % 2 == 0) // Alternate true/false
            account.pushNotifications = (i % 3 == 0) // Every third one
            account.pricingTierId = "tier_\(i)"
            
            if i % 4 == 0 { // Every fourth account gets an avatar
                let avatar = DAOMedia()
                avatar.id = "avatar_\(i)"
                account.avatar = avatar
            }
            
            accounts.append(account)
        }
        
        return accounts
    }
}

// MARK: - MockDAOPricingTierFactory -
struct MockDAOPricingTierFactory: MockDAOFactory {
    typealias DAOType = DAOPricingTier
    
    static func createMock() -> DAOPricingTier {
        let tier = DAOPricingTier()
        tier.title = "Basic Tier"
        tier.priority = DNSPriority.normal
        return tier
    }
    
    static func createMockWithTestData() -> DAOPricingTier {
        let tier = DAOPricingTier(title: "Premium Tier")
        tier.priority = DNSPriority.high
        
        // Create test data strings
        tier.dataStrings = [
            "description": DNSString.init(with: "Premium tier with advanced features"),
            "benefits": DNSString.init(with: "Unlimited access, priority support"),
            "subtitle": DNSString.init(with: "Best value plan")
        ]
        
        // Create test overrides
        let override1 = DAOPricingOverride()
        override1.id = "holiday_override"
        override1.priority = DNSPriority.highest
        let override2 = DAOPricingOverride()
        override2.id = "weekend_override" 
        override2.priority = DNSPriority.high
        tier.overrides = [override1, override2]
        
        // Create test seasons
        let season1 = DAOPricingSeason()
        season1.id = "summer_season"
        season1.priority = DNSPriority.normal
        let season2 = DAOPricingSeason()
        season2.id = "winter_season"
        season2.priority = DNSPriority.low
        tier.seasons = [season1, season2]
        
        return tier
    }
    
    static func createMockWithEdgeCases() -> DAOPricingTier {
        let tier = DAOPricingTier()
        
        // Edge cases
        tier.title = "" // Empty title
        tier.priority = DNSPriority.highest // Maximum priority
        tier.dataStrings = [:] // Empty data strings
        tier.overrides = [] // No overrides
        tier.seasons = [] // No seasons
        
        return tier
    }
    
    static func createMockWithMinimumPriority() -> DAOPricingTier {
        let tier = DAOPricingTier()
        tier.title = "Minimum Priority Tier"
        tier.priority = DNSPriority.none // Minimum priority
        return tier
    }
    
    static func createMockWithBusinessLogic() -> DAOPricingTier {
        let tier = DAOPricingTier(title: "Business Logic Test Tier")
        tier.priority = DNSPriority.normal
        
        // Create overrides with different active states and priorities for business logic testing
        let activeHighOverride = DAOPricingOverride()
        activeHighOverride.id = "active_high"
        activeHighOverride.priority = DNSPriority.highest
        // Note: Need to set isActive property - assuming it exists on DAOPricingOverride
        
        let inactiveHighOverride = DAOPricingOverride()
        inactiveHighOverride.id = "inactive_high"
        inactiveHighOverride.priority = DNSPriority.highest
        
        let activeLowOverride = DAOPricingOverride()
        activeLowOverride.id = "active_low"
        activeLowOverride.priority = DNSPriority.low
        
        tier.overrides = [inactiveHighOverride, activeHighOverride, activeLowOverride]
        
        // Create seasons with different priorities for business logic testing
        let highSeason = DAOPricingSeason()
        highSeason.id = "high_season"
        highSeason.priority = DNSPriority.high
        
        let lowSeason = DAOPricingSeason()
        lowSeason.id = "low_season"
        lowSeason.priority = DNSPriority.low
        
        tier.seasons = [lowSeason, highSeason] // Intentionally out of priority order
        
        return tier
    }
    
    static func createMockArray(count: Int) -> [DAOPricingTier] {
        var tiers: [DAOPricingTier] = []
        
        for i in 0..<count {
            let tier = DAOPricingTier()
            tier.title = "Tier \(i + 1)"
            tier.priority = (i % 5) + 1 // Cycle through priorities 1-5
            
            // Add some data strings for variety
            if i % 2 == 0 {
                tier.dataStrings["description"] = DNSString.init(with: "Description for tier \(i + 1)")
            }
            
            // Add overrides for some tiers
            if i % 3 == 0 {
                let override = DAOPricingOverride()
                override.id = "override_\(i)"
                override.priority = DNSPriority.normal
                tier.overrides = [override]
            }
            
            // Add seasons for some tiers  
            if i % 4 == 0 {
                let season = DAOPricingSeason()
                season.id = "season_\(i)"
                season.priority = DNSPriority.normal
                tier.seasons = [season]
            }
            
            tiers.append(tier)
        }
        
        return tiers
    }
}
