//
//  MockDAOSystemStateFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOSystemStateFactory -
struct MockDAOSystemStateFactory: MockDAOFactory {
    typealias DAOType = DAOSystemState
    
    static func createMock() -> DAOSystemState {
        let systemState = DAOSystemState()
        systemState.state = .green
        systemState.stateOverride = .none
        systemState.failureRate = DNSAnalyticsNumbers()
        systemState.totalPoints = DNSAnalyticsNumbers()
        systemState.failureCodes = [:]
        return systemState
    }
    
    static func createMockWithTestData() -> DAOSystemState {
        let systemState = DAOSystemState(id: "system_state_test_data")
        
        // Set state properties
        systemState.state = .yellow
        systemState.stateOverride = .red
        
        // Create analytics numbers for failure rate
        var failureRateData = DNSDataDictionary()
        failureRateData["count"] = 15
        failureRateData["total"] = 100
        failureRateData["percentage"] = 15.0
        systemState.failureRate = DNSAnalyticsNumbers(from: failureRateData)
        
        // Create analytics numbers for total points
        var totalPointsData = DNSDataDictionary()
        totalPointsData["count"] = 850
        totalPointsData["total"] = 1000
        totalPointsData["percentage"] = 85.0
        systemState.totalPoints = DNSAnalyticsNumbers(from: totalPointsData)
        
        // Create failure codes dictionary
        var failureCode1Data = DNSDataDictionary()
        failureCode1Data["count"] = 5
        failureCode1Data["total"] = 100
        failureCode1Data["percentage"] = 5.0
        
        var failureCode2Data = DNSDataDictionary()
        failureCode2Data["count"] = 10
        failureCode2Data["total"] = 100
        failureCode2Data["percentage"] = 10.0
        
        systemState.failureCodes = [
            "HTTP_500": DNSAnalyticsNumbers(from: failureCode1Data),
            "TIMEOUT": DNSAnalyticsNumbers(from: failureCode2Data)
        ]
        
        return systemState
    }
    
    static func createMockWithEdgeCases() -> DAOSystemState {
        let systemState = DAOSystemState()
        
        // Edge cases
        systemState.state = .none
        systemState.stateOverride = .none
        systemState.failureRate = DNSAnalyticsNumbers() // Empty analytics
        systemState.totalPoints = DNSAnalyticsNumbers() // Empty analytics
        systemState.failureCodes = [:] // Empty dictionary
        
        return systemState
    }
    
    static func createMockArray(count: Int) -> [DAOSystemState] {
        var systemStates: [DAOSystemState] = []
        let states: [DNSSystemState] = [.green, .yellow, .red, .none]
        
        for i in 0..<count {
            let systemState = DAOSystemState()
            systemState.id = "system_state\(i)" // Set explicit ID to match test expectations
            systemState.state = states[i % states.count]
            systemState.stateOverride = .none
            
            // Create varying analytics data
            var failureRateData = DNSDataDictionary()
            failureRateData["count"] = i * 2
            failureRateData["total"] = 100
            failureRateData["percentage"] = Double(i * 2)
            systemState.failureRate = DNSAnalyticsNumbers(from: failureRateData)
            
            var totalPointsData = DNSDataDictionary()
            totalPointsData["count"] = 100 - (i * 2)
            totalPointsData["total"] = 100
            totalPointsData["percentage"] = Double(100 - (i * 2))
            systemState.totalPoints = DNSAnalyticsNumbers(from: totalPointsData)
            
            systemStates.append(systemState)
        }
        
        return systemStates
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOSystemState {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOSystemState {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOSystemState {
        let systemState = createMockWithTestData()
        systemState.id = id
        return systemState
    }
}