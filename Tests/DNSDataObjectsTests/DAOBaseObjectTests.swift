//
//  DAOBaseObjectTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSDataObjects

final class DAOBaseObjectTests: XCTestCase {
    
    func testDAOBaseObjectDefaultInitialization() {
        let baseObject = DAOBaseObject()
        
        XCTAssertFalse(baseObject.id.isEmpty)
        XCTAssertNotNil(baseObject.meta)
        XCTAssertEqual(baseObject.analyticsData.count, 0)
        
        // ID should be a valid UUID string
        XCTAssertNotNil(UUID(uuidString: baseObject.id))
    }
    
    func testDAOBaseObjectInitializationWithId() {
        let testId = "test-base-object-id"
        let baseObject = DAOBaseObject(id: testId)
        
        XCTAssertEqual(baseObject.id, testId)
        XCTAssertNotNil(baseObject.meta)
        XCTAssertEqual(baseObject.analyticsData.count, 0)
    }
    
    func testDAOBaseObjectCopyConstructor() {
        let originalObject = DAOBaseObject(id: "original-id")
        originalObject.analyticsData = [DAOAnalyticsData(id: "analytics-1")]
        
        let copiedObject = DAOBaseObject(from: originalObject)
        
        XCTAssertEqual(copiedObject.id, originalObject.id)
        XCTAssertEqual(copiedObject.analyticsData.count, originalObject.analyticsData.count)
        XCTAssertFalse(copiedObject === originalObject) // Different instances
    }
    
    func testDAOBaseObjectUpdateFrom() {
        let object1 = DAOBaseObject(id: "object1")
        let object2 = DAOBaseObject(id: "object2")
        object2.analyticsData = [DAOAnalyticsData(id: "analytics-2")]
        
        object1.update(from: object2)
        
        XCTAssertEqual(object1.id, "object2")
        XCTAssertEqual(object1.analyticsData.count, 1)
        XCTAssertEqual(object1.analyticsData.first?.id, "analytics-2")
    }
    
    func testDAOBaseObjectFromDataDictionary() {
        let testData: DNSDataDictionary = [
            "id": "test-id-from-dict",
            "analyticsData": [],
            "meta": [
                "created": Date().timeIntervalSince1970,
                "updated": Date().timeIntervalSince1970
            ]
        ]
        
        guard let baseObject = DAOBaseObject(from: testData) else {
            XCTFail("Failed to create DAOBaseObject from data dictionary")
            return
        }
        
        XCTAssertEqual(baseObject.id, "test-id-from-dict")
        XCTAssertNotNil(baseObject.meta)
        XCTAssertEqual(baseObject.analyticsData.count, 0)
    }
    
    func testDAOBaseObjectFromEmptyDataDictionary() {
        let emptyData: DNSDataDictionary = [:]
        let baseObject = DAOBaseObject(from: emptyData)
        
        XCTAssertNil(baseObject)
    }
    
    func testDAOBaseObjectAsDictionary() {
        let baseObject = DAOBaseObject(id: "dictionary-test")
        let dictionary = baseObject.asDictionary
        
        XCTAssertEqual(dictionary["id"] as? String, "dictionary-test")
        XCTAssertNotNil(dictionary["analyticsData"] as Any?)
        XCTAssertNotNil(dictionary["meta"] as Any?)
        
        let analyticsArray = dictionary["analyticsData"] as? [[String: Any]]
        XCTAssertEqual(analyticsArray?.count, 0)
    }
    
    func testDAOBaseObjectCopyProtocol() {
        let originalObject = DAOBaseObject(id: "copy-test")
        let copiedObject = originalObject.copy() as! DAOBaseObject
        
        XCTAssertEqual(copiedObject.id, originalObject.id)
        XCTAssertFalse(copiedObject === originalObject)
    }
    
    func testDAOBaseObjectEquality() {
        let object1 = DAOBaseObject(id: "same-id")
        let object2 = DAOBaseObject(id: "same-id")
        let object3 = DAOBaseObject(id: "different-id")
        
        object2.meta = object1.meta
        object3.meta = object1.meta

        XCTAssertTrue(object1 == object2)
        XCTAssertFalse(object1 == object3)
    }
    
    func testDAOBaseObjectIsDiffFrom() {
        let object1 = DAOBaseObject(id: "test-id")
        let object2 = DAOBaseObject(id: "test-id")
        let object3 = DAOBaseObject(id: "different-id")
        
        object2.meta = object1.meta
        object3.meta = object1.meta

        XCTAssertFalse(object1.isDiffFrom(object2))
        XCTAssertTrue(object1.isDiffFrom(object3))
        XCTAssertTrue(object1.isDiffFrom("not a base object"))
    }
    
    func testDAOBaseObjectCodable() {
        let originalObject = DAOBaseObject(id: "codable-test")
        
        do {
            let encodedData = try JSONEncoder().encode(originalObject)
            let decodedObject = try JSONDecoder().decode(DAOBaseObject.self, from: encodedData)
            
            XCTAssertEqual(decodedObject.id, originalObject.id)
            XCTAssertEqual(decodedObject.analyticsData.count, originalObject.analyticsData.count)
        } catch {
            XCTFail("Failed to encode/decode DAOBaseObject: \(error)")
        }
    }
    
    func testDAOBaseObjectMetadata() {
        let baseObject = DAOBaseObject()
        
        XCTAssertNotNil(baseObject.meta)
        XCTAssertNotNil(baseObject.meta.created)
        XCTAssertNotNil(baseObject.meta.updated)
        XCTAssertNotNil(baseObject.meta.uid)
    }

    nonisolated(unsafe) static var allTests = [
        ("testDAOBaseObjectDefaultInitialization", testDAOBaseObjectDefaultInitialization),
        ("testDAOBaseObjectInitializationWithId", testDAOBaseObjectInitializationWithId),
        ("testDAOBaseObjectCopyConstructor", testDAOBaseObjectCopyConstructor),
        ("testDAOBaseObjectUpdateFrom", testDAOBaseObjectUpdateFrom),
        ("testDAOBaseObjectFromDataDictionary", testDAOBaseObjectFromDataDictionary),
        ("testDAOBaseObjectFromEmptyDataDictionary", testDAOBaseObjectFromEmptyDataDictionary),
        ("testDAOBaseObjectAsDictionary", testDAOBaseObjectAsDictionary),
        ("testDAOBaseObjectCopyProtocol", testDAOBaseObjectCopyProtocol),
        ("testDAOBaseObjectEquality", testDAOBaseObjectEquality),
        ("testDAOBaseObjectIsDiffFrom", testDAOBaseObjectIsDiffFrom),
        ("testDAOBaseObjectCodable", testDAOBaseObjectCodable),
        ("testDAOBaseObjectMetadata", testDAOBaseObjectMetadata),
    ]
}
