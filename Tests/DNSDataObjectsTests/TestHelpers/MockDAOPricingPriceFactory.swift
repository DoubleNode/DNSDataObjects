//
//  MockDAOPricingPriceFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation
@testable import DNSDataObjects

class MockDAOPricingPriceFactory {
    static func createBasic() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        
        let price1 = DNSPrice()
        price1.price = 10.00
        price1.priority = DNSPriority.normal
        
        let price2 = DNSPrice()
        price2.price = 15.00
        price2.priority = DNSPriority.high
        
        pricingPrice.prices = [price1, price2]
        return pricingPrice
    }
    
    static func createDefault() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        let price = DNSPrice()
        price.price = 25.00
        price.priority = DNSPriority.normal
        
        pricingPrice.prices = [price]
        return pricingPrice
    }
    
    static func createWeekday() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        let price = DNSPrice()
        price.price = 20.00
        price.priority = DNSPriority.normal
        
        pricingPrice.prices = [price]
        return pricingPrice
    }
    
    static func createWeekend() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        let price = DNSPrice()
        price.price = 30.00
        price.priority = DNSPriority.normal
        
        pricingPrice.prices = [price]
        return pricingPrice
    }
    
    static func createEmpty() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        pricingPrice.prices = []
        return pricingPrice
    }
    
    static func createMultiPriority() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        let price1 = DNSPrice()
        price1.price = 5.00
        price1.priority = DNSPriority.low
        
        let price2 = DNSPrice()
        price2.price = 10.00
        price2.priority = DNSPriority.normal
        
        let price3 = DNSPrice()
        price3.price = 15.00
        price3.priority = DNSPriority.high
        
        let price4 = DNSPrice()
        price4.price = 20.00
        price4.priority = DNSPriority.highest
        
        pricingPrice.prices = [price1, price2, price3, price4]
        return pricingPrice
    }
    
    static func createWithTimeRange() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        
        let startTime = Date().addingTimeInterval(-3600) // 1 hour ago
        let endTime = Date().addingTimeInterval(3600)   // 1 hour from now
        
        let price = DNSPrice()
        price.price = 12.50
        price.priority = DNSPriority.normal
        price.startTime = DNSDataTranslation().timeOfDay(from: startTime) ?? DNSTimeOfDay()
        price.endTime = DNSDataTranslation().timeOfDay(from: endTime) ?? DNSTimeOfDay()
        
        pricingPrice.prices = [price]
        return pricingPrice
    }
    
    static func createExpired() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        
        let startTime = Date().addingTimeInterval(-7200) // 2 hours ago
        let endTime = Date().addingTimeInterval(-3600)   // 1 hour ago
        
        let price = DNSPrice()
        price.price = 8.00
        price.priority = DNSPriority.normal
        price.startTime = DNSDataTranslation().timeOfDay(from: startTime) ?? DNSTimeOfDay()
        price.endTime = DNSDataTranslation().timeOfDay(from: endTime) ?? DNSTimeOfDay()
        
        pricingPrice.prices = [price]
        return pricingPrice
    }
    
    static func createFuture() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        
        let startTime = Date().addingTimeInterval(3600)  // 1 hour from now
        let endTime = Date().addingTimeInterval(7200)    // 2 hours from now
        
        let price = DNSPrice()
        price.price = 18.00
        price.priority = DNSPriority.normal
        price.startTime = DNSDataTranslation().timeOfDay(from: startTime) ?? DNSTimeOfDay()
        price.endTime = DNSDataTranslation().timeOfDay(from: endTime) ?? DNSTimeOfDay()
        
        pricingPrice.prices = [price]
        return pricingPrice
    }
    
    static func createFallbackDefault() -> DAOPricingPrice {
        let pricingPrice = DAOPricingPrice()
        // Using default ID from constructor
        
        let price = DNSPrice()
        price.price = 10.00
        price.priority = DNSPriority.normal
        
        pricingPrice.prices = [price]
        return pricingPrice
    }
}