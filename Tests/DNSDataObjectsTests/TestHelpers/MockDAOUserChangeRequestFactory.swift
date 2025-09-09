//
//  MockDAOUserChangeRequestFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOUserChangeRequestFactory -
struct MockDAOUserChangeRequestFactory: MockDAOFactory {
    typealias DAOType = DAOUserChangeRequest
    
    static func createMock() -> DAOUserChangeRequest {
        let request = DAOUserChangeRequest()
        request.id = "user_change_request_12345"
        request.requestedRole = .placeStaff
        return request
    }
    
    static func createMockWithTestData() -> DAOUserChangeRequest {
        let request = DAOUserChangeRequest(id: "user_change_request_test_data")
        request.requestedRole = .placeAdmin
        
        // Create test user
        let user = DAOUser()
        user.id = "test_user_123"
        user.name = PersonNameComponents.dnsBuildName(with: "Test User") ?? PersonNameComponents()
        user.email = "test.user@example.com"
        user.userRole = .endUser
        request.user = user
        
        return request
    }
    
    static func createMockWithEdgeCases() -> DAOUserChangeRequest {
        let request = DAOUserChangeRequest()
        
        // Edge cases
        request.id = "" // Empty ID
        request.requestedRole = .blocked // Blocked role
        request.user = nil // No user
        
        return request
    }
    
    static func createMockArray(count: Int) -> [DAOUserChangeRequest] {
        var requests: [DAOUserChangeRequest] = []
        
        let roles: [DNSUserRole] = [.endUser, .placeViewer, .placeStaff, .placeAdmin]
        
        for i in 0..<count {
            let request = DAOUserChangeRequest()
            request.id = "user_change_request\(i)" // Set explicit ID to match test expectations (changed from i + 1)
            request.requestedRole = roles[i % roles.count]
            
            // Add variety to user assignments
            if i % 2 == 0 {
                let user = DAOUser()
                user.id = "user_\(i + 1)"
                user.email = "user\(i + 1)@example.com"
                user.userRole = .endUser
                request.user = user
            }
            
            requests.append(request)
        }
        
        return requests
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOUserChangeRequest {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOUserChangeRequest {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOUserChangeRequest {
        let request = createMockWithTestData()
        request.id = id
        return request
    }
}