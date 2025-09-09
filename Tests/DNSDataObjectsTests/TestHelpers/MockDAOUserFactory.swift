//
//  MockDAOUserFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOUserFactory -
struct MockDAOUserFactory: MockDAOFactory {
    typealias DAOType = DAOUser
    
    static func createMock() -> DAOUser {
        let user = DAOUser()
        user.name = PersonNameComponents.dnsBuildName(with: "Test User") ?? PersonNameComponents()
        user.email = "test@example.com"
        user.phone = "555-0123"
        user.type = .adult
        user.consentBy = "Test Consent"
        user.userRole = .endUser
        user.status = .open
        user.visibility = .everyone
        return user
    }
    
    static func createMockWithTestData() -> DAOUser {
        let user = DAOUser(id: "user_12345", email: "john.test@example.com", name: "John Test Smith")
        
        // Set user details
        user.phone = "555-0199"
        user.type = .adult
        user.userRole = .endUser
        user.status = .open
        user.visibility = .everyone
        
        // Set date of birth (30 years old)
        let calendar = Calendar.current
        user.dob = calendar.date(byAdding: .year, value: -30, to: Date())
        
        // Set consent information
        user.consent = Date()
        user.consentBy = "john.test@example.com"
        
        // Create test accounts
        let account1 = DAOAccount()
        account1.id = "account_1"
        account1.name = PersonNameComponents.dnsBuildName(with: "Primary Account") ?? PersonNameComponents()
        
        let account2 = DAOAccount()
        account2.id = "account_2" 
        account2.name = PersonNameComponents.dnsBuildName(with: "Secondary Account") ?? PersonNameComponents()
        
        user.accounts = [account1, account2]
        
        // Create test cards
        let card1 = DAOCard()
        card1.id = "card_1"
        card1.nickname = "Primary Card"
        card1.cardType = "Visa"
        
        let card2 = DAOCard()
        card2.id = "card_2"
        card2.nickname = "Secondary Card"
        card2.cardType = "MasterCard"
        
        user.cards = [card1, card2]
        
        // Create favorite activity types
        let activityType1 = DAOActivityType()
        activityType1.id = "activity_type_1"
        
        let activityType2 = DAOActivityType()
        activityType2.id = "activity_type_2"
        
        user.favorites = [activityType1, activityType2]
        
        // Create user's place
        let myPlace = DAOPlace()
        myPlace.id = "my_place_123"
        myPlace.name = DNSString(with: "My Test Place")
        myPlace.code = "MY_PLACE"
        user.myPlace = myPlace
        
        return user
    }
    
    static func createMockWithEdgeCases() -> DAOUser {
        let user = DAOUser()
        
        // Edge cases
        user.name = PersonNameComponents() // Empty name
        user.email = "" // Empty email
        user.phone = "" // Empty phone
        user.type = .unknown // Unknown user type
        user.userRole = .endUser
        user.status = .open
        user.visibility = .everyone
        user.dob = nil // No date of birth
        user.consent = nil // No consent
        user.consentBy = "" // Empty consent by
        user.accounts = [] // No accounts
        user.cards = [] // No cards
        user.favorites = [] // No favorites
        user.myPlace = nil // No place
        
        return user
    }
    
    static func createMockArray(count: Int) -> [DAOUser] {
        var users: [DAOUser] = []
        
        for i in 0..<count {
            let user = DAOUser()
            user.id = "user\(i)" // Set explicit ID to match test expectations (changed from user_\(i + 1))
            user.name = PersonNameComponents.dnsBuildName(with: "User \(i + 1)") ?? PersonNameComponents()
            user.email = "user\(i + 1)@example.com"
            user.phone = "555-0\(String(format: "%03d", i + 100))"
            
            // Vary user types
            user.type = i % 3 == 0 ? .adult : (i % 3 == 1 ? .youth : .child)
            user.userRole = i % 2 == 0 ? .endUser : .placeAdmin
            user.status = i % 4 == 0 ? .open : .closed
            user.visibility = i % 2 == 0 ? .everyone : .staffOnly
            
            // Add variety to dates of birth
            let calendar = Calendar.current
            let ageRange = user.type == .adult ? 18...65 : (user.type == .youth ? 13...17 : 5...12)
            let age = ageRange.randomElement() ?? 25
            user.dob = calendar.date(byAdding: .year, value: -age, to: Date())
            
            // Add consent for minors
            if user.isMinor {
                user.consent = Date()
                user.consentBy = "parent\(i + 1)@example.com"
            }
            
            users.append(user)
        }
        
        return users
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOUser {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOUser {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOUser {
        let user = createMockWithTestData()
        user.id = id
        return user
    }
    
    // User-specific test methods
    static func createAdultUser() -> DAOUser {
        let user = createMockWithTestData()
        user.type = .adult
        let calendar = Calendar.current
        user.dob = calendar.date(byAdding: .year, value: -25, to: Date())
        return user
    }
    
    static func createMinorUser() -> DAOUser {
        let user = createMockWithTestData()
        user.type = .youth
        let calendar = Calendar.current
        user.dob = calendar.date(byAdding: .year, value: -15, to: Date())
        user.consent = Date()
        user.consentBy = "parent@example.com"
        return user
    }
    
    static func createChildUser() -> DAOUser {
        let user = createMockWithTestData()
        user.type = .child
        let calendar = Calendar.current
        user.dob = calendar.date(byAdding: .year, value: -10, to: Date())
        user.consent = Date()
        user.consentBy = "parent@example.com"
        return user
    }
    
    static func createAdminUser() -> DAOUser {
        let user = createMockWithTestData()
        user.userRole = .placeAdmin
        user.type = .adult
        return user
    }
}