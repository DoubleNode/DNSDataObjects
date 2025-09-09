//
//  MockDAOEventFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOEventFactory -
struct MockDAOEventFactory: MockDAOFactory {
    typealias DAOType = DAOEvent
    
    static func createMock() -> DAOEvent {
        let event = DAOEvent()
        event.title = DNSString(with: "Mock Event")
        event.body = DNSString(with: "Mock event description")
        event.enabled = true
        return event
    }
    
    static func createMockWithTestData() -> DAOEvent {
        let event = DAOEvent(id: "event_test_data")
        event.title = DNSString(with: "Test Event with Data")
        event.body = DNSString(with: "Comprehensive test event with full data")
        event.enabled = true
        
        // Create event days
        let day1 = DAOEventDay()
        let day2 = DAOEventDay()  
        event.days = [day1, day2]
        
        return event
    }
    
    static func createMockWithEdgeCases() -> DAOEvent {
        let event = DAOEvent()
        
        // Edge cases
        event.title = DNSString() // Empty title
        event.body = DNSString() // Empty body
        event.enabled = false // Disabled
        event.days = [] // No days
        
        return event
    }
    
    static func createMockArray(count: Int) -> [DAOEvent] {
        var events: [DAOEvent] = []
        
        for i in 0..<count {
            let event = DAOEvent()
            event.id = "event\(i)" // Set explicit ID to match test expectations
            event.title = DNSString(with: "Event \(i + 1)")
            event.body = DNSString(with: "Description for event \(i + 1)")
            event.enabled = (i % 2 == 0) // Alternate enabled/disabled
            
            events.append(event)
        }
        
        return events
    }
}