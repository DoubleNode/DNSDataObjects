//
//  MockDAOPricingOverrideFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOPricingOverrideFactory -
struct MockDAOPricingOverrideFactory: MockDAOFactory {
    typealias DAOType = DAOPricingOverride
    
    static func createMock() -> DAOPricingOverride {
        let override = DAOPricingOverride()
        override.title = DNSString(with: "Mock Override")
        override.enabled = true
        override.priority = DNSPriority.high
        override.startTime = Date()
        override.endTime = Date().addingTimeInterval(3600) // 1 hour later
        return override
    }
    
    static func createMockWithTestData() -> DAOPricingOverride {
        let override = DAOPricingOverride(id: "override_test_data")
        override.title = DNSString(with: "Test Override")
        override.enabled = true
        override.priority = DNSPriority.highest
        override.startTime = Date().addingTimeInterval(-1800) // 30 minutes ago
        override.endTime = Date().addingTimeInterval(1800) // 30 minutes from now
        
        // Add pricing items
        let item1 = DAOPricingItem()
        let item2 = DAOPricingItem()
        override.items = [item1, item2]
        
        return override
    }
    
    static func createMockWithEdgeCases() -> DAOPricingOverride {
        let override = DAOPricingOverride()
        override.title = DNSString() // Empty title
        override.enabled = false // Disabled
        override.priority = DNSPriority.none
        override.items = [] // No items
        return override
    }
    
    static func createMockArray(count: Int) -> [DAOPricingOverride] {
        var overrides: [DAOPricingOverride] = []
        
        for i in 0..<count {
            let override = DAOPricingOverride()
            override.id = "pricing_override\(i)" // Set explicit ID to match test expectations
            override.title = DNSString(with: "Override \(i + 1)")
            override.enabled = (i % 2 == 0) // Alternate enabled/disabled
            override.priority = DNSPriority.normal + i
            override.startTime = Date().addingTimeInterval(TimeInterval(i * 3600)) // Staggered hours
            override.endTime = Date().addingTimeInterval(TimeInterval((i + 1) * 3600))
            overrides.append(override)
        }
        
        return overrides
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOPricingOverride {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOPricingOverride {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOPricingOverride {
        let override = createMockWithTestData()
        override.id = id
        return override
    }
}