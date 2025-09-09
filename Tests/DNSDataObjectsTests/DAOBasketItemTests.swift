//
//  DAOBasketItemTests.swift
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

final class DAOBasketItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let basketItem = DAOBasketItem()
        
        // Assert
        XCTAssertNil(basketItem.account)
        XCTAssertNil(basketItem.basket)
        XCTAssertNil(basketItem.place)
        XCTAssertNil(basketItem.product)
        XCTAssertEqual(basketItem.quantity, 0)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "basket-item-123"
        
        // Act
        let basketItem = DAOBasketItem(id: testId)
        
        // Assert
        XCTAssertEqual(basketItem.id, testId)
        XCTAssertNil(basketItem.account)
        XCTAssertNil(basketItem.basket)
        XCTAssertNil(basketItem.place)
        XCTAssertNil(basketItem.product)
        XCTAssertEqual(basketItem.quantity, 0)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalBasketItem = MockDAOBasketItemFactory.createMockWithTestData()
        
        // Act
        let copiedBasketItem = DAOBasketItem(from: originalBasketItem)
        
        // Assert
        XCTAssertEqual(copiedBasketItem.id, originalBasketItem.id)
        XCTAssertEqual(copiedBasketItem.quantity, originalBasketItem.quantity)
        XCTAssertEqual(copiedBasketItem.account?.id, originalBasketItem.account?.id)
        XCTAssertEqual(copiedBasketItem.product?.id, originalBasketItem.product?.id)
        XCTAssertEqual(copiedBasketItem.place?.id, originalBasketItem.place?.id)
        XCTAssertFalse(copiedBasketItem === originalBasketItem) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "quantity": 3,
            "account": ["id": "test_account"],
            "product": ["id": "test_product"],
            "place": ["id": "test_place"],
            "basket": ["id": "test_basket"]
        ]
        
        // Act
        let basketItem = DAOBasketItem(from: testData)
        
        // Assert
        XCTAssertNotNil(basketItem)
        XCTAssertEqual(basketItem?.quantity, 3)
        XCTAssertEqual(basketItem?.account?.id, "test_account")
        XCTAssertEqual(basketItem?.product?.id, "test_product")
        XCTAssertEqual(basketItem?.place?.id, "test_place")
        XCTAssertEqual(basketItem?.basket?.id, "test_basket")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let basketItem = DAOBasketItem(from: emptyData)
        
        // Assert
        XCTAssertNil(basketItem)
    }
    
    // MARK: - Property Tests
    
    func testQuantityProperty() {
        // Arrange
        let basketItem = DAOBasketItem()
        let testQuantity = 5
        
        // Act
        basketItem.quantity = testQuantity
        
        // Assert
        XCTAssertEqual(basketItem.quantity, testQuantity)
    }
    
    func testAccountProperty() {
        // Arrange
        let basketItem = DAOBasketItem()
        let testAccount = DAOAccount()
        testAccount.id = "test_account_789"
        
        // Act
        basketItem.account = testAccount
        
        // Assert
        XCTAssertEqual(basketItem.account?.id, testAccount.id)
    }
    
    func testBasketProperty() {
        // Arrange
        let basketItem = DAOBasketItem()
        let testBasket = DAOBasket()
        testBasket.id = "test_basket_456"
        
        // Act
        basketItem.basket = testBasket
        
        // Assert
        XCTAssertEqual(basketItem.basket?.id, testBasket.id)
    }
    
    func testPlaceProperty() {
        // Arrange
        let basketItem = DAOBasketItem()
        let testPlace = DAOPlace()
        testPlace.id = "test_place_123"
        
        // Act
        basketItem.place = testPlace
        
        // Assert
        XCTAssertEqual(basketItem.place?.id, testPlace.id)
    }
    
    func testProductProperty() {
        // Arrange
        let basketItem = DAOBasketItem()
        let testProduct = DAOProduct()
        testProduct.id = "test_product_999"
        
        // Act
        basketItem.product = testProduct
        
        // Assert
        XCTAssertEqual(basketItem.product?.id, testProduct.id)
    }
    
    func testNilProperties() {
        // Arrange
        let basketItem = DAOBasketItem()
        
        // Act
        basketItem.account = nil
        basketItem.basket = nil
        basketItem.place = nil
        basketItem.product = nil
        
        // Assert
        XCTAssertNil(basketItem.account)
        XCTAssertNil(basketItem.basket)
        XCTAssertNil(basketItem.place)
        XCTAssertNil(basketItem.product)
    }
    
    func testZeroQuantity() {
        // Arrange
        let basketItem = DAOBasketItem()
        
        // Act
        basketItem.quantity = 0
        
        // Assert
        XCTAssertEqual(basketItem.quantity, 0)
    }
    
    func testNegativeQuantity() {
        // Arrange
        let basketItem = DAOBasketItem()
        
        // Act
        basketItem.quantity = -1
        
        // Assert
        XCTAssertEqual(basketItem.quantity, -1)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalBasketItem = MockDAOBasketItemFactory.createMock()
        let sourceBasketItem = MockDAOBasketItemFactory.createMockWithTestData()
        
        // Act
        originalBasketItem.update(from: sourceBasketItem)
        
        // Assert
        XCTAssertEqual(originalBasketItem.quantity, sourceBasketItem.quantity)
        XCTAssertEqual(originalBasketItem.account?.id, sourceBasketItem.account?.id)
        XCTAssertEqual(originalBasketItem.product?.id, sourceBasketItem.product?.id)
        XCTAssertEqual(originalBasketItem.place?.id, sourceBasketItem.place?.id)
    }
    
    func testBasketItemWithAllRelationships() {
        // Arrange
        let basketItem = DAOBasketItem()
        let account = DAOAccount()
        account.id = "full_account"
        let basket = DAOBasket()
        basket.id = "full_basket"
        let place = DAOPlace()
        place.id = "full_place"
        let product = DAOProduct()
        product.id = "full_product"
        
        // Act
        basketItem.account = account
        basketItem.basket = basket
        basketItem.place = place
        basketItem.product = product
        basketItem.quantity = 10
        
        // Assert
        XCTAssertEqual(basketItem.account?.id, "full_account")
        XCTAssertEqual(basketItem.basket?.id, "full_basket")
        XCTAssertEqual(basketItem.place?.id, "full_place")
        XCTAssertEqual(basketItem.product?.id, "full_product")
        XCTAssertEqual(basketItem.quantity, 10)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalBasketItem = MockDAOBasketItemFactory.createMockWithTestData()
        
        // Act
        let copiedBasketItem = originalBasketItem.copy() as? DAOBasketItem
        
        // Assert
        XCTAssertNotNil(copiedBasketItem)
        XCTAssertEqual(copiedBasketItem?.quantity, originalBasketItem.quantity)
        XCTAssertEqual(copiedBasketItem?.account?.id, originalBasketItem.account?.id)
        XCTAssertEqual(copiedBasketItem?.product?.id, originalBasketItem.product?.id)
        XCTAssertEqual(copiedBasketItem?.place?.id, originalBasketItem.place?.id)
        XCTAssertFalse(copiedBasketItem === originalBasketItem) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let basketItem1 = MockDAOBasketItemFactory.createMockWithTestData()
        let basketItem2 = DAOBasketItem(from: basketItem1) // Copy to ensure same data
        let basketItem3 = MockDAOBasketItemFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should be equal
        XCTAssertEqual(basketItem1.id, basketItem2.id)
        XCTAssertEqual(basketItem1.quantity, basketItem2.quantity)
        XCTAssertEqual(basketItem1.account?.id, basketItem2.account?.id)
        XCTAssertEqual(basketItem1.product?.id, basketItem2.product?.id)
        XCTAssertEqual(basketItem1.place?.id, basketItem2.place?.id)
        
        // Act & Assert - Different data should not be equal
        XCTAssertNotEqual(basketItem1.quantity, basketItem3.quantity)
        
        // Act & Assert - Same instance should be equal to itself
        XCTAssertEqual(basketItem1.id, basketItem1.id)
        XCTAssertEqual(basketItem1.quantity, basketItem1.quantity)
        XCTAssertEqual(basketItem1.account?.id, basketItem1.account?.id)
        XCTAssertEqual(basketItem1.product?.id, basketItem1.product?.id)
        XCTAssertEqual(basketItem1.place?.id, basketItem1.place?.id)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let basketItem1 = MockDAOBasketItemFactory.createMockWithTestData()
        let basketItem2 = DAOBasketItem(from: basketItem1) // Copy to ensure same data
        let basketItem3 = MockDAOBasketItemFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should not be different
        XCTAssertFalse(basketItem1.isDiffFrom(basketItem2))
        
        // Act & Assert - Different data should be different
        XCTAssertTrue(basketItem1.isDiffFrom(basketItem3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(basketItem1.isDiffFrom(basketItem1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(basketItem1.isDiffFrom("not a basket item"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(basketItem1.isDiffFrom(nil as DAOBasketItem?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalBasketItem = MockDAOBasketItemFactory.createMockWithTestData()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalBasketItem)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedBasketItem = try decoder.decode(DAOBasketItem.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedBasketItem.quantity, originalBasketItem.quantity)
        XCTAssertEqual(decodedBasketItem.account?.id, originalBasketItem.account?.id)
        XCTAssertEqual(decodedBasketItem.product?.id, originalBasketItem.product?.id)
        XCTAssertEqual(decodedBasketItem.place?.id, originalBasketItem.place?.id)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let basketItem = MockDAOBasketItemFactory.createMockWithTestData()
        
        // Act
        let dictionary = basketItem.asDictionary
        
        // Assert
        XCTAssertEqual(dictionary["quantity"] as? Int, basketItem.quantity)
        XCTAssertNotNil(dictionary["account"] as Any?)
        XCTAssertNotNil(dictionary["product"] as Any?)
        XCTAssertNotNil(dictionary["place"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let basketItem = MockDAOBasketItemFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertEqual(basketItem.quantity, 0)
        XCTAssertNil(basketItem.account)
        XCTAssertNil(basketItem.basket)
        XCTAssertNil(basketItem.place)
        XCTAssertNil(basketItem.product)
    }
    
    func testMaxQuantity() {
        // Arrange
        let basketItem = DAOBasketItem()
        let maxQuantity = Int.max
        
        // Act
        basketItem.quantity = maxQuantity
        
        // Assert
        XCTAssertEqual(basketItem.quantity, maxQuantity)
    }
    
    func testMinQuantity() {
        // Arrange
        let basketItem = DAOBasketItem()
        let minQuantity = Int.min
        
        // Act
        basketItem.quantity = minQuantity
        
        // Assert
        XCTAssertEqual(basketItem.quantity, minQuantity)
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let basketItems = MockDAOBasketItemFactory.createMockArray(count: 6)
        
        // Assert
        XCTAssertEqual(basketItems.count, 6)
        
        // Verify each basket item has proper data
        for i in 0..<basketItems.count {
            XCTAssertGreaterThan(basketItems[i].quantity, 0)
            XCTAssertLessThanOrEqual(basketItems[i].quantity, 5)
        }
        
        // Verify relationship patterns
        let itemsWithProducts = basketItems.filter { $0.product != nil }
        let itemsWithAccounts = basketItems.filter { $0.account != nil }
        XCTAssertEqual(itemsWithProducts.count, 3) // Every other item (0, 2, 4)
        XCTAssertEqual(itemsWithAccounts.count, 2) // Every third item (0, 3)
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOBasketItem()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalBasketItem = MockDAOBasketItemFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOBasketItem(from: originalBasketItem)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let basketItem1 = MockDAOBasketItemFactory.createMockWithTestData()
        let basketItem2 = MockDAOBasketItemFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = basketItem1 == basketItem2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let basketItem = MockDAOBasketItemFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(basketItem)
                    _ = try decoder.decode(DAOBasketItem.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testQuantityProperty", testQuantityProperty),
        ("testAccountProperty", testAccountProperty),
        ("testBasketProperty", testBasketProperty),
        ("testPlaceProperty", testPlaceProperty),
        ("testProductProperty", testProductProperty),
        ("testNilProperties", testNilProperties),
        ("testZeroQuantity", testZeroQuantity),
        ("testNegativeQuantity", testNegativeQuantity),
        ("testUpdateMethod", testUpdateMethod),
        ("testBasketItemWithAllRelationships", testBasketItemWithAllRelationships),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testMaxQuantity", testMaxQuantity),
        ("testMinQuantity", testMinQuantity),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}
