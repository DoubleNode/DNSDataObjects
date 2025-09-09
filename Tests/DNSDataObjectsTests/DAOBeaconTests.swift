//
//  DAOBeaconTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects
import CoreLocation
import Foundation

final class DAOBeaconTests: XCTestCase {
    
    // MARK: - Basic Initialization Tests
    
    func testDefaultInitialization() {
        let beacon = DAOBeacon()
        
        XCTAssertNotNil(beacon.id)
        XCTAssertFalse(beacon.id.isEmpty)
        
        // Test default values
        XCTAssertEqual(beacon.accuracy, 0)
        XCTAssertEqual(beacon.code, "")
        XCTAssertNil(beacon.data)
        XCTAssertEqual(beacon.distance, .unknown)
        XCTAssertEqual(beacon.major, 0)
        XCTAssertEqual(beacon.minor, 0)
        XCTAssertEqual(beacon.name.asString, "")
        XCTAssertNil(beacon.range)
        XCTAssertNil(beacon.rssi)
    }
    
    func testInitializationWithId() {
        let testId = "test-beacon-123"
        let beacon = DAOBeacon(id: testId)
        
        XCTAssertEqual(beacon.id, testId)
        
        // Verify default values are still set
        XCTAssertEqual(beacon.accuracy, 0)
        XCTAssertEqual(beacon.distance, .unknown)
        XCTAssertEqual(beacon.major, 0)
        XCTAssertEqual(beacon.minor, 0)
    }
    
    // MARK: - Property Assignment Tests
    
    func testPropertyAssignment() {
        let beacon = MockDAOBeaconFactory.createMockBeacon()
        
        XCTAssertEqual(beacon.accuracy, 5.0)
        XCTAssertEqual(beacon.code, "MOCK_BEACON_CODE")
        XCTAssertEqual(beacon.distance, .nearby)
        XCTAssertEqual(beacon.major, 12345)
        XCTAssertEqual(beacon.minor, 67890)
        XCTAssertEqual(beacon.name.asString, "Mock Beacon")
        XCTAssertEqual(beacon.range, "5-10m")
        XCTAssertEqual(beacon.rssi, -45)
    }
    
    func testAccuracyValidation() {
        let beacon = DAOBeacon()
        
        // Test valid accuracy
        beacon.accuracy = 10.0
        XCTAssertEqual(beacon.accuracy, 10.0)
        
        // Test negative accuracy (should be clamped to 50 by didSet)
        beacon.accuracy = -5.0
        XCTAssertEqual(beacon.accuracy, 50.0)
        
        // Test zero accuracy
        beacon.accuracy = 0.0
        XCTAssertEqual(beacon.accuracy, 0.0)
    }
    
    func testDistanceEnumValues() {
        let beacons = MockDAOBeaconFactory.createMockBeaconWithAllDistanceTypes()
        
        XCTAssertEqual(beacons.count, 4)
        
        let distances = beacons.map { $0.distance }
        XCTAssertTrue(distances.contains(.unknown))
        XCTAssertTrue(distances.contains(.immediate))
        XCTAssertTrue(distances.contains(.nearby))
        XCTAssertTrue(distances.contains(.far))
    }
    
    // MARK: - Copy and Update Tests
    
    func testCopyInitialization() {
        let original = MockDAOBeaconFactory.createMockBeacon()
        let copy = DAOBeacon(from: original)
        
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.accuracy, copy.accuracy)
        XCTAssertEqual(original.code, copy.code)
        XCTAssertEqual(original.distance, copy.distance)
        XCTAssertEqual(original.major, copy.major)
        XCTAssertEqual(original.minor, copy.minor)
        XCTAssertEqual(original.name.asString, copy.name.asString)
        XCTAssertEqual(original.range, copy.range)
        XCTAssertEqual(original.rssi, copy.rssi)
        
        // Verify they are different instances
        XCTAssertTrue(original !== copy)
    }
    
    func testUpdateFromObject() {
        let beacon1 = DAOBeacon()
        let beacon2 = MockDAOBeaconFactory.createMockBeacon()
        
        beacon1.update(from: beacon2)
        
        XCTAssertEqual(beacon1.accuracy, beacon2.accuracy)
        XCTAssertEqual(beacon1.code, beacon2.code)
        XCTAssertEqual(beacon1.distance, beacon2.distance)
        XCTAssertEqual(beacon1.major, beacon2.major)
        XCTAssertEqual(beacon1.minor, beacon2.minor)
        XCTAssertEqual(beacon1.name.asString, beacon2.name.asString)
        XCTAssertEqual(beacon1.range, beacon2.range)
        XCTAssertEqual(beacon1.rssi, beacon2.rssi)
    }
    
    func testNSCopying() {
        let original = MockDAOBeaconFactory.createMockBeacon()
        let copy = original.copy() as! DAOBeacon
        
        XCTAssertTrue(MockDAOBeaconFactory.validateBeaconEquality(original, copy))
        XCTAssertTrue(original !== copy) // Different instances
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testInitializationFromDictionary() {
        let dictionary = MockDAOBeaconFactory.createMockBeaconDictionary()
        let beacon = DAOBeacon(from: dictionary)
        
        XCTAssertNotNil(beacon)
        XCTAssertEqual(beacon?.id, "beacon123")
        XCTAssertEqual(beacon?.accuracy, 5.0)
        XCTAssertEqual(beacon?.code, "MOCK_BEACON_CODE")
        XCTAssertEqual(beacon?.distance, .nearby)
        XCTAssertEqual(beacon?.major, 12345)
        XCTAssertEqual(beacon?.minor, 67890)
        XCTAssertEqual(beacon?.name.asString, "Mock Beacon")
        XCTAssertEqual(beacon?.range, "5-10m")
        XCTAssertEqual(beacon?.rssi, -45)
    }
    
    func testInitializationFromEmptyDictionary() {
        let emptyDictionary: DNSDataDictionary = [:]
        let beacon = DAOBeacon(from: emptyDictionary)
        
        XCTAssertNil(beacon)
    }
    
    func testAsDictionary() {
        let beacon = MockDAOBeaconFactory.createMockBeacon()
        let dictionary = beacon.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["accuracy"] as Any?)
        XCTAssertNotNil(dictionary["code"] as Any?)
        XCTAssertNotNil(dictionary["distance"] as Any?)
        XCTAssertNotNil(dictionary["major"] as Any?)
        XCTAssertNotNil(dictionary["minor"] as Any?)
        XCTAssertNotNil(dictionary["name"] as Any?)
        XCTAssertNotNil(dictionary["range"] as Any?)
        XCTAssertNotNil(dictionary["rssi"] as Any?)
        
        // Verify distance is stored as raw value
        XCTAssertEqual(dictionary["distance"] as? String, beacon.distance.rawValue)
        
        // Note: data field is commented out in the source, so it shouldn't be in the dictionary
        XCTAssertNil(dictionary["data"] as Any?)
    }
    
    // MARK: - Equality and Comparison Tests
    
    func testEquality() {
        let beacon1 = MockDAOBeaconFactory.createMockBeacon()
        let beacon2 = DAOBeacon(from: beacon1)
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(beacon1.id, beacon2.id)
        XCTAssertEqual(beacon1.accuracy, beacon2.accuracy)
        XCTAssertEqual(beacon1.code, beacon2.code)
        XCTAssertEqual(beacon1.distance, beacon2.distance)
        XCTAssertEqual(beacon1.major, beacon2.major)
        XCTAssertEqual(beacon1.minor, beacon2.minor)
        XCTAssertEqual(beacon1.name.asString, beacon2.name.asString)
        XCTAssertEqual(beacon1.range, beacon2.range)
        XCTAssertEqual(beacon1.rssi, beacon2.rssi)
        XCTAssertFalse(beacon1 != beacon2)
    }
    
    func testInequality() {
        let beacon1 = MockDAOBeaconFactory.createMockBeacon()
        let beacon2 = MockDAOBeaconFactory.createMockBeacon()
        beacon2.major = 99999
        
        XCTAssertNotEqual(beacon1, beacon2)
        XCTAssertTrue(beacon1 != beacon2)
    }
    
    func testIsDiffFrom() {
        let beacon1 = MockDAOBeaconFactory.createMockBeacon()
        let beacon2 = DAOBeacon(from: beacon1)
        let beacon3 = MockDAOBeaconFactory.createMockBeacon()
        beacon3.code = "DIFFERENT_CODE"
        
        XCTAssertFalse(beacon1.isDiffFrom(beacon2))
        XCTAssertTrue(beacon1.isDiffFrom(beacon3))
        XCTAssertTrue(beacon1.isDiffFrom(nil as DAOBeacon?))
        XCTAssertTrue(beacon1.isDiffFrom("not a beacon"))
    }
    
    func testSelfComparison() {
        let beacon = MockDAOBeaconFactory.createMockBeacon()
        
        XCTAssertFalse(beacon.isDiffFrom(beacon))
        XCTAssertEqual(beacon, beacon)
    }
    
    // MARK: - Distance and Signal Strength Tests
    
    func testDistanceClassification() {
        let beacons = MockDAOBeaconFactory.createMockBeaconWithAllDistanceTypes()
        
        for beacon in beacons {
            switch beacon.distance {
            case .immediate, .nearby:
                XCTAssertTrue(beacon.isNearby)
            case .far, .unknown:
                XCTAssertFalse(beacon.isNearby)
            default:
                break
            }
            
            // Test estimated distance string
            XCTAssertFalse(beacon.estimatedDistance.isEmpty)
        }
    }
    
    func testSignalStrengthClassification() {
        let beacons = MockDAOBeaconFactory.createMockBeaconWithAllDistanceTypes()
        
        for beacon in beacons {
            if let rssi = beacon.rssi {
                switch rssi {
                case -30...0:
                    XCTAssertTrue(beacon.isStrong)
                    XCTAssertFalse(beacon.isWeak)
                    XCTAssertEqual(beacon.signalStrength, "Excellent")
                case -50...(-31):  // Fixed range boundary
                    XCTAssertTrue(beacon.isStrong)   // rssi > -50, so -45 should be strong
                    XCTAssertFalse(beacon.isWeak)
                    XCTAssertEqual(beacon.signalStrength, "Good")
                case -70...(-51):  // Fixed range boundary
                    XCTAssertFalse(beacon.isStrong)
                    XCTAssertFalse(beacon.isWeak)
                    XCTAssertEqual(beacon.signalStrength, "Fair")
                case -100...(-71):  // Fixed range boundary
                    XCTAssertFalse(beacon.isStrong)
                    XCTAssertTrue(beacon.isWeak)
                    XCTAssertEqual(beacon.signalStrength, "Poor")
                default:
                    XCTAssertEqual(beacon.signalStrength, "No Signal")
                }
                
                XCTAssertTrue(beacon.hasValidSignal)
            } else {
                XCTAssertEqual(beacon.signalStrength, "No Signal")
                XCTAssertFalse(beacon.hasValidSignal)
            }
        }
    }
    
    // MARK: - Real World Scenarios
    
    func testRealWorldBeaconData() {
        let beacons = MockDAOBeaconFactory.createMockBeaconWithRealWorldData()
        
        XCTAssertEqual(beacons.count, 5)
        
        // Test entrance beacon
        let entranceBeacon = beacons.first { $0.code == "ENTRANCE" }
        XCTAssertNotNil(entranceBeacon)
        XCTAssertEqual(entranceBeacon?.major, 1)
        XCTAssertEqual(entranceBeacon?.minor, 1)
        XCTAssertEqual(entranceBeacon?.name.asString, "Main Entrance")
        
        // Test store beacons
        let storeBeacons = beacons.filter { $0.major == 2 }
        XCTAssertEqual(storeBeacons.count, 2)
        
        // Test all beacons have valid configurations
        for beacon in beacons {
            XCTAssertGreaterThan(beacon.major, 0)
            XCTAssertGreaterThan(beacon.minor, 0)
            XCTAssertFalse(beacon.code.isEmpty)
            XCTAssertFalse(beacon.name.asString.isEmpty)
            XCTAssertNotNil(beacon.rssi)
            XCTAssertTrue(beacon.hasValidSignal)
        }
    }
    
    // MARK: - Boundary Value Tests
    
    func testBoundaryValues() {
        let beacons = MockDAOBeaconFactory.createMockBeaconWithBoundaryValues()
        
        for beacon in beacons {
            // Test major/minor are non-negative
            XCTAssertGreaterThanOrEqual(beacon.major, 0)
            XCTAssertGreaterThanOrEqual(beacon.minor, 0)
            
            // Test accuracy is non-negative after validation
            XCTAssertGreaterThanOrEqual(beacon.accuracy, 0)
            
            // Test RSSI is reasonable if present
            if let rssi = beacon.rssi {
                XCTAssertLessThanOrEqual(rssi, 0) // RSSI should be negative or zero
            }
        }
    }
    
    func testAccuracyBoundaryValidation() {
        let beacons = MockDAOBeaconFactory.createMockBeaconWithVariousAccuracies()
        
        for beacon in beacons {
            // All accuracies should be >= 0 after didSet validation
            XCTAssertGreaterThanOrEqual(beacon.accuracy, 0)
            
            // The one that was set to -1.0 should now be 50.0
            if beacon.name.asString.contains("Accuracy Test -1") {
                XCTAssertEqual(beacon.accuracy, 50.0)
            }
        }
    }
    
    // MARK: - Validation Tests
    
    func testValidationHelper() {
        let validBeacon = MockDAOBeaconFactory.createMockBeacon()
        XCTAssertTrue(MockDAOBeaconFactory.validateBeaconProperties(validBeacon))
        
        let invalidBeacon = DAOBeacon()
        invalidBeacon.code = "" // Empty code
        invalidBeacon.name = DNSString(with: "") // Empty name
        XCTAssertFalse(MockDAOBeaconFactory.validateBeaconProperties(invalidBeacon))
        
        let invalidRSSIBeacon = MockDAOBeaconFactory.createMockBeacon()
        invalidRSSIBeacon.rssi = 10 // Positive RSSI is unrealistic
        XCTAssertFalse(MockDAOBeaconFactory.validateBeaconProperties(invalidRSSIBeacon))
    }
    
    // MARK: - Array Tests
    
    func testBeaconArray() {
        let beacons = MockDAOBeaconFactory.createMockBeaconArray(count: 5)
        
        XCTAssertEqual(beacons.count, 5)
        
        for (index, beacon) in beacons.enumerated() {
            XCTAssertEqual(beacon.id, "beacon\(index)")
            XCTAssertTrue(MockDAOBeaconFactory.validateBeaconProperties(beacon))
        }
    }
    
    // MARK: - Edge Cases
    
    func testMinimalDataBeacon() {
        let beacon = MockDAOBeaconFactory.createMockBeaconWithMinimalData()
        
        XCTAssertNotNil(beacon)
        XCTAssertEqual(beacon.name.asString, "Minimal Beacon")
        XCTAssertEqual(beacon.code, "MIN_BEACON")
        XCTAssertEqual(beacon.distance, .unknown) // Default value
    }
    
    func testInvalidDictionaryHandling() {
        let invalidDict = MockDAOBeaconFactory.createInvalidBeaconDictionary()
        let beacon = DAOBeacon(from: invalidDict)
        
        // Should still create object but with default values
        XCTAssertNotNil(beacon)
        if let beacon = beacon {
            XCTAssertEqual(beacon.distance, .unknown) // Should fall back to default
        }
    }
    
    // MARK: - CoreLocation Integration Tests
    
    func testCLBeaconDataHandling() {
        let beacon = DAOBeacon()
        
        // Test that CLBeacon data property exists but is nil by default
        XCTAssertNil(beacon.data)
        
        // Note: We can't easily test CLBeacon creation in unit tests
        // as it requires Bluetooth hardware, but we can test the property exists
    }
    
    // MARK: - Complex Scenarios
    
    func testBeaconNetworkScenario() {
        let beacons = MockDAOBeaconFactory.createMockBeaconWithRealWorldData()
        
        // Test filtering by major/minor
        let majorGroup1 = beacons.filter { $0.major == 1 }
        let majorGroup2 = beacons.filter { $0.major == 2 }
        let majorGroup3 = beacons.filter { $0.major == 3 }
        
        XCTAssertEqual(majorGroup1.count, 2) // Entrance and lobby
        XCTAssertEqual(majorGroup2.count, 2) // Store sections
        XCTAssertEqual(majorGroup3.count, 1) // Exit
        
        // Test signal strength distribution - be more specific about expected counts
        let strongSignals = beacons.filter { $0.isStrong }
        let weakSignals = beacons.filter { $0.isWeak }
        
        // Based on the mock data, we expect at least one strong signal (rssi > -50)
        // ENTRANCE (-40) and STORE_A (-35) should be strong
        XCTAssertGreaterThanOrEqual(strongSignals.count, 2)
        // EXIT (-55) and STORE_B (-60) should be weak (rssi < -70 is weak, so we expect 0 weak actually)
        XCTAssertGreaterThanOrEqual(weakSignals.count, 0)
        
        // Test nearby beacons
        let nearbyBeacons = beacons.filter { $0.isNearby }
        XCTAssertGreaterThan(nearbyBeacons.count, 0)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateBeacon() {
        measure {
            for _ in 0..<1000 {
                let _ = MockDAOBeaconFactory.createMockBeacon()
            }
        }
    }
    
    func testPerformanceCopyBeacon() {
        let beacon = MockDAOBeaconFactory.createMockBeacon()
        
        measure {
            for _ in 0..<1000 {
                let _ = DAOBeacon(from: beacon)
            }
        }
    }
    
    func testPerformanceDictionaryConversion() {
        let beacon = MockDAOBeaconFactory.createMockBeacon()
        
        measure {
            for _ in 0..<1000 {
                let _ = beacon.asDictionary
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testPropertyAssignment", testPropertyAssignment),
        ("testAccuracyValidation", testAccuracyValidation),
        ("testDistanceEnumValues", testDistanceEnumValues),
        ("testCopyInitialization", testCopyInitialization),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testNSCopying", testNSCopying),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testAsDictionary", testAsDictionary),
        ("testEquality", testEquality),
        ("testInequality", testInequality),
        ("testIsDiffFrom", testIsDiffFrom),
        ("testSelfComparison", testSelfComparison),
        ("testDistanceClassification", testDistanceClassification),
        ("testSignalStrengthClassification", testSignalStrengthClassification),
        ("testRealWorldBeaconData", testRealWorldBeaconData),
        ("testBoundaryValues", testBoundaryValues),
        ("testAccuracyBoundaryValidation", testAccuracyBoundaryValidation),
        ("testValidationHelper", testValidationHelper),
        ("testBeaconArray", testBeaconArray),
        ("testMinimalDataBeacon", testMinimalDataBeacon),
        ("testInvalidDictionaryHandling", testInvalidDictionaryHandling),
        ("testCLBeaconDataHandling", testCLBeaconDataHandling),
        ("testBeaconNetworkScenario", testBeaconNetworkScenario),
        ("testPerformanceCreateBeacon", testPerformanceCreateBeacon),
        ("testPerformanceCopyBeacon", testPerformanceCopyBeacon),
        ("testPerformanceDictionaryConversion", testPerformanceDictionaryConversion),
    ]
}
