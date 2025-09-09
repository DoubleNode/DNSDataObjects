//
//  MockDAOActivityBlackoutFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOActivityBlackoutFactory -
struct MockDAOActivityBlackoutFactory: MockDAOFactory {
    typealias DAOType = DAOActivityBlackout
    
    static func createMock() -> DAOActivityBlackout {
        let activityBlackout = DAOActivityBlackout()
        activityBlackout.message = DNSString(with: "Mock blackout period")
        activityBlackout.startTime = Date()
        activityBlackout.endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        return activityBlackout
    }
    
    static func createMockWithTestData() -> DAOActivityBlackout {
        let activityBlackout = DAOActivityBlackout()
        
        // Realistic test data
        let now = Date()
        activityBlackout.message = DNSString(with: "Scheduled maintenance blackout for activity testing")
        activityBlackout.startTime = Calendar.current.date(byAdding: .hour, value: 2, to: now) ?? now
        activityBlackout.endTime = Calendar.current.date(byAdding: .hour, value: 4, to: now) ?? now
        
        return activityBlackout
    }
    
    static func createMockWithEdgeCases() -> DAOActivityBlackout {
        let activityBlackout = DAOActivityBlackout()
        
        // Edge cases and boundary values
        activityBlackout.message = DNSString() // Empty message
        activityBlackout.startTime = nil // No start time
        activityBlackout.endTime = nil // No end time
        
        return activityBlackout
    }
    
    static func createMockArray(count: Int) -> [DAOActivityBlackout] {
        var activityBlackouts: [DAOActivityBlackout] = []
        
        for i in 0..<count {
            let activityBlackout = DAOActivityBlackout()
            activityBlackout.id = "activity_blackout\(i)" // Set explicit ID to match test expectations
            let baseDate = Date()
            
            activityBlackout.message = DNSString(with: "Blackout period \(i + 1)")
            activityBlackout.startTime = Calendar.current.date(byAdding: .hour, value: i, to: baseDate) ?? baseDate
            activityBlackout.endTime = Calendar.current.date(byAdding: .hour, value: i + 2, to: baseDate) ?? baseDate
            
            activityBlackouts.append(activityBlackout)
        }
        
        return activityBlackouts
    }
}