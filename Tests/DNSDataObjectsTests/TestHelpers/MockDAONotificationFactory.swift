//
//  MockDAONotificationFactory.swift
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

// MARK: - MockDAONotificationFactory -
struct MockDAONotificationFactory: MockDAOFactory {
    typealias DAOType = DAONotification
    
    static func createMock() -> DAONotification {
        let dao = DAONotification()
        dao.title = DNSString(with: "Test Notification")
        dao.body = DNSString(with: "Test notification body.")
        dao.type = .alert
        return dao
    }
    
    static func createMockWithTestData() -> DAONotification {
        let dao = DAONotification()
        dao.id = "notification_12345"
        
        // Set notification properties
        dao.title = DNSString(with: "Important Update")
        dao.body = DNSString(with: "This is an important notification body with details about the update.")
        dao.type = .alert
        dao.deepLink = URL(string: "myapp://notification/12345")
        
        return dao
    }
    
    static func createMockWithEdgeCases() -> DAONotification {
        let dao = DAONotification()
        
        // Edge cases
        dao.title = DNSString() // Empty title
        dao.body = DNSString() // Empty body
        dao.type = .unknown // Unknown type
        dao.deepLink = nil // No deep link
        
        return dao
    }
    
    static func createMockArray(count: Int) -> [DAONotification] {
        let types: [DNSNotificationType] = [.alert, .deepLink, .deepLinkAuto, .unknown]
        
        return (0..<count).map { i in
            let dao = DAONotification()
            dao.id = "notification\(i)" // Set explicit ID to match test expectations
            dao.title = DNSString(with: "Notification \(i)")
            dao.body = DNSString(with: "Body for notification \(i)")
            dao.type = types[i % types.count]
            dao.deepLink = URL(string: "myapp://notification/\(i)")
            return dao
        }
    }
    
    // MARK: - Additional helper methods
    
    static func createWithType(_ type: DNSNotificationType) -> DAONotification {
        let dao = createMock()
        dao.type = type
        return dao
    }
    
    static func createAlertNotification() -> DAONotification {
        let dao = createMock()
        dao.type = .alert
        dao.title = DNSString(with: "Alert Notification")
        dao.body = DNSString(with: "This is an alert notification message.")
        return dao
    }
    
    static func createDeepLinkNotification() -> DAONotification {
        let dao = createMock()
        dao.type = .deepLink
        dao.title = DNSString(with: "Deep Link Notification")
        dao.body = DNSString(with: "This is a deep link notification message.")
        return dao
    }
    
    // Test-specific method aliases expected by DAONotificationTests
    static func createPushNotification() -> DAONotification {
        return createAlertNotification() // Map push to alert type
    }
    
    static func createEmailNotification() -> DAONotification {
        return createDeepLinkNotification() // Map email to deepLink type
    }
    
    // MARK: - Test compatibility methods
    
    static func create() -> DAONotification {
        return createMock()
    }
    
    static func createEmpty() -> DAONotification {
        let dao = DAONotification()
        dao.title = DNSString()
        dao.body = DNSString()
        dao.type = .unknown
        dao.deepLink = nil
        return dao
    }
    
    static func createWithId(_ id: String) -> DAONotification {
        let dao = createMock()
        dao.id = id
        return dao
    }
}