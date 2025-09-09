//
//  MockDAOOrderItemFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOOrderItemFactory -
struct MockDAOOrderItemFactory: MockDAOFactory {
    typealias DAOType = DAOOrderItem
    
    static func createMock() -> DAOOrderItem {
        let orderItem = DAOOrderItem()
        orderItem.quantity = 1
        return orderItem
    }
    
    static func createMockWithTestData() -> DAOOrderItem {
        let orderItem = DAOOrderItem()
        orderItem.id = "order_item_12345"
        orderItem.quantity = 2
        
        // Create test account
        let account = DAOAccount()
        account.id = "test_account_123"
        account.name = PersonNameComponents.dnsBuildName(with: "Test User") ?? PersonNameComponents()
        orderItem.account = account
        
        // Create test place
        let place = DAOPlace()
        place.id = "test_place_456" 
        place.name = DNSString(with: "Test Place")
        place.code = "TEST_PLACE"
        orderItem.place = place
        
        // Create test order (minimal to avoid circular references)
        let order = DAOOrder()
        order.id = "test_order_789"
        orderItem.order = order
        
        return orderItem
    }
    
    static func createMockWithEdgeCases() -> DAOOrderItem {
        let orderItem = DAOOrderItem()
        
        // Edge cases
        orderItem.quantity = 0 // Zero quantity
        orderItem.account = nil // No account
        orderItem.place = nil // No place
        orderItem.order = nil // No order
        
        return orderItem
    }
    
    static func createMockArray(count: Int) -> [DAOOrderItem] {
        var orderItems: [DAOOrderItem] = []
        
        for i in 0..<count {
            let orderItem = DAOOrderItem()
            orderItem.id = "order_item_\(i + 1)" // Fixed to match test expectations
            orderItem.quantity = (i % 5) + 1 // Quantities from 1 to 5
            
            // Add variety
            if i % 2 == 0 {
                let account = DAOAccount()
                account.id = "account_\(i + 1)"
                orderItem.account = account
            }
            
            if i % 3 == 0 {
                let place = DAOPlace()
                place.id = "place_\(i + 1)"
                place.code = "PLACE_\(i + 1)"
                orderItem.place = place
            }
            
            orderItems.append(orderItem)
        }
        
        return orderItems
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOOrderItem {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOOrderItem {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOOrderItem {
        let orderItem = createMockWithTestData()
        orderItem.id = id
        return orderItem
    }
    
    // OrderItem-specific test methods
    static func createWithQuantity(_ quantity: Int) -> DAOOrderItem {
        let orderItem = createMockWithTestData()
        orderItem.quantity = quantity
        return orderItem
    }
    
    static func createZeroQuantityItem() -> DAOOrderItem {
        let orderItem = createMockWithTestData()
        orderItem.quantity = 0
        return orderItem
    }
    
    static func createHighQuantityItem() -> DAOOrderItem {
        let orderItem = createMockWithTestData()
        orderItem.quantity = 100
        return orderItem
    }
}