//
//  MockDAOSystemEndPointFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOSystemEndPointFactory -
struct MockDAOSystemEndPointFactory: MockDAOFactory {
    typealias DAOType = DAOSystemEndPoint
    
    static func createMock() -> DAOSystemEndPoint {
        let endPoint = DAOSystemEndPoint()
        endPoint.name = DNSString(with: "Mock System EndPoint")
        
        // Create current state
        let currentState = DAOSystemState()
        currentState.state = .green
        currentState.failureRate = DNSAnalyticsNumbers(android: 0.0, iOS: 0.0, total: 0.0)
        currentState.totalPoints = DNSAnalyticsNumbers(android: 2525.0, iOS: 2525.0, total: 5050.0)
        endPoint.currentState = currentState
        
        // Create system
        let system = DAOSystem()
        system.name = DNSString(with: "Mock System")
        system.message = DNSString(with: "System running normally")
        endPoint.system = system
        
        return endPoint
    }
    
    static func createMockWithTestData() -> DAOSystemEndPoint {
        let endPoint = DAOSystemEndPoint(id: "endpoint_test_data")
        endPoint.name = DNSString(with: "Test System EndPoint")
        
        // Create detailed current state
        let currentState = DAOSystemState()
        currentState.id = "current_state_test"
        currentState.state = .yellow
        currentState.stateOverride = .green
        currentState.failureRate = DNSAnalyticsNumbers(android: 1.75, iOS: 1.75, total: 3.5)
        currentState.totalPoints = DNSAnalyticsNumbers(android: 1250.0, iOS: 1250.0, total: 2500.0)
        currentState.failureCodes = [
            "404": DNSAnalyticsNumbers(android: 2.5, iOS: 2.5, total: 5.0),
            "500": DNSAnalyticsNumbers(android: 1.5, iOS: 1.5, total: 3.0)
        ]
        endPoint.currentState = currentState
        
        // Create test system
        let system = DAOSystem()
        system.id = "system_test"
        system.name = DNSString(with: "Test System")
        system.message = DNSString(with: "Comprehensive test system with full data")
        endPoint.system = system
        
        // Create history states
        let historyState1 = DAOSystemState()
        historyState1.id = "history_1"
        historyState1.state = .green
        historyState1.failureRate = DNSAnalyticsNumbers(android: 0.125, iOS: 0.125, total: 0.25)
        
        let historyState2 = DAOSystemState()
        historyState2.id = "history_2"
        historyState2.state = .red
        historyState2.failureRate = DNSAnalyticsNumbers(android: 9.25, iOS: 9.25, total: 18.5)
        historyState2.failureCodes = [
            "503": DNSAnalyticsNumbers(android: 7.5, iOS: 7.5, total: 15.0)
        ]
        
        endPoint.historyState = [historyState1, historyState2]
        
        return endPoint
    }
    
    static func createMockWithEdgeCases() -> DAOSystemEndPoint {
        let endPoint = DAOSystemEndPoint()
        
        // Edge cases
        endPoint.name = DNSString() // Empty name
        
        // Minimal current state
        let currentState = DAOSystemState()
        currentState.state = .none
        currentState.stateOverride = .none
        currentState.failureRate = DNSAnalyticsNumbers()
        currentState.totalPoints = DNSAnalyticsNumbers()
        currentState.failureCodes = [:]
        endPoint.currentState = currentState
        
        // Minimal system
        let system = DAOSystem()
        system.name = DNSString()
        system.message = DNSString()
        endPoint.system = system
        
        // No history
        endPoint.historyState = []
        
        return endPoint
    }
    
    static func createMockArray(count: Int) -> [DAOSystemEndPoint] {
        var endPoints: [DAOSystemEndPoint] = []
        
        for i in 0..<count {
            let endPoint = DAOSystemEndPoint()
            endPoint.id = "endpoint\(i)" // Set explicit ID to match test expectations
            endPoint.name = DNSString(with: "EndPoint \(i + 1)")
            
            let currentState = DAOSystemState()
            currentState.state = i % 2 == 0 ? .green : .yellow
            currentState.failureRate = DNSAnalyticsNumbers(android: Double(i) * 0.05, iOS: Double(i) * 0.1, total: Double(i) * 0.5)
            endPoint.currentState = currentState
            
            let system = DAOSystem()
            system.name = DNSString(with: "System for EndPoint \(i + 1)")
            endPoint.system = system
            
            endPoints.append(endPoint)
        }
        
        return endPoints
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOSystemEndPoint {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOSystemEndPoint {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOSystemEndPoint {
        let endPoint = createMockWithTestData()
        endPoint.id = id
        return endPoint
    }
}