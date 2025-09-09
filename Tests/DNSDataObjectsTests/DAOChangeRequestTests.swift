//
//  DAOChangeRequestTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOChangeRequestTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        let changeRequest = DAOChangeRequest()
        XCTAssertNotNil(changeRequest)
        XCTAssertFalse(changeRequest.id.isEmpty)
    }
    
    func testInitializationWithId() {
        let testId = "change_request_test_12345"
        let changeRequest = DAOChangeRequest(id: testId)
        XCTAssertEqual(changeRequest.id, testId)
    }
    
    // MARK: - Property Tests
    
    func testBaseProperties() {
        let changeRequest = MockDAOChangeRequestFactory.create()
        XCTAssertEqual(changeRequest.id, "change_request_12345")
        
        // DAOChangeRequest is essentially empty - only has base properties
        // Testing that it inherits properly from DAOBaseObject
        XCTAssertNotNil(changeRequest.meta.created)
        XCTAssertNotNil(changeRequest.meta.updated)
    }
    
    // MARK: - Copy Tests
    
    func testCopyFromObject() {
        let originalChangeRequest = MockDAOChangeRequestFactory.create()
        let copiedChangeRequest = DAOChangeRequest(from: originalChangeRequest)
        
        XCTAssertEqual(copiedChangeRequest.id, originalChangeRequest.id)
        XCTAssertEqual(copiedChangeRequest.meta.created, originalChangeRequest.meta.created)
    }
    
    func testUpdateFromObject() {
        let originalChangeRequest = MockDAOChangeRequestFactory.create()
        let targetChangeRequest = DAOChangeRequest()
        
        targetChangeRequest.update(from: originalChangeRequest)
        
        XCTAssertEqual(targetChangeRequest.id, originalChangeRequest.id)
        XCTAssertEqual(targetChangeRequest.meta.created, originalChangeRequest.meta.created)
    }
    
    func testNSCopying() {
        let originalChangeRequest = MockDAOChangeRequestFactory.create()
        let copiedChangeRequest = originalChangeRequest.copy() as! DAOChangeRequest
        
        XCTAssertEqual(copiedChangeRequest.id, originalChangeRequest.id)
        XCTAssertFalse(copiedChangeRequest === originalChangeRequest)
    }
    
    // MARK: - Dictionary Translation Tests
    
    func testDictionaryTranslation() {
        let originalChangeRequest = MockDAOChangeRequestFactory.create()
        let dictionary = originalChangeRequest.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        // created and updated are nested under meta
        let meta = dictionary["meta"] as? [String: Any]
        XCTAssertNotNil(meta?["created"] as Any?)
        XCTAssertNotNil(meta?["updated"] as Any?)
        
        let reconstructedChangeRequest = DAOChangeRequest(from: dictionary)
        XCTAssertNotNil(reconstructedChangeRequest)
        XCTAssertEqual(reconstructedChangeRequest?.id, originalChangeRequest.id)
    }
    
    func testDictionaryTranslationEmpty() {
        let emptyDictionary: [String: Any] = [:]
        let changeRequest = DAOChangeRequest(from: emptyDictionary)
        XCTAssertNil(changeRequest)
    }
    
    func testDictionaryTranslationMinimal() {
        let minimalDictionary: [String: Any] = ["id": "test_id"]
        let changeRequest = DAOChangeRequest(from: minimalDictionary)
        XCTAssertNotNil(changeRequest)
        XCTAssertEqual(changeRequest?.id, "test_id")
    }
    
    // MARK: - Equality Tests
    
    func testEquality() {
        let changeRequest1 = MockDAOChangeRequestFactory.create()
        let changeRequest2 = DAOChangeRequest(from: changeRequest1)
        let changeRequest3 = MockDAOChangeRequestFactory.createEmpty()
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(changeRequest1.id, changeRequest2.id)
        XCTAssertEqual(changeRequest1.meta.created, changeRequest2.meta.created)
        XCTAssertNotEqual(changeRequest1, changeRequest3)
        XCTAssertFalse(changeRequest1.isDiffFrom(changeRequest2))
        XCTAssertTrue(changeRequest1.isDiffFrom(changeRequest3))
    }
    
    func testEqualityWithDifferentIds() {
        let changeRequest1 = MockDAOChangeRequestFactory.create()
        let changeRequest2 = MockDAOChangeRequestFactory.createWithId("different_id")
        
        XCTAssertNotEqual(changeRequest1, changeRequest2)
        XCTAssertTrue(changeRequest1.isDiffFrom(changeRequest2))
    }
    
    func testEqualityWithSameObject() {
        let changeRequest = MockDAOChangeRequestFactory.create()
        
        XCTAssertEqual(changeRequest, changeRequest)
        XCTAssertFalse(changeRequest.isDiffFrom(changeRequest))
    }
    
    // MARK: - Codable Tests
    
    func testJSONEncoding() throws {
        let originalChangeRequest = MockDAOChangeRequestFactory.create()
        let data = try JSONEncoder().encode(originalChangeRequest)
        XCTAssertFalse(data.isEmpty)
    }
    
    func testJSONDecoding() throws {
        let originalChangeRequest = MockDAOChangeRequestFactory.create()
        let data = try JSONEncoder().encode(originalChangeRequest)
        let decodedChangeRequest = try JSONDecoder().decode(DAOChangeRequest.self, from: data)
        
        XCTAssertEqual(decodedChangeRequest.id, originalChangeRequest.id)
    }
    
    func testJSONRoundTrip() throws {
        let originalChangeRequest = MockDAOChangeRequestFactory.create()
        let data = try JSONEncoder().encode(originalChangeRequest)
        let decodedChangeRequest = try JSONDecoder().decode(DAOChangeRequest.self, from: data)
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(decodedChangeRequest.id, originalChangeRequest.id)
        XCTAssertEqual(decodedChangeRequest.meta.created, originalChangeRequest.meta.created)
        XCTAssertEqual(decodedChangeRequest.meta.updated, originalChangeRequest.meta.updated)
        XCTAssertFalse(originalChangeRequest.isDiffFrom(decodedChangeRequest))
    }
    
    func testJSONEncodingEmpty() throws {
        let emptyChangeRequest = DAOChangeRequest()
        let data = try JSONEncoder().encode(emptyChangeRequest)
        XCTAssertFalse(data.isEmpty)
        
        let decodedChangeRequest = try JSONDecoder().decode(DAOChangeRequest.self, from: data)
        XCTAssertNotNil(decodedChangeRequest)
    }
    
    // MARK: - Edge Cases
    
    func testEmptyObject() {
        let changeRequest = DAOChangeRequest()
        
        XCTAssertNotNil(changeRequest)
        XCTAssertFalse(changeRequest.id.isEmpty)
        
        let dictionary = changeRequest.asDictionary
        XCTAssertNotNil(dictionary["id"] as Any?)
        
        let reconstructed = DAOChangeRequest(from: dictionary)
        XCTAssertNotNil(reconstructed)
        XCTAssertEqual(reconstructed?.id, changeRequest.id)
    }
    
    func testMultipleInstances() {
        let changeRequest1 = DAOChangeRequest()
        let changeRequest2 = DAOChangeRequest()
        let changeRequest3 = DAOChangeRequest()
        
        // Each instance should have a unique ID
        XCTAssertNotEqual(changeRequest1.id, changeRequest2.id)
        XCTAssertNotEqual(changeRequest2.id, changeRequest3.id)
        XCTAssertNotEqual(changeRequest1.id, changeRequest3.id)
    }
    
    func testPerformanceCreation() {
        measure {
            for _ in 0..<1000 {
                _ = DAOChangeRequest()
            }
        }
    }
    
    func testPerformanceCopying() {
        let original = MockDAOChangeRequestFactory.create()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOChangeRequest(from: original)
            }
        }
    }
    
    // MARK: - Factory Tests
    
    func testMockFactory() {
        let changeRequest = MockDAOChangeRequestFactory.create()
        XCTAssertNotNil(changeRequest)
        XCTAssertEqual(changeRequest.id, "change_request_12345")
    }
    
    func testMockFactoryEmpty() {
        let changeRequest = MockDAOChangeRequestFactory.createEmpty()
        XCTAssertNotNil(changeRequest)
        XCTAssertFalse(changeRequest.id.isEmpty)
    }
    
    func testMockFactoryWithId() {
        let testId = "custom_change_request_id"
        let changeRequest = MockDAOChangeRequestFactory.createWithId(testId)
        XCTAssertEqual(changeRequest.id, testId)
    }

    static var allTests = [
        ("testInitialization", testInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testBaseProperties", testBaseProperties),
        ("testCopyFromObject", testCopyFromObject),
        ("testUpdateFromObject", testUpdateFromObject),
        ("testNSCopying", testNSCopying),
        ("testDictionaryTranslation", testDictionaryTranslation),
        ("testDictionaryTranslationEmpty", testDictionaryTranslationEmpty),
        ("testDictionaryTranslationMinimal", testDictionaryTranslationMinimal),
        ("testEquality", testEquality),
        ("testEqualityWithDifferentIds", testEqualityWithDifferentIds),
        ("testEqualityWithSameObject", testEqualityWithSameObject),
        ("testJSONEncoding", testJSONEncoding),
        ("testJSONDecoding", testJSONDecoding),
        ("testJSONRoundTrip", testJSONRoundTrip),
        ("testJSONEncodingEmpty", testJSONEncodingEmpty),
        ("testEmptyObject", testEmptyObject),
        ("testMultipleInstances", testMultipleInstances),
        ("testPerformanceCreation", testPerformanceCreation),
        ("testPerformanceCopying", testPerformanceCopying),
        ("testMockFactory", testMockFactory),
        ("testMockFactoryEmpty", testMockFactoryEmpty),
        ("testMockFactoryWithId", testMockFactoryWithId),
    ]
}
