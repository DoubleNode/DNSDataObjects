//
//  MockDAOActivityFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOActivityFactory -
struct MockDAOActivityFactory: MockDAOFactory {
    typealias DAOType = DAOActivity
    
    static func createMock() -> DAOActivity {
        let activity = DAOActivity()
        activity.code = "TEST_ACTIVITY"
        activity.name = DNSString(with: "Test Activity")
        return activity
    }
    
    static func createMockWithTestData() -> DAOActivity {
        let activity = DAOActivity(code: "PREMIUM_ACTIVITY", name: DNSString(with: "Premium Activity"))
        
        // Set booking times
        activity.bookingStartTime = Date()
        activity.bookingEndTime = Date().addingTimeInterval(3600) // 1 hour later
        
        // Create base type
        let baseType = DAOActivityType()
        baseType.id = "base_type_test"
        activity.baseType = baseType
        
        // Create blackouts
        let blackout1 = DAOActivityBlackout()
        blackout1.id = "blackout_1"
        let blackout2 = DAOActivityBlackout()
        blackout2.id = "blackout_2"
        activity.blackouts = [blackout1, blackout2]
        
        return activity
    }
    
    static func createMockWithEdgeCases() -> DAOActivity {
        let activity = DAOActivity()
        
        // Edge cases
        activity.code = "" // Empty code
        activity.name = DNSString() // Empty name
        activity.bookingStartTime = nil
        activity.bookingEndTime = nil
        activity.blackouts = [] // Empty blackouts
        
        return activity
    }
    
    static func createMockArray(count: Int) -> [DAOActivity] {
        var activities: [DAOActivity] = []
        
        for i in 0..<count {
            let activity = DAOActivity()
            activity.id = "activity\(i)" // Set explicit ID to match test expectations
            activity.code = "ACTIVITY_\(i + 1)"
            activity.name = DNSString(with: "Activity \(i + 1)")
            
            // Add variety
            if i % 2 == 0 {
                activity.bookingStartTime = Date()
                activity.bookingEndTime = Date().addingTimeInterval(1800) // 30 minutes
            }
            
            if i % 3 == 0 {
                let blackout = DAOActivityBlackout()
                blackout.id = "blackout_\(i)"
                activity.blackouts = [blackout]
            }
            
            activities.append(activity)
        }
        
        return activities
    }
}