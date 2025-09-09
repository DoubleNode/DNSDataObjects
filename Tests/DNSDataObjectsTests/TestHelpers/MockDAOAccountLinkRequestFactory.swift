//
//  MockDAOAccountLinkRequestFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOAccountLinkRequestFactory -
struct MockDAOAccountLinkRequestFactory: MockDAOFactory {
    typealias DAOType = DAOAccountLinkRequest
    
    static func createMock() -> DAOAccountLinkRequest {
        let accountLinkRequest = DAOAccountLinkRequest()
        // Basic valid object with minimal data
        accountLinkRequest.requested = Date()
        accountLinkRequest.approved = nil
        accountLinkRequest.approvedBy = ""
        return accountLinkRequest
    }
    
    static func createMockWithTestData() -> DAOAccountLinkRequest {
        let accountLinkRequest = DAOAccountLinkRequest()
        
        // Realistic test data
        accountLinkRequest.requested = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        accountLinkRequest.approved = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        accountLinkRequest.approvedBy = "admin_user_123"
        
        // Create test account
        let account = DAOAccount()
        account.id = "test_account_123"
        accountLinkRequest.account = account
        
        // Create test user
        let user = DAOUser()
        user.id = "test_user_456"
        accountLinkRequest.user = user
        
        return accountLinkRequest
    }
    
    static func createMockWithEdgeCases() -> DAOAccountLinkRequest {
        let accountLinkRequest = DAOAccountLinkRequest()
        
        // Edge cases and boundary values
        accountLinkRequest.requested = Date.distantPast // Very old date
        accountLinkRequest.approved = Date.distantFuture // Future date (unusual but valid)
        accountLinkRequest.approvedBy = "" // Empty approver
        
        // nil relationships (edge cases)
        accountLinkRequest.account = nil
        accountLinkRequest.user = nil
        
        return accountLinkRequest
    }
    
    static func createMockArray(count: Int) -> [DAOAccountLinkRequest] {
        var accountLinkRequests: [DAOAccountLinkRequest] = []
        
        for i in 0..<count {
            let accountLinkRequest = DAOAccountLinkRequest()
            accountLinkRequest.id = "account_link_request\(i)" // Set explicit ID to match test expectations
            accountLinkRequest.requested = Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            
            if i % 2 == 0 { // Every other request is approved
                accountLinkRequest.approved = Calendar.current.date(byAdding: .hour, value: i, to: Date())
                accountLinkRequest.approvedBy = "approver_\(i)"
            }
            
            if i % 3 == 0 { // Every third gets an account
                let account = DAOAccount()
                account.id = "account_\(i)"
                accountLinkRequest.account = account
            }
            
            // All get users
            let user = DAOUser()
            user.id = "user_\(i)"
            accountLinkRequest.user = user
            
            accountLinkRequests.append(accountLinkRequest)
        }
        
        return accountLinkRequests
    }
    
    // Safe versions for copy operations and distinct data for tests
    static func createSafeAccountLinkRequest() -> DAOAccountLinkRequest {
        let accountLinkRequest = DAOAccountLinkRequest()
        accountLinkRequest.id = "safe-link-request-123"
        accountLinkRequest.requested = Date(timeIntervalSinceReferenceDate: 1000)
        accountLinkRequest.approved = Date(timeIntervalSinceReferenceDate: 2000)
        accountLinkRequest.approvedBy = "safe_admin"
        
        // Simple account and user without complex nested objects
        let account = DAOAccount()
        account.id = "safe_account_123"
        accountLinkRequest.account = account
        
        let user = DAOUser()
        user.id = "safe_user_123" 
        accountLinkRequest.user = user
        
        return accountLinkRequest
    }
    
    static func createSafeAccountLinkRequestForCopy() -> DAOAccountLinkRequest {
        let accountLinkRequest = DAOAccountLinkRequest()
        accountLinkRequest.id = "copy-safe-link-request-456"
        accountLinkRequest.requested = Date(timeIntervalSinceReferenceDate: 3000)
        accountLinkRequest.approved = Date(timeIntervalSinceReferenceDate: 4000)
        accountLinkRequest.approvedBy = "copy_safe_admin"
        
        // Different safe account and user
        let account = DAOAccount()
        account.id = "copy_safe_account_456"
        accountLinkRequest.account = account
        
        let user = DAOUser()
        user.id = "copy_safe_user_456"
        accountLinkRequest.user = user
        
        return accountLinkRequest
    }
}