//
//  MockDAOCardFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOCardFactory -
struct MockDAOCardFactory: MockDAOFactory {
    typealias DAOType = DAOCard
    
    static func createMock() -> DAOCard {
        let card = DAOCard()
        card.cardNumber = "4444333322221111"
        card.nickname = "Test Card"
        card.pinNumber = "1234"
        card.cardType = "Visa"
        card.cardHolderEmail = "test@example.com"
        return card
    }
    
    static func createMockWithTestData() -> DAOCard {
        let card = DAOCard(cardNumber: "4111111111111111", nickname: "Premium Test Card", pinNumber: "5678")
        
        // Set cardholder details
        card.cardHolderName = PersonNameComponents.dnsBuildName(with: "John Test Smith") ?? PersonNameComponents()
        card.cardHolderEmail = "john.test@example.com"
        card.cardHolderPhone = "555-0123"
        card.cardType = "Visa"
        card.default = true
        
        // Set expiration date (2 years from now)
        let calendar = Calendar.current
        card.expiration = calendar.date(byAdding: .year, value: 2, to: Date())
        
        // Set billing address
        let billingAddress = DNSPostalAddress()
        billingAddress.street = "123 Test Street"
        billingAddress.city = "Test City"
        billingAddress.state = "Test State"
        billingAddress.postalCode = "12345"
        billingAddress.country = "US"
        card.billingAddress = billingAddress
        
        // Create test transactions
        let transaction1 = DAOTransaction()
        transaction1.id = "trans_1"
        transaction1.amount = Float(99.99)
        transaction1.tax = Float(8.50)
        transaction1.tip = Float(15.00)
        
        let transaction2 = DAOTransaction()
        transaction2.id = "trans_2"
        transaction2.amount = Float(25.50)
        transaction2.tax = Float(2.15)
        transaction2.tip = Float(5.00)
        
        card.transactions = [transaction1, transaction2]
        
        return card
    }
    
    static func createMockWithEdgeCases() -> DAOCard {
        let card = DAOCard()
        
        // Edge cases
        card.cardNumber = "" // Empty card number
        card.nickname = "" // Empty nickname
        card.pinNumber = "" // Empty PIN
        card.cardType = "" // Empty card type
        card.cardHolderEmail = "" // Empty email
        card.cardHolderPhone = "" // Empty phone
        card.default = false
        card.expiration = nil // No expiration
        card.transactions = [] // No transactions
        
        return card
    }
    
    static func createMockArray(count: Int) -> [DAOCard] {
        var cards: [DAOCard] = []
        
        for i in 0..<count {
            let card = DAOCard()
            card.id = "card\(i)" // Set explicit ID to match test expectations
            card.cardNumber = "4444333322221\(String(format: "%03d", i + 111))"
            card.nickname = "Test Card \(i + 1)"
            card.pinNumber = String(format: "%04d", (i + 1) * 1111 % 10000)
            card.cardType = i % 2 == 0 ? "Visa" : "MasterCard"
            card.cardHolderEmail = "test\(i + 1)@example.com"
            card.default = i == 0 // First card is default
            
            // Add variety to expiration dates
            let calendar = Calendar.current
            card.expiration = calendar.date(byAdding: .year, value: (i % 5) + 1, to: Date())
            
            cards.append(card)
        }
        
        return cards
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOCard {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOCard {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOCard {
        let card = createMockWithTestData()
        card.id = id
        return card
    }
    
    // Credit card specific test methods
    static func createVisaCard() -> DAOCard {
        let card = createMockWithTestData()
        card.cardType = "Visa"
        card.cardNumber = "4111111111111111"
        return card
    }
    
    static func createMasterCard() -> DAOCard {
        let card = createMockWithTestData()
        card.cardType = "MasterCard"
        card.cardNumber = "5555555555554444"
        return card
    }
    
    static func createExpiredCard() -> DAOCard {
        let card = createMockWithTestData()
        let calendar = Calendar.current
        card.expiration = calendar.date(byAdding: .year, value: -1, to: Date()) // Expired 1 year ago
        return card
    }
}
