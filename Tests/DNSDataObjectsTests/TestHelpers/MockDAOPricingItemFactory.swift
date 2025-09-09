//
//  MockDAOPricingItemFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

enum DNSDayOfWeek {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

class MockDAOPricingItemFactory {
    static func createBasic() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-basic"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createBasic()
        pricingItem.priority = DNSPriority.normal
        return pricingItem
    }
    
    static func createFull() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-full"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createDefault()
        pricingItem.priceMonday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceTuesday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceWednesday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceThursday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceFriday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceSaturday = MockDAOPricingPriceFactory.createWeekend()
        pricingItem.priceSunday = MockDAOPricingPriceFactory.createWeekend()
        pricingItem.priority = DNSPriority.high
        return pricingItem
    }
    
    static func createWeekdaysOnly() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-weekdays"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createFallbackDefault()
        pricingItem.priceMonday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceTuesday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceWednesday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceThursday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priceFriday = MockDAOPricingPriceFactory.createWeekday()
        pricingItem.priority = DNSPriority.normal
        return pricingItem
    }
    
    static func createWeekendsOnly() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-weekends"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createFallbackDefault()
        pricingItem.priceSaturday = MockDAOPricingPriceFactory.createWeekend()
        pricingItem.priceSunday = MockDAOPricingPriceFactory.createWeekend()
        pricingItem.priority = DNSPriority.normal
        return pricingItem
    }
    
    static func createDefaultOnly() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-default-only"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createDefault()
        pricingItem.priority = DNSPriority.low
        return pricingItem
    }
    
    static func createEmpty() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-empty"
        pricingItem.priority = DNSPriority.none
        return pricingItem
    }
    
    static func createWithHighPriority() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-high-priority"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createMultiPriority()
        pricingItem.priority = DNSPriority.highest
        return pricingItem
    }
    
    static func createWithLowPriority() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-low-priority"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createBasic()
        pricingItem.priority = DNSPriority.none
        return pricingItem
    }
    
    static func createForSpecificDay(_ day: DNSDayOfWeek) -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-\(day)"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createDefault()
        
        let specificPrice = MockDAOPricingPriceFactory.createWeekday()
        
        switch day {
        case .monday:
            pricingItem.priceMonday = specificPrice
        case .tuesday:
            pricingItem.priceTuesday = specificPrice
        case .wednesday:
            pricingItem.priceWednesday = specificPrice
        case .thursday:
            pricingItem.priceThursday = specificPrice
        case .friday:
            pricingItem.priceFriday = specificPrice
        case .saturday:
            pricingItem.priceSaturday = specificPrice
        case .sunday:
            pricingItem.priceSunday = specificPrice
        default:
            break
        }
        
        pricingItem.priority = DNSPriority.normal
        return pricingItem
    }
    
    static func createWithNilPrices() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-nil-prices"
        pricingItem.priceDefault = nil
        pricingItem.priceMonday = nil
        pricingItem.priceTuesday = nil
        pricingItem.priceWednesday = nil
        pricingItem.priceThursday = nil
        pricingItem.priceFriday = nil
        pricingItem.priceSaturday = nil
        pricingItem.priceSunday = nil
        pricingItem.priority = DNSPriority.normal
        return pricingItem
    }
    
    static func createWithTimeRanges() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-time-ranges"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createWithTimeRange()
        pricingItem.priceMonday = MockDAOPricingPriceFactory.createExpired()
        pricingItem.priceTuesday = MockDAOPricingPriceFactory.createFuture()
        pricingItem.priority = DNSPriority.normal
        return pricingItem
    }
    
    static func createWithEmptyPrices() -> DAOPricingItem {
        let pricingItem = DAOPricingItem()
        pricingItem.id = "pricing-empty-prices"
        pricingItem.priceDefault = MockDAOPricingPriceFactory.createEmpty()
        pricingItem.priceMonday = MockDAOPricingPriceFactory.createEmpty()
        pricingItem.priority = DNSPriority.normal
        return pricingItem
    }
    
    static func createTestData() -> [DAOPricingItem] {
        return [
            createBasic(),
            createFull(),
            createWeekdaysOnly(),
            createWeekendsOnly(),
            createDefaultOnly(),
            createEmpty(),
            createWithHighPriority(),
            createWithLowPriority(),
            createWithNilPrices(),
            createWithTimeRanges(),
            createWithEmptyPrices()
        ]
    }
}