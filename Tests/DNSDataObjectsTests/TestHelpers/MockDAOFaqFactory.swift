//
//  MockDAOFaqFactory.swift
//  DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataObjects
import DNSDataTypes
import Foundation

// MARK: - MockDAOFaqFactory -
struct MockDAOFaqFactory: MockDAOFactory {
    typealias DAOType = DAOFaq
    
    static func createMock() -> DAOFaq {
        let dao = DAOFaq()
        dao.question = DNSString(with: "What is this FAQ about?")
        dao.answer = DNSString(with: "This is a test FAQ answer.")
        return dao
    }
    
    static func createMockWithTestData() -> DAOFaq {
        let dao = DAOFaq()
        dao.id = "faq_12345"
        
        // Create mock section
        dao.section = MockDAOFaqSectionFactory.createMock()
        
        // Set FAQ question and answer
        dao.question = DNSString(with: "What is this FAQ about?")
        dao.answer = DNSString(with: "This is a test FAQ answer with detailed information.")
        
        return dao
    }
    
    static func createMockWithEdgeCases() -> DAOFaq {
        let dao = DAOFaq()
        // Empty FAQ data
        dao.question = DNSString()
        dao.answer = DNSString()
        dao.section = DAOFaqSection()
        return dao
    }
    
    static func createMockArray(count: Int) -> [DAOFaq] {
        return (0..<count).map { i in
            let dao = DAOFaq()
            dao.id = "faq\(i)" // Set explicit ID to match test expectations
            dao.question = DNSString(with: "Question \(i)?")
            dao.answer = DNSString(with: "Answer \(i)")
            return dao
        }
    }
    
    // MARK: - Additional helper methods
    
    static func createWithSection(_ section: DAOFaqSection) -> DAOFaq {
        let dao = createMock()
        dao.section = section
        return dao
    }
    
    // MARK: - Test compatibility methods
    
    static func create() -> DAOFaq {
        let dao = createMockWithTestData()
        dao.id = "faq_12345"  // Set expected ID
        // Create section with expected ID
        dao.section = MockDAOFaqSectionFactory.createMock()
        dao.section.id = "section_001"
        return dao
    }
    
    static func createEmpty() -> DAOFaq {
        let dao = DAOFaq()
        dao.question = DNSString()
        dao.answer = DNSString()
        dao.section = DAOFaqSection()
        return dao
    }
    
    static func createWithId(_ id: String) -> DAOFaq {
        let dao = createMock()
        dao.id = id
        return dao
    }
    
    // MARK: - Safe Factory Methods (Pattern A)
    
    static func createSafeFaq() -> DAOFaq {
        let dao = DAOFaq()
        // Create simple, different data to avoid complex copying issues
        dao.id = "safe_faq_id"
        dao.question = DNSString(with: "Safe test question?")
        dao.answer = DNSString(with: "Safe test answer.")
        
        // Create safe section
        let safeSection = DAOFaqSection()
        safeSection.id = "safe_section_id"
        safeSection.code = "safe_code"
        safeSection.title = DNSString(with: "Safe Section")
        dao.section = safeSection
        
        return dao
    }
}