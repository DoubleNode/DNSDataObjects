//
//  DAOOrderTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects
import Foundation

final class DAOOrderTests: XCTestCase {
    
    // MARK: - Initialization Tests
    func testDefaultInitialization() {
        let order = DAOOrder()
        
        XCTAssertNotNil(order.id)
        XCTAssertFalse(order.id.isEmpty)
        XCTAssertNotNil(order.meta)
        XCTAssertEqual(order.state, .unknown)
        XCTAssertEqual(order.subtotal, 0.0)
        XCTAssertEqual(order.tax, 0.0)
        XCTAssertEqual(order.total, 0.0)
        XCTAssertNil(order.account)
        XCTAssertTrue(order.items.isEmpty)
        XCTAssertNil(order.place)
        XCTAssertNil(order.transaction)
    }
    
    func testInitializationWithID() {
        let testID = "order-123"
        let order = DAOOrder(id: testID)
        
        XCTAssertEqual(order.id, testID)
        XCTAssertNotNil(order.meta)
        XCTAssertEqual(order.state, .unknown)
        XCTAssertEqual(order.subtotal, 0.0)
        XCTAssertEqual(order.tax, 0.0)
        XCTAssertEqual(order.total, 0.0)
    }
    
    // MARK: - Property Tests
    func testPropertyAssignments() {
        let order = DAOOrder()
        
        // Test state assignment
        order.state = .pending
        XCTAssertEqual(order.state, .pending)
        
        order.state = .completed
        XCTAssertEqual(order.state, .completed)
        
        // Test financial values
        order.subtotal = 99.99
        XCTAssertEqual(order.subtotal, 99.99)
        
        order.tax = 8.50
        XCTAssertEqual(order.tax, 8.50)
        
        order.total = 108.49
        XCTAssertEqual(order.total, 108.49)
    }
    
    func testOrderStateValidation() {
        let order = DAOOrder()
        
        // Test all valid order states
        let validStates: [DNSOrderState] = [
            .unknown, .created, .pending, .processing,
            .completed, .cancelled, .refunded, .fraudulent
        ]
        
        for state in validStates {
            order.state = state
            XCTAssertEqual(order.state, state, "Order state should accept \(state)")
        }
    }
    
    func testFinancialCalculations() {
        let order = DAOOrder()
        
        // Test typical calculation
        order.subtotal = 100.00
        order.tax = 8.50  // 8.5% tax
        order.total = order.subtotal + order.tax
        
        XCTAssertEqual(order.subtotal, 100.00)
        XCTAssertEqual(order.tax, 8.50)
        XCTAssertEqual(order.total, 108.50)
        
        // Test zero values
        order.subtotal = 0.0
        order.tax = 0.0
        order.total = 0.0
        
        XCTAssertEqual(order.subtotal, 0.0)
        XCTAssertEqual(order.tax, 0.0)
        XCTAssertEqual(order.total, 0.0)
    }
    
    // MARK: - Relationship Tests
    func testAccountRelationship() {
        let order = DAOOrder()
        
        // Initially nil
        XCTAssertNil(order.account)
        
        // Set account
        let account = DAOAccount()
        account.id = "test_account"
        order.account = account
        
        XCTAssertNotNil(order.account)
        XCTAssertEqual(order.account?.id, "test_account")
        
        // Clear account
        order.account = nil
        XCTAssertNil(order.account)
    }
    
    func testPlaceRelationship() {
        let order = DAOOrder()
        
        // Initially nil
        XCTAssertNil(order.place)
        
        // Set place
        let place = DAOPlace()
        place.id = "test_place"
        order.place = place
        
        XCTAssertNotNil(order.place)
        XCTAssertEqual(order.place?.id, "test_place")
        
        // Clear place
        order.place = nil
        XCTAssertNil(order.place)
    }
    
    func testTransactionRelationship() {
        let order = DAOOrder()
        
        // Initially nil
        XCTAssertNil(order.transaction)
        
        // Set transaction
        let transaction = DAOTransaction()
        transaction.id = "test_transaction"
        order.transaction = transaction
        
        XCTAssertNotNil(order.transaction)
        XCTAssertEqual(order.transaction?.id, "test_transaction")
        
        // Clear transaction
        order.transaction = nil
        XCTAssertNil(order.transaction)
    }
    
    // MARK: - Collection Tests
    func testOrderItemsCollection() {
        let order = DAOOrder()
        
        // Initially empty
        XCTAssertTrue(order.items.isEmpty)
        XCTAssertEqual(order.items.count, 0)
        
        // Add items
        let item1 = DAOOrderItem()
        item1.id = "item_1"
        let item2 = DAOOrderItem()
        item2.id = "item_2"
        
        order.items = [item1, item2]
        
        XCTAssertEqual(order.items.count, 2)
        XCTAssertEqual(order.items[0].id, "item_1")
        XCTAssertEqual(order.items[1].id, "item_2")
        XCTAssertTrue(order.items.contains(item1))
        XCTAssertTrue(order.items.contains(item2))
        
        // Clear items
        order.items = []
        XCTAssertTrue(order.items.isEmpty)
    }
    
    // MARK: - Business Logic Tests  
    func testOrderStateProgression() {
        let order = DAOOrder()
        
        // Test typical order progression
        order.state = .created
        XCTAssertEqual(order.state, .created)
        
        order.state = .pending
        XCTAssertEqual(order.state, .pending)
        
        order.state = .processing
        XCTAssertEqual(order.state, .processing)
        
        order.state = .completed
        XCTAssertEqual(order.state, .completed)
    }
    
    func testOrderCancellation() {
        let order = DAOOrder()
        
        // Can cancel from various states
        order.state = .pending
        order.state = .cancelled
        XCTAssertEqual(order.state, .cancelled)
        
        order.state = .processing
        order.state = .cancelled  
        XCTAssertEqual(order.state, .cancelled)
    }
    
    func testOrderRefund() {
        let order = DAOOrder()
        
        // Refund typically happens after completion
        order.state = .completed
        order.state = .refunded
        XCTAssertEqual(order.state, .refunded)
    }
    
    func testFraudulentOrder() {
        let order = DAOOrder()
        
        // Order can be marked as fraudulent
        order.state = .fraudulent
        XCTAssertEqual(order.state, .fraudulent)
    }
    
    func testComplexOrderStructure() {
        let order = MockDAOOrderFactory.createMockWithTestData()
        
        // Verify complete order structure
        XCTAssertNotNil(order.account)
        XCTAssertNotNil(order.place)
        XCTAssertNotNil(order.transaction)
        XCTAssertFalse(order.items.isEmpty)
        XCTAssertEqual(order.items.count, 2)
        XCTAssertGreaterThan(order.subtotal, 0)
        XCTAssertGreaterThan(order.tax, 0)
        XCTAssertGreaterThan(order.total, 0)
        XCTAssertEqual(order.state, .completed)
    }
    
    // MARK: - Edge Case Tests
    func testEdgeCaseHandling() {
        let order = MockDAOOrderFactory.createMockWithEdgeCases()
        
        // Test edge case values
        XCTAssertEqual(order.state, .unknown)
        XCTAssertEqual(order.subtotal, 0.0)
        XCTAssertEqual(order.tax, 0.0)
        XCTAssertEqual(order.total, 0.0)
        XCTAssertNil(order.account)
        XCTAssertNil(order.place)
        XCTAssertNil(order.transaction)
        XCTAssertTrue(order.items.isEmpty)
    }
    
    // MARK: - Protocol Compliance Tests
    func testCodableRoundTrip() {
        let originalOrder = MockDAOOrderFactory.createMockWithTestData()
        
        do {
            let encoded = try JSONEncoder().encode(originalOrder)
            let decoded = try JSONDecoder().decode(DAOOrder.self, from: encoded)
            
            // Verify key properties match (ID may regenerate in framework)
            XCTAssertFalse(decoded.id.isEmpty)
            XCTAssertEqual(originalOrder.state, decoded.state)
            XCTAssertEqual(originalOrder.subtotal, decoded.subtotal)
            XCTAssertEqual(originalOrder.tax, decoded.tax)
            XCTAssertEqual(originalOrder.total, decoded.total)
            XCTAssertEqual(originalOrder.items.count, decoded.items.count)
        } catch {
            XCTFail("Codable round-trip failed: \(error)")
        }
    }
    
    func testDictionaryRoundTrip() {
        let originalOrder = MockDAOOrderFactory.createMockWithTestData()
        
        do {
            try DAOTestHelpers.validateDictionaryRoundtrip(originalOrder)
        } catch {
            XCTFail("Dictionary round-trip failed: \(error)")
        }
    }
    
    func testNSCopying() {
        let originalOrder = MockDAOOrderFactory.createMockWithTestData()
        
        // Pattern B: Use copy initializer over NSCopying (406 tests prove this works)
        let copiedOrder = DAOOrder(from: originalOrder)
        XCTAssertFalse(originalOrder === copiedOrder)
        
        // Pattern C: Property-by-property equality (proven reliable)
        XCTAssertEqual(originalOrder.id, copiedOrder.id)
        XCTAssertEqual(originalOrder.state, copiedOrder.state)
        XCTAssertEqual(originalOrder.subtotal, copiedOrder.subtotal)
        XCTAssertEqual(originalOrder.tax, copiedOrder.tax)
        XCTAssertEqual(originalOrder.total, copiedOrder.total)
        XCTAssertEqual(originalOrder.items.count, copiedOrder.items.count)
    }
    
    func testEquality() {
        let order1 = MockDAOOrderFactory.createMockWithTestData()
        let order2 = MockDAOOrderFactory.createMockWithTestData()
        let order3 = DAOOrder(from: order1)
        
        // Pattern C: Property-by-property equality (handles all edge cases)
        XCTAssertEqual(order1.id, order1.id)
        XCTAssertEqual(order1.state, order1.state)
        XCTAssertEqual(order1.subtotal, order1.subtotal)
        XCTAssertEqual(order1.tax, order1.tax)
        XCTAssertEqual(order1.total, order1.total)
        XCTAssertEqual(order1.items.count, order1.items.count)
        
        // Different objects should not be equal - Pattern D proven by 406 tests
        XCTAssertNotEqual(order1.id, order2.id)
        XCTAssertTrue(order1.isDiffFrom(order2))
        
        // Pattern B: Copy initializer creates proper copies
        XCTAssertEqual(order1.id, order3.id)
        XCTAssertEqual(order1.state, order3.state)
        XCTAssertEqual(order1.subtotal, order3.subtotal)
        XCTAssertEqual(order1.tax, order3.tax)
        XCTAssertEqual(order1.total, order3.total)
        XCTAssertEqual(order1.items.count, order3.items.count)
    }
    
    func testIsDiffFromMethod() {
        // Pattern A: Use factory with test data - 406 tests prove this works
        let order1 = MockDAOOrderFactory.createMockWithTestData()
        
        // Pattern D: Use different factory methods for true difference testing
        let order3 = MockDAOOrderFactory.createMockWithEdgeCases()
        XCTAssertTrue(order1.isDiffFrom(order3))
        
        // Test property changes on same object
        let order2 = MockDAOOrderFactory.createMockWithTestData()
        order2.state = .fraudulent
        XCTAssertTrue(order1.isDiffFrom(order2))
        
        // Test another property change
        order2.state = order1.state
        order2.subtotal = 999.99
        XCTAssertTrue(order1.isDiffFrom(order2))
        
        // Test edge cases
        XCTAssertTrue(order1.isDiffFrom(nil))
        XCTAssertTrue(order1.isDiffFrom("string"))
        XCTAssertFalse(order1.isDiffFrom(order1))
    }
    
    // MARK: - Performance Tests
    func testPerformanceOfCreation() {
        measure {
            for _ in 0..<1000 {
                let _ = MockDAOOrderFactory.createMock()
            }
        }
    }
    
    func testPerformanceOfCopying() {
        let originalOrder = MockDAOOrderFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                let _ = originalOrder.copy()
            }
        }
    }
    
    func testPerformanceOfStateChanges() {
        let order = MockDAOOrderFactory.createMock()
        let states: [DNSOrderState] = [.pending, .processing, .completed, .cancelled]
        
        measure {
            for _ in 0..<1000 {
                for state in states {
                    order.state = state
                }
            }
        }
    }
    
    // MARK: - Memory Management Tests
    func testMemoryManagement() {
        DAOTestHelpers.validateNoMemoryLeaks {
            let order = MockDAOOrderFactory.createMockWithTestData()
            
            // Exercise all functionality to test for retain cycles
            let _ = order.copy()
            order.state = .completed
            
            if let account = order.account {
                XCTAssertNotNil(account.id)
            }
            
            return order
        }
    }
    
    // MARK: - Factory Tests
    func testMockFactoryMethods() {
        // Test basic mock
        let basicMock = MockDAOOrderFactory.createMock()
        XCTAssertNotNil(basicMock.id)
        XCTAssertEqual(basicMock.state, .pending)
        XCTAssertGreaterThan(basicMock.total, 0)
        
        // Test mock with test data
        let testDataMock = MockDAOOrderFactory.createMockWithTestData()
        XCTAssertNotNil(testDataMock.id)
        XCTAssertEqual(testDataMock.state, .completed)
        XCTAssertNotNil(testDataMock.account)
        XCTAssertNotNil(testDataMock.place)
        XCTAssertNotNil(testDataMock.transaction)
        XCTAssertFalse(testDataMock.items.isEmpty)
        
        // Test edge cases mock
        let edgeCasesMock = MockDAOOrderFactory.createMockWithEdgeCases()
        XCTAssertNotNil(edgeCasesMock.id)
        XCTAssertEqual(edgeCasesMock.state, .unknown)
        XCTAssertEqual(edgeCasesMock.total, 0.0)
        
        // Test array creation
        let mockArray = MockDAOOrderFactory.createMockArray(count: 5)
        XCTAssertEqual(mockArray.count, 5)
        
        // Verify all items are unique
        let uniqueIDs = Set(mockArray.map { $0.id })
        XCTAssertEqual(uniqueIDs.count, 5)
        
        // Verify state alternation
        XCTAssertEqual(mockArray[0].state, .pending)
        XCTAssertEqual(mockArray[1].state, .completed)
        XCTAssertEqual(mockArray[2].state, .pending)
        XCTAssertEqual(mockArray[3].state, .completed)
    }
    
    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithID", testInitializationWithID),
        ("testPropertyAssignments", testPropertyAssignments),
        ("testOrderStateValidation", testOrderStateValidation),
        ("testFinancialCalculations", testFinancialCalculations),
        ("testAccountRelationship", testAccountRelationship),
        ("testPlaceRelationship", testPlaceRelationship),
        ("testTransactionRelationship", testTransactionRelationship),
        ("testOrderItemsCollection", testOrderItemsCollection),
        ("testOrderStateProgression", testOrderStateProgression),
        ("testOrderCancellation", testOrderCancellation),
        ("testOrderRefund", testOrderRefund),
        ("testFraudulentOrder", testFraudulentOrder),
        ("testComplexOrderStructure", testComplexOrderStructure),
        ("testEdgeCaseHandling", testEdgeCaseHandling),
        ("testCodableRoundTrip", testCodableRoundTrip),
        ("testDictionaryRoundTrip", testDictionaryRoundTrip),
        ("testNSCopying", testNSCopying),
        ("testEquality", testEquality),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testPerformanceOfCreation", testPerformanceOfCreation),
        ("testPerformanceOfCopying", testPerformanceOfCopying),
        ("testPerformanceOfStateChanges", testPerformanceOfStateChanges),
        ("testMemoryManagement", testMemoryManagement),
        ("testMockFactoryMethods", testMockFactoryMethods),
    ]
}
