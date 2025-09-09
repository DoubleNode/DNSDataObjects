//
//  MockDAOPlaceHolidayFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOPlaceHolidayFactory -
struct MockDAOPlaceHolidayFactory: MockDAOFactory {
    typealias DAOType = DAOPlaceHoliday
    
    static func createMock() -> DAOPlaceHoliday {
        let placeHoliday = DAOPlaceHoliday()
        placeHoliday.date = Date.today
        placeHoliday.hours = DNSDailyHours()
        return placeHoliday
    }
    
    static func createMockWithTestData() -> DAOPlaceHoliday {
        let placeHoliday = DAOPlaceHoliday()
        placeHoliday.id = "place_holiday_12345"
        
        // Set test date (Christmas Day 2024)
        let calendar = Calendar.current
        let components = DateComponents(year: 2024, month: 12, day: 25)
        placeHoliday.date = calendar.date(from: components) ?? Date.today
        
        // Create test daily hours
        let hours = DNSDailyHours()
        hours.open = nil  // Holiday is closed
        hours.close = nil
        placeHoliday.hours = hours
        
        return placeHoliday
    }
    
    static func createMockWithEdgeCases() -> DAOPlaceHoliday {
        let placeHoliday = DAOPlaceHoliday()
        
        // Edge cases
        placeHoliday.date = Date.distantPast  // Very old date
        placeHoliday.hours = DNSDailyHours()  // Default hours
        
        return placeHoliday
    }
    
    static func createMockArray(count: Int) -> [DAOPlaceHoliday] {
        var placeHolidays: [DAOPlaceHoliday] = []
        let calendar = Calendar.current
        
        for i in 0..<count {
            let placeHoliday = DAOPlaceHoliday()
            placeHoliday.id = "place_holiday_\(i + 1)" // Set explicit ID to match test expectations
            
            // Create different holiday dates
            let components = DateComponents(year: 2024, month: (i % 12) + 1, day: (i % 28) + 1)
            placeHoliday.date = calendar.date(from: components) ?? Date.today
            
            // Vary the hours
            let hours = DNSDailyHours()
            if i % 2 == 0 {
                // Closed
                hours.open = nil
                hours.close = nil
            } else {
                // Open
                hours.open = DNSTimeOfDay(hour: 9, minute: 0)
                hours.close = DNSTimeOfDay(hour: 17, minute: 0)
            }
            placeHoliday.hours = hours
            
            placeHolidays.append(placeHoliday)
        }
        
        return placeHolidays
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOPlaceHoliday {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOPlaceHoliday {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOPlaceHoliday {
        let placeHoliday = createMockWithTestData()
        placeHoliday.id = id
        return placeHoliday
    }
    
    // PlaceHoliday-specific test methods
    static func createWithDate(_ date: Date) -> DAOPlaceHoliday {
        let placeHoliday = createMockWithTestData()
        placeHoliday.date = date
        return placeHoliday
    }
    
    static func createClosedHoliday() -> DAOPlaceHoliday {
        let placeHoliday = createMockWithTestData()
        let hours = DNSDailyHours()
        hours.open = nil
        hours.close = nil
        placeHoliday.hours = hours
        return placeHoliday
    }
    
    static func createOpenHoliday() -> DAOPlaceHoliday {
        let placeHoliday = createMockWithTestData()
        let hours = DNSDailyHours()
        hours.open = DNSTimeOfDay(hour: 9, minute: 0)
        hours.close = DNSTimeOfDay(hour: 17, minute: 0)
        placeHoliday.hours = hours
        return placeHoliday
    }
}