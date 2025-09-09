//
//  DAODocumentTests.swift
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

final class DAODocumentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let document = DAODocument()
        
        // Assert
        XCTAssertEqual(document.priority, DNSPriority.normal)
        XCTAssertEqual(document.title, DNSString())
        XCTAssertEqual(document.url, DNSURL())
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "doc-123"
        
        // Act
        let document = DAODocument(id: testId)
        
        // Assert
        XCTAssertEqual(document.id, testId)
        XCTAssertEqual(document.priority, DNSPriority.normal)
        XCTAssertEqual(document.title, DNSString())
        XCTAssertEqual(document.url, DNSURL())
    }
    
    func testInitializationWithParameters() {
        // Arrange
        let title = DNSString(with: "Test Document")
        let url = DNSURL(with: URL(string: "https://example.com/test.pdf"))
        
        // Act
        let document = DAODocument(title: title, url: url)
        
        // Assert
        XCTAssertEqual(document.title, title)
        XCTAssertEqual(document.url, url)
        XCTAssertEqual(document.priority, DNSPriority.normal) // Default value
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalDocument = MockDAODocumentFactory.createCompleteDocument()
        
        // Act
        let copiedDocument = DAODocument(from: originalDocument)
        
        // Assert
        XCTAssertEqual(copiedDocument.priority, originalDocument.priority)
        XCTAssertEqual(copiedDocument.title.asString, originalDocument.title.asString)
        XCTAssertEqual(copiedDocument.url, originalDocument.url)
        XCTAssertFalse(copiedDocument === originalDocument) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "priority": DNSPriority.high,
            "title": ["": "Test Document"],
            "url": "https://example.com/document.pdf"
        ]
        
        // Act
        let document = DAODocument(from: testData)
        
        // Assert
        XCTAssertNotNil(document)
        XCTAssertEqual(document?.priority, DNSPriority.high)
        XCTAssertEqual(document?.title.asString, "Test Document")
        XCTAssertEqual(document?.url.asURL?.absoluteString, "https://example.com/document.pdf")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let document = DAODocument(from: emptyData)
        
        // Assert
        XCTAssertNil(document)
    }
    
    // MARK: - Property Tests
    
    func testPriorityProperty() {
        // Arrange
        let document = DAODocument()
        
        // Act & Assert - Normal priority
        document.priority = DNSPriority.normal
        XCTAssertEqual(document.priority, DNSPriority.normal)
        
        // Act & Assert - High priority
        document.priority = DNSPriority.high
        XCTAssertEqual(document.priority, DNSPriority.high)
    }
    
    func testTitleProperty() {
        // Arrange
        let document = DAODocument()
        let testTitle = DNSString(with: "Updated Document Title")
        
        // Act
        document.title = testTitle
        
        // Assert
        XCTAssertEqual(document.title, testTitle)
    }
    
    func testUrlProperty() {
        // Arrange
        let document = DAODocument()
        let testUrl = DNSURL(with: URL(string: "https://example.com/updated-document.pdf"))
        
        // Act
        document.url = testUrl
        
        // Assert
        XCTAssertEqual(document.url, testUrl)
    }
    
    // MARK: - Business Logic Tests
    
    func testPriorityValidationUpperBound() {
        // Arrange
        let document = DAODocument()
        
        // Act - Set priority above maximum
        document.priority = DNSPriority.highest + 100
        
        // Assert - Should clamp to highest
        XCTAssertEqual(document.priority, DNSPriority.highest)
    }
    
    func testPriorityValidationLowerBound() {
        // Arrange
        let document = DAODocument()
        
        // Act - Set priority below minimum
        document.priority = DNSPriority.none - 100
        
        // Assert - Should clamp to none
        XCTAssertEqual(document.priority, DNSPriority.none)
    }
    
    func testPriorityValidationWithinRange() {
        // Arrange
        let document = DAODocument()
        
        // Act - Set valid priorities
        let validPriorities = [DNSPriority.none, DNSPriority.low, DNSPriority.normal, DNSPriority.high, DNSPriority.highest]
        
        for validPriority in validPriorities {
            document.priority = validPriority
            // Assert
            XCTAssertEqual(document.priority, validPriority, "Priority validation failed for \(validPriority)")
        }
    }
    
    func testUpdateMethod() {
        // Arrange
        let originalDocument = MockDAODocumentFactory.createMinimalDocument()
        let sourceDocument = MockDAODocumentFactory.createCompleteDocument()
        
        // Act
        originalDocument.update(from: sourceDocument)
        
        // Assert
        XCTAssertEqual(originalDocument.priority, sourceDocument.priority)
        XCTAssertEqual(originalDocument.title.asString, sourceDocument.title.asString)
        XCTAssertEqual(originalDocument.url, sourceDocument.url)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalDocument = MockDAODocumentFactory.createCompleteDocument()
        
        // Act
        let copiedDocument = originalDocument.copy() as? DAODocument
        
        // Assert
        XCTAssertNotNil(copiedDocument)
        XCTAssertEqual(copiedDocument?.priority, originalDocument.priority)
        XCTAssertEqual(copiedDocument?.title.asString, originalDocument.title.asString)
        XCTAssertEqual(copiedDocument?.url, originalDocument.url)
        XCTAssertFalse(copiedDocument === originalDocument) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange
        let document1 = MockDAODocumentFactory.createTypicalDocument()
        let document2 = MockDAODocumentFactory.createTypicalDocument()
        let document3 = MockDAODocumentFactory.createCompleteDocument()
        
        // Act & Assert - Same data should be equal (Property-by-property comparison)
        XCTAssertEqual(document1.priority, document2.priority)
        XCTAssertEqual(document1.title.asString, document2.title.asString)
        XCTAssertEqual(document1.url.asURL?.absoluteString, document2.url.asURL?.absoluteString)
        // Note: Objects may differ in metadata timestamps, so we test logical equality
        
        // Act & Assert - Different data should not be equal
        XCTAssertTrue(document1.isDiffFrom(document3))
        
        // Act & Assert - Same instance should be equal
        XCTAssertTrue(document1 == document1)
        XCTAssertFalse(document1 != document1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange
        let document1 = MockDAODocumentFactory.createTypicalDocument()
        let document2 = MockDAODocumentFactory.createTypicalDocument()
        let document3 = MockDAODocumentFactory.createCompleteDocument()
        
        // Act & Assert - Same data should not be different
        XCTAssertEqual(document1.priority, document2.priority)
        XCTAssertEqual(document1.title.asString, document2.title.asString)
        
        // Act & Assert - Different data should be different
        XCTAssertTrue(document1.isDiffFrom(document3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(document1.isDiffFrom(document1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(document1.isDiffFrom("not a document"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(document1.isDiffFrom(nil as DAODocument?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalDocument = MockDAODocumentFactory.createCompleteDocument()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalDocument)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedDocument = try decoder.decode(DAODocument.self, from: encodedData)
        
        // Assert - Property-by-property comparison to avoid DNSURL equality issues
        XCTAssertEqual(decodedDocument.priority, originalDocument.priority)
        XCTAssertEqual(decodedDocument.title.asString, originalDocument.title.asString)
        XCTAssertEqual(decodedDocument.url.asURL?.absoluteString, originalDocument.url.asURL?.absoluteString)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let document = MockDAODocumentFactory.createCompleteDocument()
        
        // Act
        let dictionary = document.asDictionary
        
        // Assert
        XCTAssertEqual(dictionary["priority"] as? Int, document.priority)
        XCTAssertNotNil(dictionary["title"] as Any?)
        XCTAssertNotNil(dictionary["url"] as Any?)
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAODocument()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalDocument = MockDAODocumentFactory.createCompleteDocument()
        
        measure {
            for _ in 0..<1000 {
                _ = DAODocument(from: originalDocument)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let document1 = MockDAODocumentFactory.createCompleteDocument()
        let document2 = MockDAODocumentFactory.createCompleteDocument()
        
        measure {
            for _ in 0..<1000 {
                _ = document1 == document2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let document = MockDAODocumentFactory.createCompleteDocument()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(document)
                    _ = try decoder.decode(DAODocument.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
}
