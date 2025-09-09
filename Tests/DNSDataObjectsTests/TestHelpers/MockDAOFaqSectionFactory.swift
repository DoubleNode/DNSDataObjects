//
//  MockDAOFaqSectionFactory.swift
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

// MARK: - MockDAOFaqSectionFactory -
struct MockDAOFaqSectionFactory: MockDAOFactory {
    typealias DAOType = DAOFaqSection
    
    static func createMock() -> DAOFaqSection {
        let dao = DAOFaqSection()
        dao.code = "general"
        dao.title = DNSString(with: "General Questions")
        dao.icon = "questionmark.circle"
        return dao
    }
    
    static func createMockWithTestData() -> DAOFaqSection {
        let dao = DAOFaqSection()
        dao.id = "faq_section_12345"
        
        // Set section properties
        dao.code = "general"
        dao.title = DNSString(with: "General Questions")
        dao.icon = "questionmark.circle"
        
        // Create mock FAQs for this section
        let faq1 = DAOFaq()
        faq1.id = "faq_001"
        faq1.question = DNSString(with: "How do I get started?")
        faq1.answer = DNSString(with: "Getting started is easy...")
        faq1.section = dao
        
        let faq2 = DAOFaq()
        faq2.id = "faq_002"
        faq2.question = DNSString(with: "What are the requirements?")
        faq2.answer = DNSString(with: "The requirements are...")
        faq2.section = dao
        
        dao.faqs = [faq1, faq2]
        
        return dao
    }
    
    static func createMockWithEdgeCases() -> DAOFaqSection {
        let dao = DAOFaqSection()
        // Empty section with minimal data
        dao.code = ""
        dao.title = DNSString()
        dao.icon = ""
        dao.faqs = []
        return dao
    }
    
    static func createMockArray(count: Int) -> [DAOFaqSection] {
        return (0..<count).map { i in
            let dao = DAOFaqSection()
            dao.id = "faq_section\(i)" // Set explicit ID to match test expectations
            dao.code = "section_\(i)"
            dao.title = DNSString(with: "Section \(i)")
            dao.icon = "icon_\(i)"
            return dao
        }
    }
    
    // MARK: - Additional helper methods
    
    static func createWithCode(_ code: String) -> DAOFaqSection {
        let dao = createMock()
        dao.code = code
        return dao
    }
    
    // MARK: - Test compatibility methods
    
    static func create() -> DAOFaqSection {
        return createMock()
    }
    
    static func createWithId(_ id: String) -> DAOFaqSection {
        let dao = createMock()
        dao.id = id
        return dao
    }
    
    static func createEmpty() -> DAOFaqSection {
        let dao = DAOFaqSection()
        dao.code = ""
        dao.title = DNSString()
        dao.icon = ""
        dao.faqs = []
        return dao
    }
}