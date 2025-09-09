//
//  MockDAOActivityTypeFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOActivityTypeFactory -
struct MockDAOActivityTypeFactory: MockDAOFactory {
    typealias DAOType = DAOActivityType
    
    static func createMock() -> DAOActivityType {
        let activityType = DAOActivityType()
        // Basic valid object with minimal data
        activityType.code = "TEST_TYPE"
        activityType.name = DNSString(with: "Test Activity Type")
        return activityType
    }
    
    static func createMockWithTestData() -> DAOActivityType {
        let activityType = DAOActivityType()
        
        // Realistic test data
        activityType.code = "SPORTS_RECREATION"
        activityType.name = DNSString(with: "Sports & Recreation")
        
        // Create test pricing
        let pricing = DAOPricing()
        pricing.id = "sports_pricing_123"
        activityType.pricing = pricing
        
        return activityType
    }
    
    static func createMockWithEdgeCases() -> DAOActivityType {
        let activityType = DAOActivityType()
        
        // Edge cases and boundary values
        activityType.code = "" // Empty code
        activityType.name = DNSString() // Empty name
        
        // Default pricing object (edge case)
        activityType.pricing = DAOPricing()
        
        return activityType
    }
    
    static func createMockArray(count: Int) -> [DAOActivityType] {
        var activityTypes: [DAOActivityType] = []
        
        let typeNames = ["Sports", "Arts", "Education", "Entertainment", "Recreation", "Wellness"]
        
        for i in 0..<count {
            let activityType = DAOActivityType()
            activityType.id = "activity_type\(i)" // Set explicit ID to match test expectations
            let typeName = typeNames[i % typeNames.count]
            
            activityType.code = "\(typeName.uppercased())_\(i + 1)"
            activityType.name = DNSString(with: "\(typeName) \(i + 1)")
            
            // Add variety with pricing
            if i % 2 == 0 {
                let pricing = DAOPricing()
                pricing.id = "pricing_\(i)"
                activityType.pricing = pricing
            }
            
            activityTypes.append(activityType)
        }
        
        return activityTypes
    }
}