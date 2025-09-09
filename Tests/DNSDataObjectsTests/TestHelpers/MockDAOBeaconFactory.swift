//
//  MockDAOBeaconFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import CoreLocation
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOBeaconFactory -
struct MockDAOBeaconFactory: MockDAOFactory {
    typealias DAOType = DAOBeacon
    
    static func createMock() -> DAOBeacon {
        let beacon = DAOBeacon()
        beacon.accuracy = 5.0
        beacon.code = "TEST_BEACON"
        beacon.data = nil // CLBeacon is complex to mock
        beacon.distance = .nearby
        beacon.major = 12345
        beacon.minor = 67890
        beacon.name = DNSString(with: "Test Beacon")
        beacon.range = "5-10m"
        beacon.rssi = -45
        return beacon
    }
    
    static func createMockWithTestData() -> DAOBeacon {
        let beacon = DAOBeacon()
        beacon.id = "beacon123"
        
        beacon.accuracy = 5.0
        beacon.code = "MOCK_BEACON_CODE"
        beacon.data = nil // CLBeacon is complex to mock
        beacon.distance = .nearby
        beacon.major = 12345
        beacon.minor = 67890
        beacon.name = DNSString(with: "Mock Beacon")
        beacon.range = "5-10m"
        beacon.rssi = -45
        
        return beacon
    }
    
    static func createMockWithEdgeCases() -> DAOBeacon {
        let beacon = DAOBeacon()
        
        // Edge cases and boundary values
        beacon.accuracy = -1.0 // Should trigger didSet validation
        beacon.code = ""
        beacon.data = nil
        beacon.distance = .unknown
        beacon.major = 0
        beacon.minor = 0
        beacon.name = DNSString()
        beacon.range = nil
        beacon.rssi = nil
        
        return beacon
    }
    
    static func createMockArray(count: Int) -> [DAOBeacon] {
        let distances: [DNSBeaconDistance] = [.unknown, .immediate, .nearby, .far]
        
        return (0..<count).map { i in
            let beacon = DAOBeacon()
            beacon.id = "beacon\(i)" // Set explicit ID to match test expectations
            beacon.name = DNSString(with: "Beacon \(i)")
            beacon.code = "BEACON_\(i)"
            beacon.major = i + 1
            beacon.minor = (i * 10) + 1
            beacon.distance = distances[i % distances.count]
            
            // Set realistic values based on distance
            switch beacon.distance {
            case .immediate:
                beacon.rssi = -30
                beacon.accuracy = 1.0
            case .nearby:
                beacon.rssi = -45
                beacon.accuracy = 5.0
            case .far:
                beacon.rssi = -65
                beacon.accuracy = 15.0
            case .unknown:
                beacon.rssi = nil
                beacon.accuracy = 0
            default:
                beacon.rssi = -50
                beacon.accuracy = 10.0
            }
            
            return beacon
        }
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOBeacon {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOBeacon {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOBeacon {
        let beacon = createMockWithTestData()
        beacon.id = id
        return beacon
    }
    
    // Test-specific method aliases expected by DAOBeaconTests
    static func createMockBeacon() -> DAOBeacon {
        return createMockWithTestData()
    }
    
    static func createMockBeaconArray(count: Int) -> [DAOBeacon] {
        return createMockArray(count: count)
    }
    
    static func createMockBeaconWithMinimalData() -> DAOBeacon {
        let beacon = DAOBeacon()
        beacon.name = DNSString(with: "Minimal Beacon")
        beacon.code = "MIN_BEACON"
        beacon.distance = .unknown // Default value
        beacon.major = 1
        beacon.minor = 1
        beacon.accuracy = 0.0
        beacon.rssi = nil
        return beacon
    }

    // MARK: - Additional helper methods for complex testing
    
    static func createMockBeaconWithAllDistanceTypes() -> [DAOBeacon] {
        let distances: [DNSBeaconDistance] = [.unknown, .immediate, .nearby, .far]
        
        return distances.enumerated().map { index, distance in
            let beacon = createMock()
            beacon.id = "beacon_\(distance.rawValue)"
            beacon.distance = distance
            beacon.name = DNSString(with: "Beacon \(distance.rawValue)")
            
            // Set realistic RSSI values for each distance
            switch distance {
            case .immediate:
                beacon.rssi = -30
                beacon.accuracy = 1.0
            case .nearby:
                beacon.rssi = -45
                beacon.accuracy = 5.0
            case .far:
                beacon.rssi = -65
                beacon.accuracy = 15.0
            case .unknown:
                beacon.rssi = nil
                beacon.accuracy = 0
            default:
                beacon.rssi = -50
                beacon.accuracy = 10.0
            }
            
            return beacon
        }
    }
    
    static func createMockBeaconWithVariousAccuracies() -> [DAOBeacon] {
        let accuracies: [CLLocationAccuracy] = [-1.0, 0.5, 5.0, 25.0, 100.0]
        
        return accuracies.enumerated().map { index, accuracy in
            let beacon = createMock()
            beacon.id = "accuracy_beacon_\(index)"
            beacon.accuracy = accuracy // This will test the didSet validation
            beacon.name = DNSString(with: "Accuracy Test \(accuracy)")
            return beacon
        }
    }
    
    static func createMockBeaconWithRealWorldData() -> [DAOBeacon] {
        // Simulate real-world beacon scenarios
        let beaconConfigs = [
            (major: 1, minor: 1, code: "ENTRANCE", name: "Main Entrance", rssi: -40),
            (major: 1, minor: 2, code: "LOBBY", name: "Reception Lobby", rssi: -50),
            (major: 2, minor: 1, code: "STORE_A", name: "Store Section A", rssi: -35),
            (major: 2, minor: 2, code: "STORE_B", name: "Store Section B", rssi: -60),
            (major: 3, minor: 1, code: "EXIT", name: "Emergency Exit", rssi: -55)
        ]
        
        return beaconConfigs.enumerated().map { index, config in
            let beacon = createMock()
            beacon.id = "realworld_\(config.code)"
            beacon.major = config.major
            beacon.minor = config.minor
            beacon.code = config.code
            beacon.name = DNSString(with: config.name)
            beacon.rssi = config.rssi
            beacon.range = "\(abs(config.rssi/10))m"
            
            // Set distance based on RSSI
            if config.rssi > -40 {
                beacon.distance = .immediate
                beacon.accuracy = 1.0
            } else if config.rssi > -55 {
                beacon.distance = .nearby
                beacon.accuracy = 5.0
            } else {
                beacon.distance = .far
                beacon.accuracy = 15.0
            }
            
            return beacon
        }
    }
    
    static func createMockBeaconWithBoundaryValues() -> [DAOBeacon] {
        let beacon1 = createMock()
        beacon1.id = "boundary_1"
        beacon1.major = 0
        beacon1.minor = 0
        beacon1.rssi = nil
        beacon1.range = nil
        
        let beacon2 = createMock()
        beacon2.id = "boundary_2"
        beacon2.major = 65535 // Max uint16
        beacon2.minor = 65535 // Max uint16
        beacon2.rssi = -100 // Very weak signal
        
        let beacon3 = createMock()
        beacon3.id = "boundary_3"
        beacon3.accuracy = -1.0 // Should trigger didSet validation
        
        return [beacon1, beacon2, beacon3]
    }
    
    // MARK: - Dictionary Creation
    
    static func createMockBeaconDictionary() -> DNSDataDictionary {
        return [
            "id": "beacon123",
            "accuracy": 5.0,
            "code": "MOCK_BEACON_CODE",
            "distance": DNSBeaconDistance.nearby.rawValue,
            "major": 12345,
            "minor": 67890,
            "name": "Mock Beacon",
            "range": "5-10m",
            "rssi": -45
        ]
    }
    
    static func createInvalidBeaconDictionary() -> DNSDataDictionary {
        return [
            "invalidProperty": "invalidValue",
            "distance": "invalidDistance",
            "major": "not_a_number",
            "accuracy": "not_a_double"
        ]
    }
    
    // MARK: - Validation Helpers
    
    static func validateBeaconProperties(_ beacon: DAOBeacon) -> Bool {
        // Validate accuracy (should be >= 0 after didSet validation)
        guard beacon.accuracy >= 0 else { return false }
        
        // Validate major and minor are non-negative
        guard beacon.major >= 0 && beacon.minor >= 0 else { return false }
        
        // Validate distance enum
        switch beacon.distance {
        case .unknown, .distant, .far, .nearby, .close, .immediate:
            break
//        default:
//            return false
        }
        
        // Validate RSSI if present (should be negative for realistic values)
        if let rssi = beacon.rssi {
            guard rssi <= 0 else { return false }
        }
        
        // Validate code is not empty
        guard !beacon.code.isEmpty else { return false }
        
        // Validate name exists
        guard !beacon.name.asString.isEmpty else { return false }
        
        return true
    }
    
    static func validateBeaconEquality(_ beacon1: DAOBeacon, _ beacon2: DAOBeacon) -> Bool {
        return beacon1.id == beacon2.id &&
               beacon1.accuracy == beacon2.accuracy &&
               beacon1.code == beacon2.code &&
               beacon1.distance == beacon2.distance &&
               beacon1.major == beacon2.major &&
               beacon1.minor == beacon2.minor &&
               beacon1.name.asString == beacon2.name.asString &&
               beacon1.range == beacon2.range &&
               beacon1.rssi == beacon2.rssi
    }
}

// MARK: - Extensions for Test Support

extension DAOBeacon {
    var isStrong: Bool {
        guard let rssi = rssi else { return false }
        return rssi > -50
    }
    
    var isWeak: Bool {
        guard let rssi = rssi else { return true }
        return rssi < -70
    }
    
    var isNearby: Bool {
        return distance == .immediate || distance == .nearby
    }
    
    var hasValidSignal: Bool {
        return rssi != nil && distance != .unknown
    }
    
    var estimatedDistance: String {
        switch distance {
        case .immediate:
            return "< 1m"
        case .nearby:
            return "1-5m"
        case .far:
            return "> 5m"
        case .unknown:
            return "Unknown"
        default:
            return "Unknown"
        }
    }
    
    var signalStrength: String {
        guard let rssi = rssi else { return "No Signal" }
        
        switch rssi {
        case -30...0:
            return "Excellent"
        case -50...(-30):
            return "Good"
        case -70...(-50):
            return "Fair"
        case -100...(-70):
            return "Poor"
        default:
            return "No Signal"
        }
    }
}
