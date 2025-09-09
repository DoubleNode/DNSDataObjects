//
//  MockDAOPricingSeasonFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOPricingSeasonFactory -
struct MockDAOPricingSeasonFactory: MockDAOFactory {
    typealias DAOType = DAOPricingSeason
    
    static func createMock() -> DAOPricingSeason {
        let season = DAOPricingSeason()
        season.priority = DNSPriority.normal
        season.startTime = Date()
        season.endTime = Date().addingTimeInterval(86400 * 90) // 90 days later
        return season
    }
    
    static func createMockWithTestData() -> DAOPricingSeason {
        let season = DAOPricingSeason(id: "season_test_data")
        season.priority = DNSPriority.high
        season.startTime = Date().addingTimeInterval(-86400 * 30) // 30 days ago
        season.endTime = Date().addingTimeInterval(86400 * 60) // 60 days from now
        
        // Add pricing items with different priorities
        let item1 = DAOPricingItem()
        item1.priority = DNSPriority.high
        let priceDefault1 = DAOPricingPrice()
        let price1 = DNSPrice()
        price1.price = 100.0
        price1.priority = DNSPriority.normal
        priceDefault1.prices = [price1]
        item1.priceDefault = priceDefault1
        
        let item2 = DAOPricingItem()
        item2.priority = DNSPriority.normal
        let priceDefault2 = DAOPricingPrice()
        let price2 = DNSPrice()
        price2.price = 80.0
        price2.priority = DNSPriority.normal
        priceDefault2.prices = [price2]
        item2.priceDefault = priceDefault2
        
        season.items = [item1, item2]
        
        return season
    }
    
    static func createMockWithEdgeCases() -> DAOPricingSeason {
        let season = DAOPricingSeason()
        season.priority = DNSPriority.none
        season.items = [] // No items
        // Note: DAOPricingSeason doesn't have title property
        return season
    }
    
    static func createMockArray(count: Int) -> [DAOPricingSeason] {
        var seasons: [DAOPricingSeason] = []
        
        for i in 0..<count {
            let season = DAOPricingSeason()
            season.id = "pricing_season\(i)" // Set explicit ID to match test expectations
            season.priority = min(DNSPriority.normal + i, DNSPriority.highest)
            season.startTime = Date().addingTimeInterval(TimeInterval(i * 86400 * 90)) // 90-day seasons
            season.endTime = Date().addingTimeInterval(TimeInterval((i + 1) * 86400 * 90))
            
            // Add a pricing item to each season
            let item = DAOPricingItem()
            item.priority = min(DNSPriority.normal + i, DNSPriority.highest)
            let priceDefault = DAOPricingPrice()
            let price = DNSPrice()
            price.price = Float(50 + i * 10)
            price.priority = DNSPriority.normal
            priceDefault.prices = [price]
            item.priceDefault = priceDefault
            season.items = [item]
            
            seasons.append(season)
        }
        
        return seasons
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOPricingSeason {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOPricingSeason {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOPricingSeason {
        let season = DAOPricingSeason(id: id)
        season.priority = DNSPriority.high
        season.startTime = Date().addingTimeInterval(-86400 * 30) // 30 days ago
        season.endTime = Date().addingTimeInterval(86400 * 60) // 60 days from now
        
        // Add pricing items with different priorities
        let item1 = DAOPricingItem()
        item1.priority = DNSPriority.high
        let priceDefault1 = DAOPricingPrice()
        let price1 = DNSPrice()
        price1.price = 100.0
        price1.priority = DNSPriority.normal
        priceDefault1.prices = [price1]
        item1.priceDefault = priceDefault1
        
        let item2 = DAOPricingItem()
        item2.priority = DNSPriority.normal
        let priceDefault2 = DAOPricingPrice()
        let price2 = DNSPrice()
        price2.price = 80.0
        price2.priority = DNSPriority.normal
        priceDefault2.prices = [price2]
        item2.priceDefault = priceDefault2
        
        season.items = [item1, item2]
        
        return season
    }
}