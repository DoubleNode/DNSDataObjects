//
//  DataTranslationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSDataObjects

final class DataTranslationTests: XCTestCase {
    var testObject: DAOBaseObject!
    
    override func setUp() {
        super.setUp()
        testObject = DAOBaseObject()
    }
    
    override func tearDown() {
        testObject = nil
        super.tearDown()
    }
    
    // MARK: - String Translation Tests
    
    func testStringTranslation() {
        let testString = "Hello, World!"
        let result = testObject.string(from: testString as Any?)
        XCTAssertEqual(result, testString)
        
        let nilResult = testObject.string(from: nil as Any?)
        XCTAssertNil(nilResult)
        
        let numberResult = testObject.string(from: 42 as Any?)
        XCTAssertEqual(numberResult, "42")
    }
    
    // MARK: - Boolean Translation Tests
    
    func testBooleanTranslation() {
        XCTAssertEqual(testObject.bool(from: true as Any?), true)
        XCTAssertEqual(testObject.bool(from: false as Any?), false)
        XCTAssertEqual(testObject.bool(from: "true" as Any?), true)
        XCTAssertEqual(testObject.bool(from: "false" as Any?), false)
        XCTAssertEqual(testObject.bool(from: "YES" as Any?), true)
        XCTAssertEqual(testObject.bool(from: "NO" as Any?), false)
        XCTAssertEqual(testObject.bool(from: 1 as Any?), true)
        XCTAssertEqual(testObject.bool(from: 0 as Any?), false)
        XCTAssertNil(testObject.bool(from: nil as Any?))
    }
    
    // MARK: - Int Translation Tests
    
    func testIntTranslation() {
        XCTAssertEqual(testObject.int(from: 42 as Any?), 42)
        XCTAssertEqual(testObject.int(from: "123" as Any?), 123)
        XCTAssertEqual(testObject.int(from: 45.67 as Any?), 45)
        XCTAssertNil(testObject.int(from: nil as Any?))
        XCTAssertNil(testObject.int(from: "invalid" as Any?))
    }
    
    // MARK: - Double Translation Tests
    
    func testDoubleTranslation() {
        XCTAssertEqual(testObject.double(from: 42.5 as Any?), 42.5)
        XCTAssertEqual(testObject.double(from: "123.45" as Any?), 123.45)
        XCTAssertEqual(testObject.double(from: 67 as Any?), 67.0)
        XCTAssertNil(testObject.double(from: nil as Any?))
        XCTAssertNil(testObject.double(from: "invalid" as Any?))
    }
    
    // MARK: - Date Translation Tests
    
    func testDateTranslation() {
        let testDate = Date()
        let timeInterval = testDate.timeIntervalSince1970
        
        // FIXME: DNSDataTranslation Date doesn't translate from TimeIntervals
        let result = testObject.date(from: timeInterval as Any?)
        XCTAssertNotNil(result)
        if let result {
            XCTAssertEqual(result.timeIntervalSince1970, timeInterval, accuracy: 1.0)
        }
        
        let nilResult = testObject.date(from: nil as Any?)
        XCTAssertNil(nilResult)
    }
    
    // MARK: - Dictionary Translation Tests
    
    func testDictionaryTranslation() {
        let testDict: [String: Any] = ["key1": "value1", "key2": 42]
        let result = testObject.dictionary(from: testDict as Any?)
        
        XCTAssertEqual(result["key1"] as? String, "value1")
        XCTAssertEqual(result["key2"] as? Int, 42)
        
        let nilResult: DNSDataDictionary = testObject.dictionary(from: nil as Any?)
        XCTAssertNotNil(nilResult)
//        XCTAssertEqual(nilResult, DNSDataDictionary.empty)
    }
    
    // MARK: - Array Translation Tests
    
    func testArrayTranslation() {
        let testArray: [[String: Any]] = [
            [
                "first": "string",
                "second": 42,
                "third": true
            ]
        ]
        let result = testObject.dataarray(from: testArray as Any?)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0]["first"] as? String, "string")
        XCTAssertEqual(result[0]["second"] as? Int, 42)
        XCTAssertEqual(result[0]["third"] as? Bool, true)
        
        let nilResult = testObject.dataarray(from: nil as Any?)
        XCTAssertEqual(nilResult.count, 0)
    }
    
    // MARK: - URL Translation Tests
    
    func testURLTranslation() {
        let testURLString = "https://example.com/test"
        let result = testObject.url(from: testURLString as Any?)
        
        XCTAssertEqual(result?.absoluteString, testURLString)
        
        // FIXME: Invalid URL strings still create valid objects
//        let invalidResult = testObject.url(from: "invalid url" as Any?)
//        XCTAssertNil(invalidResult)
        
        let nilResult = testObject.url(from: nil as Any?)
        XCTAssertNil(nilResult)
    }
    
    // MARK: - Integration Tests with DAO Objects
    
    func testDAOObjectDataTranslation() {
        let testData: DNSDataDictionary = [
            "id": "test-id",
            "analyticsData": [],
            "meta": [
                "createdTime": Date().timeIntervalSince1970,
                "updatedTime": Date().timeIntervalSince1970,
                "uid": UUID().uuidString
            ]
        ]
        
        guard let baseObject = DAOBaseObject(from: testData) else {
            XCTFail("Failed to create DAOBaseObject from data")
            return
        }
        
        XCTAssertEqual(baseObject.id, "test-id")
        XCTAssertNotNil(baseObject.meta)
        XCTAssertEqual(baseObject.analyticsData.count, 0)
    }
    
    func testComplexDataTranslation() {
        let complexData: DNSDataDictionary = [
            "stringValue": "test",
            "intValue": 42,
            "doubleValue": 3.14,
            "boolValue": true,
            "arrayValue": ["first": "item1", "second": "item2"],
            "dictValue": ["nested": "value"],
            "urlValue": "https://example.com"
        ]
        
        // Test that all data types can be extracted correctly
        XCTAssertEqual(testObject.string(from: complexData["stringValue"] as Any?), "test")
        XCTAssertEqual(testObject.int(from: complexData["intValue"] as Any?), 42)
        XCTAssertEqual(testObject.double(from: complexData["doubleValue"] as Any?), 3.14)
        XCTAssertEqual(testObject.bool(from: complexData["boolValue"] as Any?), true)
        
        // FIXME: DNSDataTranslation DataArray doesn't translate from simple Arrays
        let array = testObject.dataarray(from: complexData["arrayValue"] as Any?)
        XCTAssertEqual(array.count, 1)
        XCTAssertEqual(array[0].count, 2)

        let dict = testObject.dictionary(from: complexData["dictValue"] as Any?)
        XCTAssertEqual(dict["nested"] as? String, "value")
        
        let url = testObject.url(from: complexData["urlValue"] as Any?)
        XCTAssertEqual(url?.absoluteString, "https://example.com")
    }
    
    nonisolated(unsafe) static var allTests = [
        ("testStringTranslation", testStringTranslation),
        ("testBooleanTranslation", testBooleanTranslation),
        ("testIntTranslation", testIntTranslation),
        ("testDoubleTranslation", testDoubleTranslation),
        ("testDateTranslation", testDateTranslation),
        ("testDictionaryTranslation", testDictionaryTranslation),
        ("testArrayTranslation", testArrayTranslation),
        ("testURLTranslation", testURLTranslation),
        ("testDAOObjectDataTranslation", testDAOObjectDataTranslation),
        ("testComplexDataTranslation", testComplexDataTranslation),
    ]
}
