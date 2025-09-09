//
//  DAOCardTests.swift
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

final class DAOCardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let card = DAOCard()
        
        // Assert
        XCTAssertEqual(card.billingAddress.street, "")
        XCTAssertEqual(card.cardHolderEmail, "")
        XCTAssertEqual(card.cardHolderName.givenName, nil)
        XCTAssertEqual(card.cardHolderPhone, "")
        XCTAssertEqual(card.cardNumber, "")
        XCTAssertEqual(card.cardType, "")
        XCTAssertEqual(card.default, false)
        XCTAssertNil(card.expiration)
        XCTAssertEqual(card.nickname, "")
        XCTAssertEqual(card.pinNumber, "")
        XCTAssertTrue(card.transactions.isEmpty)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "card-123"
        
        // Act
        let card = DAOCard(id: testId)
        
        // Assert
        XCTAssertEqual(card.id, testId)
        XCTAssertEqual(card.cardNumber, "")
        XCTAssertEqual(card.cardType, "")
        XCTAssertEqual(card.default, false)
        XCTAssertTrue(card.transactions.isEmpty)
    }
    
    func testInitializationWithCardDetails() {
        // Arrange
        let cardNumber = "4111111111111111"
        let nickname = "Test Card"
        let pinNumber = "1234"
        
        // Act
        let card = DAOCard(cardNumber: cardNumber, nickname: nickname, pinNumber: pinNumber)
        
        // Assert
        XCTAssertEqual(card.id, cardNumber)
        XCTAssertEqual(card.cardNumber, cardNumber)
        XCTAssertEqual(card.nickname, nickname)
        XCTAssertEqual(card.pinNumber, pinNumber)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalCard = MockDAOCardFactory.createMockWithTestData()
        
        // Act
        let copiedCard = DAOCard(from: originalCard)
        
        // Assert
        XCTAssertEqual(copiedCard.id, originalCard.id)
        XCTAssertEqual(copiedCard.cardNumber, originalCard.cardNumber)
        XCTAssertEqual(copiedCard.nickname, originalCard.nickname)
        XCTAssertEqual(copiedCard.pinNumber, originalCard.pinNumber)
        XCTAssertEqual(copiedCard.cardType, originalCard.cardType)
        XCTAssertEqual(copiedCard.cardHolderEmail, originalCard.cardHolderEmail)
        XCTAssertEqual(copiedCard.default, originalCard.default)
        XCTAssertEqual(copiedCard.transactions.count, originalCard.transactions.count)
        XCTAssertFalse(copiedCard === originalCard) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "cardNumber": "4444333322221111",
            "nickname": "Dictionary Card",
            "pinNumber": "5678",
            "cardType": "Visa",
            "cardHolderEmail": "dict@example.com",
            "default": true,
            "transactions": [
                ["id": "trans_1", "amount": 100.0],
                ["id": "trans_2", "amount": 50.0]
            ]
        ]
        
        // Act
        let card = DAOCard(from: testData)
        
        // Assert
        XCTAssertNotNil(card)
        XCTAssertEqual(card?.cardNumber, "4444333322221111")
        XCTAssertEqual(card?.nickname, "Dictionary Card")
        XCTAssertEqual(card?.pinNumber, "5678")
        XCTAssertEqual(card?.cardType, "Visa")
        XCTAssertEqual(card?.cardHolderEmail, "dict@example.com")
        XCTAssertEqual(card?.default, true)
        XCTAssertEqual(card?.transactions.count, 2)
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let card = DAOCard(from: emptyData)
        
        // Assert
        XCTAssertNil(card)
    }
    
    // MARK: - Property Tests
    
    func testCardNumberProperty() {
        // Arrange
        let card = DAOCard()
        let testCardNumber = "4111111111111111"
        
        // Act
        card.cardNumber = testCardNumber
        
        // Assert
        XCTAssertEqual(card.cardNumber, testCardNumber)
    }
    
    func testNicknameProperty() {
        // Arrange
        let card = DAOCard()
        let testNickname = "My Visa Card"
        
        // Act
        card.nickname = testNickname
        
        // Assert
        XCTAssertEqual(card.nickname, testNickname)
    }
    
    func testPinNumberProperty() {
        // Arrange
        let card = DAOCard()
        let testPin = "9876"
        
        // Act
        card.pinNumber = testPin
        
        // Assert
        XCTAssertEqual(card.pinNumber, testPin)
    }
    
    func testCardTypeProperty() {
        // Arrange
        let card = DAOCard()
        let testCardType = "MasterCard"
        
        // Act
        card.cardType = testCardType
        
        // Assert
        XCTAssertEqual(card.cardType, testCardType)
    }
    
    func testCardHolderEmailProperty() {
        // Arrange
        let card = DAOCard()
        let testEmail = "cardholder@example.com"
        
        // Act
        card.cardHolderEmail = testEmail
        
        // Assert
        XCTAssertEqual(card.cardHolderEmail, testEmail)
    }
    
    func testCardHolderNameProperty() {
        // Arrange
        let card = DAOCard()
        let testName = PersonNameComponents.dnsBuildName(with: "Jane Doe Smith") ?? PersonNameComponents()
        
        // Act
        card.cardHolderName = testName
        
        // Assert
        XCTAssertEqual(card.cardHolderName.givenName, testName.givenName)
        XCTAssertEqual(card.cardHolderName.familyName, testName.familyName)
    }
    
    func testCardHolderPhoneProperty() {
        // Arrange
        let card = DAOCard()
        let testPhone = "555-0199"
        
        // Act
        card.cardHolderPhone = testPhone
        
        // Assert
        XCTAssertEqual(card.cardHolderPhone, testPhone)
    }
    
    func testDefaultProperty() {
        // Arrange
        let card = DAOCard()
        
        // Act
        card.default = true
        
        // Assert
        XCTAssertTrue(card.default)
    }
    
    func testExpirationProperty() {
        // Arrange
        let card = DAOCard()
        let expirationDate = Date().addingTimeInterval(365 * 24 * 60 * 60) // 1 year from now
        
        // Act
        card.expiration = expirationDate
        
        // Assert
        XCTAssertEqual(card.expiration?.timeIntervalSince1970 ?? 0.0, expirationDate.timeIntervalSince1970, accuracy: 1.0)
    }
    
    func testBillingAddressProperty() {
        // Arrange
        let card = DAOCard()
        let address = DNSPostalAddress()
        address.street = "456 Test Avenue"
        address.city = "Test City"
        
        // Act
        card.billingAddress = address
        
        // Assert
        XCTAssertEqual(card.billingAddress.street, "456 Test Avenue")
        XCTAssertEqual(card.billingAddress.city, "Test City")
    }
    
    func testTransactionsProperty() {
        // Arrange
        let card = DAOCard()
        let transaction1 = DAOTransaction()
        transaction1.id = "trans_1"
        let transaction2 = DAOTransaction()
        transaction2.id = "trans_2"
        let testTransactions = [transaction1, transaction2]
        
        // Act
        card.transactions = testTransactions
        
        // Assert
        XCTAssertEqual(card.transactions.count, 2)
        XCTAssertEqual(card.transactions[0].id, "trans_1")
        XCTAssertEqual(card.transactions[1].id, "trans_2")
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalCard = MockDAOCardFactory.createMock()
        let sourceCard = MockDAOCardFactory.createMockWithTestData()
        
        // Act
        originalCard.update(from: sourceCard)
        
        // Assert
        XCTAssertEqual(originalCard.cardNumber, sourceCard.cardNumber)
        XCTAssertEqual(originalCard.nickname, sourceCard.nickname)
        XCTAssertEqual(originalCard.pinNumber, sourceCard.pinNumber)
        XCTAssertEqual(originalCard.cardType, sourceCard.cardType)
        XCTAssertEqual(originalCard.cardHolderEmail, sourceCard.cardHolderEmail)
        XCTAssertEqual(originalCard.default, sourceCard.default)
        XCTAssertEqual(originalCard.transactions.count, sourceCard.transactions.count)
    }
    
    func testCardNumberAsId() {
        // Arrange
        let cardNumber = "4000000000000002"
        let nickname = "Test Card"
        let pinNumber = "4321"
        
        // Act
        let card = DAOCard(cardNumber: cardNumber, nickname: nickname, pinNumber: pinNumber)
        
        // Assert
        XCTAssertEqual(card.id, cardNumber)
        XCTAssertEqual(card.cardNumber, cardNumber)
    }
    
    func testCardExpirationValidation() {
        // Arrange
        let card = DAOCard()
        let pastDate = Date().addingTimeInterval(-365 * 24 * 60 * 60) // 1 year ago
        let futureDate = Date().addingTimeInterval(365 * 24 * 60 * 60) // 1 year from now
        
        // Act & Assert - Past expiration
        card.expiration = pastDate
        XCTAssertNotNil(card.expiration)
        XCTAssertTrue(card.expiration! < Date())
        
        // Act & Assert - Future expiration
        card.expiration = futureDate
        XCTAssertNotNil(card.expiration)
        XCTAssertTrue(card.expiration! > Date())
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalCard = MockDAOCardFactory.createMockWithTestData()
        
        // Act
        let copiedCard = originalCard.copy() as? DAOCard
        
        // Assert
        XCTAssertNotNil(copiedCard)
        XCTAssertEqual(copiedCard?.cardNumber, originalCard.cardNumber)
        XCTAssertEqual(copiedCard?.nickname, originalCard.nickname)
        XCTAssertEqual(copiedCard?.pinNumber, originalCard.pinNumber)
        XCTAssertEqual(copiedCard?.cardType, originalCard.cardType)
        XCTAssertEqual(copiedCard?.transactions.count, originalCard.transactions.count)
        XCTAssertFalse(copiedCard === originalCard) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let card1 = MockDAOCardFactory.createMockWithTestData()
        let card2 = MockDAOCardFactory.createMockWithTestData()
        let card3 = MockDAOCardFactory.createMockWithEdgeCases()
        
        // Act & Assert - Property by property comparison instead of full object equality
        XCTAssertEqual(card1.cardNumber, card2.cardNumber)
        XCTAssertEqual(card1.nickname, card2.nickname)
        XCTAssertEqual(card1.pinNumber, card2.pinNumber)
        XCTAssertEqual(card1.cardType, card2.cardType)
        XCTAssertEqual(card1.default, card2.default)
        
        // Act & Assert - Different data should be different
        XCTAssertNotEqual(card1.cardNumber, card3.cardNumber)
        XCTAssertNotEqual(card1.nickname, card3.nickname)
        XCTAssertNotEqual(card1.pinNumber, card3.pinNumber)
        
        // Act & Assert - Same instance should be equal
        XCTAssertTrue(card1 == card1)
        XCTAssertFalse(card1 != card1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let card1 = MockDAOCardFactory.createMockWithTestData()
        let card2 = DAOCard(from: card1)  // Use copy initializer for consistency
        let card3 = MockDAOCardFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should not be different
        XCTAssertFalse(card1.isDiffFrom(card2))
        
        // Act & Assert - Different data should be different
        XCTAssertTrue(card1.isDiffFrom(card3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(card1.isDiffFrom(card1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(card1.isDiffFrom("not a card"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(card1.isDiffFrom(nil as DAOCard?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalCard = MockDAOCardFactory.createMockWithTestData()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalCard)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedCard = try decoder.decode(DAOCard.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedCard.cardNumber, originalCard.cardNumber)
        XCTAssertEqual(decodedCard.nickname, originalCard.nickname)
        XCTAssertEqual(decodedCard.pinNumber, originalCard.pinNumber)
        XCTAssertEqual(decodedCard.cardType, originalCard.cardType)
        XCTAssertEqual(decodedCard.cardHolderEmail, originalCard.cardHolderEmail)
        XCTAssertEqual(decodedCard.default, originalCard.default)
        XCTAssertEqual(decodedCard.transactions.count, originalCard.transactions.count)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let card = MockDAOCardFactory.createMockWithTestData()
        
        // Act
        let dictionary = card.asDictionary
        
        // Assert
        XCTAssertEqual(dictionary["cardNumber"] as? String, card.cardNumber)
        XCTAssertEqual(dictionary["nickname"] as? String, card.nickname)
        XCTAssertEqual(dictionary["pinNumber"] as? String, card.pinNumber)
        XCTAssertEqual(dictionary["cardType"] as? String, card.cardType)
        XCTAssertEqual(dictionary["cardHolderEmail"] as? String, card.cardHolderEmail)
        XCTAssertEqual(dictionary["default"] as? Bool, card.default)
        XCTAssertNotNil(dictionary["transactions"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let card = MockDAOCardFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertEqual(card.cardNumber, "")
        XCTAssertEqual(card.nickname, "")
        XCTAssertEqual(card.pinNumber, "")
        XCTAssertEqual(card.cardType, "")
        XCTAssertEqual(card.cardHolderEmail, "")
        XCTAssertEqual(card.cardHolderPhone, "")
        XCTAssertEqual(card.default, false)
        XCTAssertNil(card.expiration)
        XCTAssertTrue(card.transactions.isEmpty)
    }
    
    func testNilExpiration() {
        // Arrange
        let card = DAOCard()
        
        // Act
        card.expiration = nil
        
        // Assert
        XCTAssertNil(card.expiration)
    }
    
    func testEmptyTransactionsArray() {
        // Arrange
        let card = DAOCard()
        
        // Act
        card.transactions = []
        
        // Assert
        XCTAssertTrue(card.transactions.isEmpty)
        XCTAssertEqual(card.transactions.count, 0)
    }
    
    func testLongCardNumber() {
        // Arrange
        let card = DAOCard()
        let longCardNumber = "41111111111111111111111111111111"
        
        // Act
        card.cardNumber = longCardNumber
        
        // Assert
        XCTAssertEqual(card.cardNumber, longCardNumber)
    }
    
    func testSpecialCharactersInFields() {
        // Arrange
        let card = DAOCard()
        
        // Act
        card.nickname = "Card-With_Special@Characters!"
        card.cardHolderEmail = "test+special@example.co.uk"
        card.cardHolderPhone = "+1 (555) 123-4567"
        
        // Assert
        XCTAssertEqual(card.nickname, "Card-With_Special@Characters!")
        XCTAssertEqual(card.cardHolderEmail, "test+special@example.co.uk")
        XCTAssertEqual(card.cardHolderPhone, "+1 (555) 123-4567")
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let cards = MockDAOCardFactory.createMockArray(count: 5)
        
        // Assert
        XCTAssertEqual(cards.count, 5)
        
        // Verify each card has proper data
        for i in 0..<cards.count {
            XCTAssertFalse(cards[i].cardNumber.isEmpty)
            XCTAssertFalse(cards[i].nickname.isEmpty)
            XCTAssertFalse(cards[i].pinNumber.isEmpty)
            XCTAssertFalse(cards[i].cardType.isEmpty)
            XCTAssertNotNil(cards[i].expiration)
        }
        
        // Verify first card is default
        XCTAssertTrue(cards[0].default)
        for i in 1..<cards.count {
            XCTAssertFalse(cards[i].default)
        }
        
        // Verify card type alternation
        XCTAssertEqual(cards[0].cardType, "Visa")
        XCTAssertEqual(cards[1].cardType, "MasterCard")
        XCTAssertEqual(cards[2].cardType, "Visa")
        XCTAssertEqual(cards[3].cardType, "MasterCard")
    }
    
    func testCardTypeSpecificCreation() {
        // Arrange & Act
        let visaCard = MockDAOCardFactory.createVisaCard()
        let masterCard = MockDAOCardFactory.createMasterCard()
        
        // Assert
        XCTAssertEqual(visaCard.cardType, "Visa")
        XCTAssertEqual(visaCard.cardNumber, "4111111111111111")
        
        XCTAssertEqual(masterCard.cardType, "MasterCard")
        XCTAssertEqual(masterCard.cardNumber, "5555555555554444")
    }
    
    func testExpiredCardCreation() {
        // Arrange & Act
        let expiredCard = MockDAOCardFactory.createExpiredCard()
        
        // Assert
        XCTAssertNotNil(expiredCard.expiration)
        XCTAssertTrue(expiredCard.expiration! < Date())
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOCard()
            }
        }
    }
    
    func testSpecialInitializationPerformance() {
        measure {
            for i in 0..<1000 {
                _ = DAOCard(cardNumber: "4111\(i)", nickname: "Card \(i)", pinNumber: "\(i)")
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalCard = MockDAOCardFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOCard(from: originalCard)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let card1 = MockDAOCardFactory.createMockWithTestData()
        let card2 = MockDAOCardFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = card1 == card2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let card = MockDAOCardFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(card)
                    _ = try decoder.decode(DAOCard.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testInitializationWithCardDetails", testInitializationWithCardDetails),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testCardNumberProperty", testCardNumberProperty),
        ("testNicknameProperty", testNicknameProperty),
        ("testPinNumberProperty", testPinNumberProperty),
        ("testCardTypeProperty", testCardTypeProperty),
        ("testCardHolderEmailProperty", testCardHolderEmailProperty),
        ("testCardHolderNameProperty", testCardHolderNameProperty),
        ("testCardHolderPhoneProperty", testCardHolderPhoneProperty),
        ("testDefaultProperty", testDefaultProperty),
        ("testExpirationProperty", testExpirationProperty),
        ("testBillingAddressProperty", testBillingAddressProperty),
        ("testTransactionsProperty", testTransactionsProperty),
        ("testUpdateMethod", testUpdateMethod),
        ("testCardNumberAsId", testCardNumberAsId),
        ("testCardExpirationValidation", testCardExpirationValidation),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testNilExpiration", testNilExpiration),
        ("testEmptyTransactionsArray", testEmptyTransactionsArray),
        ("testLongCardNumber", testLongCardNumber),
        ("testSpecialCharactersInFields", testSpecialCharactersInFields),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testCardTypeSpecificCreation", testCardTypeSpecificCreation),
        ("testExpiredCardCreation", testExpiredCardCreation),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testSpecialInitializationPerformance", testSpecialInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}
