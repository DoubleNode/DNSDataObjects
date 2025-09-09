//
//  MockDAOApplicationFactory.swift
//  DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

struct MockDAOApplicationFactory: MockDAOFactory {
    typealias DAOType = DAOApplication
    static func createMock() -> DAOApplication {
        let dao = DAOApplication()
        return dao
    }
    
    static func createMockWithTestData() -> DAOApplication {
        let dao = DAOApplication()
        dao.id = "app_12345"
        
        // Create mock app events - simplified to avoid dependency issues
        let appEvent1 = DAOAppEvent()
        appEvent1.id = "event_001"
        
        let appEvent2 = DAOAppEvent()
        appEvent2.id = "event_002"
        
        dao.appEvents = [appEvent1, appEvent2]
        
        return dao
    }
    
    static func createMockWithEdgeCases() -> DAOApplication {
        let dao = DAOApplication()
        dao.appEvents = [] // Empty app events
        return dao
    }
    
    static func createMockArray(count: Int) -> [DAOApplication] {
        var applications: [DAOApplication] = []
        for i in 0..<count {
            let dao = DAOApplication()
            dao.id = "application\(i)" // Set explicit ID to match test expectations (changed from app_\(i + 1))
            
            // Add some variety
            if i % 2 == 0 {
                let appEvent = DAOAppEvent()
                appEvent.id = "event_\(i + 1)"
                dao.appEvents = [appEvent]
            }
            
            applications.append(dao)
        }
        return applications
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOApplication {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOApplication {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOApplication {
        let dao = createMockWithTestData()
        dao.id = id
        return dao
    }
}