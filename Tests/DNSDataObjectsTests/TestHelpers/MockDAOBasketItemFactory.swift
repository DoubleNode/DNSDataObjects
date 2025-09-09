//
//  MockDAOBasketItemFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOBasketItemFactory -
struct MockDAOBasketItemFactory: MockDAOFactory {
    typealias DAOType = DAOBasketItem
    
    static func createMock() -> DAOBasketItem {
        let basketItem = DAOBasketItem()
        // Basic valid object with minimal data
        basketItem.quantity = 1
        return basketItem
    }
    
    static func createMockWithTestData() -> DAOBasketItem {
        let basketItem = DAOBasketItem()
        
        // Realistic test data
        basketItem.quantity = 2
        
        // Create test account
        let account = DAOAccount()
        basketItem.account = account
        
        // Create test product
        let product = DAOProduct()
        basketItem.product = product
        
        // Create test place
        let place = DAOPlace()
        basketItem.place = place
        
        return basketItem
    }
    
    static func createMockWithEdgeCases() -> DAOBasketItem {
        let basketItem = DAOBasketItem()
        
        // Edge cases and boundary values
        basketItem.quantity = 0 // Zero quantity
        
        // All optional relationships are nil (edge case)
        basketItem.account = nil
        basketItem.basket = nil
        basketItem.place = nil
        basketItem.product = nil
        
        return basketItem
    }
    
    static func createMockArray(count: Int) -> [DAOBasketItem] {
        var basketItems: [DAOBasketItem] = []
        
        for i in 0..<count {
            let basketItem = DAOBasketItem()
            basketItem.id = "basket_item\(i)" // Set explicit ID to match test expectations
            
            basketItem.quantity = (i % 5) + 1 // 1 to 5
            
            if i % 2 == 0 { // Every other gets a product
                let product = DAOProduct()
                basketItem.product = product
            }
            
            if i % 3 == 0 { // Every third gets an account
                let account = DAOAccount()
                basketItem.account = account
            }
            
            basketItems.append(basketItem)
        }
        
        return basketItems
    }
}