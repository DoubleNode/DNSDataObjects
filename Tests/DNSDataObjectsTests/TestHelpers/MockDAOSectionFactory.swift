//
//  MockDAOSectionFactory.swift
//  DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

struct MockDAOSectionFactory: MockDAOFactory {
    typealias DAOType = DAOSection
    static func createMock() -> DAOSection {
        let dao = DAOSection()
        dao.name = DNSString(with: "Test Section")
        dao.pricingTierId = "test_tier"
        return dao
    }
    
    static func createMockWithTestData() -> DAOSection {
        let dao = DAOSection()
        dao.id = "section_12345"
        
        // Set section properties
        dao.name = DNSString(with: "Main Section")
        dao.pricingTierId = "tier_premium"
        
        // Create mock parent section
        let parent = DAOSection()
        parent.id = "parent_section_001"
        parent.name = DNSString(with: "Parent Section")
        parent.pricingTierId = "tier_basic"
        dao.parent = parent
        
        // Create mock child sections
        let child1 = DAOSection()
        child1.id = "child_section_001"
        child1.name = DNSString(with: "Child Section 1")
        child1.pricingTierId = "tier_basic"
        child1.parent = dao
        
        let child2 = DAOSection()
        child2.id = "child_section_002"
        child2.name = DNSString(with: "Child Section 2")
        child2.pricingTierId = "tier_premium"
        child2.parent = dao
        
        dao.children = [child1, child2]
        
        // Create mock places - simplified without dependency for now
        let place1 = DAOPlace()
        place1.id = "place_001"
        place1.name = DNSString(with: "Test Place 1")
        
        let place2 = DAOPlace()
        place2.id = "place_002"
        place2.name = DNSString(with: "Test Place 2")
        
        dao.places = [place1, place2]
        
        return dao
    }
    
    static func createMockWithEdgeCases() -> DAOSection {
        let dao = DAOSection()
        dao.name = DNSString()  // Empty name
        dao.pricingTierId = ""  // Empty pricing tier
        dao.children = []       // No children
        dao.places = []         // No places
        dao.parent = nil        // No parent
        return dao
    }
    
    static func createMockArray(count: Int) -> [DAOSection] {
        var sections: [DAOSection] = []
        for i in 0..<count {
            let dao = DAOSection()
            dao.id = "section\(i)" // Set explicit ID to match test expectations (changed from i + 1)
            dao.name = DNSString(with: "Section \(i + 1)")
            dao.pricingTierId = i % 2 == 0 ? "tier_basic" : "tier_premium"
            sections.append(dao)
        }
        return sections
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOSection {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOSection {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOSection {
        let dao = createMockWithTestData()
        dao.id = id
        return dao
    }
    
    static func createLeafSection() -> DAOSection {
        let dao = DAOSection()
        dao.id = "leaf_section_12345"
        dao.name = DNSString(with: "Leaf Section")
        dao.pricingTierId = "tier_basic"
        // No children or parent - this is a leaf section
        return dao
    }
    
    static func createRootSection() -> DAOSection {
        let dao = createMockWithTestData()
        dao.parent = nil // Root section has no parent
        return dao
    }
}