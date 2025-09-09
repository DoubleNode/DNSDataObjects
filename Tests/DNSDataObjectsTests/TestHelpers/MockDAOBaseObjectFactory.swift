//
//  MockDAOBaseObjectFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOBaseObjectFactory -
struct MockDAOBaseObjectFactory: MockDAOFactory {
    typealias DAOType = DAOBaseObject
    
    static func createMock() -> DAOBaseObject {
        let baseObject = DAOBaseObject()
        return baseObject
    }
    
    static func createMockWithTestData() -> DAOBaseObject {
        let baseObject = DAOBaseObject(id: "test_base_object_id")
        
        // Add analytics data
        let analyticsData1 = DAOAnalyticsData()
        analyticsData1.title = "Test Analytics 1"
        analyticsData1.subtitle = "Analytics Data 1"
        
        let analyticsData2 = DAOAnalyticsData()
        analyticsData2.title = "Test Analytics 2"
        analyticsData2.subtitle = "Analytics Data 2"
        
        baseObject.analyticsData = [analyticsData1, analyticsData2]
        
        // Set metadata properties - meta is DNSMetadata with status and views properties
        if let meta = baseObject.meta as? DNSMetadata {
            meta.status = "active"
            meta.views = 42
        }
        
        return baseObject
    }
    
    static func createMockWithEdgeCases() -> DAOBaseObject {
        let baseObject = DAOBaseObject()
        
        // Edge cases
        baseObject.id = "" // Empty ID (though framework may override)
        baseObject.analyticsData = [] // Empty analytics data
        
        return baseObject
    }
    
    static func createMockArray(count: Int) -> [DAOBaseObject] {
        var baseObjects: [DAOBaseObject] = []
        
        for i in 0..<count {
            let baseObject = DAOBaseObject(id: "base_object\(i)") // Set explicit ID to match test expectations (changed from i + 1)
            
            // Add variety
            if i % 2 == 0 {
                let analyticsData = DAOAnalyticsData()
                analyticsData.title = "Analytics for Object \(i + 1)"
                baseObject.analyticsData = [analyticsData]
            }
            
            baseObjects.append(baseObject)
        }
        
        return baseObjects
    }
}