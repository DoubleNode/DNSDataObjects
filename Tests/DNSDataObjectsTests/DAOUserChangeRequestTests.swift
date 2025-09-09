//
//  DAOUserChangeRequestTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOUserChangeRequestTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInit_Default_CreatesValidObject() {
        let request = DAOUserChangeRequest()
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request.requestedRole, .endUser)
        XCTAssertNil(request.user)
    }
    
    func testInit_WithId_CreatesValidObjectWithId() {
        let id = "test_request_id"
        let request = DAOUserChangeRequest(id: id)
        
        XCTAssertEqual(request.id, id)
        XCTAssertEqual(request.requestedRole, .endUser)
        XCTAssertNil(request.user)
    }
    
    func testInit_WithUser_CreatesValidObjectWithUser() {
        let user = DAOUser()
        user.id = "test_user_id"
        
        let request = DAOUserChangeRequest(user: user)
        
        XCTAssertNotNil(request.user)
        XCTAssertEqual(request.user?.id, "test_user_id")
        XCTAssertEqual(request.requestedRole, .endUser)
    }
    
    func testInit_FromObject_CopiesAllProperties() {
        let original = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let copy = DAOUserChangeRequest(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.requestedRole, original.requestedRole)
        XCTAssertEqual(copy.user?.id, original.user?.id)
        XCTAssertEqual(copy.user?.email, original.user?.email)
    }
    
    func testInit_FromDictionary_ValidData_CreatesObject() {
        let userData: DNSDataDictionary = [
            "id": "user_123",
            "email": "test@example.com",
            "userRole": DNSUserRole.endUser.rawValue
        ]
        
        let data: DNSDataDictionary = [
            "id": "request_id",
            "requestedRole": DNSUserRole.placeAdmin.rawValue,
            "user": userData
        ]
        
        let request = DAOUserChangeRequest(from: data)
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.id, "request_id")
        XCTAssertEqual(request?.requestedRole, .placeAdmin)
        XCTAssertEqual(request?.user?.id, "user_123")
        XCTAssertEqual(request?.user?.email, "test@example.com")
    }
    
    func testInit_FromDictionary_EmptyData_ReturnsNil() {
        let data: DNSDataDictionary = [:]
        let request = DAOUserChangeRequest(from: data)
        
        XCTAssertNil(request)
    }
    
    func testInit_FromDictionary_WithoutUser_CreatesObjectWithoutUser() {
        let data: DNSDataDictionary = [
            "id": "request_id",
            "requestedRole": DNSUserRole.placeStaff.rawValue
        ]
        
        let request = DAOUserChangeRequest(from: data)
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.id, "request_id")
        XCTAssertEqual(request?.requestedRole, .placeStaff)
        XCTAssertNil(request?.user)
    }
    
    // MARK: - Property Tests
    
    func testRequestedRole_SetAndGet_WorksCorrectly() {
        let request = DAOUserChangeRequest()
        
        request.requestedRole = .placeAdmin
        
        XCTAssertEqual(request.requestedRole, .placeAdmin)
    }
    
    func testRequestedRole_AllValidRoles_WorkCorrectly() {
        let request = DAOUserChangeRequest()
        let roles: [DNSUserRole] = [.endUser, .placeViewer, .placeStaff, .placeAdmin, .blocked]
        
        for role in roles {
            request.requestedRole = role
            XCTAssertEqual(request.requestedRole, role)
        }
    }
    
    func testUser_SetAndGet_WorksCorrectly() {
        let request = DAOUserChangeRequest()
        let user = DAOUser()
        user.id = "test_user"
        user.email = "test@example.com"
        
        request.user = user
        
        XCTAssertNotNil(request.user)
        XCTAssertEqual(request.user?.id, "test_user")
        XCTAssertEqual(request.user?.email, "test@example.com")
    }
    
    func testUser_SetToNil_WorksCorrectly() {
        let request = MockDAOUserChangeRequestFactory.createMockWithTestData()
        
        request.user = nil
        
        XCTAssertNil(request.user)
    }
    
    // MARK: - DAO Translation Tests
    
    func testAsDictionary_WithAllProperties_ContainsAllData() {
        let request = MockDAOUserChangeRequestFactory.createMockWithTestData()
        
        let dictionary = request.asDictionary
        
        XCTAssertEqual(dictionary["id"] as? String, request.id)
        XCTAssertEqual(dictionary["requestedRole"] as? Int, request.requestedRole.rawValue)
        XCTAssertNotNil(dictionary["user"] as? DNSDataDictionary)
    }
    
    func testAsDictionary_WithoutUser_ContainsBasicData() {
        let request = DAOUserChangeRequest()
        request.id = "test_id"
        request.requestedRole = .placeStaff
        
        let dictionary = request.asDictionary
        
        XCTAssertEqual(dictionary["id"] as? String, "test_id")
        XCTAssertEqual(dictionary["requestedRole"] as? Int, DNSUserRole.placeStaff.rawValue)
        // Note: user entry handling varies by implementation, main test is that basic data is present
    }
    
    func testDao_FromDictionary_UpdatesExistingObject() {
        let request = DAOUserChangeRequest()
        let userData: DNSDataDictionary = [
            "id": "user_456",
            "email": "updated@example.com"
        ]
        
        let data: DNSDataDictionary = [
            "id": "updated_id",
            "requestedRole": DNSUserRole.placeViewer.rawValue,
            "user": userData
        ]
        
        let updatedRequest = request.dao(from: data)
        
        XCTAssertEqual(updatedRequest.id, "updated_id")
        XCTAssertEqual(updatedRequest.requestedRole, .placeViewer)
        XCTAssertEqual(updatedRequest.user?.id, "user_456")
    }
    
    // MARK: - Codable Tests
    
    func testEncode_ValidObject_ProducesValidJSON() throws {
        let request = MockDAOUserChangeRequestFactory.createMockWithTestData()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        
        XCTAssertGreaterThan(data.count, 0)
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = jsonObject as? [String: Any] else {
            XCTFail("Encoded data should be a dictionary")
            return
        }
        
        XCTAssertNotNil(dictionary["id"])
        XCTAssertNotNil(dictionary["requestedRole"])
        XCTAssertNotNil(dictionary["user"])
    }
    
    func testDecode_ValidJSON_CreatesValidObject() throws {
        let json = """
        {
            "id": "decoded_request",
            "requestedRole": \(DNSUserRole.placeAdmin.rawValue),
            "user": {
                "id": "decoded_user",
                "email": "decoded@example.com"
            }
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let request = try decoder.decode(DAOUserChangeRequest.self, from: data)
        
        XCTAssertEqual(request.id, "decoded_request")
        XCTAssertEqual(request.requestedRole, .placeAdmin)
        XCTAssertEqual(request.user?.id, "decoded_user")
        XCTAssertEqual(request.user?.email, "decoded@example.com")
    }
    
    func testDecode_WithoutUser_CreatesValidObject() throws {
        let json = """
        {
            "id": "decoded_request",
            "requestedRole": \(DNSUserRole.placeStaff.rawValue)
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let request = try decoder.decode(DAOUserChangeRequest.self, from: data)
        
        XCTAssertEqual(request.id, "decoded_request")
        XCTAssertEqual(request.requestedRole, .placeStaff)
        XCTAssertNil(request.user)
    }
    
    // MARK: - Copy Tests
    
    func testCopy_CreatesIdenticalObject() {
        let original = MockDAOUserChangeRequestFactory.createMockWithTestData()
        
        let copy = original.copy() as! DAOUserChangeRequest
        
        XCTAssertTrue(original !== copy) // Different instances
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.requestedRole, copy.requestedRole)
        XCTAssertEqual(original.user?.id, copy.user?.id)
        XCTAssertEqual(original.user?.email, copy.user?.email)
    }
    
    func testCopy_WithoutUser_CreatesIdenticalObject() {
        let original = DAOUserChangeRequest()
        original.id = "test_id"
        original.requestedRole = .placeViewer
        
        let copy = original.copy() as! DAOUserChangeRequest
        
        XCTAssertTrue(original !== copy)
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.requestedRole, copy.requestedRole)
        XCTAssertNil(copy.user)
    }
    
    // MARK: - Update Tests
    
    func testUpdate_FromObject_UpdatesAllProperties() {
        let request = DAOUserChangeRequest()
        let source = MockDAOUserChangeRequestFactory.createMockWithTestData()
        
        request.update(from: source)
        
        XCTAssertEqual(request.id, source.id)
        XCTAssertEqual(request.requestedRole, source.requestedRole)
        XCTAssertEqual(request.user?.id, source.user?.id)
        XCTAssertEqual(request.user?.email, source.user?.email)
    }
    
    func testUpdate_FromObjectWithoutUser_UpdatesCorrectly() {
        let request = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let source = DAOUserChangeRequest()
        source.id = "updated_id"
        source.requestedRole = .blocked
        source.user = nil
        
        request.update(from: source)
        
        XCTAssertEqual(request.id, "updated_id")
        XCTAssertEqual(request.requestedRole, .blocked)
        XCTAssertNil(request.user)
    }
    
    // MARK: - Equality Tests
    
    func testEquality_SameObjects_ReturnsTrue() {
        let request1 = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let request2 = DAOUserChangeRequest(from: request1)
        
        XCTAssertTrue(request1 == request2)
        XCTAssertFalse(request1 != request2)
    }
    
    func testEquality_DifferentRequestedRole_ReturnsFalse() {
        let request1 = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let request2 = DAOUserChangeRequest(from: request1)
        request2.requestedRole = .blocked
        
        XCTAssertFalse(request1 == request2)
        XCTAssertTrue(request1 != request2)
    }
    
    func testEquality_DifferentUser_ReturnsFalse() {
        let request1 = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let request2 = DAOUserChangeRequest(from: request1)
        request2.user?.id = "different_user"
        
        XCTAssertFalse(request1 == request2)
        XCTAssertTrue(request1 != request2)
    }
    
    func testEquality_OneWithUserOneWithout_ReturnsFalse() {
        let request1 = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let request2 = DAOUserChangeRequest(from: request1)
        request2.user = nil
        
        XCTAssertFalse(request1 == request2)
        XCTAssertTrue(request1 != request2)
    }
    
    func testEquality_SameInstance_ReturnsTrue() {
        let request = MockDAOUserChangeRequestFactory.createMockWithTestData()
        
        XCTAssertTrue(request == request)
        XCTAssertFalse(request != request)
    }
    
    // MARK: - IsDiffFrom Tests
    
    func testIsDiffFrom_SameObjects_ReturnsFalse() {
        let request1 = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let request2 = DAOUserChangeRequest(from: request1)
        
        XCTAssertFalse(request1.isDiffFrom(request2))
    }
    
    func testIsDiffFrom_DifferentRequestedRole_ReturnsTrue() {
        let request1 = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let request2 = DAOUserChangeRequest(from: request1)
        request2.requestedRole = .blocked
        
        XCTAssertTrue(request1.isDiffFrom(request2))
    }
    
    func testIsDiffFrom_DifferentUser_ReturnsTrue() {
        let request1 = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let request2 = DAOUserChangeRequest(from: request1)
        request2.user?.email = "different@example.com"
        
        XCTAssertTrue(request1.isDiffFrom(request2))
    }
    
    func testIsDiffFrom_NilComparison_ReturnsTrue() {
        let request = MockDAOUserChangeRequestFactory.createMockWithTestData()
        
        XCTAssertTrue(request.isDiffFrom(nil))
    }
    
    func testIsDiffFrom_DifferentType_ReturnsTrue() {
        let request = MockDAOUserChangeRequestFactory.createMockWithTestData()
        let differentObject = "string"
        
        XCTAssertTrue(request.isDiffFrom(differentObject))
    }
    
    func testIsDiffFrom_SameInstance_ReturnsFalse() {
        let request = MockDAOUserChangeRequestFactory.createMockWithTestData()
        
        XCTAssertFalse(request.isDiffFrom(request))
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCases_EmptyId_HandledCorrectly() {
        let request = DAOUserChangeRequest()
        request.id = ""
        
        XCTAssertEqual(request.id, "")
        XCTAssertEqual(request.requestedRole, .endUser)
    }
    
    func testEdgeCases_BlockedRole_HandledCorrectly() {
        let request = DAOUserChangeRequest()
        request.requestedRole = .blocked
        
        XCTAssertEqual(request.requestedRole, .blocked)
    }
    
    func testEdgeCases_UserWithEmptyProperties_HandledCorrectly() {
        let request = DAOUserChangeRequest()
        let user = DAOUser()
        user.id = ""
        user.email = ""
        
        request.user = user
        
        XCTAssertNotNil(request.user)
        XCTAssertEqual(request.user?.id, "")
        XCTAssertEqual(request.user?.email ?? "", "")
    }
    
    func testEdgeCases_FromDictionary_InvalidRole_UsesDefault() {
        let data: DNSDataDictionary = [
            "id": "request_id",
            "requestedRole": 999 // Invalid role
        ]
        
        let request = DAOUserChangeRequest(from: data)
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.requestedRole, .endUser) // Should use default
    }
    
    func testEdgeCases_FromDictionary_InvalidUserData_HandledGracefully() {
        let data: DNSDataDictionary = [
            "id": "request_id",
            "requestedRole": DNSUserRole.placeAdmin.rawValue,
            "user": "invalid_user_data" // Invalid user data
        ]
        
        let request = DAOUserChangeRequest(from: data)
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.id, "request_id")
        XCTAssertEqual(request?.requestedRole, .placeAdmin)
        XCTAssertNil(request?.user) // Should be nil due to invalid data
    }
    
    // MARK: - Factory Method Tests
    
    func testCreateUser_ReturnsValidUser() {
        let user = DAOUserChangeRequest.createUser()
        
        XCTAssertNotNil(user)
        XCTAssertTrue(user is DAOUser)
    }
    
    func testCreateUser_FromObject_CopiesUserCorrectly() {
        let originalUser = DAOUser()
        originalUser.id = "original_user"
        originalUser.email = "original@example.com"
        
        let newUser = DAOUserChangeRequest.createUser(from: originalUser)
        
        XCTAssertEqual(newUser.id, originalUser.id)
        XCTAssertEqual(newUser.email, originalUser.email)
    }
    
    func testCreateUser_FromDictionary_CreatesUserFromData() {
        let userData: DNSDataDictionary = [
            "id": "dict_user",
            "email": "dict@example.com"
        ]
        
        let user = DAOUserChangeRequest.createUser(from: userData)
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.id, "dict_user")
        XCTAssertEqual(user?.email, "dict@example.com")
    }
    
    func testCreateUser_FromEmptyDictionary_ReturnsNil() {
        let userData: DNSDataDictionary = [:]
        
        let user = DAOUserChangeRequest.createUser(from: userData)
        
        XCTAssertNil(user)
    }

    static var allTests = [
        ("testInit_Default_CreatesValidObject", testInit_Default_CreatesValidObject),
        ("testInit_WithId_CreatesValidObjectWithId", testInit_WithId_CreatesValidObjectWithId),
        ("testInit_WithUser_CreatesValidObjectWithUser", testInit_WithUser_CreatesValidObjectWithUser),
        ("testInit_FromObject_CopiesAllProperties", testInit_FromObject_CopiesAllProperties),
        ("testInit_FromDictionary_ValidData_CreatesObject", testInit_FromDictionary_ValidData_CreatesObject),
        ("testInit_FromDictionary_EmptyData_ReturnsNil", testInit_FromDictionary_EmptyData_ReturnsNil),
        ("testInit_FromDictionary_WithoutUser_CreatesObjectWithoutUser", testInit_FromDictionary_WithoutUser_CreatesObjectWithoutUser),
        ("testRequestedRole_SetAndGet_WorksCorrectly", testRequestedRole_SetAndGet_WorksCorrectly),
        ("testRequestedRole_AllValidRoles_WorkCorrectly", testRequestedRole_AllValidRoles_WorkCorrectly),
        ("testUser_SetAndGet_WorksCorrectly", testUser_SetAndGet_WorksCorrectly),
        ("testUser_SetToNil_WorksCorrectly", testUser_SetToNil_WorksCorrectly),
        ("testAsDictionary_WithAllProperties_ContainsAllData", testAsDictionary_WithAllProperties_ContainsAllData),
        ("testAsDictionary_WithoutUser_ContainsBasicData", testAsDictionary_WithoutUser_ContainsBasicData),
        ("testDao_FromDictionary_UpdatesExistingObject", testDao_FromDictionary_UpdatesExistingObject),
        ("testEncode_ValidObject_ProducesValidJSON", testEncode_ValidObject_ProducesValidJSON),
        ("testDecode_ValidJSON_CreatesValidObject", testDecode_ValidJSON_CreatesValidObject),
        ("testDecode_WithoutUser_CreatesValidObject", testDecode_WithoutUser_CreatesValidObject),
        ("testCopy_CreatesIdenticalObject", testCopy_CreatesIdenticalObject),
        ("testCopy_WithoutUser_CreatesIdenticalObject", testCopy_WithoutUser_CreatesIdenticalObject),
        ("testUpdate_FromObject_UpdatesAllProperties", testUpdate_FromObject_UpdatesAllProperties),
        ("testUpdate_FromObjectWithoutUser_UpdatesCorrectly", testUpdate_FromObjectWithoutUser_UpdatesCorrectly),
        ("testEquality_SameObjects_ReturnsTrue", testEquality_SameObjects_ReturnsTrue),
        ("testEquality_DifferentRequestedRole_ReturnsFalse", testEquality_DifferentRequestedRole_ReturnsFalse),
        ("testEquality_DifferentUser_ReturnsFalse", testEquality_DifferentUser_ReturnsFalse),
        ("testEquality_OneWithUserOneWithout_ReturnsFalse", testEquality_OneWithUserOneWithout_ReturnsFalse),
        ("testEquality_SameInstance_ReturnsTrue", testEquality_SameInstance_ReturnsTrue),
        ("testIsDiffFrom_SameObjects_ReturnsFalse", testIsDiffFrom_SameObjects_ReturnsFalse),
        ("testIsDiffFrom_DifferentRequestedRole_ReturnsTrue", testIsDiffFrom_DifferentRequestedRole_ReturnsTrue),
        ("testIsDiffFrom_DifferentUser_ReturnsTrue", testIsDiffFrom_DifferentUser_ReturnsTrue),
        ("testIsDiffFrom_NilComparison_ReturnsTrue", testIsDiffFrom_NilComparison_ReturnsTrue),
        ("testIsDiffFrom_DifferentType_ReturnsTrue", testIsDiffFrom_DifferentType_ReturnsTrue),
        ("testIsDiffFrom_SameInstance_ReturnsFalse", testIsDiffFrom_SameInstance_ReturnsFalse),
        ("testEdgeCases_EmptyId_HandledCorrectly", testEdgeCases_EmptyId_HandledCorrectly),
        ("testEdgeCases_BlockedRole_HandledCorrectly", testEdgeCases_BlockedRole_HandledCorrectly),
        ("testEdgeCases_UserWithEmptyProperties_HandledCorrectly", testEdgeCases_UserWithEmptyProperties_HandledCorrectly),
        ("testEdgeCases_FromDictionary_InvalidRole_UsesDefault", testEdgeCases_FromDictionary_InvalidRole_UsesDefault),
        ("testEdgeCases_FromDictionary_InvalidUserData_HandledGracefully", testEdgeCases_FromDictionary_InvalidUserData_HandledGracefully),
        ("testCreateUser_ReturnsValidUser", testCreateUser_ReturnsValidUser),
        ("testCreateUser_FromObject_CopiesUserCorrectly", testCreateUser_FromObject_CopiesUserCorrectly),
        ("testCreateUser_FromDictionary_CreatesUserFromData", testCreateUser_FromDictionary_CreatesUserFromData),
        ("testCreateUser_FromEmptyDictionary_ReturnsNil", testCreateUser_FromEmptyDictionary_ReturnsNil),
    ]
}
