//
//  MockDAOEventDayItemFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOEventDayItemFactory -
struct MockDAOEventDayItemFactory: MockDAOFactory {
    typealias DAOType = DAOEventDayItem
    
    static func createMock() -> DAOEventDayItem {
        let item = DAOEventDayItem()
        item.id = "event_day_item_12345"
        return item
    }
    
    static func createMockWithTestData() -> DAOEventDayItem {
        let item = DAOEventDayItem(id: "event_day_item_test_data")
        return item
    }
    
    static func createMockWithEdgeCases() -> DAOEventDayItem {
        let item = DAOEventDayItem()
        item.id = ""
        return item
    }
    
    static func createMockArray(count: Int) -> [DAOEventDayItem] {
        var items: [DAOEventDayItem] = []
        
        for i in 0..<count {
            let item = DAOEventDayItem()
            item.id = "event_day_item_\(i + 1)" // Fixed to match test expectations
            items.append(item)
        }
        
        return items
    }
}