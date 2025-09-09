//
//  MockDAOPricingFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOPricingFactory -
struct MockDAOPricingFactory: MockDAOFactory {
    typealias DAOType = DAOPricing
    
    static func createMock() -> DAOPricing {
        let pricing = DAOPricing()
        pricing.id = "pricing_12345"
        return pricing
    }
    
    static func createMockWithTestData() -> DAOPricing {
        let pricing = DAOPricing(id: "pricing_test_data")
        
        // Create pricing tiers
        let tier1 = DAOPricingTier()
        tier1.id = "tier_basic"
        tier1.title = "Basic Tier"
        tier1.priority = DNSPriority.normal
        
        let tier2 = DAOPricingTier()
        tier2.id = "tier_premium"
        tier2.title = "Premium Tier"
        tier2.priority = DNSPriority.high
        
        pricing.tiers = [tier1, tier2]
        
        return pricing
    }
    
    static func createMockWithEdgeCases() -> DAOPricing {
        let pricing = DAOPricing()
        
        // Edge cases
        pricing.id = "" // Empty ID
        pricing.tiers = [] // No tiers
        
        return pricing
    }
    
    static func createMockArray(count: Int) -> [DAOPricing] {
        var pricings: [DAOPricing] = []
        
        for i in 0..<count {
            let pricing = DAOPricing()
            pricing.id = "pricing\(i)" // Set explicit ID to match test expectations (changed from i + 1)
            
            // Add variety to tiers
            if i % 2 == 0 {
                let tier = DAOPricingTier()
                tier.id = "tier_\(i + 1)"
                tier.title = "Tier \(i + 1)"
                tier.priority = (i % 5) + 1 // Cycle through priorities 1-5
                pricing.tiers = [tier]
            }
            
            pricings.append(pricing)
        }
        
        return pricings
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOPricing {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOPricing {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOPricing {
        let pricing = createMockWithTestData()
        pricing.id = id
        return pricing
    }
}