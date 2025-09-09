//
//  MockDAOAlertFactory.swift
//  DNSDataObjects Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOAlertFactory -
struct MockDAOAlertFactory: MockDAOFactory {
    typealias DAOType = DAOAlert
    
    static func createMock() -> DAOAlert {
        let alert = DAOAlert()
        alert.title = DNSString(with: "Test Alert")
        alert.status = .open
        return alert
    }
    
    static func createMockWithTestData() -> DAOAlert {
        let metadata = [
            "uid": UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
            "created": Date(timeIntervalSinceReferenceDate: 1),
            "synced": Date(timeIntervalSinceReferenceDate: 2),
            "updated": Date(timeIntervalSinceReferenceDate: 3),
        ] as [String : Any]
        let alert = DAOAlert()
        alert.meta = DNSMetadata(from: metadata)
        alert.id = alert.meta.uid.uuidString
        alert.endTime = Date(timeIntervalSinceReferenceDate: 1001)
        alert.imageUrl = DNSURL(with: URL(string: "https://example.com/alert.png"))
        alert.name = "test-alert"
        alert.priority = DNSPriority.normal
        alert.scope = .all
        alert.startTime = Date(timeIntervalSinceReferenceDate: 4)
        alert.status = .open
        alert.tagLine = DNSString(with: "Important notification")
        alert.title = DNSString(with: "System Alert")
        return alert
    }
    
    static func createMockWithEdgeCases() -> DAOAlert {
        let metadata = [
            "uid": UUID(uuidString: "d36348ac-70e0-4938-8fd5-45e625d22d66")!,
            "created": Date(timeIntervalSinceReferenceDate: 100),
            "synced": Date(timeIntervalSinceReferenceDate: 200),
            "updated": Date(timeIntervalSinceReferenceDate: 300),
        ] as [String : Any]
        let alert = DAOAlert()
        alert.meta = DNSMetadata(from: metadata)
        alert.id = alert.meta.uid.uuidString
        alert.endTime = Date(timeIntervalSinceReferenceDate: 2002)
        alert.imageUrl = DNSURL(with: URL(string: "https://example.com/priority-alert.png"))
        alert.name = "critical-system-alert"
        alert.priority = DNSPriority.highest
        alert.scope = .place
        alert.startTime = Date(timeIntervalSinceReferenceDate: 400)
        alert.status = .open
        alert.tagLine = DNSString(with: "Critical system maintenance notification")
        alert.title = DNSString(with: "Scheduled Maintenance Alert")
        return alert
    }
    
    static func createMockArray(count: Int) -> [DAOAlert] {
        return (0..<count).map { i in
            let alert = DAOAlert()
            alert.id = "alert\(i)" // Set explicit ID to match test expectations
            alert.title = DNSString(with: "Alert \(i)")
            alert.status = i % 2 == 0 ? .open : .closed
            alert.priority = i % 2 == 0 ? DNSPriority.normal : DNSPriority.high
            alert.name = "alert-\(i)"
            return alert
        }
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOAlert {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOAlert {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOAlert {
        let alert = createMockWithTestData()
        alert.id = id
        return alert
    }
    
    // Test-specific method aliases expected by DAOAlertTests
    static func createCompleteAlert() -> DAOAlert {
        return createMockWithEdgeCases() // Use edge cases for "complete"
    }
    
    static func createMinimalAlert() -> DAOAlert {
        return createMock() // Simple version
    }
    
    static func createTypicalAlert() -> DAOAlert {
        return createMockWithTestData() // Standard version
    }
    
    // Safe versions for copy operations - no complex metadata
    static func createSafeAlert() -> DAOAlert {
        let alert = DAOAlert()
        alert.id = "safe-alert-123"
        alert.endTime = Date(timeIntervalSinceReferenceDate: 1000)
        alert.imageUrl = DNSURL(with: URL(string: "https://example.com/safe-alert.png"))
        alert.name = "safe-alert"
        alert.priority = DNSPriority.normal
        alert.scope = .all
        alert.startTime = Date(timeIntervalSinceReferenceDate: 0)
        alert.status = .open
        alert.tagLine = DNSString(with: "Safe alert")
        alert.title = DNSString(with: "Safe Alert Title")
        // No metadata to avoid DNSUserReaction copying issues
        return alert
    }
    
    static func createSafeAlertForCopy() -> DAOAlert {
        let alert = DAOAlert()
        alert.id = "copy-safe-alert-456"
        alert.endTime = Date(timeIntervalSinceReferenceDate: 2000)
        alert.imageUrl = DNSURL(with: URL(string: "https://example.com/copy-safe.png"))
        alert.name = "copy-safe-alert"
        alert.priority = DNSPriority.high
        alert.scope = .place
        alert.startTime = Date(timeIntervalSinceReferenceDate: 500)
        alert.status = .closed
        alert.tagLine = DNSString(with: "Copy safe alert")
        alert.title = DNSString(with: "Copy Safe Alert Title")
        // No metadata to avoid copying issues
        return alert
    }
}

// Type alias for backward compatibility with tests
typealias DefaultMockDAOAlertFactory = MockDAOAlertFactory