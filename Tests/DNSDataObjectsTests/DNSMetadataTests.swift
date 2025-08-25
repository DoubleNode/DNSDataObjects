//
//  DNSMetadataTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSDataObjects

final class DNSMetadataTests: XCTestCase {
    
    func testDNSMetadataInitialization() {
        let metadata = DNSMetadata()
        
        XCTAssertNotNil(metadata)
        XCTAssertNotNil(metadata.created)
        XCTAssertNotNil(metadata.updated)
        XCTAssertNotNil(metadata.uid)
    }
    
    func testDNSMetadataFromDataDictionary() {
        let testTime = Date().timeIntervalSince1970
        let testUUID = UUID()
        let testData: DNSDataDictionary = [
            "created": testTime,
            "updated": testTime,
            "uid": testUUID.uuidString
        ]
        
        let metadata = DNSMetadata(from: testData)
        
        XCTAssertEqual(metadata.created.timeIntervalSince1970, testTime, accuracy: 1.0)
        XCTAssertEqual(metadata.updated.timeIntervalSince1970, testTime, accuracy: 1.0)
        XCTAssertEqual(metadata.uid, testUUID)
    }
    
    func testDNSMetadataAsDictionary() {
        let metadata = DNSMetadata()
        let dictionary = metadata.asDictionary
        
        XCTAssertNotNil(dictionary["created"] as Any?)
        XCTAssertNotNil(dictionary["updated"] as Any?)
        XCTAssertNotNil(dictionary["uid"] as Any?)
        
        XCTAssertTrue(dictionary["created"] is Date)
        XCTAssertTrue(dictionary["updated"] is Date)
        XCTAssertTrue(dictionary["uid"] is UUID)
    }
    
    func testDNSMetadataCopy() {
        let originalMetadata = DNSMetadata()
        let copiedMetadata = DNSMetadata(from: originalMetadata)
        
        XCTAssertEqual(copiedMetadata.created, originalMetadata.created)
        XCTAssertEqual(copiedMetadata.updated, originalMetadata.updated)
        XCTAssertEqual(copiedMetadata.uid, originalMetadata.uid)
        XCTAssertFalse(copiedMetadata === originalMetadata)
    }
    
    func testDNSMetadataEquality() {
        let metadata1 = DNSMetadata()
        let metadata2 = DNSMetadata()
        
        // Copy metadata1 to metadata2 for equality test
        metadata2.created = metadata1.created
        metadata2.updated = metadata1.updated
        metadata2.uid = metadata1.uid
        
        XCTAssertTrue(metadata1 == metadata2)
        
        // Create different metadata
        let metadata3 = DNSMetadata()
        XCTAssertFalse(metadata1 == metadata3)
    }
    
    func testDNSMetadataIsDiffFrom() {
        let metadata1 = DNSMetadata()
        let metadata2 = DNSMetadata()
        
        // Copy metadata1 to metadata2
        metadata2.created = metadata1.created
        metadata2.updated = metadata1.updated
        metadata2.uid = metadata1.uid
        
        XCTAssertFalse(metadata1.isDiffFrom(metadata2))
        
        // Different metadata
        let metadata3 = DNSMetadata()
        XCTAssertTrue(metadata1.isDiffFrom(metadata3))
        XCTAssertTrue(metadata1.isDiffFrom("not metadata"))
    }
    
    func testDNSMetadataTimeProgression() {
        let metadata = DNSMetadata()
        let created = metadata.created
        
        // Simulate updating
        Thread.sleep(forTimeInterval: 0.01) // Small delay to ensure different timestamp
        metadata.updated = Date()
        
        XCTAssertGreaterThanOrEqual(metadata.updated, created)
    }
    
    func testDNSMetadataUUIDUniqueness() {
        let metadata1 = DNSMetadata()
        let metadata2 = DNSMetadata()
        
        XCTAssertNotEqual(metadata1.uid, metadata2.uid)
    }
    
    func testDNSMetadataFromEmptyDataDictionary() {
        let emptyData: DNSDataDictionary = [:]
        let metadata = DNSMetadata(from: emptyData)
        
        // Should create with default values
        XCTAssertNotNil(metadata.created)
        XCTAssertNotNil(metadata.updated)
        XCTAssertNotNil(metadata.uid)
    }
    
    func testDNSMetadataFromPartialDataDictionary() {
        let testTime = Date().timeIntervalSince1970
        let partialData: DNSDataDictionary = [
            "created": testTime
            // Missing updated and uid
        ]
        
        let metadata = DNSMetadata(from: partialData)
        
        XCTAssertEqual(metadata.created.timeIntervalSince1970, testTime, accuracy: 1.0)
        XCTAssertNotNil(metadata.updated) // Should have default value
        XCTAssertNotNil(metadata.uid) // Should have default value
    }
    
    nonisolated(unsafe) static var allTests = [
        ("testDNSMetadataInitialization", testDNSMetadataInitialization),
        ("testDNSMetadataFromDataDictionary", testDNSMetadataFromDataDictionary),
        ("testDNSMetadataAsDictionary", testDNSMetadataAsDictionary),
        ("testDNSMetadataCopy", testDNSMetadataCopy),
        ("testDNSMetadataEquality", testDNSMetadataEquality),
        ("testDNSMetadataIsDiffFrom", testDNSMetadataIsDiffFrom),
        ("testDNSMetadataTimeProgression", testDNSMetadataTimeProgression),
        ("testDNSMetadataUUIDUniqueness", testDNSMetadataUUIDUniqueness),
        ("testDNSMetadataFromEmptyDataDictionary", testDNSMetadataFromEmptyDataDictionary),
        ("testDNSMetadataFromPartialDataDictionary", testDNSMetadataFromPartialDataDictionary),
    ]
}
