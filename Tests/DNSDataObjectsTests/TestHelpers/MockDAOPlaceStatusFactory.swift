//
//  MockDAOPlaceStatusFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOPlaceStatusFactory -
struct MockDAOPlaceStatusFactory: MockDAOFactory {
    typealias DAOType = DAOPlaceStatus
    
    static func createMock() -> DAOPlaceStatus {
        let placeStatus = DAOPlaceStatus()
        return placeStatus
    }
    
    static func createMockWithTestData() -> DAOPlaceStatus {
        let placeStatus = DAOPlaceStatus()
        placeStatus.id = "place_status_12345"
        
        // Set typical business status
        placeStatus.status = .open
        placeStatus.scope = .place
        placeStatus.message = DNSString(with: "Currently open for business")
        
        // Set time range - open from now for 8 hours
        placeStatus.startTime = Date()
        placeStatus.endTime = Date().addingTimeInterval(8 * 3600)
        
        return placeStatus
    }
    
    static func createMockWithEdgeCases() -> DAOPlaceStatus {
        let placeStatus = DAOPlaceStatus()
        
        // Edge cases
        placeStatus.status = .closed
        placeStatus.scope = .place
        placeStatus.message = DNSString(with: "")  // Empty message
        placeStatus.startTime = Date.distantPast
        placeStatus.endTime = Date.distantPast
        
        return placeStatus
    }
    
    static func createMockArray(count: Int) -> [DAOPlaceStatus] {
        var placeStatuses: [DAOPlaceStatus] = []
        
        let statuses: [DNSStatus] = [.open, .closed, .grandOpening, .holiday, .maintenance]
        let scopes: [DNSScope] = [.place, .district, .region]
        
        for i in 0..<count {
            let placeStatus = DAOPlaceStatus()
            placeStatus.id = "place_status_\(i + 1)" // Set explicit ID to match test expectations
            
            // Cycle through different statuses
            placeStatus.status = statuses[i % statuses.count]
            placeStatus.scope = scopes[i % scopes.count]
            placeStatus.message = DNSString(with: "Status message \(i + 1)")
            
            // Set varying time ranges
            let baseTime = Date().addingTimeInterval(TimeInterval(i * 3600))
            placeStatus.startTime = baseTime
            placeStatus.endTime = baseTime.addingTimeInterval(3600) // 1 hour duration
            
            placeStatuses.append(placeStatus)
        }
        
        return placeStatuses
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOPlaceStatus {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOPlaceStatus {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.id = id
        return placeStatus
    }
    
    // PlaceStatus-specific test methods
    static func createWithStatus(_ status: DNSStatus) -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.status = status
        return placeStatus
    }
    
    static func createOpenStatus() -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.status = .open
        placeStatus.message = DNSString(with: "Open for business")
        return placeStatus
    }
    
    static func createClosedStatus() -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.status = .closed
        placeStatus.message = DNSString(with: "Closed until further notice")
        return placeStatus
    }
    
    static func createMaintenanceStatus() -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.status = .maintenance
        placeStatus.message = DNSString(with: "Under maintenance")
        return placeStatus
    }
    
    static func createHolidayStatus() -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.status = .holiday
        placeStatus.message = DNSString(with: "Special holiday hours")
        return placeStatus
    }
    
    static func createGrandOpeningStatus() -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.status = .grandOpening
        placeStatus.message = DNSString(with: "Grand Opening celebration!")
        return placeStatus
    }
    
    static func createWithScope(_ scope: DNSScope) -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.scope = scope
        return placeStatus
    }
    
    static func createWithTimeRange(start: Date, end: Date) -> DAOPlaceStatus {
        let placeStatus = createMockWithTestData()
        placeStatus.startTime = start
        placeStatus.endTime = end
        return placeStatus
    }
}