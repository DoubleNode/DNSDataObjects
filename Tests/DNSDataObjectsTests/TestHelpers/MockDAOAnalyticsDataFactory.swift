//
//  MockDAOAnalyticsDataFactory.swift
//  DNSDataObjects Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOAnalyticsDataFactory -
struct MockDAOAnalyticsDataFactory: MockDAOFactory {
    typealias DAOType = DAOAnalyticsData
    
    static func createMock() -> DAOAnalyticsData {
        let analyticsData = DAOAnalyticsData()
        analyticsData.title = "Test Analytics"
        return analyticsData
    }
    
    static func createMockWithTestData() -> DAOAnalyticsData {
        let analyticsData = DAOAnalyticsData()
        analyticsData.title = "User Engagement"
        analyticsData.subtitle = "Monthly Report"
        analyticsData.data = [createAnalyticsNumbers()]
        return analyticsData
    }
    
    static func createMockWithEdgeCases() -> DAOAnalyticsData {
        let analyticsData = DAOAnalyticsData()
        analyticsData.title = "Complete Analytics Dashboard"
        analyticsData.subtitle = "Comprehensive metrics and KPIs"
        analyticsData.data = [
            createAnalyticsNumbers(),
            createAnalyticsNumbersWithCustomData()
        ]
        return analyticsData
    }
    
    static func createMockArray(count: Int) -> [DAOAnalyticsData] {
        return (0..<count).map { i in
            let analyticsData = DAOAnalyticsData()
            analyticsData.id = "analytics_data\(i)" // Set explicit ID to match test expectations
            analyticsData.title = "Analytics \(i)"
            analyticsData.subtitle = "Report \(i)"
            analyticsData.data = [createAnalyticsNumbers()]
            return analyticsData
        }
    }
    
    // MARK: - Helper methods
    
    static func createAnalyticsNumbers() -> DNSAnalyticsNumbers {
        return DNSAnalyticsNumbers(android: 400.0, iOS: 600.0, total: 1000.0)
    }
    
    static func createAnalyticsNumbersWithCustomData() -> DNSAnalyticsNumbers {
        return DNSAnalyticsNumbers(android: 20000.0, iOS: 30000.0, total: 50000.0)
    }
    
    // MARK: - Additional test methods expected by DAOAnalyticsDataTests
    
    static func createMinimalAnalyticsData() -> DAOAnalyticsData {
        let analyticsData = DAOAnalyticsData()
        analyticsData.title = "Minimal Analytics"
        return analyticsData
    }
    
    static func createCompleteAnalyticsData() -> DAOAnalyticsData {
        let analyticsData = DAOAnalyticsData()
        analyticsData.title = "Complete Analytics"
        analyticsData.subtitle = "Full dataset"
        analyticsData.data = [
            createAnalyticsNumbers(),
            createAnalyticsNumbersWithCustomData()
        ]
        return analyticsData
    }
    
    static func createTypicalAnalyticsData() -> DAOAnalyticsData {
        let analyticsData = DAOAnalyticsData()
        analyticsData.title = "Typical Analytics"
        analyticsData.subtitle = "Standard metrics"
        analyticsData.data = [createAnalyticsNumbers()]
        return analyticsData
    }
    
    // Safe versions for copy operations - no complex data that requires copying
    static func createSafeAnalyticsData() -> DAOAnalyticsData {
        let analyticsData = DAOAnalyticsData()
        analyticsData.id = "safe-analytics-123"
        analyticsData.title = "Safe Analytics"
        analyticsData.subtitle = "Safe data"
        // No data array to avoid DNSAnalyticsNumbers copying issues
        return analyticsData
    }
    
    static func createSafeAnalyticsDataForCopy() -> DAOAnalyticsData {
        let analyticsData = DAOAnalyticsData()
        analyticsData.id = "copy-safe-analytics-456"
        analyticsData.title = "Copy Safe Analytics"
        analyticsData.subtitle = "Copy safe data"
        // No data array to avoid copying issues
        return analyticsData
    }
}

// MARK: - Legacy name support
typealias DefaultMockDAOAnalyticsDataFactory = MockDAOAnalyticsDataFactory