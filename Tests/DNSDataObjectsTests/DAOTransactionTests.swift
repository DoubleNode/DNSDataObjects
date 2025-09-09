//
//  DAOTransactionTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOTransactionTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        let transaction = DAOTransaction()
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction.amount, 0)
        XCTAssertEqual(transaction.tax, 0)
        XCTAssertEqual(transaction.tip, 0)
        XCTAssertEqual(transaction.type, "")
        XCTAssertEqual(transaction.confirmation, "")
        XCTAssertNil(transaction.card)
        XCTAssertNil(transaction.order)
    }
    
    func testInitializationWithId() {
        let testId = "transaction_test_12345"
        let transaction = DAOTransaction(id: testId)
        XCTAssertEqual(transaction.id, testId)
    }
    
    // MARK: - Property Tests
    
    func testAmountProperty() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        XCTAssertEqual(transaction.amount, 99.99)
    }
    
    func testTaxProperty() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        XCTAssertEqual(transaction.tax, 8.00)
    }
    
    func testTipProperty() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        XCTAssertEqual(transaction.tip, 15.00)
    }
    
    func testTypeProperty() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        XCTAssertEqual(transaction.type, "purchase")
    }
    
    func testConfirmationProperty() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        XCTAssertEqual(transaction.confirmation, "CONF_ABC123XYZ")
    }
    
    func testCardProperty() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        XCTAssertNotNil(transaction.card)
        // Use property-by-property comparison - card should exist with some ID
        XCTAssertFalse(transaction.card?.id.isEmpty ?? true)
    }
    
    func testOrderProperty() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        XCTAssertNotNil(transaction.order)
        // Use property-by-property comparison - order should exist with some ID
        XCTAssertFalse(transaction.order?.id.isEmpty ?? true)
    }
    
    // MARK: - Copy Tests
    
    func testCopyFromObject() {
        let originalTransaction = MockDAOTransactionFactory.createMockWithTestData()
        let copiedTransaction = DAOTransaction(from: originalTransaction)
        
        XCTAssertEqual(copiedTransaction.id, originalTransaction.id)
        XCTAssertEqual(copiedTransaction.amount, originalTransaction.amount)
        XCTAssertEqual(copiedTransaction.tax, originalTransaction.tax)
        XCTAssertEqual(copiedTransaction.tip, originalTransaction.tip)
        XCTAssertEqual(copiedTransaction.type, originalTransaction.type)
        XCTAssertEqual(copiedTransaction.confirmation, originalTransaction.confirmation)
        // Property-by-property comparison for complex objects
        XCTAssertEqual(copiedTransaction.card?.id, originalTransaction.card?.id)
        XCTAssertEqual(copiedTransaction.order?.id, originalTransaction.order?.id)
    }
    
    func testUpdateFromObject() {
        let originalTransaction = MockDAOTransactionFactory.createMockWithTestData()
        let targetTransaction = DAOTransaction()
        
        targetTransaction.update(from: originalTransaction)
        
        XCTAssertEqual(targetTransaction.id, originalTransaction.id)
        XCTAssertEqual(targetTransaction.amount, originalTransaction.amount)
        XCTAssertEqual(targetTransaction.tax, originalTransaction.tax)
        XCTAssertEqual(targetTransaction.tip, originalTransaction.tip)
        XCTAssertEqual(targetTransaction.type, originalTransaction.type)
        XCTAssertEqual(targetTransaction.confirmation, originalTransaction.confirmation)
    }
    
    func testNSCopying() {
        let originalTransaction = MockDAOTransactionFactory.createMockWithTestData()
        let copiedTransaction = DAOTransaction(from: originalTransaction)
        
        XCTAssertEqual(copiedTransaction.id, originalTransaction.id)
        XCTAssertFalse(copiedTransaction === originalTransaction)
    }
    
    // MARK: - Dictionary Translation Tests
    
    func testDictionaryTranslation() {
        let originalTransaction = MockDAOTransactionFactory.createMockWithTestData()
        let dictionary = originalTransaction.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["amount"] as Any?)
        XCTAssertNotNil(dictionary["tax"] as Any?)
        XCTAssertNotNil(dictionary["tip"] as Any?)
        XCTAssertNotNil(dictionary["type"] as Any?)
        XCTAssertNotNil(dictionary["confirmation"] as Any?)
        XCTAssertNotNil(dictionary["card"] as Any?)
        XCTAssertNotNil(dictionary["order"] as Any?)
        
        let reconstructedTransaction = DAOTransaction(from: dictionary)
        XCTAssertNotNil(reconstructedTransaction)
        XCTAssertEqual(reconstructedTransaction?.id, originalTransaction.id)
        XCTAssertEqual(reconstructedTransaction?.amount, originalTransaction.amount)
        XCTAssertEqual(reconstructedTransaction?.type, originalTransaction.type)
    }
    
    func testDictionaryTranslationEmpty() {
        let emptyDictionary: [String: Any] = [:]
        let transaction = DAOTransaction(from: emptyDictionary)
        XCTAssertNil(transaction)
    }
    
    // MARK: - Equality Tests
    
    func testEquality() {
        let transaction1 = MockDAOTransactionFactory.createMockWithTestData()
        let transaction2 = DAOTransaction(from: transaction1)
        let transaction3 = MockDAOTransactionFactory.createMockWithEdgeCases()
        
        // Property-by-property comparison
        XCTAssertEqual(transaction1.id, transaction2.id)
        XCTAssertEqual(transaction1.amount, transaction2.amount)
        XCTAssertEqual(transaction1.type, transaction2.type)
        XCTAssertNotEqual(transaction1.amount, transaction3.amount)
        XCTAssertFalse(transaction1.isDiffFrom(transaction2))
        XCTAssertTrue(transaction1.isDiffFrom(transaction3))
    }
    
    func testEqualityWithDifferentAmounts() {
        let transaction1 = MockDAOTransactionFactory.createMockWithTestData()
        let transaction2 = DAOTransaction(from: transaction1)
        
        // Modify amount
        transaction2.amount = 199.99
        
        XCTAssertNotEqual(transaction1, transaction2)
        XCTAssertTrue(transaction1.isDiffFrom(transaction2))
    }
    
    func testEqualityWithDifferentCard() {
        let transaction1 = MockDAOTransactionFactory.createMockWithTestData()
        let transaction2 = DAOTransaction(from: transaction1)
        
        // Modify card
        transaction2.card = nil
        
        XCTAssertNotEqual(transaction1, transaction2)
        XCTAssertTrue(transaction1.isDiffFrom(transaction2))
    }
    
    // MARK: - Codable Tests
    
    func testJSONEncoding() throws {
        let originalTransaction = MockDAOTransactionFactory.createMockWithTestData()
        let data = try JSONEncoder().encode(originalTransaction)
        XCTAssertFalse(data.isEmpty)
    }
    
    func testJSONDecoding() throws {
        let originalTransaction = MockDAOTransactionFactory.createMockWithTestData()
        let data = try JSONEncoder().encode(originalTransaction)
        let decodedTransaction = try JSONDecoder().decode(DAOTransaction.self, from: data)
        
        XCTAssertEqual(decodedTransaction.id, originalTransaction.id)
        XCTAssertEqual(decodedTransaction.amount, originalTransaction.amount)
        XCTAssertEqual(decodedTransaction.type, originalTransaction.type)
    }
    
    func testJSONRoundTrip() throws {
        let originalTransaction = MockDAOTransactionFactory.createMockWithTestData()
        let data = try JSONEncoder().encode(originalTransaction)
        let decodedTransaction = try JSONDecoder().decode(DAOTransaction.self, from: data)
        
        // Property-by-property comparison instead of object equality
        XCTAssertEqual(originalTransaction.id, decodedTransaction.id)
        XCTAssertEqual(originalTransaction.amount, decodedTransaction.amount)
        XCTAssertEqual(originalTransaction.tax, decodedTransaction.tax)
        XCTAssertEqual(originalTransaction.tip, decodedTransaction.tip)
        XCTAssertEqual(originalTransaction.type, decodedTransaction.type)
        XCTAssertEqual(originalTransaction.confirmation, decodedTransaction.confirmation)
        XCTAssertFalse(originalTransaction.isDiffFrom(decodedTransaction))
    }
    
    // MARK: - Edge Cases
    
    func testZeroAmounts() {
        let transaction = DAOTransaction()
        transaction.amount = 0
        transaction.tax = 0
        transaction.tip = 0
        
        XCTAssertEqual(transaction.amount, 0)
        XCTAssertEqual(transaction.tax, 0)
        XCTAssertEqual(transaction.tip, 0)
        
        let dictionary = transaction.asDictionary
        let reconstructed = DAOTransaction(from: dictionary)
        XCTAssertNotNil(reconstructed)
        XCTAssertEqual(reconstructed?.amount, 0)
        XCTAssertEqual(reconstructed?.tax, 0)
        XCTAssertEqual(reconstructed?.tip, 0)
    }
    
    func testNegativeAmounts() {
        let transaction = DAOTransaction()
        transaction.amount = -50.00 // Refund
        transaction.tax = -4.00
        transaction.tip = 0
        
        XCTAssertEqual(transaction.amount, -50.00)
        XCTAssertEqual(transaction.tax, -4.00)
        XCTAssertEqual(transaction.tip, 0)
        
        let dictionary = transaction.asDictionary
        let reconstructed = DAOTransaction(from: dictionary)
        XCTAssertNotNil(reconstructed)
        XCTAssertEqual(reconstructed?.amount, -50.00)
    }
    
    func testNilCardAndOrder() {
        let transaction = DAOTransaction()
        transaction.card = nil
        transaction.order = nil
        
        XCTAssertNil(transaction.card)
        XCTAssertNil(transaction.order)
        
        let dictionary = transaction.asDictionary
        let reconstructed = DAOTransaction(from: dictionary)
        XCTAssertNotNil(reconstructed)
        XCTAssertNil(reconstructed?.card)
        XCTAssertNil(reconstructed?.order)
    }
    
    func testEmptyConfirmation() {
        let transaction = DAOTransaction()
        transaction.confirmation = ""
        
        XCTAssertEqual(transaction.confirmation, "")
        
        let dictionary = transaction.asDictionary
        let reconstructed = DAOTransaction(from: dictionary)
        XCTAssertNotNil(reconstructed)
        XCTAssertEqual(reconstructed?.confirmation, "")
    }
    
    func testLongConfirmation() {
        let transaction = DAOTransaction()
        let longConfirmation = String(repeating: "CONF_", count: 100)
        transaction.confirmation = longConfirmation
        
        XCTAssertEqual(transaction.confirmation, longConfirmation)
        
        let copiedTransaction = DAOTransaction(from: transaction)
        XCTAssertEqual(copiedTransaction.confirmation, longConfirmation)
    }
    
    // MARK: - Factory Tests
    
    func testMockFactory() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction.id, "transaction_12345")
        XCTAssertEqual(transaction.amount, 99.99)
        XCTAssertEqual(transaction.type, "purchase")
        XCTAssertNotNil(transaction.card)
        XCTAssertNotNil(transaction.order)
    }
    
    func testMockFactoryEmpty() {
        let transaction = MockDAOTransactionFactory.createMockWithEdgeCases()
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction.amount, 0)
        XCTAssertNil(transaction.card)
        XCTAssertNil(transaction.order)
    }
    
    func testMockFactoryWithId() {
        let testId = "custom_transaction_id"
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        transaction.id = testId
        XCTAssertEqual(transaction.id, testId)
    }
    
    func testMockFactoryRefund() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        transaction.type = "refund"
        transaction.amount = Float(-49.99)
        transaction.tax = Float(-4.00)
        transaction.tip = Float(0.00)
        XCTAssertEqual(transaction.type, "refund")
        XCTAssertEqual(transaction.amount, -49.99)
        XCTAssertEqual(transaction.tax, -4.00)
        XCTAssertEqual(transaction.tip, 0.00)
    }
    
    func testMockFactoryWithCard() {
        let card = MockDAOCardFactory.createMock()
        card.id = "custom_card_id"
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        transaction.card = card
        XCTAssertEqual(transaction.card?.id, "custom_card_id")
    }
    
    func testMockFactoryCashTransaction() {
        let transaction = MockDAOTransactionFactory.createMockWithTestData()
        transaction.type = "cash"
        transaction.card = nil
        XCTAssertEqual(transaction.type, "cash")
        XCTAssertNil(transaction.card)
    }

    static var allTests = [
        ("testInitialization", testInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testAmountProperty", testAmountProperty),
        ("testTaxProperty", testTaxProperty),
        ("testTipProperty", testTipProperty),
        ("testTypeProperty", testTypeProperty),
        ("testConfirmationProperty", testConfirmationProperty),
        ("testCardProperty", testCardProperty),
        ("testOrderProperty", testOrderProperty),
        ("testCopyFromObject", testCopyFromObject),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testNSCopying", testNSCopying),
        ("testDictionaryTranslation", testDictionaryTranslation),
        ("testDictionaryTranslationEmpty", testDictionaryTranslationEmpty),
        ("testEquality", testEquality),
        ("testEqualityWithDifferentAmounts", testEqualityWithDifferentAmounts),
        ("testEqualityWithDifferentCard", testEqualityWithDifferentCard),
        ("testJSONEncoding", testJSONEncoding),
        ("testJSONDecoding", testJSONDecoding),
        ("testJSONRoundTrip", testJSONRoundTrip),
        ("testZeroAmounts", testZeroAmounts),
        ("testNegativeAmounts", testNegativeAmounts),
        ("testNilCardAndOrder", testNilCardAndOrder),
        ("testEmptyConfirmation", testEmptyConfirmation),
        ("testLongConfirmation", testLongConfirmation),
        ("testMockFactory", testMockFactory),
        ("testMockFactoryEmpty", testMockFactoryEmpty),
        ("testMockFactoryWithId", testMockFactoryWithId),
        ("testMockFactoryRefund", testMockFactoryRefund),
        ("testMockFactoryWithCard", testMockFactoryWithCard),
        ("testMockFactoryCashTransaction", testMockFactoryCashTransaction),
    ]
}
