//
//  MockDAOAccountFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOAccountFactory -
struct MockDAOAccountFactory: MockDAOFactory {
    typealias DAOType = DAOAccount
    
    static func createMock() -> DAOAccount {
        let account = DAOAccount()
        // Basic valid object with minimal data
        account.name = PersonNameComponents.dnsBuildName(with: "Test User") ?? PersonNameComponents()
        account.emailNotifications = false
        account.pushNotifications = false
        return account
    }
    
    static func createMockWithTestData() -> DAOAccount {
        let account = DAOAccount()
        
        // Realistic test data
        account.name = PersonNameComponents.dnsBuildName(with: "John Michael Smith") ?? PersonNameComponents()
        account.dob = Calendar.current.date(from: DateComponents(year: 1985, month: 6, day: 15))
        account.emailNotifications = true
        account.pushNotifications = true
        account.pricingTierId = "tier_premium_123"
        
        // Create test avatar
        let avatar = DAOMedia()
        avatar.id = "avatar_media_id"
        account.avatar = avatar
        
        // Create test cards
        let card1 = DAOCard()
        card1.id = "card_1"
        let card2 = DAOCard()
        card2.id = "card_2"
        account.cards = [card1, card2]
        
        // Create test users
        let user1 = DAOUser()
        user1.id = "user_1"
        let user2 = DAOUser()
        user2.id = "user_2"
        account.users = [user1, user2]
        
        return account
    }
    
    static func createMockWithEdgeCases() -> DAOAccount {
        let account = DAOAccount()
        
        // Edge cases and boundary values
        account.name = PersonNameComponents() // Empty name
        account.dob = Date.distantPast // Very old date
        account.emailNotifications = true
        account.pushNotifications = false
        account.pricingTierId = "" // Empty pricing tier ID
        
        // nil avatar (edge case)
        account.avatar = nil
        
        // Empty collections (edge cases)
        account.cards = []
        account.users = []
        
        return account
    }
    
    static func createMockArray(count: Int) -> [DAOAccount] {
        var accounts: [DAOAccount] = []
        
        for i in 0..<count {
            let account = DAOAccount()
            account.id = "account\(i)" // Set explicit ID to match test expectations
            account.name = PersonNameComponents.dnsBuildName(with: "User \(i + 1)") ?? PersonNameComponents()
            account.emailNotifications = (i % 2 == 0) // Alternate true/false
            account.pushNotifications = (i % 3 == 0) // Every third one
            account.pricingTierId = "tier_\(i)"
            
            if i % 4 == 0 { // Every fourth account gets an avatar
                let avatar = DAOMedia()
                avatar.id = "avatar_\(i)"
                account.avatar = avatar
            }
            
            accounts.append(account)
        }
        
        return accounts
    }
}