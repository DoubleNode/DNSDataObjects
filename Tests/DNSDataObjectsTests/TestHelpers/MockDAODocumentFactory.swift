//
//  MockDAODocumentFactory.swift
//  DNSDataObjects Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAODocumentFactory -
struct MockDAODocumentFactory: MockDAOFactory {
    typealias DAOType = DAODocument
    
    static func createMock() -> DAODocument {
        let document = DAODocument()
        document.title = DNSString(with: "Test Document")
        return document
    }
    
    static func createMockWithTestData() -> DAODocument {
        let document = DAODocument(id: "doc_typical_123")
        document.priority = DNSPriority.normal
        document.title = DNSString(with: "User Manual")
        document.url = DNSURL(with: URL(string: "https://docs.example.com/manual.pdf"))
        // Ensure consistent metadata for equality tests
        let fixedDate = Date(timeIntervalSince1970: 1609459200) // Fixed timestamp
        document.meta.created = fixedDate
        document.meta.updated = fixedDate
        return document
    }
    
    static func createMockWithEdgeCases() -> DAODocument {
        let document = DAODocument(id: "doc_complete_456")
        document.priority = DNSPriority.high
        document.title = DNSString(with: "Critical Security Documentation")
        document.url = DNSURL(with: URL(string: "https://secure.example.com/security-docs.pdf"))
        return document
    }
    
    static func createMockArray(count: Int) -> [DAODocument] {
        return (0..<count).map { i in
            let document = DAODocument()
            document.id = "document\(i)" // Set explicit ID to match test expectations
            document.title = DNSString(with: "Document \(i)")
            document.priority = i % 2 == 0 ? DNSPriority.normal : DNSPriority.high
            document.url = DNSURL(with: URL(string: "https://example.com/doc\(i).pdf"))
            return document
        }
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAODocument {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAODocument {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAODocument {
        let document = createMockWithTestData()
        document.id = id
        return document
    }
    
    // Test-specific method aliases expected by DAODocumentTests
    static func createCompleteDocument() -> DAODocument {
        // Use createMockWithEdgeCases() to ensure different data from createTypicalDocument()
        return createMockWithEdgeCases()
    }
    
    static func createMinimalDocument() -> DAODocument {
        return createMock()
    }
    
    static func createTypicalDocument() -> DAODocument {
        return createMockWithTestData()
    }
}

// Type alias for backward compatibility with tests
typealias DefaultMockDAODocumentFactory = MockDAODocumentFactory