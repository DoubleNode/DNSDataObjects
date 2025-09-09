//
//  MockDAOEventDayFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOEventDayFactory -
struct MockDAOEventDayFactory: MockDAOFactory {
    typealias DAOType = DAOEventDay
    
    static func createMock() -> DAOEventDay {
        let eventDay = DAOEventDay()
        eventDay.id = "event_day_12345"
        return eventDay
    }
    
    static func createMockWithTestData() -> DAOEventDay {
        let eventDay = DAOEventDay(id: "event_day_typical_123")
        eventDay.title = DNSString(with: "Test Event Day")
        eventDay.body = DNSString(with: "Event description")
        // Ensure consistent metadata for equality tests
        let fixedDate = Date(timeIntervalSince1970: 1609459200) // Fixed timestamp
        eventDay.meta.created = fixedDate
        eventDay.meta.updated = fixedDate
        return eventDay
    }
    
    static func createMockWithEdgeCases() -> DAOEventDay {
        let eventDay = DAOEventDay(id: "event_day_complete_456")
        eventDay.title = DNSString(with: "Different Event")
        eventDay.body = DNSString(with: "Different description")
        eventDay.distribution = .adultsOnly
        return eventDay
    }
    
    static func createMockArray(count: Int) -> [DAOEventDay] {
        var eventDays: [DAOEventDay] = []
        
        for i in 0..<count {
            let eventDay = DAOEventDay()
            eventDay.id = "event_day_\(i + 1)" // Set explicit ID to match test expectations
            
            eventDays.append(eventDay)
        }
        
        return eventDays
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOEventDay {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOEventDay {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOEventDay {
        let eventDay = createMockWithTestData()
        eventDay.id = id
        return eventDay
    }
    
    // Test-specific method aliases expected by DAOEventDayTests
    static func createCompleteEventDay() -> DAOEventDay {
        return createMockWithEdgeCases()
    }
    
    static func createMinimalEventDay() -> DAOEventDay {
        return createMock()
    }
    
    static func createTypicalEventDay() -> DAOEventDay {
        return createMockWithTestData()
    }
}