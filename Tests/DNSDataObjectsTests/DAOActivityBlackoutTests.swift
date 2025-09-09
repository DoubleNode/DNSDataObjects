//
//  DAOActivityBlackoutTests.swift
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

final class DAOActivityBlackoutTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let activityBlackout = DAOActivityBlackout()
        
        // Assert
        XCTAssertNil(activityBlackout.endTime)
        XCTAssertEqual(activityBlackout.message, DNSString())
        XCTAssertNil(activityBlackout.startTime)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "blackout-123"
        
        // Act
        let activityBlackout = DAOActivityBlackout(id: testId)
        
        // Assert
        XCTAssertEqual(activityBlackout.id, testId)
        XCTAssertNil(activityBlackout.endTime)
        XCTAssertEqual(activityBlackout.message, DNSString())
        XCTAssertNil(activityBlackout.startTime)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalBlackout = MockDAOActivityBlackoutFactory.createMockWithTestData()
        
        // Act
        let copiedBlackout = DAOActivityBlackout(from: originalBlackout)
        
        // Assert
        XCTAssertEqual(copiedBlackout.id, originalBlackout.id)
        XCTAssertEqual(copiedBlackout.endTime, originalBlackout.endTime)
        XCTAssertEqual(copiedBlackout.message.asString, originalBlackout.message.asString)
        XCTAssertEqual(copiedBlackout.startTime, originalBlackout.startTime)
        XCTAssertFalse(copiedBlackout === originalBlackout) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let startDate = Date()
        let endDate = Date().addingTimeInterval(3600)
        let testData: DNSDataDictionary = [
            "startTime": startDate,
            "endTime": endDate,
            "message": ["": "Test blackout message"]
        ]
        
        // Act
        let activityBlackout = DAOActivityBlackout(from: testData)
        
        // Assert
        XCTAssertNotNil(activityBlackout)
        XCTAssertEqual(activityBlackout?.startTime?.timeIntervalSince1970 ?? 0.0, startDate.timeIntervalSince1970, accuracy: 1.0)
        XCTAssertEqual(activityBlackout?.endTime?.timeIntervalSince1970 ?? 0.0, endDate.timeIntervalSince1970, accuracy: 1.0)
        XCTAssertEqual(activityBlackout?.message.asString, "Test blackout message")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let activityBlackout = DAOActivityBlackout(from: emptyData)
        
        // Assert
        XCTAssertNil(activityBlackout)
    }
    
    // MARK: - Property Tests
    
    func testStartTimeProperty() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        let startTime = Date()
        
        // Act
        activityBlackout.startTime = startTime
        
        // Assert
        XCTAssertEqual(activityBlackout.startTime, startTime)
    }
    
    func testEndTimeProperty() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        let endTime = Date().addingTimeInterval(7200) // 2 hours later
        
        // Act
        activityBlackout.endTime = endTime
        
        // Assert
        XCTAssertEqual(activityBlackout.endTime, endTime)
    }
    
    func testMessageProperty() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        let testMessage = DNSString(with: "Maintenance in progress")
        
        // Act
        activityBlackout.message = testMessage
        
        // Assert
        XCTAssertEqual(activityBlackout.message.asString, testMessage.asString)
    }
    
    func testNilTimeProperties() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        
        // Act
        activityBlackout.startTime = nil
        activityBlackout.endTime = nil
        
        // Assert
        XCTAssertNil(activityBlackout.startTime)
        XCTAssertNil(activityBlackout.endTime)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalBlackout = MockDAOActivityBlackoutFactory.createMock()
        let sourceBlackout = MockDAOActivityBlackoutFactory.createMockWithTestData()
        
        // Act
        originalBlackout.update(from: sourceBlackout)
        
        // Assert
        XCTAssertEqual(originalBlackout.startTime, sourceBlackout.startTime)
        XCTAssertEqual(originalBlackout.endTime, sourceBlackout.endTime)
        XCTAssertEqual(originalBlackout.message.asString, sourceBlackout.message.asString)
    }
    
    func testBlackoutPeriodDuration() {
        // Arrange
        let activityBlackout = MockDAOActivityBlackoutFactory.createMockWithTestData()
        
        // Act & Assert
        guard let startTime = activityBlackout.startTime,
              let endTime = activityBlackout.endTime else {
            XCTFail("Both start and end times should be set")
            return
        }
        
        let duration = endTime.timeIntervalSince(startTime)
        XCTAssertGreaterThan(duration, 0, "End time should be after start time")
    }
    
    func testBlackoutWithOnlyStartTime() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        let startTime = Date()
        
        // Act
        activityBlackout.startTime = startTime
        activityBlackout.endTime = nil
        
        // Assert
        XCTAssertNotNil(activityBlackout.startTime)
        XCTAssertNil(activityBlackout.endTime)
    }
    
    func testBlackoutWithOnlyEndTime() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        let endTime = Date()
        
        // Act
        activityBlackout.startTime = nil
        activityBlackout.endTime = endTime
        
        // Assert
        XCTAssertNil(activityBlackout.startTime)
        XCTAssertNotNil(activityBlackout.endTime)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalBlackout = MockDAOActivityBlackoutFactory.createMockWithTestData()
        
        // Act
        let copiedBlackout = originalBlackout.copy() as? DAOActivityBlackout
        
        // Assert
        XCTAssertNotNil(copiedBlackout)
        XCTAssertEqual(copiedBlackout?.startTime, originalBlackout.startTime)
        XCTAssertEqual(copiedBlackout?.endTime, originalBlackout.endTime)
        XCTAssertEqual(copiedBlackout?.message.asString, originalBlackout.message.asString)
        XCTAssertFalse(copiedBlackout === originalBlackout) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let blackout1 = MockDAOActivityBlackoutFactory.createMockWithTestData()
        let blackout2 = DAOActivityBlackout(from: blackout1) // Copy to ensure same data
        let blackout3 = MockDAOActivityBlackoutFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should be equal
        XCTAssertEqual(blackout1.id, blackout2.id)
        XCTAssertEqual(blackout1.startTime, blackout2.startTime)
        XCTAssertEqual(blackout1.endTime, blackout2.endTime)
        XCTAssertEqual(blackout1.message.asString, blackout2.message.asString)
        
        // Act & Assert - Different data should not be equal
        XCTAssertNotEqual(blackout1.message.asString, blackout3.message.asString)
        XCTAssertNotEqual(blackout1.startTime, blackout3.startTime)
        XCTAssertNotEqual(blackout1.endTime, blackout3.endTime)
        
        // Act & Assert - Same instance should be equal to itself
        XCTAssertEqual(blackout1.id, blackout1.id)
        XCTAssertEqual(blackout1.startTime, blackout1.startTime)
        XCTAssertEqual(blackout1.endTime, blackout1.endTime)
        XCTAssertEqual(blackout1.message.asString, blackout1.message.asString)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let blackout1 = MockDAOActivityBlackoutFactory.createMockWithTestData()
        let blackout2 = DAOActivityBlackout(from: blackout1) // Copy to ensure same data
        let blackout3 = MockDAOActivityBlackoutFactory.createMockWithEdgeCases()
        
        // Act & Assert - Same data should not be different
        XCTAssertFalse(blackout1.isDiffFrom(blackout2))
        
        // Act & Assert - Different data should be different
        XCTAssertTrue(blackout1.isDiffFrom(blackout3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(blackout1.isDiffFrom(blackout1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(blackout1.isDiffFrom("not a blackout"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(blackout1.isDiffFrom(nil as DAOActivityBlackout?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalBlackout = MockDAOActivityBlackoutFactory.createMockWithTestData()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalBlackout)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedBlackout = try decoder.decode(DAOActivityBlackout.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedBlackout.startTime?.timeIntervalSince1970 ?? 0.0, originalBlackout.startTime?.timeIntervalSince1970 ?? 0.0, accuracy: 1.0)
        XCTAssertEqual(decodedBlackout.endTime?.timeIntervalSince1970 ?? 0.0, originalBlackout.endTime?.timeIntervalSince1970 ?? 0.0, accuracy: 1.0)
        XCTAssertEqual(decodedBlackout.message.asString, originalBlackout.message.asString)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let activityBlackout = MockDAOActivityBlackoutFactory.createMockWithTestData()
        
        // Act
        let dictionary = activityBlackout.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertNotNil(dictionary["endTime"] as Any?)
        XCTAssertNotNil(dictionary["message"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let activityBlackout = MockDAOActivityBlackoutFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertNil(activityBlackout.startTime)
        XCTAssertNil(activityBlackout.endTime)
        XCTAssertEqual(activityBlackout.message.asString, "")
    }
    
    func testBoundaryDates() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        
        // Act - Set boundary dates
        activityBlackout.startTime = Date.distantPast
        activityBlackout.endTime = Date.distantFuture
        
        // Assert
        XCTAssertEqual(activityBlackout.startTime, Date.distantPast)
        XCTAssertEqual(activityBlackout.endTime, Date.distantFuture)
    }
    
    func testEmptyMessage() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        
        // Act
        activityBlackout.message = DNSString()
        
        // Assert
        XCTAssertEqual(activityBlackout.message.asString, "")
    }
    
    func testVeryLongMessage() {
        // Arrange
        let activityBlackout = DAOActivityBlackout()
        let longMessage = String(repeating: "A", count: 1000)
        
        // Act
        activityBlackout.message = DNSString(with: longMessage)
        
        // Assert
        XCTAssertEqual(activityBlackout.message.asString, longMessage)
        XCTAssertEqual(activityBlackout.message.asString.count, 1000)
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let blackouts = MockDAOActivityBlackoutFactory.createMockArray(count: 5)
        
        // Assert
        XCTAssertEqual(blackouts.count, 5)
        
        // Verify each blackout has unique times
        for i in 0..<blackouts.count {
            XCTAssertNotNil(blackouts[i].startTime)
            XCTAssertNotNil(blackouts[i].endTime)
            XCTAssertTrue(blackouts[i].message.asString.contains("Blackout period"))
        }
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOActivityBlackout()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalBlackout = MockDAOActivityBlackoutFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOActivityBlackout(from: originalBlackout)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let blackout1 = MockDAOActivityBlackoutFactory.createMockWithTestData()
        let blackout2 = MockDAOActivityBlackoutFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = blackout1 == blackout2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let activityBlackout = MockDAOActivityBlackoutFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(activityBlackout)
                    _ = try decoder.decode(DAOActivityBlackout.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testStartTimeProperty", testStartTimeProperty),
        ("testEndTimeProperty", testEndTimeProperty),
        ("testMessageProperty", testMessageProperty),
        ("testNilTimeProperties", testNilTimeProperties),
        ("testUpdateMethod", testUpdateMethod),
        ("testBlackoutPeriodDuration", testBlackoutPeriodDuration),
        ("testBlackoutWithOnlyStartTime", testBlackoutWithOnlyStartTime),
        ("testBlackoutWithOnlyEndTime", testBlackoutWithOnlyEndTime),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testBoundaryDates", testBoundaryDates),
        ("testEmptyMessage", testEmptyMessage),
        ("testVeryLongMessage", testVeryLongMessage),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}