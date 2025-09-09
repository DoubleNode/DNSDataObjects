//
//  MockDAOPlaceFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
import CoreLocation
@testable import DNSDataObjects

// MARK: - MockDAOPlaceFactory -
struct MockDAOPlaceFactory: MockDAOFactory {
    typealias DAOType = DAOPlace
    
    static func createMock() -> DAOPlace {
        let place = DAOPlace()
        place.code = "TEST_PLACE"
        place.name = DNSString(with: "Test Place")
        place.phone = "555-0123"
        place.pricingTierId = "test_tier"
        return place
    }
    
    static func createMockWithTestData() -> DAOPlace {
        let place = DAOPlace(code: "PREMIUM_PLACE", name: DNSString(with: "Premium Test Place"))
        
        // Set address
        let address = DNSPostalAddress()
        address.street = "123 Test Street"
        address.city = "Test City"
        address.state = "Test State"
        address.postalCode = "12345"
        place.address = address
        
        place.phone = "555-0199"
        place.pricingTierId = "tier_premium"
        place.timeZone = TimeZone(identifier: "America/New_York") ?? TimeZone.current
        
        // Set location
        place.geopoint = CLLocation(latitude: 40.7128, longitude: -74.0060) // NYC coordinates
        place.geohashes = ["dr5regy", "dr5regz"]
        
        // Create test activities
        let activity = DAOActivity()
        activity.id = "test_activity_1"
        activity.code = "ACTIVITY_1"
        activity.name = DNSString(with: "Test Activity")
        place.activities = [activity]
        
        // Create test events
        let event = DAOEvent()
        event.id = "test_event_1"
        event.title = DNSString(with: "Test Event")
        place.events = [event]
        
        // Create test alerts
        let alert = DAOAlert()
        alert.id = "test_alert_1"
        alert.title = DNSString(with: "Test Alert")
        place.alerts = [alert]
        
        return place
    }
    
    static func createMockWithEdgeCases() -> DAOPlace {
        let place = DAOPlace()
        
        // Edge cases
        place.code = "" // Empty code
        place.name = DNSString() // Empty name
        place.phone = "" // Empty phone
        place.pricingTierId = "" // Empty pricing tier
        place.activities = [] // Empty activities
        place.events = [] // Empty events
        place.alerts = [] // Empty alerts
        place.announcements = [] // Empty announcements
        place.geohashes = [] // Empty geohashes
        place.geopoint = nil // No location
        
        return place
    }
    
    static func createMockArray(count: Int) -> [DAOPlace] {
        var places: [DAOPlace] = []
        
        for i in 0..<count {
            let place = DAOPlace()
            place.id = "place\(i)" // Set explicit ID to match test expectations
            place.code = "PLACE_\(i + 1)"
            place.name = DNSString(with: "Place \(i + 1)")
            place.phone = "555-0\(String(format: "%03d", i + 100))"
            place.pricingTierId = i % 2 == 0 ? "tier_basic" : "tier_premium"
            
            // Add variety
            if i % 3 == 0 {
                let address = DNSPostalAddress()
                address.street = "\(i + 100) Main Street"
                address.city = "Test City \(i + 1)"
                place.address = address
            }
            
            if i % 2 == 0 {
                place.geopoint = CLLocation(latitude: 40.7128 + Double(i) * 0.001, 
                                          longitude: -74.0060 + Double(i) * 0.001)
            }
            
            places.append(place)
        }
        
        return places
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOPlace {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOPlace {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOPlace {
        let place = createMockWithTestData()
        place.id = id
        return place
    }
}
