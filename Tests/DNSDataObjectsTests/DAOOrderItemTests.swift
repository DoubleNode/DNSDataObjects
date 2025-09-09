//
//  DAOOrderItemTests.swift
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

final class DAOOrderItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let orderItem = DAOOrderItem()
        
        // Assert
        XCTAssertEqual(orderItem.quantity, 0)
        XCTAssertNil(orderItem.account)
        XCTAssertNil(orderItem.order)
        XCTAssertNil(orderItem.place)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "order-item-123"
        
        // Act
        let orderItem = DAOOrderItem(id: testId)
        
        // Assert
        XCTAssertEqual(orderItem.id, testId)
        XCTAssertEqual(orderItem.quantity, 0)
        XCTAssertNil(orderItem.account)
        XCTAssertNil(orderItem.order)
        XCTAssertNil(orderItem.place)
    }
    
    func testInitializationFromDAOProduct() {
        // Arrange
        let product = DAOProduct()
        product.id = "product_123"
        
        // Act
        let orderItem = DAOOrderItem(from: product)
        
        // Assert
        XCTAssertEqual(orderItem.id, "product_123")
        XCTAssertEqual(orderItem.quantity, 1)
        XCTAssertNil(orderItem.account)
        XCTAssertNil(orderItem.order)
        XCTAssertNil(orderItem.place)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalOrderItem = MockDAOOrderItemFactory.createMockWithTestData()
        
        // Act
        let copiedOrderItem = DAOOrderItem(from: originalOrderItem)
        
        // Assert
        XCTAssertEqual(copiedOrderItem.id, originalOrderItem.id)
        XCTAssertEqual(copiedOrderItem.quantity, originalOrderItem.quantity)
        XCTAssertEqual(copiedOrderItem.account?.id, originalOrderItem.account?.id)
        XCTAssertEqual(copiedOrderItem.order?.id, originalOrderItem.order?.id)
        XCTAssertEqual(copiedOrderItem.place?.id, originalOrderItem.place?.id)
        XCTAssertFalse(copiedOrderItem === originalOrderItem)
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "quantity": 3,
            "account": ["id": "account_test"],
            "order": ["id": "order_test"],
            "place": ["id": "place_test"]
        ]
        
        // Act
        let orderItem = DAOOrderItem(from: testData)
        
        // Assert
        XCTAssertNotNil(orderItem)
        XCTAssertEqual(orderItem?.quantity, 3)
        XCTAssertEqual(orderItem?.account?.id, "account_test")
        XCTAssertEqual(orderItem?.order?.id, "order_test")
        XCTAssertEqual(orderItem?.place?.id, "place_test")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let orderItem = DAOOrderItem(from: emptyData)
        
        // Assert
        XCTAssertNil(orderItem)
    }
    
    // MARK: - Property Tests
    
    func testQuantityProperty() {
        // Arrange
        let orderItem = DAOOrderItem()
        
        // Act & Assert
        orderItem.quantity = 5
        XCTAssertEqual(orderItem.quantity, 5)
        
        orderItem.quantity = 0
        XCTAssertEqual(orderItem.quantity, 0)
        
        orderItem.quantity = 100
        XCTAssertEqual(orderItem.quantity, 100)
        
        orderItem.quantity = -1
        XCTAssertEqual(orderItem.quantity, -1)
    }
    
    func testAccountProperty() {
        // Arrange
        let orderItem = DAOOrderItem()
        let testAccount = DAOAccount()
        testAccount.id = "test_account"
        testAccount.name = PersonNameComponents.dnsBuildName(with: "John Doe") ?? PersonNameComponents()
        
        // Act
        orderItem.account = testAccount
        
        // Assert
        XCTAssertNotNil(orderItem.account)
        XCTAssertEqual(orderItem.account?.id, "test_account")
        XCTAssertEqual(orderItem.account?.name, testAccount.name)
    }
    
    func testOrderProperty() {
        // Arrange
        let orderItem = DAOOrderItem()
        let testOrder = DAOOrder()
        testOrder.id = "test_order"
        
        // Act
        orderItem.order = testOrder
        
        // Assert
        XCTAssertNotNil(orderItem.order)
        XCTAssertEqual(orderItem.order?.id, "test_order")
    }
    
    func testPlaceProperty() {
        // Arrange
        let orderItem = DAOOrderItem()
        let testPlace = DAOPlace()
        testPlace.id = "test_place"
        testPlace.name = DNSString(with: "Test Place")
        testPlace.code = "TEST"
        
        // Act
        orderItem.place = testPlace
        
        // Assert
        XCTAssertNotNil(orderItem.place)
        XCTAssertEqual(orderItem.place?.id, "test_place")
        XCTAssertEqual(orderItem.place?.name.asString, "Test Place")
        XCTAssertEqual(orderItem.place?.code, "TEST")
    }
    
    func testNullPropertiesHandling() {
        // Arrange
        let orderItem = DAOOrderItem()
        
        // Act
        orderItem.account = nil
        orderItem.order = nil
        orderItem.place = nil
        
        // Assert
        XCTAssertNil(orderItem.account)
        XCTAssertNil(orderItem.order)
        XCTAssertNil(orderItem.place)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalOrderItem = MockDAOOrderItemFactory.createMock()
        let sourceOrderItem = MockDAOOrderItemFactory.createMockWithTestData()
        
        // Act
        originalOrderItem.update(from: sourceOrderItem)
        
        // Assert
        XCTAssertEqual(originalOrderItem.quantity, sourceOrderItem.quantity)
        XCTAssertEqual(originalOrderItem.account?.id, sourceOrderItem.account?.id)
        XCTAssertEqual(originalOrderItem.order?.id, sourceOrderItem.order?.id)
        XCTAssertEqual(originalOrderItem.place?.id, sourceOrderItem.place?.id)
    }
    
    func testQuantityCalculations() {
        // Arrange
        let orderItem1 = MockDAOOrderItemFactory.createWithQuantity(5)
        let orderItem2 = MockDAOOrderItemFactory.createWithQuantity(3)
        
        // Act
        let totalQuantity = orderItem1.quantity + orderItem2.quantity
        
        // Assert
        XCTAssertEqual(totalQuantity, 8)
    }
    
    func testZeroQuantityHandling() {
        // Arrange & Act
        let orderItem = MockDAOOrderItemFactory.createZeroQuantityItem()
        
        // Assert
        XCTAssertEqual(orderItem.quantity, 0)
        XCTAssertNotNil(orderItem.account)
        XCTAssertNotNil(orderItem.place)
        XCTAssertNotNil(orderItem.order)
    }
    
    func testHighQuantityHandling() {
        // Arrange & Act
        let orderItem = MockDAOOrderItemFactory.createHighQuantityItem()
        
        // Assert
        XCTAssertEqual(orderItem.quantity, 100)
        XCTAssertNotNil(orderItem.account)
        XCTAssertNotNil(orderItem.place)
        XCTAssertNotNil(orderItem.order)
    }
    
    func testOrderItemWithCompleteRelations() {
        // Arrange
        let orderItem = DAOOrderItem()
        orderItem.quantity = 2
        
        let account = DAOAccount()
        account.id = "customer_123"
        orderItem.account = account
        
        let order = DAOOrder()
        order.id = "order_456"
        orderItem.order = order
        
        let place = DAOPlace()
        place.id = "store_789"
        orderItem.place = place
        
        // Act & Assert
        XCTAssertEqual(orderItem.quantity, 2)
        XCTAssertEqual(orderItem.account?.id, "customer_123")
        XCTAssertEqual(orderItem.order?.id, "order_456")
        XCTAssertEqual(orderItem.place?.id, "store_789")
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalOrderItem = MockDAOOrderItemFactory.createMockWithTestData()
        
        // Act
        let copiedOrderItem = originalOrderItem.copy() as? DAOOrderItem
        
        // Assert
        XCTAssertNotNil(copiedOrderItem)
        XCTAssertEqual(copiedOrderItem?.quantity, originalOrderItem.quantity)
        XCTAssertEqual(copiedOrderItem?.account?.id, originalOrderItem.account?.id)
        XCTAssertEqual(copiedOrderItem?.order?.id, originalOrderItem.order?.id)
        XCTAssertEqual(copiedOrderItem?.place?.id, originalOrderItem.place?.id)
        XCTAssertFalse(copiedOrderItem === originalOrderItem)
    }
    
    func testEquatableCompliance() {
        // Arrange
        let orderItem1 = MockDAOOrderItemFactory.createMockWithTestData()
        let orderItem2 = DAOOrderItem(from: orderItem1)
        let orderItem3 = MockDAOOrderItemFactory.createMockWithEdgeCases()
        
        // Act & Assert
        XCTAssertTrue(orderItem1 == orderItem2)
        XCTAssertFalse(orderItem1 != orderItem2)
        XCTAssertFalse(orderItem1 == orderItem3)
        XCTAssertTrue(orderItem1 != orderItem3)
        XCTAssertTrue(orderItem1 == orderItem1)
        XCTAssertFalse(orderItem1 != orderItem1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let orderItem1 = MockDAOOrderItemFactory.createMockWithTestData()
        let orderItem2 = DAOOrderItem(from: orderItem1)
        let orderItem3 = MockDAOOrderItemFactory.createMockWithEdgeCases()
        
        // Act & Assert
        XCTAssertFalse(orderItem1.isDiffFrom(orderItem2))
        XCTAssertTrue(orderItem1.isDiffFrom(orderItem3))
        XCTAssertFalse(orderItem1.isDiffFrom(orderItem1))
        XCTAssertTrue(orderItem1.isDiffFrom("not an order item"))
        XCTAssertTrue(orderItem1.isDiffFrom(nil as DAOOrderItem?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalOrderItem = MockDAOOrderItemFactory.createMockWithTestData()
        
        // Act
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalOrderItem)
        let decoder = JSONDecoder()
        let decodedOrderItem = try decoder.decode(DAOOrderItem.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedOrderItem.quantity, originalOrderItem.quantity)
        XCTAssertEqual(decodedOrderItem.account?.id, originalOrderItem.account?.id)
        XCTAssertEqual(decodedOrderItem.order?.id, originalOrderItem.order?.id)
        XCTAssertEqual(decodedOrderItem.place?.id, originalOrderItem.place?.id)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let orderItem = MockDAOOrderItemFactory.createMockWithTestData()
        
        // Act
        let dictionary = orderItem.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["quantity"] as Any?)
        XCTAssertNotNil(dictionary["account"] as Any?)
        XCTAssertNotNil(dictionary["order"] as Any?)
        XCTAssertNotNil(dictionary["place"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let orderItem = MockDAOOrderItemFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertEqual(orderItem.quantity, 0)
        XCTAssertNil(orderItem.account)
        XCTAssertNil(orderItem.order)
        XCTAssertNil(orderItem.place)
    }
    
    func testNegativeQuantityHandling() {
        // Arrange
        let orderItem = DAOOrderItem()
        
        // Act
        orderItem.quantity = -5
        
        // Assert
        XCTAssertEqual(orderItem.quantity, -5)
        XCTAssertNotNil(orderItem.asDictionary)
    }
    
    func testVeryLargeQuantityHandling() {
        // Arrange
        let orderItem = DAOOrderItem()
        let largeQuantity = Int.max
        
        // Act
        orderItem.quantity = largeQuantity
        
        // Assert
        XCTAssertEqual(orderItem.quantity, largeQuantity)
    }
    
    func testPartialRelationships() {
        // Arrange
        let orderItem = DAOOrderItem()
        orderItem.quantity = 3
        
        let account = DAOAccount()
        account.id = "partial_account"
        orderItem.account = account
        // Leave order and place as nil
        
        // Act & Assert
        XCTAssertEqual(orderItem.quantity, 3)
        XCTAssertNotNil(orderItem.account)
        XCTAssertEqual(orderItem.account?.id, "partial_account")
        XCTAssertNil(orderItem.order)
        XCTAssertNil(orderItem.place)
        XCTAssertNotNil(orderItem.asDictionary)
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let orderItems = MockDAOOrderItemFactory.createMockArray(count: 6)
        
        // Assert
        XCTAssertEqual(orderItems.count, 6)
        
        for i in 0..<orderItems.count {
            XCTAssertEqual(orderItems[i].id, "order_item_\(i + 1)")
            XCTAssertEqual(orderItems[i].quantity, (i % 5) + 1)
            
            // Every other item has an account
            if i % 2 == 0 {
                XCTAssertNotNil(orderItems[i].account)
                XCTAssertEqual(orderItems[i].account?.id, "account_\(i + 1)")
            } else {
                XCTAssertNil(orderItems[i].account)
            }
            
            // Every third item has a place
            if i % 3 == 0 {
                XCTAssertNotNil(orderItems[i].place)
                XCTAssertEqual(orderItems[i].place?.id, "place_\(i + 1)")
            } else {
                XCTAssertNil(orderItems[i].place)
            }
        }
    }
    
    func testArrayDifferencesDetection() {
        // Arrange
        let orderItems1 = MockDAOOrderItemFactory.createMockArray(count: 3)
        let orderItems2: [DAOOrderItem] = orderItems1.map { DAOOrderItem(from: $0) }
        let orderItems3 = MockDAOOrderItemFactory.createMockArray(count: 4)
        
        // Act & Assert
        XCTAssertFalse(orderItems1.hasDiffElementsFrom(orderItems2))
        XCTAssertTrue(orderItems1.hasDiffElementsFrom(orderItems3))
    }
    
    func testOrderItemSummation() {
        // Arrange
        let orderItems = [
            MockDAOOrderItemFactory.createWithQuantity(2),
            MockDAOOrderItemFactory.createWithQuantity(5),
            MockDAOOrderItemFactory.createWithQuantity(3)
        ]
        
        // Act
        let totalQuantity = orderItems.reduce(0) { $0 + $1.quantity }
        
        // Assert
        XCTAssertEqual(totalQuantity, 10)
    }
    
    // MARK: - Factory Method Tests
    
    func testLegacyFactoryMethods() {
        // Arrange & Act
        let orderItem1 = MockDAOOrderItemFactory.create()
        let orderItem2 = MockDAOOrderItemFactory.createEmpty()
        let orderItem3 = MockDAOOrderItemFactory.createWithId("custom_id")
        
        // Assert
        XCTAssertNotNil(orderItem1.account)
        XCTAssertNotNil(orderItem1.place)
        XCTAssertNotNil(orderItem1.order)
        
        XCTAssertNil(orderItem2.account)
        XCTAssertNil(orderItem2.place)
        XCTAssertNil(orderItem2.order)
        XCTAssertEqual(orderItem2.quantity, 0)
        
        XCTAssertEqual(orderItem3.id, "custom_id")
        XCTAssertNotNil(orderItem3.account)
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOOrderItem()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalOrderItem = MockDAOOrderItemFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOOrderItem(from: originalOrderItem)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let orderItem1 = MockDAOOrderItemFactory.createMockWithTestData()
        let orderItem2 = MockDAOOrderItemFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = orderItem1 == orderItem2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let orderItem = MockDAOOrderItemFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(orderItem)
                    _ = try decoder.decode(DAOOrderItem.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
    
    func testQuantitySummationPerformance() {
        // Arrange
        let orderItems = MockDAOOrderItemFactory.createMockArray(count: 1000)
        
        measure {
            _ = orderItems.reduce(0) { $0 + $1.quantity }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testInitializationFromDAOProduct", testInitializationFromDAOProduct),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testQuantityProperty", testQuantityProperty),
        ("testAccountProperty", testAccountProperty),
        ("testOrderProperty", testOrderProperty),
        ("testPlaceProperty", testPlaceProperty),
        ("testNullPropertiesHandling", testNullPropertiesHandling),
        ("testUpdateMethod", testUpdateMethod),
        ("testQuantityCalculations", testQuantityCalculations),
        ("testZeroQuantityHandling", testZeroQuantityHandling),
        ("testHighQuantityHandling", testHighQuantityHandling),
        ("testOrderItemWithCompleteRelations", testOrderItemWithCompleteRelations),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testNegativeQuantityHandling", testNegativeQuantityHandling),
        ("testVeryLargeQuantityHandling", testVeryLargeQuantityHandling),
        ("testPartialRelationships", testPartialRelationships),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testArrayDifferencesDetection", testArrayDifferencesDetection),
        ("testOrderItemSummation", testOrderItemSummation),
        ("testLegacyFactoryMethods", testLegacyFactoryMethods),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
        ("testQuantitySummationPerformance", testQuantitySummationPerformance),
    ]
}
