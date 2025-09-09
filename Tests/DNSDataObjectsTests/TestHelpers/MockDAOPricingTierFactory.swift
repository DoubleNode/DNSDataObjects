//
//  MockDAOPricingTierFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

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
            tier.id = "pricing_tier\(i)" // Set explicit ID to match test expectations
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