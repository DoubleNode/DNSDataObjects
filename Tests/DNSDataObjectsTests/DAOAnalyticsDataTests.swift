//
//  DAOAnalyticsDataTests.swift
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

final class DAOAnalyticsDataTests: XCTestCase {
    private var mockFactory: MockDAOAnalyticsDataFactory!
    
    override func setUp() {
        super.setUp()
        mockFactory = DefaultMockDAOAnalyticsDataFactory()
    }
    
    override func tearDown() {
        mockFactory = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let analyticsData = DAOAnalyticsData()
        
        // Assert
        XCTAssertEqual(analyticsData.data, [])
        XCTAssertEqual(analyticsData.title, "")
        XCTAssertEqual(analyticsData.subtitle, "")
        XCTAssertEqual(analyticsData.titleDNS, DNSString())
        XCTAssertEqual(analyticsData.subtitleDNS, DNSString())
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "analytics-data-123"
        
        // Act
        let analyticsData = DAOAnalyticsData(id: testId)
        
        // Assert
        XCTAssertEqual(analyticsData.id, testId)
        XCTAssertEqual(analyticsData.data, [])
        XCTAssertEqual(analyticsData.title, "")
        XCTAssertEqual(analyticsData.subtitle, "")
        XCTAssertEqual(analyticsData.titleDNS, DNSString())
        XCTAssertEqual(analyticsData.subtitleDNS, DNSString())
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalAnalyticsData = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        
        // Act
        let copiedAnalyticsData = DAOAnalyticsData(from: originalAnalyticsData)
        
        // Assert
        XCTAssertEqual(copiedAnalyticsData.data.count, originalAnalyticsData.data.count)
        XCTAssertEqual(copiedAnalyticsData.title, originalAnalyticsData.title)
        XCTAssertEqual(copiedAnalyticsData.subtitle, originalAnalyticsData.subtitle)
        XCTAssertEqual(copiedAnalyticsData.titleDNS, originalAnalyticsData.titleDNS)
        XCTAssertEqual(copiedAnalyticsData.subtitleDNS, originalAnalyticsData.subtitleDNS)
        XCTAssertFalse(copiedAnalyticsData === originalAnalyticsData) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "data": [
                [
                    "category": "users",
                    "value": 1000.0,
                    "label": "Active Users"
                ]
            ],
            "subtitle": ["": "Test Subtitle"],
            "title": ["": "Test Analytics Data"]
        ]
        
        // Act
        let analyticsData = DAOAnalyticsData(from: testData)
        
        // Assert
        XCTAssertNotNil(analyticsData)
        XCTAssertEqual(analyticsData?.data.count, 1)
        XCTAssertEqual(analyticsData?.title, "Test Analytics Data")
        XCTAssertEqual(analyticsData?.subtitle, "Test Subtitle")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let analyticsData = DAOAnalyticsData(from: emptyData)
        
        // Assert
        XCTAssertNil(analyticsData)
    }
    
    // MARK: - Property Tests
    
    func testDataProperty() {
        // Arrange
        let analyticsData = DAOAnalyticsData()
        let testData = [MockDAOAnalyticsDataFactory.createAnalyticsNumbers()]
        
        // Act
        analyticsData.data = testData
        
        // Assert
        XCTAssertEqual(analyticsData.data.count, 1)
        XCTAssertEqual(analyticsData.data.first?.total, testData.first?.total)
    }
    
    func testTitleProperty() {
        // Arrange
        let analyticsData = DAOAnalyticsData()
        let testTitle = "Updated Analytics Title"
        
        // Act
        analyticsData.title = testTitle
        
        // Assert
        XCTAssertEqual(analyticsData.title, testTitle)
        XCTAssertEqual(analyticsData.titleDNS.asString, testTitle)
    }
    
    func testSubtitleProperty() {
        // Arrange
        let analyticsData = DAOAnalyticsData()
        let testSubtitle = "Updated Analytics Subtitle"
        
        // Act
        analyticsData.subtitle = testSubtitle
        
        // Assert
        XCTAssertEqual(analyticsData.subtitle, testSubtitle)
        XCTAssertEqual(analyticsData.subtitleDNS.asString, testSubtitle)
    }
    
    func testTitleDNSProperty() {
        // Arrange
        let analyticsData = DAOAnalyticsData()
        let testTitleDNS = DNSString(with: "DNS Title")
        
        // Act
        analyticsData.titleDNS = testTitleDNS
        
        // Assert
        XCTAssertEqual(analyticsData.titleDNS, testTitleDNS)
        XCTAssertEqual(analyticsData.title, testTitleDNS.asString)
    }
    
    func testSubtitleDNSProperty() {
        // Arrange
        let analyticsData = DAOAnalyticsData()
        let testSubtitleDNS = DNSString(with: "DNS Subtitle")
        
        // Act
        analyticsData.subtitleDNS = testSubtitleDNS
        
        // Assert
        XCTAssertEqual(analyticsData.subtitleDNS, testSubtitleDNS)
        XCTAssertEqual(analyticsData.subtitle, testSubtitleDNS.asString)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalAnalyticsData = MockDAOAnalyticsDataFactory.createMinimalAnalyticsData()
        let sourceAnalyticsData = MockDAOAnalyticsDataFactory.createSafeAnalyticsDataForCopy()
        
        // Act
        originalAnalyticsData.update(from: sourceAnalyticsData)
        
        // Assert
        XCTAssertEqual(originalAnalyticsData.data.count, sourceAnalyticsData.data.count)
        XCTAssertEqual(originalAnalyticsData.title, sourceAnalyticsData.title)
        XCTAssertEqual(originalAnalyticsData.subtitle, sourceAnalyticsData.subtitle)
        XCTAssertEqual(originalAnalyticsData.titleDNS, sourceAnalyticsData.titleDNS)
        XCTAssertEqual(originalAnalyticsData.subtitleDNS, sourceAnalyticsData.subtitleDNS)
    }
    
    func testDataArrayManipulation() {
        // Arrange
        let analyticsData = DAOAnalyticsData()
        let firstData = MockDAOAnalyticsDataFactory.createAnalyticsNumbers()
        
        // Act - Add first data
        analyticsData.data.append(firstData)
        
        // Assert
        XCTAssertEqual(analyticsData.data.count, 1)
        XCTAssertEqual(analyticsData.data.first?.total, firstData.total)
        
        // Act - Add second data
        let secondData = DNSAnalyticsNumbers(android: 2000.0, iOS: 3000.0, total: 5000.0)
        analyticsData.data.append(secondData)
        
        // Assert
        XCTAssertEqual(analyticsData.data.count, 2)
        XCTAssertEqual(analyticsData.data.last?.total, secondData.total)
        
        // Act - Remove first data
        analyticsData.data.removeFirst()
        
        // Assert
        XCTAssertEqual(analyticsData.data.count, 1)
        XCTAssertEqual(analyticsData.data.first?.total, secondData.total)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalAnalyticsData = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        
        // Act
        let copiedAnalyticsData = originalAnalyticsData.copy() as? DAOAnalyticsData
        
        // Assert
        XCTAssertNotNil(copiedAnalyticsData)
        XCTAssertEqual(copiedAnalyticsData?.data.count, originalAnalyticsData.data.count)
        XCTAssertEqual(copiedAnalyticsData?.title, originalAnalyticsData.title)
        XCTAssertEqual(copiedAnalyticsData?.subtitle, originalAnalyticsData.subtitle)
        XCTAssertEqual(copiedAnalyticsData?.titleDNS, originalAnalyticsData.titleDNS)
        XCTAssertEqual(copiedAnalyticsData?.subtitleDNS, originalAnalyticsData.subtitleDNS)
        XCTAssertFalse(copiedAnalyticsData === originalAnalyticsData) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let analyticsData1 = MockDAOAnalyticsDataFactory.createTypicalAnalyticsData()
        let analyticsData2 = MockDAOAnalyticsDataFactory.createTypicalAnalyticsData()
        let analyticsData3 = MockDAOAnalyticsDataFactory.createCompleteAnalyticsData()
        
        // Act & Assert - Same data should be equal
        XCTAssertEqual(analyticsData1.title, analyticsData2.title, "Analytics should have same title")
        XCTAssertEqual(analyticsData1.subtitle, analyticsData2.subtitle, "Analytics should have same subtitle")
        XCTAssertEqual(analyticsData1.data.count, analyticsData2.data.count, "Analytics should have same data count")
        
        // Act & Assert - Different data should not be equal  
        XCTAssertNotEqual(analyticsData1.title, analyticsData3.title, "Different analytics should have different titles")
        XCTAssertNotEqual(analyticsData1.subtitle, analyticsData3.subtitle, "Different analytics should have different subtitles")
        
        // Act & Assert - Same instance should be equal
        XCTAssertTrue(analyticsData1 == analyticsData1)
        XCTAssertFalse(analyticsData1 != analyticsData1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let analyticsData1 = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        let analyticsData2 = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        let analyticsData3 = MockDAOAnalyticsDataFactory.createSafeAnalyticsDataForCopy()
        
        // Act & Assert - Different objects with same data should be considered different (based on object identity)
        XCTAssertTrue(analyticsData1.isDiffFrom(analyticsData2))
        
        // Act & Assert - Different data should definitely be different
        XCTAssertTrue(analyticsData1.isDiffFrom(analyticsData3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(analyticsData1.isDiffFrom(analyticsData1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(analyticsData1.isDiffFrom("not analytics data"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(analyticsData1.isDiffFrom(nil as DAOAnalyticsData?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalAnalyticsData = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalAnalyticsData)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedAnalyticsData = try decoder.decode(DAOAnalyticsData.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedAnalyticsData.data.count, originalAnalyticsData.data.count)
        XCTAssertEqual(decodedAnalyticsData.title, originalAnalyticsData.title)
        XCTAssertEqual(decodedAnalyticsData.subtitle, originalAnalyticsData.subtitle)
        XCTAssertEqual(decodedAnalyticsData.titleDNS.asString, originalAnalyticsData.titleDNS.asString)
        XCTAssertEqual(decodedAnalyticsData.subtitleDNS.asString, originalAnalyticsData.subtitleDNS.asString)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let analyticsData = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        
        // Act
        let dictionary = analyticsData.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["data"] as Any?)
        XCTAssertNotNil(dictionary["subtitle"] as Any?)
        XCTAssertNotNil(dictionary["title"] as Any?)
        
        // Verify data array structure
        if let dataArray = dictionary["data"] as? [DNSDataDictionary] {
            XCTAssertEqual(dataArray.count, analyticsData.data.count)
        } else {
            XCTFail("Data array not properly serialized")
        }
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOAnalyticsData()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalAnalyticsData = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOAnalyticsData(from: originalAnalyticsData)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let analyticsData1 = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        let analyticsData2 = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        
        measure {
            for _ in 0..<1000 {
                _ = analyticsData1 == analyticsData2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let analyticsData = MockDAOAnalyticsDataFactory.createSafeAnalyticsData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(analyticsData)
                    _ = try decoder.decode(DAOAnalyticsData.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
    
    func testDataArrayPerformance() {
        // Arrange
        let analyticsData = DAOAnalyticsData()
        
        measure {
            for i in 0..<100 {
                let dataItem = DNSAnalyticsNumbers(android: Double(i), iOS: Double(i*2), total: Double(i*3))
                analyticsData.data.append(dataItem)
            }
            analyticsData.data.removeAll()
        }
    }
}
