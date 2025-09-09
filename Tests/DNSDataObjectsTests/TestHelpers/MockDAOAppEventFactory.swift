//
//  MockDAOAppEventFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOAppEventFactory -
struct MockDAOAppEventFactory: MockDAOFactory {
    typealias DAOType = DAOAppEvent
    
    static func createMock() -> DAOAppEvent {
        let appEvent = DAOAppEvent()
        appEvent.title = DNSString(with: "Test App Event")
        appEvent.priority = DNSPriority.normal
        appEvent.startTime = Date()
        appEvent.endTime = Date().addingTimeInterval(3600) // 1 hour from now
        return appEvent
    }
    
    static func createMockWithTestData() -> DAOAppEvent {
        let appEvent = DAOAppEvent()
        appEvent.id = "appevent123"
        
        appEvent.endTime = Date().addingTimeInterval(3600) // 1 hour from now
        appEvent.priority = DNSPriority.normal
        appEvent.startTime = Date()
        appEvent.title = DNSString(with: "Mock App Event")
        
        return appEvent
    }
    
    static func createMockWithEdgeCases() -> DAOAppEvent {
        let appEvent = DAOAppEvent()
        
        // Test boundary priorities - this will test the didSet validation
        appEvent.priority = DNSPriority.highest + 1 // Should be clamped to highest
        appEvent.title = DNSString() // Empty title
        appEvent.startTime = Date.distantPast
        appEvent.endTime = Date.distantFuture
        
        return appEvent
    }
    
    static func createMockArray(count: Int) -> [DAOAppEvent] {
        let priorities = [DNSPriority.none, DNSPriority.low, DNSPriority.normal, DNSPriority.high, DNSPriority.highest]
        
        return (0..<count).map { i in
            let appEvent = DAOAppEvent()
            appEvent.id = "appevent\(i)" // Explicit ID already set correctly
            appEvent.title = DNSString(with: "App Event \(i)")
            appEvent.priority = priorities[i % priorities.count]
            appEvent.startTime = Date().addingTimeInterval(TimeInterval(i * 3600)) // Staggered start times
            appEvent.endTime = Date().addingTimeInterval(TimeInterval((i + 1) * 3600)) // 1 hour duration each
            return appEvent
        }
    }
    
    // MARK: - Additional helper methods for complex testing
    
    static func createMockAppEventWithAllPriorityLevels() -> [DAOAppEvent] {
        let priorities = [DNSPriority.none, DNSPriority.low, DNSPriority.normal, DNSPriority.high, DNSPriority.highest]
        
        return priorities.enumerated().map { index, priority in
            let appEvent = createMock()
            appEvent.id = "appevent_priority_\(priority)"
            appEvent.priority = priority
            appEvent.title = DNSString(with: "Event Priority \(priority)")
            return appEvent
        }
    }
    
    static func createMockAppEventWithTimeRanges() -> [DAOAppEvent] {
        let now = Date()
        
        let pastEvent = createMock()
        pastEvent.id = "past_event"
        pastEvent.startTime = now.addingTimeInterval(-7200) // 2 hours ago
        pastEvent.endTime = now.addingTimeInterval(-3600) // 1 hour ago
        pastEvent.title = DNSString(with: "Past Event")
        
        let currentEvent = createMock()
        currentEvent.id = "current_event"
        currentEvent.startTime = now.addingTimeInterval(-1800) // 30 minutes ago
        currentEvent.endTime = now.addingTimeInterval(1800) // 30 minutes from now
        currentEvent.title = DNSString(with: "Current Event")
        
        let futureEvent = createMock()
        futureEvent.id = "future_event"
        futureEvent.startTime = now.addingTimeInterval(3600) // 1 hour from now
        futureEvent.endTime = now.addingTimeInterval(7200) // 2 hours from now
        futureEvent.title = DNSString(with: "Future Event")
        
        return [pastEvent, currentEvent, futureEvent]
    }
    
    static func createMockAppEventWithBoundaryPriorities() -> [DAOAppEvent] {
        let boundaryValues = [-1, 0, DNSPriority.highest, DNSPriority.highest + 1]
        
        return boundaryValues.enumerated().map { index, priority in
            let appEvent = createMock()
            appEvent.id = "boundary_priority_\(index)"
            appEvent.priority = priority // This will test the didSet validation
            appEvent.title = DNSString(with: "Boundary Priority Test \(index)")
            return appEvent
        }
    }
    
    static func createMockAppEventWithCustomInitializer() -> DAOAppEvent {
        let title = DNSString(with: "Custom Initialized Event")
        let startTime = Date().addingTimeInterval(1800) // 30 minutes from now
        let endTime = Date().addingTimeInterval(5400) // 90 minutes from now
        
        return DAOAppEvent(title: title, startTime: startTime, endTime: endTime)
    }
    
    // MARK: - Dictionary Creation
    
    static func createMockAppEventDictionary() -> DNSDataDictionary {
        return [
            "id": "appevent123",
            "endTime": Date().addingTimeInterval(3600),
            "priority": DNSPriority.normal,
            "startTime": Date(),
            "title": "Mock App Event"
        ]
    }
    
    static func createInvalidAppEventDictionary() -> DNSDataDictionary {
        return [
            "invalidProperty": "invalidValue",
            "priority": "not_a_number",
            "endTime": "not_a_date"
        ]
    }
    
    // MARK: - Validation Helpers
    
    static func validateAppEventProperties(_ appEvent: DAOAppEvent) -> Bool {
        // Validate priority is within valid range
        guard appEvent.priority >= DNSPriority.none && appEvent.priority <= DNSPriority.highest else {
            return false
        }
        
        // Validate time relationship
        guard appEvent.startTime <= appEvent.endTime else {
            return false
        }
        
        // Validate title exists
        guard !appEvent.title.asString.isEmpty else {
            return false
        }
        
        return true
    }
    
    static func validateAppEventEquality(_ appEvent1: DAOAppEvent, _ appEvent2: DAOAppEvent) -> Bool {
        return appEvent1.id == appEvent2.id &&
               appEvent1.endTime == appEvent2.endTime &&
               appEvent1.priority == appEvent2.priority &&
               appEvent1.startTime == appEvent2.startTime &&
               appEvent1.title.asString == appEvent2.title.asString
    }
    
    // MARK: - Missing test methods expected by DAOAppEventTests
    
    static func createMockAppEvent() -> DAOAppEvent {
        return createMockWithTestData()
    }
    
    static func createMockAppEventArray(count: Int) -> [DAOAppEvent] {
        return createMockArray(count: count)
    }
    
    static func createMockAppEventWithMinimalData() -> DAOAppEvent {
        let appEvent = DAOAppEvent()
        appEvent.title = DNSString(with: "Minimal Event")
        appEvent.priority = DNSPriority.normal
        return appEvent
    }
    
    // Legacy method expected by DAOApplicationTests
    static func create() -> DAOAppEvent {
        return createMockWithTestData()
    }
}

// MARK: - Extensions for Test Support

extension DAOAppEvent {
    var isActive: Bool {
        let now = Date()
        return startTime <= now && now <= endTime
    }
    
    var isPast: Bool {
        return endTime < Date()
    }
    
    var isFuture: Bool {
        return startTime > Date()
    }
    
    var duration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    
    var isHighPriority: Bool {
        return priority >= DNSPriority.high
    }
    
    var priorityName: String {
        switch priority {
        case DNSPriority.none: return "None"
        case DNSPriority.low: return "Low"
        case DNSPriority.normal: return "Normal"
        case DNSPriority.high: return "High"
        case DNSPriority.highest: return "Highest"
        default: return "Unknown"
        }
    }
}