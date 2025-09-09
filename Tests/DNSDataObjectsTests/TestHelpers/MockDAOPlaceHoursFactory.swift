//
//  MockDAOPlaceHoursFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOPlaceHoursFactory -
struct MockDAOPlaceHoursFactory: MockDAOFactory {
    typealias DAOType = DAOPlaceHours
    
    static func createMock() -> DAOPlaceHours {
        let placeHours = DAOPlaceHours()
        return placeHours
    }
    
    static func createMockWithTestData() -> DAOPlaceHours {
        let placeHours = DAOPlaceHours()
        placeHours.id = "place_hours_12345"
        
        // Set up weekly hours - typical business hours
        placeHours.monday = createBusinessHours()
        placeHours.tuesday = createBusinessHours()
        placeHours.wednesday = createBusinessHours()
        placeHours.thursday = createBusinessHours()
        placeHours.friday = createBusinessHours()
        placeHours.saturday = createWeekendHours()
        placeHours.sunday = createClosedHours()
        
        // Add test events
        let event1 = DAOPlaceEvent()
        event1.id = "event_1"
        event1.name = DNSString(with: "Holiday Party")
        event1.type = "party"
        event1.startDate = Date()
        event1.endDate = Date().addingTimeInterval(3600)
        placeHours.events = [event1]
        
        // Add test holidays
        let holiday1 = DAOPlaceHoliday()
        holiday1.id = "holiday_1"
        holiday1.date = Date.today
        holiday1.hours = createClosedHours()
        placeHours.holidays = [holiday1]
        
        return placeHours
    }
    
    static func createMockWithEdgeCases() -> DAOPlaceHours {
        let placeHours = DAOPlaceHours()
        
        // Edge cases - all days closed
        placeHours.monday = createClosedHours()
        placeHours.tuesday = createClosedHours()
        placeHours.wednesday = createClosedHours()
        placeHours.thursday = createClosedHours()
        placeHours.friday = createClosedHours()
        placeHours.saturday = createClosedHours()
        placeHours.sunday = createClosedHours()
        
        // Empty arrays
        placeHours.events = []
        placeHours.holidays = []
        
        return placeHours
    }
    
    static func createMockArray(count: Int) -> [DAOPlaceHours] {
        var placeHoursArray: [DAOPlaceHours] = []
        
        for i in 0..<count {
            let placeHours = DAOPlaceHours()
            placeHours.id = "place_hours_\(i + 1)" // Set explicit ID to match test expectations
            
            // Vary the hours patterns
            if i % 3 == 0 {
                // Standard business hours
                placeHours.monday = createBusinessHours()
                placeHours.tuesday = createBusinessHours()
                placeHours.wednesday = createBusinessHours()
                placeHours.thursday = createBusinessHours()
                placeHours.friday = createBusinessHours()
                placeHours.saturday = createWeekendHours()
                placeHours.sunday = createClosedHours()
            } else if i % 3 == 1 {
                // 24/7 operation
                placeHours.monday = create24HourHours()
                placeHours.tuesday = create24HourHours()
                placeHours.wednesday = create24HourHours()
                placeHours.thursday = create24HourHours()
                placeHours.friday = create24HourHours()
                placeHours.saturday = create24HourHours()
                placeHours.sunday = create24HourHours()
            } else {
                // All closed
                placeHours.monday = createClosedHours()
                placeHours.tuesday = createClosedHours()
                placeHours.wednesday = createClosedHours()
                placeHours.thursday = createClosedHours()
                placeHours.friday = createClosedHours()
                placeHours.saturday = createClosedHours()
                placeHours.sunday = createClosedHours()
            }
            
            placeHoursArray.append(placeHours)
        }
        
        return placeHoursArray
    }
    
    // Helper methods for creating different hour types
    private static func createBusinessHours() -> DNSDailyHours {
        let hours = DNSDailyHours()
        hours.open = DNSTimeOfDay(hour: 9, minute: 0)
        hours.close = DNSTimeOfDay(hour: 17, minute: 0)
        return hours
    }
    
    private static func createWeekendHours() -> DNSDailyHours {
        let hours = DNSDailyHours()
        hours.open = DNSTimeOfDay(hour: 10, minute: 0)
        hours.close = DNSTimeOfDay(hour: 16, minute: 0)
        return hours
    }
    
    private static func createClosedHours() -> DNSDailyHours {
        let hours = DNSDailyHours()
        hours.open = nil
        hours.close = nil
        return hours
    }
    
    private static func create24HourHours() -> DNSDailyHours {
        let hours = DNSDailyHours()
        hours.open = DNSTimeOfDay(hour: 0, minute: 0)
        hours.close = DNSTimeOfDay(hour: 23, minute: 59)
        return hours
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOPlaceHours {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOPlaceHours {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOPlaceHours {
        let placeHours = createMockWithTestData()
        placeHours.id = id
        return placeHours
    }
    
    // PlaceHours-specific test methods
    static func createBusinessHoursOnly() -> DAOPlaceHours {
        let placeHours = createMockWithTestData()
        placeHours.events = []
        placeHours.holidays = []
        return placeHours
    }
    
    static func createWith24HourSchedule() -> DAOPlaceHours {
        let placeHours = DAOPlaceHours()
        placeHours.monday = create24HourHours()
        placeHours.tuesday = create24HourHours()
        placeHours.wednesday = create24HourHours()
        placeHours.thursday = create24HourHours()
        placeHours.friday = create24HourHours()
        placeHours.saturday = create24HourHours()
        placeHours.sunday = create24HourHours()
        return placeHours
    }
    
    static func createWithEventsAndHolidays() -> DAOPlaceHours {
        let placeHours = createMockWithTestData()
        
        // Add more events
        let event2 = DAOPlaceEvent()
        event2.id = "event_2"
        event2.name = DNSString(with: "Staff Meeting")
        event2.type = "meeting"
        placeHours.events.append(event2)
        
        // Add more holidays
        let holiday2 = DAOPlaceHoliday()
        holiday2.id = "holiday_2"
        holiday2.date = Date.today.addingTimeInterval(86400)
        placeHours.holidays.append(holiday2)
        
        return placeHours
    }
}