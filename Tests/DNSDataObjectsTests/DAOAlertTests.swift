//
//  DAOAlertTests.swift
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

final class DAOAlertTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let alert = DAOAlert()
        
        // Assert
        XCTAssertEqual(alert.endTime, DAOAlert.C.defaultEndTime)
        XCTAssertEqual(alert.imageUrl, DNSURL())
        XCTAssertEqual(alert.name, "")
        XCTAssertEqual(alert.priority, DNSPriority.normal)
        XCTAssertEqual(alert.scope, .all)
        XCTAssertEqual(alert.startTime, DAOAlert.C.defaultStartTime)
        XCTAssertEqual(alert.status, .tempClosed)
        XCTAssertEqual(alert.tagLine, DNSString())
        XCTAssertEqual(alert.title, DNSString())
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "test-alert-123"
        
        // Act
        let alert = DAOAlert(id: testId)
        
        // Assert
        XCTAssertEqual(alert.id, testId)
        XCTAssertEqual(alert.endTime, DAOAlert.C.defaultEndTime)
        XCTAssertEqual(alert.imageUrl, DNSURL())
        XCTAssertEqual(alert.name, "")
        XCTAssertEqual(alert.priority, DNSPriority.normal)
        XCTAssertEqual(alert.scope, .all)
        XCTAssertEqual(alert.startTime, DAOAlert.C.defaultStartTime)
        XCTAssertEqual(alert.status, .tempClosed)
        XCTAssertEqual(alert.tagLine, DNSString())
        XCTAssertEqual(alert.title, DNSString())
    }
    
    func testInitializationWithParameters() {
        // Arrange
        let status = DNSStatus.open
        let title = DNSString(with: "Test Alert")
        let tagLine = DNSString(with: "Test Tag Line")
        let startTime = Date()
        let endTime = Date().addingTimeInterval(86400)
        
        // Act
        let alert = DAOAlert(status: status, title: title, tagLine: tagLine, startTime: startTime, endTime: endTime)
        
        // Assert
        XCTAssertEqual(alert.status, status)
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.tagLine, tagLine)
        XCTAssertEqual(alert.startTime, startTime)
        XCTAssertEqual(alert.endTime, endTime)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalAlert = MockDAOAlertFactory.createSafeAlert()
        
        // Act
        let copiedAlert = DAOAlert(from: originalAlert)
        
        // Assert
        XCTAssertEqual(copiedAlert.endTime, originalAlert.endTime)
        XCTAssertEqual(copiedAlert.imageUrl, originalAlert.imageUrl)
        XCTAssertEqual(copiedAlert.name, originalAlert.name)
        XCTAssertEqual(copiedAlert.priority, originalAlert.priority)
        XCTAssertEqual(copiedAlert.scope, originalAlert.scope)
        XCTAssertEqual(copiedAlert.startTime, originalAlert.startTime)
        XCTAssertEqual(copiedAlert.status, originalAlert.status)
        XCTAssertEqual(copiedAlert.tagLine.asString, originalAlert.tagLine.asString)
        XCTAssertEqual(copiedAlert.title.asString, originalAlert.title.asString)
        XCTAssertFalse(copiedAlert === originalAlert) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "endTime": Date().addingTimeInterval(86400),
            "imageUrl": "https://example.com/alert.png",
            "name": "test-alert",
            "priority": DNSPriority.high,
            "scope": DNSScope.place.rawValue,
            "startTime": Date(),
            "status": DNSStatus.open.rawValue,
            "tagLine": ["": "Test tag line"],   // with empty language (should default)
            "title": ["": "Test Alert"] // with empty language (should default)
        ]
        
        // Act
        let alert = DAOAlert(from: testData)
        
        // Assert
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.name, "test-alert")
        XCTAssertEqual(alert?.priority, DNSPriority.high)
        XCTAssertEqual(alert?.scope, .place)
        XCTAssertEqual(alert?.status, .open)
        XCTAssertEqual(alert?.tagLine.asString, "Test tag line")
        XCTAssertEqual(alert?.title.asString, "Test Alert")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let alert = DAOAlert(from: emptyData)
        
        // Assert
        XCTAssertNil(alert)
    }
    
    // MARK: - Property Tests
    
    func testEndTimeProperty() {
        // Arrange
        let alert = DAOAlert()
        let newEndTime = Date().addingTimeInterval(172800) // 2 days
        
        // Act
        alert.endTime = newEndTime
        
        // Assert
        XCTAssertEqual(alert.endTime, newEndTime)
    }
    
    func testImageUrlProperty() {
        // Arrange
        let alert = DAOAlert()
        let testUrl = DNSURL(with: URL(string: "https://example.com/new-alert.png"))
        
        // Act
        alert.imageUrl = testUrl
        
        // Assert
        XCTAssertEqual(alert.imageUrl, testUrl)
    }
    
    func testNameProperty() {
        // Arrange
        let alert = DAOAlert()
        let testName = "updated-alert-name"
        
        // Act
        alert.name = testName
        
        // Assert
        XCTAssertEqual(alert.name, testName)
    }
    
    func testPriorityProperty() {
        // Arrange
        let alert = DAOAlert()
        
        // Act & Assert - Normal priority
        alert.priority = DNSPriority.normal
        XCTAssertEqual(alert.priority, DNSPriority.normal)
        
        // Act & Assert - High priority
        alert.priority = DNSPriority.high
        XCTAssertEqual(alert.priority, DNSPriority.high)
    }
    
    func testScopeProperty() {
        // Arrange
        let alert = DAOAlert()
        
        // Act & Assert - Place scope
        alert.scope = .place
        XCTAssertEqual(alert.scope, .place)
        
        // Act & Assert - District scope
        alert.scope = .district
        XCTAssertEqual(alert.scope, .district)
    }
    
    func testStartTimeProperty() {
        // Arrange
        let alert = DAOAlert()
        let newStartTime = Date().addingTimeInterval(-3600) // 1 hour ago
        
        // Act
        alert.startTime = newStartTime
        
        // Assert
        XCTAssertEqual(alert.startTime, newStartTime)
    }
    
    func testStatusProperty() {
        // Arrange
        let alert = DAOAlert()
        
        // Act & Assert - Open status
        alert.status = .open
        XCTAssertEqual(alert.status, .open)
        
        // Act & Assert - Closed status
        alert.status = .closed
        XCTAssertEqual(alert.status, .closed)
    }
    
    func testTagLineProperty() {
        // Arrange
        let alert = DAOAlert()
        let testTagLine = DNSString(with: "Updated tag line")
        
        // Act
        alert.tagLine = testTagLine
        
        // Assert
        XCTAssertEqual(alert.tagLine, testTagLine)
    }
    
    func testTitleProperty() {
        // Arrange
        let alert = DAOAlert()
        let testTitle = DNSString(with: "Updated Alert Title")
        
        // Act
        alert.title = testTitle
        
        // Assert
        XCTAssertEqual(alert.title, testTitle)
    }
    
    // MARK: - Business Logic Tests
    
    func testPriorityValidationUpperBound() {
        // Arrange
        let alert = DAOAlert()
        
        // Act - Set priority above maximum
        alert.priority = DNSPriority.highest + 100
        
        // Assert - Should clamp to highest
        XCTAssertEqual(alert.priority, DNSPriority.highest)
    }
    
    func testPriorityValidationLowerBound() {
        // Arrange
        let alert = DAOAlert()
        
        // Act - Set priority below minimum
        alert.priority = DNSPriority.none - 100
        
        // Assert - Should clamp to none
        XCTAssertEqual(alert.priority, DNSPriority.none)
    }
    
    func testPriorityValidationWithinRange() {
        // Arrange
        let alert = DAOAlert()
        
        // Act - Set valid priorities
        let validPriorities = [DNSPriority.none, DNSPriority.low, DNSPriority.normal, DNSPriority.high, DNSPriority.highest]
        
        for validPriority in validPriorities {
            alert.priority = validPriority
            // Assert
            XCTAssertEqual(alert.priority, validPriority, "Priority validation failed for \(validPriority)")
        }
    }
    
    func testUpdateMethod() {
        // Arrange
        let originalAlert = MockDAOAlertFactory.createMinimalAlert()
        let sourceAlert = MockDAOAlertFactory.createSafeAlertForCopy()
        
        // Act
        originalAlert.update(from: sourceAlert)
        
        // Assert
        XCTAssertEqual(originalAlert.endTime, sourceAlert.endTime)
        XCTAssertEqual(originalAlert.imageUrl, sourceAlert.imageUrl)
        XCTAssertEqual(originalAlert.name, sourceAlert.name)
        XCTAssertEqual(originalAlert.priority, sourceAlert.priority)
        XCTAssertEqual(originalAlert.scope, sourceAlert.scope)
        XCTAssertEqual(originalAlert.startTime, sourceAlert.startTime)
        XCTAssertEqual(originalAlert.status, sourceAlert.status)
        XCTAssertEqual(originalAlert.tagLine.asString, sourceAlert.tagLine.asString)
        XCTAssertEqual(originalAlert.title.asString, sourceAlert.title.asString)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalAlert = MockDAOAlertFactory.createSafeAlert()
        
        // Act
        let copiedAlert = originalAlert.copy() as? DAOAlert
        
        // Assert
        XCTAssertNotNil(copiedAlert)
        XCTAssertEqual(copiedAlert?.endTime, originalAlert.endTime)
        XCTAssertEqual(copiedAlert?.imageUrl, originalAlert.imageUrl)
        XCTAssertEqual(copiedAlert?.name, originalAlert.name)
        XCTAssertEqual(copiedAlert?.priority, originalAlert.priority)
        XCTAssertEqual(copiedAlert?.scope, originalAlert.scope)
        XCTAssertEqual(copiedAlert?.startTime, originalAlert.startTime)
        XCTAssertEqual(copiedAlert?.status, originalAlert.status)
        XCTAssertEqual(copiedAlert?.tagLine.asString, originalAlert.tagLine.asString)
        XCTAssertEqual(copiedAlert?.title.asString, originalAlert.title.asString)
        XCTAssertFalse(copiedAlert === originalAlert) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let alert1 = MockDAOAlertFactory.createTypicalAlert()
        let alert2 = MockDAOAlertFactory.createTypicalAlert()
        let alert3 = MockDAOAlertFactory.createCompleteAlert()
        
        // Act & Assert - Same data should be equal
        XCTAssertEqual(alert1.name, alert2.name, "Alerts should have same name")
        XCTAssertEqual(alert1.status, alert2.status, "Alerts should have same status")
        XCTAssertEqual(alert1.priority, alert2.priority, "Alerts should have same priority")
        
        // Act & Assert - Different data should not be equal  
        XCTAssertNotEqual(alert1.name, alert3.name, "Different alerts should have different names")
        XCTAssertNotEqual(alert1.priority, alert3.priority, "Different alerts should have different priorities")
        
        // Act & Assert - Same instance should be equal
        XCTAssertTrue(alert1 == alert1)
        XCTAssertFalse(alert1 != alert1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let alert1 = MockDAOAlertFactory.createSafeAlert()
        let alert2 = MockDAOAlertFactory.createSafeAlert()
        let alert3 = MockDAOAlertFactory.createSafeAlertForCopy() // Different safe alert
        
        // Act & Assert - Different objects with same data should be considered different (based on object identity)
        XCTAssertTrue(alert1.isDiffFrom(alert2))
        
        // Act & Assert - Different data should definitely be different
        XCTAssertTrue(alert1.isDiffFrom(alert3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(alert1.isDiffFrom(alert1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(alert1.isDiffFrom("not an alert"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(alert1.isDiffFrom(nil as DAOAlert?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalAlert = MockDAOAlertFactory.createSafeAlert()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalAlert)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedAlert = try decoder.decode(DAOAlert.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedAlert.endTime.timeIntervalSince1970, originalAlert.endTime.timeIntervalSince1970, accuracy: 1.0)
        XCTAssertEqual(decodedAlert.imageUrl.asURL, originalAlert.imageUrl.asURL)
        XCTAssertEqual(decodedAlert.name, originalAlert.name)
        XCTAssertEqual(decodedAlert.priority, originalAlert.priority)
        XCTAssertEqual(decodedAlert.scope, originalAlert.scope)
        XCTAssertEqual(decodedAlert.startTime.timeIntervalSince1970, originalAlert.startTime.timeIntervalSince1970, accuracy: 1.0)
        XCTAssertEqual(decodedAlert.status, originalAlert.status)
        XCTAssertEqual(decodedAlert.tagLine.asString, originalAlert.tagLine.asString)
        XCTAssertEqual(decodedAlert.title.asString, originalAlert.title.asString)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let alert = MockDAOAlertFactory.createSafeAlert()
        
        // Act
        let dictionary = alert.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["endTime"] as Any?)
        XCTAssertNotNil(dictionary["imageUrl"] as Any?)
        XCTAssertEqual(dictionary["name"] as? String, alert.name)
        XCTAssertEqual(dictionary["priority"] as? Int, alert.priority)
        XCTAssertEqual(dictionary["scope"] as? Int, alert.scope.rawValue)
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertEqual(dictionary["status"] as? String, alert.status.rawValue)
        XCTAssertNotNil(dictionary["tagLine"] as Any?)
        XCTAssertNotNil(dictionary["title"] as Any?)
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOAlert()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalAlert = MockDAOAlertFactory.createSafeAlert()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOAlert(from: originalAlert)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let alert1 = MockDAOAlertFactory.createSafeAlert()
        let alert2 = MockDAOAlertFactory.createSafeAlert()
        
        measure {
            for _ in 0..<1000 {
                _ = alert1 == alert2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let alert = MockDAOAlertFactory.createSafeAlert()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(alert)
                    _ = try decoder.decode(DAOAlert.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
}
