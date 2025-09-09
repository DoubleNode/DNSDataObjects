//
//  DAOUserTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOUserTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitEmpty() {
        let user = DAOUser()
        
        XCTAssertNotNil(user.id)
        XCTAssertFalse(user.id.isEmpty)
        XCTAssertEqual(user.name, PersonNameComponents())
        XCTAssertNil(user.email)
        XCTAssertEqual(user.phone, "")
        XCTAssertEqual(user.type, .unknown)
        XCTAssertEqual(user.userRole, .endUser)
        XCTAssertEqual(user.status, .open)
        XCTAssertEqual(user.visibility, .everyone)
        XCTAssertTrue(user.accounts.isEmpty)
        XCTAssertTrue(user.cards.isEmpty)
        XCTAssertTrue(user.favorites.isEmpty)
        XCTAssertNil(user.myPlace)
        XCTAssertNil(user.consent)
        XCTAssertEqual(user.consentBy, "")
        XCTAssertNil(user.dob)
    }
    
    func testInitWithId() {
        let testId = "user_12345"
        let user = DAOUser(id: testId)
        
        XCTAssertEqual(user.id, testId)
        XCTAssertEqual(user.name, PersonNameComponents())
        XCTAssertNil(user.email)
        XCTAssertEqual(user.type, .unknown)
    }
    
    func testInitWithIdEmailName() {
        let testId = "user_12345"
        let testEmail = "test@example.com"
        let testName = "John Smith"
        
        let user = DAOUser(id: testId, email: testEmail, name: testName)
        
        XCTAssertEqual(user.id, testId)
        XCTAssertEqual(user.email, testEmail)
        XCTAssertEqual(user.nameMedium, testName)
        XCTAssertEqual(user.name.givenName, "John")
        XCTAssertEqual(user.name.familyName, "Smith")
    }
    
    func testInitFromObject() {
        let originalUser = MockDAOUserFactory.createMockWithTestData()
        let copiedUser = DAOUser(from: originalUser)
        
        XCTAssertEqual(copiedUser.id, originalUser.id)
        XCTAssertEqual(copiedUser.email, originalUser.email)
        XCTAssertEqual(copiedUser.name, originalUser.name)
        XCTAssertEqual(copiedUser.phone, originalUser.phone)
        XCTAssertEqual(copiedUser.type, originalUser.type)
        XCTAssertEqual(copiedUser.userRole, originalUser.userRole)
        XCTAssertEqual(copiedUser.status, originalUser.status)
        XCTAssertEqual(copiedUser.visibility, originalUser.visibility)
        XCTAssertEqual(copiedUser.accounts.count, originalUser.accounts.count)
        XCTAssertEqual(copiedUser.cards.count, originalUser.cards.count)
        XCTAssertEqual(copiedUser.favorites.count, originalUser.favorites.count)
        XCTAssertEqual(copiedUser.consent, originalUser.consent)
        XCTAssertEqual(copiedUser.consentBy, originalUser.consentBy)
        XCTAssertEqual(copiedUser.dob, originalUser.dob)
        
        // Verify deep copy
        XCTAssertFalse(copiedUser === originalUser)
        if !copiedUser.accounts.isEmpty && !originalUser.accounts.isEmpty {
            XCTAssertFalse(copiedUser.accounts[0] === originalUser.accounts[0])
        }
    }
    
    func testInitFromDictionary() {
        let testData: DNSDataDictionary = [
            "id": "user_12345",
            "email": "test@example.com",
            "name": ["givenName": "John", "familyName": "Smith"],
            "phone": "555-0123",
            "type": "adult",
            "consentBy": "test@example.com",
            "accounts": [
                ["id": "account_1", "name": ["givenName": "Account", "familyName": "One"]]
            ],
            "cards": [
                ["id": "card_1", "nickname": "Test Card"]
            ]
        ]
        
        let user = DAOUser(from: testData)
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id, "user_12345")
        XCTAssertEqual(user?.email, "test@example.com")
        XCTAssertEqual(user?.name.givenName, "John")
        XCTAssertEqual(user?.name.familyName, "Smith")
        XCTAssertEqual(user?.phone, "555-0123")
        XCTAssertEqual(user?.type, .adult)
        XCTAssertEqual(user?.consentBy, "test@example.com")
        XCTAssertEqual(user?.accounts.count, 1)
        XCTAssertEqual(user?.cards.count, 1)
    }
    
    func testInitFromEmptyDictionary() {
        let user = DAOUser(from: [:])
        XCTAssertNil(user)
    }
    
    // MARK: - Property Tests
    
    func testEmailProperty() {
        let user = DAOUser()
        
        // Test nil email
        XCTAssertNil(user.email)
        
        // Test setting email
        user.email = "test@example.com"
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.emailString, "test@example.com")
        
        // Test setting nil email
        user.email = nil
        XCTAssertNil(user.email)
        XCTAssertEqual(user.emailString, "")
        
        // Test empty string email
        user.email = ""
        XCTAssertNil(user.email)
        XCTAssertEqual(user.emailString, "")
    }
    
    func testPhoneNumberProperty() {
        let user = DAOUser()
        
        // Test nil phone
        XCTAssertNil(user.phoneNumber)
        
        // Test setting phone
        user.phoneNumber = "555-0123"
        XCTAssertEqual(user.phoneNumber, "555-0123")
        XCTAssertEqual(user.phone, "555-0123")
        
        // Test setting nil phone
        user.phoneNumber = nil
        XCTAssertNil(user.phoneNumber)
        XCTAssertEqual(user.phone, "")
        
        // Test empty string phone
        user.phoneNumber = ""
        XCTAssertNil(user.phoneNumber)
        XCTAssertEqual(user.phone, "")
    }
    
    func testUserTypeProperty() {
        let user = DAOUser()
        
        XCTAssertEqual(user.userType, .unknown)
        
        user.userType = .adult
        XCTAssertEqual(user.userType, .adult)
        XCTAssertEqual(user.type, .adult)
    }
    
    func testDisplayNameProperty() {
        let user = DAOUser()
        
        // Test empty name
        XCTAssertNil(user.displayName)
        
        // Test setting name via displayName
        user.displayName = "John Smith"
        XCTAssertEqual(user.displayName, "John Smith")
        XCTAssertEqual(user.name.givenName, "John")
        XCTAssertEqual(user.name.familyName, "Smith")
        
        // Test setting nil displayName
        user.displayName = nil
        // Name should remain unchanged when setting nil
        XCTAssertNotNil(user.displayName)
    }
    
    func testDeprecatedNameProperties() {
        let user = DAOUser()
        
        // Test given name property
        user.name.givenName = "John"
        XCTAssertEqual(user.name.givenName, "John")
        XCTAssertEqual(user.name.givenName, "John")
        
        // Test family name property
        user.name.familyName = "Smith"
        XCTAssertEqual(user.name.familyName, "Smith")
        XCTAssertEqual(user.name.familyName, "Smith")
    }
    
    func testNameFormattingProperties() {
        let user = DAOUser()
        user.name.givenName = "John"
        user.name.familyName = "Smith"
        user.name.middleName = "Michael"
        
        XCTAssertFalse(user.nameAbbreviated.isEmpty)
        XCTAssertFalse(user.nameMedium.isEmpty)
        XCTAssertFalse(user.nameLong.isEmpty)
        XCTAssertFalse(user.nameShort.isEmpty)
        XCTAssertFalse(user.nameSortable.isEmpty)
        
        // Test that different formats produce different results
        XCTAssertNotEqual(user.nameShort, user.nameLong)
    }
    
    // MARK: - User Type Classification Tests
    
    func testIsAdult() {
        let user = DAOUser()
        
        user.type = .adult
        XCTAssertTrue(user.isAdult)
        XCTAssertFalse(user.isMinor)
        XCTAssertFalse(user.isUnder13)
        
        user.type = .youth
        XCTAssertFalse(user.isAdult)
        XCTAssertTrue(user.isMinor)
        XCTAssertFalse(user.isUnder13)
        
        user.type = .child
        XCTAssertFalse(user.isAdult)
        XCTAssertTrue(user.isMinor)
        XCTAssertTrue(user.isUnder13)
        
        user.type = .unknown
        XCTAssertFalse(user.isAdult)
        XCTAssertTrue(user.isMinor)
        XCTAssertTrue(user.isUnder13)
    }
    
    func testHasConsent() {
        let user = DAOUser()
        
        // Adult user doesn't need consent
        user.type = .adult
        XCTAssertTrue(user.hasConsent)
        
        // Minor without consent
        user.type = .child
        XCTAssertFalse(user.hasConsent)
        
        // Minor with consent date but no consentBy
        user.consent = Date()
        XCTAssertFalse(user.hasConsent)
        
        // Minor with both consent date and consentBy
        user.consentBy = "parent@example.com"
        XCTAssertTrue(user.hasConsent)
        
        // Minor with consentBy but no consent date
        user.consent = nil
        XCTAssertFalse(user.hasConsent)
    }
    
    // MARK: - Collection Property Tests
    
    func testAccountsProperty() {
        let user = DAOUser()
        
        XCTAssertTrue(user.accounts.isEmpty)
        
        let account = DAOAccount()
        account.id = "test_account"
        user.accounts = [account]
        
        XCTAssertEqual(user.accounts.count, 1)
        XCTAssertEqual(user.accounts.first?.id, "test_account")
    }
    
    func testCardsProperty() {
        let user = DAOUser()
        
        XCTAssertTrue(user.cards.isEmpty)
        
        let card = DAOCard()
        card.id = "test_card"
        user.cards = [card]
        
        XCTAssertEqual(user.cards.count, 1)
        XCTAssertEqual(user.cards.first?.id, "test_card")
    }
    
    func testFavoritesProperty() {
        let user = DAOUser()
        
        XCTAssertTrue(user.favorites.isEmpty)
        
        let activityType = DAOActivityType()
        activityType.id = "test_activity"
        user.favorites = [activityType]
        
        XCTAssertEqual(user.favorites.count, 1)
        XCTAssertEqual(user.favorites.first?.id, "test_activity")
    }
    
    func testMyPlaceProperty() {
        let user = DAOUser()
        
        XCTAssertNil(user.myPlace)
        
        let place = DAOPlace()
        place.id = "test_place"
        place.name = DNSString(with: "Test Place")
        user.myPlace = place
        
        XCTAssertNotNil(user.myPlace)
        XCTAssertEqual(user.myPlace?.id, "test_place")
        XCTAssertEqual(user.myPlace?.name.asString, "Test Place")
    }
    
    // MARK: - Date Property Tests
    
    func testDobProperty() {
        let user = DAOUser()
        
        XCTAssertNil(user.dob)
        
        let testDate = Date()
        user.dob = testDate
        
        XCTAssertEqual(user.dob, testDate)
    }
    
    func testConsentProperty() {
        let user = DAOUser()
        
        XCTAssertNil(user.consent)
        
        let testDate = Date()
        user.consent = testDate
        
        XCTAssertEqual(user.consent, testDate)
    }
    
    // MARK: - Update Method Tests
    
    func testUpdateFromObject() {
        let user1 = MockDAOUserFactory.createMockWithTestData()
        let user2 = DAOUser()
        
        user2.update(from: user1)
        
        XCTAssertEqual(user2.email, user1.email)
        XCTAssertEqual(user2.name, user1.name)
        XCTAssertEqual(user2.phone, user1.phone)
        XCTAssertEqual(user2.type, user1.type)
        XCTAssertEqual(user2.consent, user1.consent)
        XCTAssertEqual(user2.consentBy, user1.consentBy)
        XCTAssertEqual(user2.dob, user1.dob)
        XCTAssertEqual(user2.accounts.count, user1.accounts.count)
        XCTAssertEqual(user2.cards.count, user1.cards.count)
        XCTAssertEqual(user2.favorites.count, user1.favorites.count)
        XCTAssertEqual(user2.myPlace?.id, user1.myPlace?.id)
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testAsDictionary() {
        let user = MockDAOUserFactory.createMockWithTestData()
        let dictionary = user.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["email"] as Any?)
        XCTAssertNotNil(dictionary["name"] as Any?)
        XCTAssertNotNil(dictionary["phone"] as Any?)
        XCTAssertNotNil(dictionary["type"] as Any?)
        XCTAssertNotNil(dictionary["accounts"] as Any?)
        XCTAssertNotNil(dictionary["cards"] as Any?)
        XCTAssertNotNil(dictionary["favorites"] as Any?)
        XCTAssertNotNil(dictionary["myPlace"] as Any?)
        
        XCTAssertEqual(dictionary["email"] as? String, user.email)
        XCTAssertEqual(dictionary["phone"] as? String, user.phone)
        XCTAssertEqual(dictionary["type"] as? String, user.type.rawValue)
    }
    
    func testDaoFromDictionary() {
        let originalUser = MockDAOUserFactory.createMockWithTestData()
        let dictionary = originalUser.asDictionary
        let newUser = DAOUser().dao(from: dictionary)
        
        XCTAssertEqual(newUser.id, originalUser.id)
        XCTAssertEqual(newUser.email, originalUser.email)
        XCTAssertEqual(newUser.phone, originalUser.phone)
        XCTAssertEqual(newUser.type, originalUser.type)
        XCTAssertEqual(newUser.accounts.count, originalUser.accounts.count)
        XCTAssertEqual(newUser.cards.count, originalUser.cards.count)
        XCTAssertEqual(newUser.favorites.count, originalUser.favorites.count)
    }
    
    // MARK: - Codable Tests
    
    func testCodableEncoding() throws {
        let user = MockDAOUserFactory.createMockWithTestData()
        let data = try JSONEncoder().encode(user)
        
        XCTAssertFalse(data.isEmpty)
        
        let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertNotNil(dictionary)
        XCTAssertNotNil(dictionary?["id"])
        XCTAssertNotNil(dictionary?["email"])
        XCTAssertNotNil(dictionary?["name"])
        XCTAssertNotNil(dictionary?["phone"])
        XCTAssertNotNil(dictionary?["type"])
    }
    
    func testCodableDecoding() throws {
        let originalUser = MockDAOUserFactory.createMockWithTestData()
        let data = try JSONEncoder().encode(originalUser)
        let decodedUser = try JSONDecoder().decode(DAOUser.self, from: data)
        
        XCTAssertEqual(decodedUser.id, originalUser.id)
        XCTAssertEqual(decodedUser.email, originalUser.email)
        XCTAssertEqual(decodedUser.name.givenName, originalUser.name.givenName)
        XCTAssertEqual(decodedUser.name.familyName, originalUser.name.familyName)
        XCTAssertEqual(decodedUser.phone, originalUser.phone)
        XCTAssertEqual(decodedUser.type, originalUser.type)
        XCTAssertEqual(decodedUser.accounts.count, originalUser.accounts.count)
        XCTAssertEqual(decodedUser.cards.count, originalUser.cards.count)
        XCTAssertEqual(decodedUser.favorites.count, originalUser.favorites.count)
    }
    
    func testCodableRoundTrip() throws {
        let originalUser = MockDAOUserFactory.createMockWithTestData()
        let data = try JSONEncoder().encode(originalUser)
        let decodedUser = try JSONDecoder().decode(DAOUser.self, from: data)
        let reEncodedData = try JSONEncoder().encode(decodedUser)
        let reDecodedUser = try JSONDecoder().decode(DAOUser.self, from: reEncodedData)
        
        XCTAssertEqual(reDecodedUser.id, originalUser.id)
        XCTAssertEqual(reDecodedUser.email, originalUser.email)
        XCTAssertEqual(reDecodedUser.type, originalUser.type)
    }
    
    // MARK: - Copy Tests
    
    func testCopy() {
        let originalUser = MockDAOUserFactory.createMockWithTestData()
        let copiedUser = DAOUser(from: originalUser)
        
        XCTAssertFalse(copiedUser === originalUser)
        XCTAssertEqual(copiedUser.id, originalUser.id)
        XCTAssertEqual(copiedUser.email, originalUser.email)
        XCTAssertEqual(copiedUser.name, originalUser.name)
        XCTAssertEqual(copiedUser.phone, originalUser.phone)
        XCTAssertEqual(copiedUser.type, originalUser.type)
        XCTAssertEqual(copiedUser.accounts.count, originalUser.accounts.count)
        XCTAssertEqual(copiedUser.cards.count, originalUser.cards.count)
        XCTAssertEqual(copiedUser.favorites.count, originalUser.favorites.count)
    }
    
    // MARK: - Equality Tests
    
    func testEquality() {
        let user1 = MockDAOUserFactory.createMockWithTestData()
        let user2 = DAOUser(from: user1)
        let user3 = MockDAOUserFactory.createMockWithTestData()
        user3.email = "different@example.com"
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(user1.id, user2.id)
        XCTAssertEqual(user1.email, user2.email)
        XCTAssertEqual(user1.name.givenName, user2.name.givenName)
        XCTAssertEqual(user1.name.familyName, user2.name.familyName)
        XCTAssertEqual(user1.phone, user2.phone)
        XCTAssertEqual(user1.type, user2.type)
        XCTAssertEqual(user1.accounts.count, user2.accounts.count)
        XCTAssertEqual(user1.cards.count, user2.cards.count)
        XCTAssertNotEqual(user1, user3)
        XCTAssertFalse(user1.isDiffFrom(user2))
        XCTAssertTrue(user1.isDiffFrom(user3))
    }
    
    func testEqualitySameObject() {
        let user = MockDAOUserFactory.createMockWithTestData()
        
        XCTAssertEqual(user, user)
        XCTAssertFalse(user.isDiffFrom(user))
    }
    
    func testEqualityDifferentProperties() {
        let user1 = MockDAOUserFactory.createMockWithTestData()
        let user2 = DAOUser(from: user1)
        
        // Test different email
        user2.email = "different@example.com"
        XCTAssertNotEqual(user1, user2)
        XCTAssertTrue(user1.isDiffFrom(user2))
        
        // Reset and test different phone
        user2.update(from: user1)
        user2.phone = "555-9999"
        XCTAssertNotEqual(user1, user2)
        
        // Reset and test different name
        user2.update(from: user1)
        user2.name.givenName = "Different"
        XCTAssertNotEqual(user1, user2)
        
        // Reset and test different type
        user2.update(from: user1)
        user2.type = .youth
        XCTAssertNotEqual(user1, user2)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCases() {
        let user = MockDAOUserFactory.createMockWithEdgeCases()
        
        XCTAssertNotNil(user.id)
        XCTAssertNil(user.email)
        XCTAssertNil(user.phoneNumber)
        XCTAssertEqual(user.type, .unknown)
        XCTAssertTrue(user.accounts.isEmpty)
        XCTAssertTrue(user.cards.isEmpty)
        XCTAssertTrue(user.favorites.isEmpty)
        XCTAssertNil(user.myPlace)
        XCTAssertNil(user.consent)
        XCTAssertNil(user.dob)
        XCTAssertEqual(user.consentBy, "")
    }
    
    func testLargeDataSet() {
        let users = MockDAOUserFactory.createMockArray(count: 100)
        
        XCTAssertEqual(users.count, 100)
        
        // Test that all users have unique IDs
        let uniqueIds = Set(users.map { $0.id })
        XCTAssertEqual(uniqueIds.count, 100)
        
        // Test variety in user types
        let userTypes = Set(users.map { $0.type })
        XCTAssertTrue(userTypes.count > 1)
        
        // Test variety in user roles
        let userRoles = Set(users.map { $0.userRole })
        XCTAssertTrue(userRoles.count > 1)
    }
    
    func testSpecialCharacters() {
        let user = DAOUser()
        user.email = "test+special@example.com"
        user.name.givenName = "José"
        user.name.familyName = "García-Rodríguez"
        user.phone = "+1 (555) 123-4567"
        
        XCTAssertEqual(user.email, "test+special@example.com")
        XCTAssertEqual(user.name.givenName, "José")
        XCTAssertEqual(user.name.familyName, "García-Rodríguez")
        XCTAssertEqual(user.phone, "+1 (555) 123-4567")
    }
    
    // MARK: - Factory Method Tests
    
    func testFactoryMethods() {
        // Test createAccount
        let account = DAOUser.createAccount()
        XCTAssertNotNil(account)
        
        // Test createActivityType
        let activityType = DAOUser.createActivityType()
        XCTAssertNotNil(activityType)
        
        // Test createCard
        let card = DAOUser.createCard()
        XCTAssertNotNil(card)
        
        // Test createPlace
        let place = DAOUser.createPlace()
        XCTAssertNotNil(place)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateUser() {
        measure {
            for _ in 0..<1000 {
                _ = DAOUser()
            }
        }
    }
    
    func testPerformanceCopyUser() {
        let user = MockDAOUserFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOUser(from: user)
            }
        }
    }
    
    func testPerformanceEncodeUser() throws {
        let user = MockDAOUserFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        
        measure {
            for _ in 0..<1000 {
                _ = try? encoder.encode(user)
            }
        }
    }
    
    static var allTests = [
        ("testInitEmpty", testInitEmpty),
        ("testInitWithId", testInitWithId),
        ("testInitWithIdEmailName", testInitWithIdEmailName),
        ("testInitFromObject", testInitFromObject),
        ("testInitFromDictionary", testInitFromDictionary),
        ("testInitFromEmptyDictionary", testInitFromEmptyDictionary),
        ("testEmailProperty", testEmailProperty),
        ("testPhoneNumberProperty", testPhoneNumberProperty),
        ("testUserTypeProperty", testUserTypeProperty),
        ("testDisplayNameProperty", testDisplayNameProperty),
        ("testDeprecatedNameProperties", testDeprecatedNameProperties),
        ("testNameFormattingProperties", testNameFormattingProperties),
        ("testIsAdult", testIsAdult),
        ("testHasConsent", testHasConsent),
        ("testAccountsProperty", testAccountsProperty),
        ("testCardsProperty", testCardsProperty),
        ("testFavoritesProperty", testFavoritesProperty),
        ("testMyPlaceProperty", testMyPlaceProperty),
        ("testDobProperty", testDobProperty),
        ("testConsentProperty", testConsentProperty),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testAsDictionary", testAsDictionary),
        ("testDaoFromDictionary", testDaoFromDictionary),
        ("testCodableEncoding", testCodableEncoding),
        ("testCodableDecoding", testCodableDecoding),
        ("testCodableRoundTrip", testCodableRoundTrip),
        ("testCopy", testCopy),
        ("testEquality", testEquality),
        ("testEqualitySameObject", testEqualitySameObject),
        ("testEqualityDifferentProperties", testEqualityDifferentProperties),
        ("testEdgeCases", testEdgeCases),
        ("testLargeDataSet", testLargeDataSet),
        ("testSpecialCharacters", testSpecialCharacters),
        ("testFactoryMethods", testFactoryMethods),
        ("testPerformanceCreateUser", testPerformanceCreateUser),
        ("testPerformanceCopyUser", testPerformanceCopyUser),
        ("testPerformanceEncodeUser", testPerformanceEncodeUser),
    ]
}
