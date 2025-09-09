//
//  MockDAOSystemFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOSystemFactory -
struct MockDAOSystemFactory: MockDAOFactory {
    typealias DAOType = DAOSystem
    
    static func createMock() -> DAOSystem {
        let system = DAOSystem()
        system.name = DNSString(with: "Mock System")
        system.message = DNSString(with: "System is running normally")
        return system
    }
    
    static func createMockWithTestData() -> DAOSystem {
        let system = DAOSystem(id: "system_test_data")
        system.name = DNSString(with: "Test System")
        system.message = DNSString(with: "Comprehensive test system with data")
        
        // Create current system state
        let currentState = DAOSystemState()
        currentState.id = "current_state"
        system.currentState = currentState
        
        // Create system endpoints
        let endpoint1 = DAOSystemEndPoint()
        endpoint1.id = "endpoint_1"
        let endpoint2 = DAOSystemEndPoint()
        endpoint2.id = "endpoint_2"
        system.endPoints = [endpoint1, endpoint2]
        
        // Create system states history
        let state1 = DAOSystemState()
        state1.id = "history_state_1"
        let state2 = DAOSystemState()
        state2.id = "history_state_2"
        system.historyState = [state1, state2]
        
        return system
    }
    
    static func createMockWithEdgeCases() -> DAOSystem {
        let system = DAOSystem()
        
        // Edge cases
        system.name = DNSString() // Empty name
        system.message = DNSString() // Empty message
        system.endPoints = [] // No endpoints
        system.historyState = [] // No history
        system.currentState = DAOSystemState() // Default empty state (initialized by DAOSystem init)
        
        return system
    }
    
    static func createMockArray(count: Int) -> [DAOSystem] {
        var systems: [DAOSystem] = []
        
        for i in 0..<count {
            let system = DAOSystem()
            system.id = "system\(i)" // Set explicit ID to match test expectations
            system.name = DNSString(with: "System \(i + 1)")
            system.message = DNSString(with: "Status message for system \(i + 1)")
            systems.append(system)
        }
        
        return systems
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOSystem {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOSystem {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOSystem {
        let system = createMockWithTestData()
        system.id = id
        return system
    }
}