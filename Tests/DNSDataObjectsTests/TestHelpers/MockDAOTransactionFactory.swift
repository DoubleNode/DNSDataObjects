//
//  MockDAOTransactionFactory.swift
//  DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataObjects
import DNSDataTypes
import Foundation

// MARK: - MockDAOTransactionFactory -
struct MockDAOTransactionFactory: MockDAOFactory {
    typealias DAOType = DAOTransaction
    
    static func createMock() -> DAOTransaction {
        let dao = DAOTransaction()
        dao.amount = Float(99.99)
        dao.tax = Float(8.00)
        dao.tip = Float(15.00)
        dao.type = "purchase"
        dao.confirmation = "CONF_ABC123"
        return dao
    }
    
    static func createMockWithTestData() -> DAOTransaction {
        let dao = DAOTransaction()
        dao.id = "transaction_12345"
        
        // Set transaction amounts
        dao.amount = Float(99.99)
        dao.tax = Float(8.00)
        dao.tip = Float(15.00)
        dao.type = "purchase"
        dao.confirmation = "CONF_ABC123XYZ"
        
        // Create mock card - FIXED: using createMock() instead of create()
        dao.card = MockDAOCardFactory.createMock()
        
        // Create mock order - FIXED: using createMock() instead of create()
        dao.order = MockDAOOrderFactory.createMock()
        
        return dao
    }
    
    static func createMockWithEdgeCases() -> DAOTransaction {
        let dao = DAOTransaction()
        
        // Edge cases
        dao.amount = Float(0.0)
        dao.tax = Float(0.0) 
        dao.tip = Float(0.0)
        dao.type = ""
        dao.confirmation = ""
        dao.card = nil
        dao.order = nil
        
        return dao
    }
    
    static func createMockArray(count: Int) -> [DAOTransaction] {
        return (0..<count).map { i in
            let dao = DAOTransaction()
            dao.id = "transaction\(i)" // Set explicit ID to match test expectations
            dao.amount = Float(50 + (i * 10))
            dao.tax = dao.amount * Float(0.08)
            dao.tip = dao.amount * Float(0.15)
            dao.type = i % 2 == 0 ? "purchase" : "refund"
            dao.confirmation = "CONF_\(i)"
            return dao
        }
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOTransaction {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOTransaction {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOTransaction {
        let transaction = createMockWithTestData()
        transaction.id = id
        return transaction
    }
    
    // Test-specific method aliases expected by DAOTransactionTests
    static func createRefund() -> DAOTransaction {
        let transaction = createMockWithTestData()
        transaction.type = "refund"
        transaction.amount = Float(-99.99) // Negative for refund
        return transaction
    }
    
    static func createWithCard(_ card: DAOCard) -> DAOTransaction {
        let transaction = createMockWithTestData()
        transaction.card = card
        return transaction
    }
    
    static func createCashTransaction() -> DAOTransaction {
        let transaction = createMockWithTestData()
        transaction.type = "cash"
        transaction.card = nil // No card for cash transaction
        return transaction
    }
}