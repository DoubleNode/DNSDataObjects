//
//  MockDAOBasketFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOBasketFactory -
struct MockDAOBasketFactory: MockDAOFactory {
    typealias DAOType = DAOBasket
    
    static func createMock() -> DAOBasket {
        let basket = DAOBasket()
        // Basic valid object with minimal data
        basket.items = []
        return basket
    }
    
    static func createMockWithTestData() -> DAOBasket {
        let basket = DAOBasket()
        
        // Realistic test data
        // Create test account
        let account = DAOAccount()
        account.id = "test_account_123"
        basket.account = account
        
        // Create test place
        let place = DAOPlace()
        place.id = "test_place_456"
        basket.place = place
        
        // Create test basket items
        let item1 = DAOBasketItem()
        item1.id = "item_1"
        let item2 = DAOBasketItem()
        item2.id = "item_2"
        let item3 = DAOBasketItem()
        item3.id = "item_3"
        basket.items = [item1, item2, item3]
        
        return basket
    }
    
    static func createMockWithEdgeCases() -> DAOBasket {
        let basket = DAOBasket()
        
        // Edge cases and boundary values
        // nil account and place (edge cases)
        basket.account = nil
        basket.place = nil
        
        // Empty items array (edge case)
        basket.items = []
        
        return basket
    }
    
    static func createMockArray(count: Int) -> [DAOBasket] {
        var baskets: [DAOBasket] = []
        
        for i in 0..<count {
            let basket = DAOBasket()
            basket.id = "basket\(i)" // Set explicit ID to match test expectations
            
            if i % 2 == 0 { // Every other gets an account
                let account = DAOAccount()
                account.id = "account_\(i)"
                basket.account = account
            }
            
            if i % 3 == 0 { // Every third gets a place
                let place = DAOPlace()
                place.id = "place_\(i)"
                basket.place = place
            }
            
            // Variable number of items (0 to 3)
            let itemCount = i % 4
            var items: [DAOBasketItem] = []
            for j in 0..<itemCount {
                let item = DAOBasketItem()
                item.id = "item_\(i)_\(j)"
                items.append(item)
            }
            basket.items = items
            
            baskets.append(basket)
        }
        
        return baskets
    }
}