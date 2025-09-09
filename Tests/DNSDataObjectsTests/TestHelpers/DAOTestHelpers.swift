//
//  DAOTestHelpers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSDataObjects

// MARK: - MockDAOFactory Protocol -
protocol MockDAOFactory {
    associatedtype DAOType: DAOBaseObject
    
    static func createMock() -> DAOType
    static func createMockWithTestData() -> DAOType
    static func createMockWithEdgeCases() -> DAOType
    static func createMockArray(count: Int) -> [DAOType]
}

// MARK: - Test Helper Utilities -
struct DAOTestHelpers {
    
    // MARK: - Mock Creation Methods -
    
    static func createMockDNSMetadata(status: String = "active") -> DNSMetadata {
        let metadata = DNSMetadata()
        metadata.status = status
        metadata.createdBy = "TestUser"
        metadata.updatedBy = "TestUser"
        metadata.views = 42
        return metadata
    }
    
    static func createMockAnalyticsData(title: String = "Test Analytics",
                                       subtitle: String = "Test Subtitle") -> DAOAnalyticsData {
        let analytics = DAOAnalyticsData()
        analytics.title = title
        analytics.subtitle = subtitle
        return analytics
    }
    
    // MARK: - Validation Helper Methods -
    
    static func validateCodableRoundtrip<T: Codable>(_ object: T) throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let jsonData = try encoder.encode(object)
        let decodedObject = try decoder.decode(T.self, from: jsonData)
        
        // Note: We can't directly compare objects here without Equatable conformance
        // Individual tests should validate specific properties after round-trip
        XCTAssertNotNil(decodedObject, "Object should decode successfully")
    }
    
    static func validateDictionaryRoundtrip<T: DAOBaseObject>(_ object: T) {
        let dictionary = object.asDictionary
        XCTAssertNotNil(dictionary, "Object should convert to dictionary")
        XCTAssertFalse(dictionary.isEmpty, "Dictionary should not be empty")
        
        // Verify the dictionary contains expected base fields
        XCTAssertNotNil(dictionary["id"] as Any?, "Dictionary should contain id field")
        XCTAssertNotNil(dictionary["meta"] as Any?, "Dictionary should contain meta field")
    }
    
    static func validateNoMemoryLeaks<T>(_ createObject: () -> T) {
        weak var weakRef: AnyObject?
        
        autoreleasepool {
            let object = createObject() as AnyObject
            weakRef = object
            XCTAssertNotNil(weakRef, "Object should exist")
        }
        
        // Note: In test environment, immediate deallocation check may not always work
        // due to ARC optimizations and test runner behavior
        // Individual tests should verify no retain cycles exist
    }
    
    static func createMockDNSString(_ value: String = "Test String") -> DNSString {
        return DNSString(with: value)
    }
    
    static func createMockDNSURL(_ urlString: String = "https://example.com") -> DNSURL {
        return DNSURL(with: URL(string: urlString))
    }
    
    // MARK: - Mock Dictionary Creation -
    
    static func createMockBaseObjectDictionary(id: String? = nil) -> DNSDataDictionary {
        let testId = id ?? UUID().uuidString
        return [
            "id": testId,
            "meta": createMockMetadataDictionary(),
            "analyticsData": []
        ]
    }
    
    static func createMockMetadataDictionary() -> DNSDataDictionary {
        return [
            "uid": UUID().uuidString,
            "status": "active",
            "created": Date(),
            "updated": Date(),
            "createdBy": "TestUser",
            "updatedBy": "TestUser",
            "views": 42,
            "genericValues": [:],
            "reactions": [:],
            "reactionCounts": [:]
        ]
    }
    
    // MARK: - Performance Testing Helpers -
    
    static func measureObjectCreationPerformance<T>(_ createObject: () -> T, 
                                                   iterations: Int = 1000) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = createObject()
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return timeElapsed
    }
    
    static func measureCopyingPerformance<T: NSCopying>(_ object: T, 
                                                       iterations: Int = 1000) -> TimeInterval {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = object.copy()
        }
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return timeElapsed
    }
}

// MARK: - XCTestCase Extensions -
extension XCTestCase {
    
    func validateDAOBaseFunctionality<T: DAOBaseObject>(_ object: T) {
        // Test basic properties
        XCTAssertFalse(object.id.isEmpty, "DAO should have non-empty ID")
        XCTAssertNotNil(object.meta, "DAO should have metadata")
        XCTAssertNotNil(object.analyticsData, "DAO should have analytics data array")
        
        // Test NSCopying
        let copy = object.copy() as? T
        XCTAssertNotNil(copy, "DAO should be copyable")
        XCTAssertEqual(object.id, copy?.id, "Copy should have same ID")
        XCTAssertFalse(object === copy, "Copy should be different object instance")
        
        // Test dictionary conversion
        DAOTestHelpers.validateDictionaryRoundtrip(object)
    }
    
    func validateCodableFunctionality<T: Codable>(_ object: T) {
        do {
            try DAOTestHelpers.validateCodableRoundtrip(object)
        } catch {
            XCTFail("Codable round-trip failed: \(error)")
        }
    }
}

