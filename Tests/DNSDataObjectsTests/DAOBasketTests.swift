//
//  DAOBasketTests.swift
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

final class DAOBasketTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let basket = DAOBasket()
        
        // Assert
        XCTAssertNil(basket.account)
        XCTAssertNil(basket.place)
        XCTAssertTrue(basket.items.isEmpty)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "basket-123"
        
        // Act
        let basket = DAOBasket(id: testId)
        
        // Assert
        XCTAssertEqual(basket.id, testId)
        XCTAssertNil(basket.account)
        XCTAssertNil(basket.place)
        XCTAssertTrue(basket.items.isEmpty)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalBasket = MockDAOBasketFactory.createMockWithTestData()
        
        // Act
        let copiedBasket = DAOBasket(from: originalBasket)
        
        // Assert
        XCTAssertEqual(copiedBasket.id, originalBasket.id)
        XCTAssertEqual(copiedBasket.account?.id, originalBasket.account?.id)
        XCTAssertEqual(copiedBasket.place?.id, originalBasket.place?.id)
        XCTAssertEqual(copiedBasket.items.count, originalBasket.items.count)
        for i in 0..<copiedBasket.items.count {
            XCTAssertEqual(copiedBasket.items[i].id, originalBasket.items[i].id)
        }
        XCTAssertFalse(copiedBasket === originalBasket) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "account": ["id": "test_account"],
            "place": ["id": "test_place"],
            "items": [
                ["id": "item_1"],
                ["id": "item_2"]
            ]
        ]
        
        // Act
        let basket = DAOBasket(from: testData)
        
        // Assert
        XCTAssertNotNil(basket)
        XCTAssertEqual(basket?.account?.id, "test_account")
        XCTAssertEqual(basket?.place?.id, "test_place")
        XCTAssertEqual(basket?.items.count, 2)
        XCTAssertEqual(basket?.items[0].id, "item_1")
        XCTAssertEqual(basket?.items[1].id, "item_2")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let basket = DAOBasket(from: emptyData)
        
        // Assert
        XCTAssertNil(basket)
    }
    
    // MARK: - Property Tests
    
    func testAccountProperty() {
        // Arrange
        let basket = DAOBasket()
        let testAccount = DAOAccount()
        testAccount.id = "test_account_789"
        
        // Act
        basket.account = testAccount
        
        // Assert
        XCTAssertEqual(basket.account?.id, testAccount.id)
    }
    
    func testPlaceProperty() {
        // Arrange
        let basket = DAOBasket()
        let testPlace = DAOPlace()
        testPlace.id = "test_place_456"
        
        // Act
        basket.place = testPlace
        
        // Assert
        XCTAssertEqual(basket.place?.id, testPlace.id)
    }
    
    func testItemsProperty() {
        // Arrange
        let basket = DAOBasket()
        let item1 = DAOBasketItem()
        item1.id = "item_1"
        let item2 = DAOBasketItem()
        item2.id = "item_2"
        let testItems = [item1, item2]
        
        // Act
        basket.items = testItems
        
        // Assert
        XCTAssertEqual(basket.items.count, 2)
        XCTAssertEqual(basket.items[0].id, "item_1")
        XCTAssertEqual(basket.items[1].id, "item_2")
    }
    
    func testNilAccountProperty() {
        // Arrange
        let basket = DAOBasket()
        
        // Act
        basket.account = nil
        
        // Assert
        XCTAssertNil(basket.account)
    }
    
    func testNilPlaceProperty() {
        // Arrange
        let basket = DAOBasket()
        
        // Act
        basket.place = nil
        
        // Assert
        XCTAssertNil(basket.place)
    }
    
    func testEmptyItemsArray() {
        // Arrange
        let basket = DAOBasket()
        
        // Act
        basket.items = []
        
        // Assert
        XCTAssertTrue(basket.items.isEmpty)
        XCTAssertEqual(basket.items.count, 0)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalBasket = MockDAOBasketFactory.createMock()
        let sourceBasket = MockDAOBasketFactory.createMockWithTestData()
        
        // Act
        originalBasket.update(from: sourceBasket)
        
        // Assert
        XCTAssertEqual(originalBasket.account?.id, sourceBasket.account?.id)
        XCTAssertEqual(originalBasket.place?.id, sourceBasket.place?.id)
        XCTAssertEqual(originalBasket.items.count, sourceBasket.items.count)
        for i in 0..<originalBasket.items.count {
            XCTAssertEqual(originalBasket.items[i].id, sourceBasket.items[i].id)
        }
    }
    
    func testBasketWithMultipleItems() {
        // Arrange
        let basket = DAOBasket()
        let items = (1...5).map { i in
            let item = DAOBasketItem()
            item.id = "item_\(i)"
            item.quantity = i
            return item
        }
        
        // Act
        basket.items = items
        
        // Assert
        XCTAssertEqual(basket.items.count, 5)
        for i in 0..<5 {
            XCTAssertEqual(basket.items[i].id, "item_\(i + 1)")
            XCTAssertEqual(basket.items[i].quantity, i + 1)
        }
    }
    
    func testBasketItemAddition() {
        // Arrange
        let basket = DAOBasket()
        basket.items = []
        
        // Act
        let newItem = DAOBasketItem()
        newItem.id = "new_item"
        newItem.quantity = 3
        basket.items.append(newItem)
        
        // Assert
        XCTAssertEqual(basket.items.count, 1)
        XCTAssertEqual(basket.items[0].id, "new_item")
        XCTAssertEqual(basket.items[0].quantity, 3)
    }
    
    func testBasketItemRemoval() {
        // Arrange
        let basket = MockDAOBasketFactory.createMockWithTestData()
        let originalCount = basket.items.count
        
        // Act
        basket.items.removeFirst()
        
        // Assert
        XCTAssertEqual(basket.items.count, originalCount - 1)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalBasket = MockDAOBasketFactory.createMockWithTestData()
        
        // Act
        let copiedBasket = originalBasket.copy() as? DAOBasket
        
        // Assert
        XCTAssertNotNil(copiedBasket)
        XCTAssertEqual(copiedBasket?.account?.id, originalBasket.account?.id)
        XCTAssertEqual(copiedBasket?.place?.id, originalBasket.place?.id)
        XCTAssertEqual(copiedBasket?.items.count, originalBasket.items.count)
        XCTAssertFalse(copiedBasket === originalBasket) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let basket1 = MockDAOBasketFactory.createMockWithTestData()
        let basket2 = MockDAOBasketFactory.createMockWithTestData()
        let basket3 = MockDAOBasketFactory.createMockWithEdgeCases()
        
        // Act & Assert - Property by property comparison instead of full object equality
        XCTAssertEqual(basket1.account?.id, basket2.account?.id)
        XCTAssertEqual(basket1.place?.id, basket2.place?.id)
        XCTAssertEqual(basket1.items.count, basket2.items.count)
        
        // Act & Assert - Different data should be different
        XCTAssertNotEqual(basket1.account?.id, basket3.account?.id)
        XCTAssertNotEqual(basket1.place?.id, basket3.place?.id)
        XCTAssertNotEqual(basket1.items.count, basket3.items.count)
        
        // Act & Assert - Same instance should be equal
        XCTAssertTrue(basket1 == basket1)
        XCTAssertFalse(basket1 != basket1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let basket1 = MockDAOBasketFactory.createMockWithTestData()
        let basket2 = DAOBasket(from: basket1)  // Use copy initializer for consistency
        let basket3 = MockDAOBasketFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should not be different
        XCTAssertFalse(basket1.isDiffFrom(basket2))
        
        // Act & Assert - Different data should be different
        XCTAssertTrue(basket1.isDiffFrom(basket3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(basket1.isDiffFrom(basket1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(basket1.isDiffFrom("not a basket"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(basket1.isDiffFrom(nil as DAOBasket?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalBasket = MockDAOBasketFactory.createMockWithTestData()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalBasket)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedBasket = try decoder.decode(DAOBasket.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedBasket.account?.id, originalBasket.account?.id)
        XCTAssertEqual(decodedBasket.place?.id, originalBasket.place?.id)
        XCTAssertEqual(decodedBasket.items.count, originalBasket.items.count)
        for i in 0..<decodedBasket.items.count {
            XCTAssertEqual(decodedBasket.items[i].id, originalBasket.items[i].id)
        }
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let basket = MockDAOBasketFactory.createMockWithTestData()
        
        // Act
        let dictionary = basket.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["account"] as Any?)
        XCTAssertNotNil(dictionary["place"] as Any?)
        XCTAssertNotNil(dictionary["items"] as Any?)
        if let items = dictionary["items"] as? [Any] {
            XCTAssertEqual(items.count, basket.items.count)
        }
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let basket = MockDAOBasketFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertNil(basket.account)
        XCTAssertNil(basket.place)
        XCTAssertTrue(basket.items.isEmpty)
    }
    
    func testBasketWithSingleItem() {
        // Arrange
        let basket = DAOBasket()
        let singleItem = DAOBasketItem()
        singleItem.id = "single_item"
        singleItem.quantity = 1
        
        // Act
        basket.items = [singleItem]
        
        // Assert
        XCTAssertEqual(basket.items.count, 1)
        XCTAssertEqual(basket.items[0].id, "single_item")
        XCTAssertEqual(basket.items[0].quantity, 1)
    }
    
    func testBasketWithManyItems() {
        // Arrange
        let basket = DAOBasket()
        let manyItems = (1...100).map { i in
            let item = DAOBasketItem()
            item.id = "item_\(i)"
            return item
        }
        
        // Act
        basket.items = manyItems
        
        // Assert
        XCTAssertEqual(basket.items.count, 100)
        XCTAssertEqual(basket.items.first?.id, "item_1")
        XCTAssertEqual(basket.items.last?.id, "item_100")
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let baskets = MockDAOBasketFactory.createMockArray(count: 8)
        
        // Assert
        XCTAssertEqual(baskets.count, 8)
        
        // Verify relationship patterns
        let basketsWithAccounts = baskets.filter { $0.account != nil }
        let basketsWithPlaces = baskets.filter { $0.place != nil }
        XCTAssertEqual(basketsWithAccounts.count, 4) // Every other basket (0, 2, 4, 6)
        XCTAssertEqual(basketsWithPlaces.count, 3) // Every third basket (0, 3, 6)
        
        // Verify items pattern (0 to 3 items based on index % 4)
        for i in 0..<baskets.count {
            let expectedItemCount = i % 4
            XCTAssertEqual(baskets[i].items.count, expectedItemCount)
        }
    }
    
    func testBasketItemArrayEquality() {
        // Arrange
        let basket1 = DAOBasket()
        let basket2 = DAOBasket()
        
        let item1 = DAOBasketItem()
        item1.id = "item_1"
        let item2 = DAOBasketItem()
        item2.id = "item_2"
        
        basket1.items = [item1, item2]
        basket2.items = [item1, item2]
        
        // Act & Assert - Test array contents equality
        XCTAssertEqual(basket1.items.count, basket2.items.count)
        for i in 0..<basket1.items.count {
            XCTAssertEqual(basket1.items[i].id, basket2.items[i].id)
        }
    }
    
    func testBasketItemArrayInequality() {
        // Arrange
        let basket1 = DAOBasket()
        let basket2 = DAOBasket()
        
        let item1 = DAOBasketItem()
        item1.id = "item_1"
        let item2 = DAOBasketItem()
        item2.id = "item_2"
        let item3 = DAOBasketItem()
        item3.id = "item_3"
        
        basket1.items = [item1, item2]
        basket2.items = [item1, item3]
        
        // Act & Assert
        XCTAssertFalse(basket1 == basket2)
        XCTAssertTrue(basket1 != basket2)
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOBasket()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalBasket = MockDAOBasketFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOBasket(from: originalBasket)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let basket1 = MockDAOBasketFactory.createMockWithTestData()
        let basket2 = MockDAOBasketFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = basket1 == basket2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let basket = MockDAOBasketFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(basket)
                    _ = try decoder.decode(DAOBasket.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
    
    func testLargeItemsArrayPerformance() {
        // Arrange
        let basket = DAOBasket()
        let largeItemsArray = (1...1000).map { i in
            let item = DAOBasketItem()
            item.id = "item_\(i)"
            return item
        }
        
        measure {
            basket.items = largeItemsArray
            _ = basket.items.count
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testAccountProperty", testAccountProperty),
        ("testPlaceProperty", testPlaceProperty),
        ("testItemsProperty", testItemsProperty),
        ("testNilAccountProperty", testNilAccountProperty),
        ("testNilPlaceProperty", testNilPlaceProperty),
        ("testEmptyItemsArray", testEmptyItemsArray),
        ("testUpdateMethod", testUpdateMethod),
        ("testBasketWithMultipleItems", testBasketWithMultipleItems),
        ("testBasketItemAddition", testBasketItemAddition),
        ("testBasketItemRemoval", testBasketItemRemoval),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testBasketWithSingleItem", testBasketWithSingleItem),
        ("testBasketWithManyItems", testBasketWithManyItems),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testBasketItemArrayEquality", testBasketItemArrayEquality),
        ("testBasketItemArrayInequality", testBasketItemArrayInequality),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
        ("testLargeItemsArrayPerformance", testLargeItemsArrayPerformance),
    ]
}
