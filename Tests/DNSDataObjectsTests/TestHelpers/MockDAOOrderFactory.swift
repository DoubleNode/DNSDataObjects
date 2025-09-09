//
//  MockDAOOrderFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOOrderFactory -
struct MockDAOOrderFactory: MockDAOFactory {
    typealias DAOType = DAOOrder
    
    static func createMock() -> DAOOrder {
        let order = DAOOrder()
        order.state = .pending
        order.subtotal = Float(99.99)
        order.tax = Float(8.50)
        order.total = Float(108.49)
        return order
    }
    
    static func createMockWithTestData() -> DAOOrder {
        let order = DAOOrder()
        order.state = .completed
        order.subtotal = Float(149.99)
        order.tax = Float(12.75)
        order.total = Float(162.74)
        
        // Create test account
        let account = DAOAccount()
        account.id = "test_account_123"
        order.account = account
        
        // Create test place
        let place = DAOPlace()
        place.id = "test_place_456"
        order.place = place
        
        // Create test order items
        let item1 = DAOOrderItem()
        item1.id = "item_1"
        let item2 = DAOOrderItem()
        item2.id = "item_2"
        order.items = [item1, item2]
        
        // Create test transaction
        let transaction = DAOTransaction()
        transaction.id = "transaction_789"
        order.transaction = transaction
        
        return order
    }
    
    static func createMockWithEdgeCases() -> DAOOrder {
        let order = DAOOrder()
        
        // Edge cases
        order.state = .unknown // Unknown state
        order.subtotal = Float(0.0) // Zero subtotal
        order.tax = Float(0.0) // Zero tax
        order.total = Float(0.0) // Zero total
        order.account = nil // No account
        order.place = nil // No place
        order.items = [] // Empty items
        order.transaction = nil // No transaction
        
        return order
    }
    
    static func createMockArray(count: Int) -> [DAOOrder] {
        return (0..<count).map { i in
            let order = createMock()
            order.id = "order\(i)" // Set explicit ID to match test expectations
            order.subtotal = Float(50 + (i * 10))
            order.tax = order.subtotal * Float(0.085) // 8.5% tax
            order.total = order.subtotal + order.tax
            order.state = i % 2 == 0 ? .pending : .completed
            return order
        }
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOOrder {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOOrder {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOOrder {
        let order = createMockWithTestData()
        order.id = id
        return order
    }
}