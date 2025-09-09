//
//  MockDAOChangeRequestFactory.swift
//  DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

struct MockDAOChangeRequestFactory: MockDAOFactory {
    typealias DAOType = DAOChangeRequest
    
    static func createMock() -> DAOChangeRequest {
        let dao = DAOChangeRequest()
        return dao
    }
    
    static func createMockWithTestData() -> DAOChangeRequest {
        let dao = DAOChangeRequest()
        dao.id = "change_request_12345"
        // DAOChangeRequest is essentially empty - only has base properties
        return dao
    }
    
    static func createMockWithEdgeCases() -> DAOChangeRequest {
        let dao = DAOChangeRequest()
        // Edge case - completely empty
        return dao
    }
    
    static func createMockArray(count: Int) -> [DAOChangeRequest] {
        var changeRequests: [DAOChangeRequest] = []
        for i in 0..<count {
            let dao = DAOChangeRequest()
            dao.id = "change_request\(i)" // Set explicit ID to match test expectations (changed from i + 1)
            changeRequests.append(dao)
        }
        return changeRequests
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOChangeRequest {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOChangeRequest {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOChangeRequest {
        let dao = createMockWithTestData()
        dao.id = id
        return dao
    }
}