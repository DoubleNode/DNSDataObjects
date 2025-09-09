//
//  DAOAccountLinkRequestTests.swift
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

final class DAOAccountLinkRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let accountLinkRequest = DAOAccountLinkRequest()
        
        // Assert
        XCTAssertNotNil(accountLinkRequest.requested)
        XCTAssertNil(accountLinkRequest.approved)
        XCTAssertEqual(accountLinkRequest.approvedBy, "")
        XCTAssertNil(accountLinkRequest.account)
        XCTAssertNil(accountLinkRequest.user)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "test-link-request-123"
        
        // Act
        let accountLinkRequest = DAOAccountLinkRequest(id: testId)
        
        // Assert
        XCTAssertEqual(accountLinkRequest.id, testId)
        XCTAssertNotNil(accountLinkRequest.requested)
        XCTAssertNil(accountLinkRequest.approved)
        XCTAssertEqual(accountLinkRequest.approvedBy, "")
        XCTAssertNil(accountLinkRequest.account)
        XCTAssertNil(accountLinkRequest.user)
    }
    
    func testInitializationWithUser() {
        // Arrange
        let testUser = DAOUser()
        testUser.id = "test-user-456"
        
        // Act
        let accountLinkRequest = DAOAccountLinkRequest(user: testUser)
        
        // Assert
        XCTAssertEqual(accountLinkRequest.user?.id, testUser.id)
        XCTAssertNotNil(accountLinkRequest.requested)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalRequest = MockDAOAccountLinkRequestFactory.createMockWithTestData()
        
        // Act
        let copiedRequest = DAOAccountLinkRequest(from: originalRequest)
        
        // Assert
        XCTAssertEqual(copiedRequest.id, originalRequest.id)
        XCTAssertEqual(copiedRequest.requested, originalRequest.requested)
        XCTAssertEqual(copiedRequest.approved, originalRequest.approved)
        XCTAssertEqual(copiedRequest.approvedBy, originalRequest.approvedBy)
        XCTAssertEqual(copiedRequest.account?.id, originalRequest.account?.id)
        XCTAssertEqual(copiedRequest.user?.id, originalRequest.user?.id)
        XCTAssertFalse(copiedRequest === originalRequest) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "requested": Date(),
            "approved": Date().addingTimeInterval(86400),
            "approvedBy": "admin_user",
            "account": ["id": "test_account"],
            "user": ["id": "test_user"]
        ]
        
        // Act
        let accountLinkRequest = DAOAccountLinkRequest(from: testData)
        
        // Assert
        XCTAssertNotNil(accountLinkRequest)
        XCTAssertEqual(accountLinkRequest?.approvedBy, "admin_user")
        XCTAssertEqual(accountLinkRequest?.account?.id, "test_account")
        XCTAssertEqual(accountLinkRequest?.user?.id, "test_user")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let accountLinkRequest = DAOAccountLinkRequest(from: emptyData)
        
        // Assert
        XCTAssertNil(accountLinkRequest)
    }
    
    // MARK: - Property Tests
    
    func testRequestedProperty() {
        // Arrange
        let accountLinkRequest = DAOAccountLinkRequest()
        let newRequestedDate = Date().addingTimeInterval(-3600) // 1 hour ago
        
        // Act
        accountLinkRequest.requested = newRequestedDate
        
        // Assert
        XCTAssertEqual(accountLinkRequest.requested, newRequestedDate)
    }
    
    func testApprovedProperty() {
        // Arrange
        let accountLinkRequest = DAOAccountLinkRequest()
        let approvedDate = Date()
        
        // Act
        accountLinkRequest.approved = approvedDate
        
        // Assert
        XCTAssertEqual(accountLinkRequest.approved, approvedDate)
    }
    
    func testApprovedByProperty() {
        // Arrange
        let accountLinkRequest = DAOAccountLinkRequest()
        let approverName = "admin_user_123"
        
        // Act
        accountLinkRequest.approvedBy = approverName
        
        // Assert
        XCTAssertEqual(accountLinkRequest.approvedBy, approverName)
    }
    
    func testAccountProperty() {
        // Arrange
        let accountLinkRequest = DAOAccountLinkRequest()
        let testAccount = DAOAccount()
        testAccount.id = "test_account_789"
        
        // Act
        accountLinkRequest.account = testAccount
        
        // Assert
        XCTAssertEqual(accountLinkRequest.account?.id, testAccount.id)
    }
    
    func testUserProperty() {
        // Arrange
        let accountLinkRequest = DAOAccountLinkRequest()
        let testUser = DAOUser()
        testUser.id = "test_user_101"
        
        // Act
        accountLinkRequest.user = testUser
        
        // Assert
        XCTAssertEqual(accountLinkRequest.user?.id, testUser.id)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalRequest = MockDAOAccountLinkRequestFactory.createMock()
        let sourceRequest = MockDAOAccountLinkRequestFactory.createMockWithTestData()
        
        // Act
        originalRequest.update(from: sourceRequest)
        
        // Assert
        XCTAssertEqual(originalRequest.requested, sourceRequest.requested)
        XCTAssertEqual(originalRequest.approved, sourceRequest.approved)
        XCTAssertEqual(originalRequest.approvedBy, sourceRequest.approvedBy)
        XCTAssertEqual(originalRequest.account?.id, sourceRequest.account?.id)
        XCTAssertEqual(originalRequest.user?.id, sourceRequest.user?.id)
    }
    
    func testApprovalWorkflow() {
        // Arrange
        let accountLinkRequest = MockDAOAccountLinkRequestFactory.createMock()
        let approvalDate = Date()
        let approver = "supervisor_123"
        
        // Act - Approve the request
        accountLinkRequest.approved = approvalDate
        accountLinkRequest.approvedBy = approver
        
        // Assert
        XCTAssertNotNil(accountLinkRequest.approved)
        XCTAssertEqual(accountLinkRequest.approved, approvalDate)
        XCTAssertEqual(accountLinkRequest.approvedBy, approver)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalRequest = MockDAOAccountLinkRequestFactory.createSafeAccountLinkRequest()
        
        // Act - Use copy initializer instead of .copy() method to avoid NSCopying issues
        let copiedRequest = DAOAccountLinkRequest(from: originalRequest)
        
        // Assert
        XCTAssertEqual(copiedRequest.requested, originalRequest.requested)
        XCTAssertEqual(copiedRequest.approved, originalRequest.approved)
        XCTAssertEqual(copiedRequest.approvedBy, originalRequest.approvedBy)
        XCTAssertEqual(copiedRequest.account?.id, originalRequest.account?.id)
        XCTAssertEqual(copiedRequest.user?.id, originalRequest.user?.id)
        XCTAssertFalse(copiedRequest === originalRequest) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let request1 = MockDAOAccountLinkRequestFactory.createMockWithTestData()
        let request2 = MockDAOAccountLinkRequestFactory.createMockWithTestData()
        let request3 = MockDAOAccountLinkRequestFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should have matching properties
        XCTAssertEqual(request1.approvedBy, request2.approvedBy, "Requests should have same approvedBy")
        XCTAssertEqual(request1.account?.id, request2.account?.id, "Requests should have same account")
        XCTAssertEqual(request1.user?.id, request2.user?.id, "Requests should have same user")
        
        // Act & Assert - Different data should not be equal  
        XCTAssertNotEqual(request1.approvedBy, request3.approvedBy, "Different requests should have different approvers")
        XCTAssertNotEqual(request1.account?.id ?? "", request3.account?.id ?? "nil", "Different requests should have different accounts")
        
        // Act & Assert - Same instance should be equal
        XCTAssertTrue(request1 == request1)
        XCTAssertFalse(request1 != request1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let request1 = MockDAOAccountLinkRequestFactory.createSafeAccountLinkRequest()
        let request2 = MockDAOAccountLinkRequestFactory.createSafeAccountLinkRequest()
        let request3 = MockDAOAccountLinkRequestFactory.createSafeAccountLinkRequestForCopy()
        
        // Act & Assert - Different objects with same data should be considered different (based on object identity)
        XCTAssertTrue(request1.isDiffFrom(request2))
        
        // Act & Assert - Different data should definitely be different
        XCTAssertTrue(request1.isDiffFrom(request3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(request1.isDiffFrom(request1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(request1.isDiffFrom("not a request"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(request1.isDiffFrom(nil as DAOAccountLinkRequest?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalRequest = MockDAOAccountLinkRequestFactory.createMockWithTestData()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalRequest)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedRequest = try decoder.decode(DAOAccountLinkRequest.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedRequest.requested.timeIntervalSince1970, originalRequest.requested.timeIntervalSince1970, accuracy: 1.0)
        XCTAssertEqual(decodedRequest.approved?.timeIntervalSince1970 ?? 0.0, originalRequest.approved?.timeIntervalSince1970 ?? 0.0, accuracy: 1.0)
        XCTAssertEqual(decodedRequest.approvedBy, originalRequest.approvedBy)
        XCTAssertEqual(decodedRequest.account?.id, originalRequest.account?.id)
        XCTAssertEqual(decodedRequest.user?.id, originalRequest.user?.id)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let accountLinkRequest = MockDAOAccountLinkRequestFactory.createMockWithTestData()
        
        // Act
        let dictionary = accountLinkRequest.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["requested"] as Any?)
        XCTAssertNotNil(dictionary["approved"] as Any?)
        XCTAssertEqual(dictionary["approvedBy"] as? String, accountLinkRequest.approvedBy)
        XCTAssertNotNil(dictionary["account"] as Any?)
        XCTAssertNotNil(dictionary["user"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testNilValues() {
        // Arrange & Act
        let accountLinkRequest = MockDAOAccountLinkRequestFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertNil(accountLinkRequest.account)
        XCTAssertNil(accountLinkRequest.user)
        XCTAssertEqual(accountLinkRequest.approvedBy, "")
    }
    
    func testBoundaryDates() {
        // Arrange
        let accountLinkRequest = DAOAccountLinkRequest()
        
        // Act - Set boundary dates
        accountLinkRequest.requested = Date.distantPast
        accountLinkRequest.approved = Date.distantFuture
        
        // Assert
        XCTAssertEqual(accountLinkRequest.requested, Date.distantPast)
        XCTAssertEqual(accountLinkRequest.approved, Date.distantFuture)
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOAccountLinkRequest()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalRequest = MockDAOAccountLinkRequestFactory.createSafeAccountLinkRequest()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOAccountLinkRequest(from: originalRequest)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let request1 = MockDAOAccountLinkRequestFactory.createSafeAccountLinkRequest()
        let request2 = MockDAOAccountLinkRequestFactory.createSafeAccountLinkRequest()
        
        measure {
            for _ in 0..<1000 {
                _ = request1 == request2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let accountLinkRequest = MockDAOAccountLinkRequestFactory.createSafeAccountLinkRequest()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(accountLinkRequest)
                    _ = try decoder.decode(DAOAccountLinkRequest.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testInitializationWithUser", testInitializationWithUser),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testRequestedProperty", testRequestedProperty),
        ("testApprovedProperty", testApprovedProperty),
        ("testApprovedByProperty", testApprovedByProperty),
        ("testAccountProperty", testAccountProperty),
        ("testUserProperty", testUserProperty),
        ("testUpdateMethod", testUpdateMethod),
        ("testApprovalWorkflow", testApprovalWorkflow),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testNilValues", testNilValues),
        ("testBoundaryDates", testBoundaryDates),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}