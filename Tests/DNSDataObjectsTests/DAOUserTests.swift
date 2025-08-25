//
//  DAOUserTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSDataObjects

final class DAOUserTests: XCTestCase {
    
    func testDAOUserInitialization() {
        let user = DAOUser()
        
        XCTAssertNotNil(user.id)
        XCTAssertFalse(user.id.isEmpty)
        XCTAssertNotNil(user.meta)
        XCTAssertEqual(user.analyticsData.count, 0)
    }
    
    func testDAOUserInitializationWithId() {
        let testId = "test-user-id"
        let user = DAOUser(id: testId)
        
        XCTAssertEqual(user.id, testId)
        XCTAssertNotNil(user.meta)
        XCTAssertEqual(user.analyticsData.count, 0)
    }
    
    func testDAOUserCopyConstructor() {
        let originalUser = DAOUser(id: "original-user-id")
        let copiedUser = DAOUser(from: originalUser)
        
        XCTAssertEqual(copiedUser.id, originalUser.id)
        XCTAssertFalse(copiedUser === originalUser) // Different instances
    }
    
    func testDAOUserFromDataDictionary() {
        let testData: DNSDataDictionary = [
            "id": "test-user-from-dict",
            "analyticsData": [],
            "meta": [
                "createdTime": Date().timeIntervalSince1970,
                "updatedTime": Date().timeIntervalSince1970
            ]
        ]
        
        guard let user = DAOUser(from: testData) else {
            XCTFail("Failed to create DAOUser from data dictionary")
            return
        }
        
        XCTAssertEqual(user.id, "test-user-from-dict")
        XCTAssertNotNil(user.meta)
        XCTAssertEqual(user.analyticsData.count, 0)
    }
    
    func testDAOUserCopyMethod() {
        let originalUser = DAOUser(id: "copy-test-user")
        let copiedUser = originalUser.copy() as! DAOUser
        
        XCTAssertEqual(copiedUser.id, originalUser.id)
        XCTAssertFalse(copiedUser === originalUser)
    }
    
    func testDAOUserEquality() {
        let user1 = DAOUser(id: "same-user-id")
        let user2 = DAOUser(id: "same-user-id")
        let user3 = DAOUser(id: "different-user-id")
        
        user2.meta = user1.meta
        user3.meta = user1.meta
        
        XCTAssertTrue(user1 == user2)
        XCTAssertFalse(user1 == user3)
    }
    
    func testDAOUserIsDiffFrom() {
        let user1 = DAOUser(id: "test-user-id")
        let user2 = DAOUser(id: "test-user-id")
        let user3 = DAOUser(id: "different-user-id")
        
        user2.meta = user1.meta
        user3.meta = user1.meta

        XCTAssertFalse(user1.isDiffFrom(user2))
        XCTAssertTrue(user1.isDiffFrom(user3))
        XCTAssertTrue(user1.isDiffFrom("not a user object"))
    }
    
    func testDAOUserAsDictionary() {
        let user = DAOUser(id: "dictionary-test-user")
        let dictionary = user.asDictionary
        
        XCTAssertEqual(dictionary["id"] as? String, "dictionary-test-user")
        XCTAssertNotNil(dictionary["analyticsData"] as Any?)
        XCTAssertNotNil(dictionary["meta"] as Any?)
    }
    
    func testDAOUserClassFactory() {
        let user1 = DAOUser()
        let user2 = DAOUser(from: user1)
        
        XCTAssertNotNil(user1)
        XCTAssertNotNil(user2)
        XCTAssertEqual(user1.id, user2.id)
        XCTAssertFalse(user1 === user2)
    }
    
    func testDAOUserConfiguration() {
        XCTAssertNotNil(DAOUser.config)
        XCTAssertTrue(DAOUser.config is CFGUserObject)
    }
    
    func testDAOUserInheritsFromBaseObject() {
        let user = DAOUser()
        XCTAssertTrue(user is DAOBaseObject)
    }

    nonisolated(unsafe) static var allTests = [
        ("testDAOUserInitialization", testDAOUserInitialization),
        ("testDAOUserInitializationWithId", testDAOUserInitializationWithId),
        ("testDAOUserCopyConstructor", testDAOUserCopyConstructor),
        ("testDAOUserFromDataDictionary", testDAOUserFromDataDictionary),
        ("testDAOUserCopyMethod", testDAOUserCopyMethod),
        ("testDAOUserEquality", testDAOUserEquality),
        ("testDAOUserIsDiffFrom", testDAOUserIsDiffFrom),
        ("testDAOUserAsDictionary", testDAOUserAsDictionary),
        ("testDAOUserClassFactory", testDAOUserClassFactory),
        ("testDAOUserConfiguration", testDAOUserConfiguration),
        ("testDAOUserInheritsFromBaseObject", testDAOUserInheritsFromBaseObject),
    ]
}
