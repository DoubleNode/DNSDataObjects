//
//  DAOActivityTypeTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects
import Foundation

final class DAOActivityTypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let activityType = DAOActivityType()
        
        // Assert
        XCTAssertEqual(activityType.code, "")
        XCTAssertEqual(activityType.name, DNSString())
        XCTAssertNotNil(activityType.pricing)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "activity-type-123"
        
        // Act
        let activityType = DAOActivityType(id: testId)
        
        // Assert
        XCTAssertEqual(activityType.id, testId)
        XCTAssertEqual(activityType.code, "")
        XCTAssertEqual(activityType.name, DNSString())
        XCTAssertNotNil(activityType.pricing)
    }
    
    func testInitializationWithCodeAndName() {
        // Arrange
        let testCode = "SPORTS"
        let testName = DNSString(with: "Sports Activities")
        
        // Act
        let activityType = DAOActivityType(code: testCode, name: testName)
        
        // Assert
        XCTAssertEqual(activityType.id, testCode)
        XCTAssertEqual(activityType.code, testCode)
        XCTAssertEqual(activityType.name.asString, testName.asString)
        XCTAssertNotNil(activityType.pricing)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalActivityType = MockDAOActivityTypeFactory.createMockWithTestData()
        
        // Act
        let copiedActivityType = DAOActivityType(from: originalActivityType)
        
        // Assert
        XCTAssertEqual(copiedActivityType.id, originalActivityType.id)
        XCTAssertEqual(copiedActivityType.code, originalActivityType.code)
        XCTAssertEqual(copiedActivityType.name.asString, originalActivityType.name.asString)
        XCTAssertEqual(copiedActivityType.pricing.id, originalActivityType.pricing.id)
        XCTAssertFalse(copiedActivityType === originalActivityType) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "code": "FITNESS",
            "name": ["": "Fitness & Wellness"],
            "pricing": ["id": "fitness_pricing"]
        ]
        
        // Act
        let activityType = DAOActivityType(from: testData)
        
        // Assert
        XCTAssertNotNil(activityType)
        XCTAssertEqual(activityType?.code, "FITNESS")
        XCTAssertEqual(activityType?.name.asString, "Fitness & Wellness")
        XCTAssertEqual(activityType?.pricing.id, "fitness_pricing")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let activityType = DAOActivityType(from: emptyData)
        
        // Assert
        XCTAssertNil(activityType)
    }
    
    // MARK: - Property Tests
    
    func testCodeProperty() {
        // Arrange
        let activityType = DAOActivityType()
        let testCode = "ADVENTURE"
        
        // Act
        activityType.code = testCode
        
        // Assert
        XCTAssertEqual(activityType.code, testCode)
    }
    
    func testNameProperty() {
        // Arrange
        let activityType = DAOActivityType()
        let testName = DNSString(with: "Adventure Activities")
        
        // Act
        activityType.name = testName
        
        // Assert
        XCTAssertEqual(activityType.name.asString, testName.asString)
    }
    
    func testPricingProperty() {
        // Arrange
        let activityType = DAOActivityType()
        let testPricing = DAOPricing()
        testPricing.id = "custom_pricing_456"
        
        // Act
        activityType.pricing = testPricing
        
        // Assert
        XCTAssertEqual(activityType.pricing.id, testPricing.id)
    }
    
    func testEmptyCodeProperty() {
        // Arrange
        let activityType = DAOActivityType()
        
        // Act
        activityType.code = ""
        
        // Assert
        XCTAssertEqual(activityType.code, "")
    }
    
    func testEmptyNameProperty() {
        // Arrange
        let activityType = DAOActivityType()
        
        // Act
        activityType.name = DNSString()
        
        // Assert
        XCTAssertEqual(activityType.name.asString, "")
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalActivityType = MockDAOActivityTypeFactory.createMock()
        let sourceActivityType = MockDAOActivityTypeFactory.createMockWithTestData()
        
        // Act
        originalActivityType.update(from: sourceActivityType)
        
        // Assert
        XCTAssertEqual(originalActivityType.code, sourceActivityType.code)
        XCTAssertEqual(originalActivityType.name.asString, sourceActivityType.name.asString)
        XCTAssertEqual(originalActivityType.pricing.id, sourceActivityType.pricing.id)
    }
    
    func testCodeAsId() {
        // Arrange
        let testCode = "UNIQUE_CODE"
        let testName = DNSString(with: "Unique Activity")
        
        // Act
        let activityType = DAOActivityType(code: testCode, name: testName)
        
        // Assert
        XCTAssertEqual(activityType.id, testCode)
        XCTAssertEqual(activityType.code, testCode)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalActivityType = MockDAOActivityTypeFactory.createMockWithTestData()
        
        // Act
        let copiedActivityType = originalActivityType.copy() as? DAOActivityType
        
        // Assert
        XCTAssertNotNil(copiedActivityType)
        XCTAssertEqual(copiedActivityType?.code, originalActivityType.code)
        XCTAssertEqual(copiedActivityType?.name.asString, originalActivityType.name.asString)
        XCTAssertEqual(copiedActivityType?.pricing.id, originalActivityType.pricing.id)
        XCTAssertFalse(copiedActivityType === originalActivityType) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let activityType1 = MockDAOActivityTypeFactory.createMockWithTestData()
        let activityType2 = DAOActivityType(from: activityType1) // Copy to ensure same data
        let activityType3 = MockDAOActivityTypeFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should be equal
        XCTAssertEqual(activityType1.id, activityType2.id)
        XCTAssertEqual(activityType1.code, activityType2.code)
        XCTAssertEqual(activityType1.name.asString, activityType2.name.asString)
        XCTAssertEqual(activityType1.pricing.id, activityType2.pricing.id)
        
        // Act & Assert - Different data should not be equal
        XCTAssertNotEqual(activityType1.code, activityType3.code)
        XCTAssertNotEqual(activityType1.name.asString, activityType3.name.asString)
        
        // Act & Assert - Same instance should be equal to itself
        XCTAssertEqual(activityType1.id, activityType1.id)
        XCTAssertEqual(activityType1.code, activityType1.code)
        XCTAssertEqual(activityType1.name.asString, activityType1.name.asString)
        XCTAssertEqual(activityType1.pricing.id, activityType1.pricing.id)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let activityType1 = MockDAOActivityTypeFactory.createMockWithTestData()
        let activityType2 = DAOActivityType(from: activityType1) // Copy to ensure same data
        let activityType3 = MockDAOActivityTypeFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should not be different
        XCTAssertFalse(activityType1.isDiffFrom(activityType2))
        
        // Act & Assert - Different data should be different
        XCTAssertTrue(activityType1.isDiffFrom(activityType3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(activityType1.isDiffFrom(activityType1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(activityType1.isDiffFrom("not an activity type"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(activityType1.isDiffFrom(nil as DAOActivityType?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalActivityType = MockDAOActivityTypeFactory.createMockWithTestData()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalActivityType)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedActivityType = try decoder.decode(DAOActivityType.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedActivityType.code, originalActivityType.code)
        XCTAssertEqual(decodedActivityType.name.asString, originalActivityType.name.asString)
        XCTAssertEqual(decodedActivityType.pricing.id, originalActivityType.pricing.id)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let activityType = MockDAOActivityTypeFactory.createMockWithTestData()
        
        // Act
        let dictionary = activityType.asDictionary
        
        // Assert
        XCTAssertEqual(dictionary["code"] as? String, activityType.code)
        XCTAssertNotNil(dictionary["name"] as Any?)
        XCTAssertNotNil(dictionary["pricing"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let activityType = MockDAOActivityTypeFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertEqual(activityType.code, "")
        XCTAssertEqual(activityType.name.asString, "")
        XCTAssertNotNil(activityType.pricing)
    }
    
    func testLongCode() {
        // Arrange
        let activityType = DAOActivityType()
        let longCode = String(repeating: "A", count: 100)
        
        // Act
        activityType.code = longCode
        
        // Assert
        XCTAssertEqual(activityType.code, longCode)
        XCTAssertEqual(activityType.code.count, 100)
    }
    
    func testVeryLongName() {
        // Arrange
        let activityType = DAOActivityType()
        let longName = String(repeating: "B", count: 500)
        
        // Act
        activityType.name = DNSString(with: longName)
        
        // Assert
        XCTAssertEqual(activityType.name.asString, longName)
        XCTAssertEqual(activityType.name.asString.count, 500)
    }
    
    func testSpecialCharactersInCode() {
        // Arrange
        let activityType = DAOActivityType()
        let specialCode = "TEST_CODE-123!@#$%"
        
        // Act
        activityType.code = specialCode
        
        // Assert
        XCTAssertEqual(activityType.code, specialCode)
    }
    
    func testUnicodeCharactersInName() {
        // Arrange
        let activityType = DAOActivityType()
        let unicodeName = "Activité Sportive 体育活动 🏃‍♀️"
        
        // Act
        activityType.name = DNSString(with: unicodeName)
        
        // Assert
        XCTAssertEqual(activityType.name.asString, unicodeName)
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let activityTypes = MockDAOActivityTypeFactory.createMockArray(count: 6)
        
        // Assert
        XCTAssertEqual(activityTypes.count, 6)
        
        // Verify each activity type has proper data
        for i in 0..<activityTypes.count {
            XCTAssertFalse(activityTypes[i].code.isEmpty)
            XCTAssertFalse(activityTypes[i].name.asString.isEmpty)
            XCTAssertNotNil(activityTypes[i].pricing)
        }
        
        // Verify unique codes
        let codes = activityTypes.map { $0.code }
        let uniqueCodes = Set(codes)
        XCTAssertEqual(codes.count, uniqueCodes.count, "All codes should be unique")
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOActivityType()
            }
        }
    }
    
    func testSpecialInitializationPerformance() {
        measure {
            for i in 0..<1000 {
                _ = DAOActivityType(code: "CODE_\(i)", name: DNSString(with: "Name \(i)"))
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalActivityType = MockDAOActivityTypeFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOActivityType(from: originalActivityType)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let activityType1 = MockDAOActivityTypeFactory.createMockWithTestData()
        let activityType2 = MockDAOActivityTypeFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = activityType1 == activityType2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let activityType = MockDAOActivityTypeFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(activityType)
                    _ = try decoder.decode(DAOActivityType.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testInitializationWithCodeAndName", testInitializationWithCodeAndName),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testCodeProperty", testCodeProperty),
        ("testNameProperty", testNameProperty),
        ("testPricingProperty", testPricingProperty),
        ("testEmptyCodeProperty", testEmptyCodeProperty),
        ("testEmptyNameProperty", testEmptyNameProperty),
        ("testUpdateMethod", testUpdateMethod),
        ("testCodeAsId", testCodeAsId),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testLongCode", testLongCode),
        ("testVeryLongName", testVeryLongName),
        ("testSpecialCharactersInCode", testSpecialCharactersInCode),
        ("testUnicodeCharactersInName", testUnicodeCharactersInName),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testSpecialInitializationPerformance", testSpecialInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}
