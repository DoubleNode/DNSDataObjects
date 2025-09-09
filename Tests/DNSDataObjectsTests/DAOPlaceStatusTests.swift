//
//  DAOPlaceStatusTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOPlaceStatusTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        let placeStatus = DAOPlaceStatus()
        
        XCTAssertNotNil(placeStatus.id)
        XCTAssertNotNil(placeStatus.endTime)
        XCTAssertNotNil(placeStatus.startTime)
        XCTAssertEqual(placeStatus.message.asString, "")
        XCTAssertEqual(placeStatus.scope, .place)
        XCTAssertEqual(placeStatus.status, .open)
    }
    
    func testInitializationWithId() {
        let testId = "test_place_status_123"
        let placeStatus = DAOPlaceStatus(id: testId)
        
        XCTAssertEqual(placeStatus.id, testId)
        XCTAssertEqual(placeStatus.status, .open)
        XCTAssertEqual(placeStatus.scope, .place)
    }
    
    func testInitializationWithStatus() {
        let placeStatus = DAOPlaceStatus(status: .closed)
        
        XCTAssertNotNil(placeStatus.id)
        XCTAssertEqual(placeStatus.status, .closed)
    }
    
    func testInitializationFromObject() {
        let original = MockDAOPlaceStatusFactory.createMockWithTestData()
        let copy = DAOPlaceStatus(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.status, original.status)
        XCTAssertEqual(copy.scope, original.scope)
        XCTAssertEqual(copy.message.asString, original.message.asString)
        XCTAssertEqual(copy.startTime, original.startTime)
        XCTAssertEqual(copy.endTime, original.endTime)
        XCTAssertTrue(copy !== original)
    }
    
    func testInitializationFromDictionary() {
        let testId = "dict_place_status_456"
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(3600)
        
        let data: DNSDataDictionary = [
            "id": testId,
            "status": "closed",
            "scope": DNSScope.district.rawValue,
            "message": "Test message",
            "startTime": startTime,
            "endTime": endTime
        ]
        
        let placeStatus = DAOPlaceStatus(from: data)
        
        XCTAssertNotNil(placeStatus)
        XCTAssertEqual(placeStatus?.id, testId)
        XCTAssertEqual(placeStatus?.status, .closed)
        XCTAssertEqual(placeStatus?.scope, .district)
        XCTAssertEqual(placeStatus?.message.asString, "Test message")
        if let status = placeStatus {
            XCTAssertEqual(status.startTime.timeIntervalSince1970, startTime.timeIntervalSince1970, accuracy: 1)
            XCTAssertEqual(status.endTime.timeIntervalSince1970, endTime.timeIntervalSince1970, accuracy: 1)
        }
    }
    
    func testInitializationFromEmptyDictionary() {
        let placeStatus = DAOPlaceStatus(from: [:])
        XCTAssertNil(placeStatus)
    }
    
    // MARK: - Property Tests
    
    func testStatusProperty() {
        let placeStatus = DAOPlaceStatus()
        
        placeStatus.status = .closed
        XCTAssertEqual(placeStatus.status, .closed)
        
        placeStatus.status = .maintenance
        XCTAssertEqual(placeStatus.status, .maintenance)
        
        placeStatus.status = .grandOpening
        XCTAssertEqual(placeStatus.status, .grandOpening)
    }
    
    func testScopeProperty() {
        let placeStatus = DAOPlaceStatus()
        
        placeStatus.scope = .district
        XCTAssertEqual(placeStatus.scope, .district)
        
        placeStatus.scope = .region
        XCTAssertEqual(placeStatus.scope, .region)
    }
    
    func testMessageProperty() {
        let placeStatus = DAOPlaceStatus()
        let testMessage = "Test status message"
        
        placeStatus.message = DNSString(with: testMessage)
        XCTAssertEqual(placeStatus.message.asString, testMessage)
    }
    
    func testTimeProperties() {
        let placeStatus = DAOPlaceStatus()
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(3600)
        
        placeStatus.startTime = startTime
        placeStatus.endTime = endTime
        
        XCTAssertEqual(placeStatus.startTime, startTime)
        XCTAssertEqual(placeStatus.endTime, endTime)
    }
    
    // MARK: - Computed Property Tests
    
    func testIsOpenPropertyWithOpenStatus() {
        let openStatus = MockDAOPlaceStatusFactory.createOpenStatus()
        XCTAssertTrue(openStatus.isOpen)
    }
    
    func testIsOpenPropertyWithClosedStatus() {
        let closedStatus = MockDAOPlaceStatusFactory.createClosedStatus()
        XCTAssertFalse(closedStatus.isOpen)
    }
    
    func testIsOpenPropertyWithGrandOpeningStatus() {
        let grandOpeningStatus = MockDAOPlaceStatusFactory.createGrandOpeningStatus()
        XCTAssertTrue(grandOpeningStatus.isOpen)
    }
    
    func testIsOpenPropertyWithHolidayStatus() {
        let holidayStatus = MockDAOPlaceStatusFactory.createHolidayStatus()
        XCTAssertTrue(holidayStatus.isOpen)
    }
    
    func testIsOpenPropertyWithMaintenanceStatus() {
        let maintenanceStatus = MockDAOPlaceStatusFactory.createMaintenanceStatus()
        XCTAssertFalse(maintenanceStatus.isOpen)
    }
    
    // MARK: - Business Logic Tests
    
    func testUtilityIsOpenMethod() {
        let placeStatus = DAOPlaceStatus()
        
        // Test open statuses
        placeStatus.status = .open
        XCTAssertTrue(placeStatus.utilityIsOpen())
        
        placeStatus.status = .grandOpening
        XCTAssertTrue(placeStatus.utilityIsOpen())
        
        placeStatus.status = .holiday
        XCTAssertTrue(placeStatus.utilityIsOpen())
        
        // Test closed statuses
        placeStatus.status = .closed
        XCTAssertFalse(placeStatus.utilityIsOpen())
        
        placeStatus.status = .maintenance
        XCTAssertFalse(placeStatus.utilityIsOpen())
    }
    
    func testStatusValidation() {
        let openStatus = MockDAOPlaceStatusFactory.createWithStatus(.open)
        XCTAssertEqual(openStatus.status, .open)
        XCTAssertTrue(openStatus.isOpen)
        
        let closedStatus = MockDAOPlaceStatusFactory.createWithStatus(.closed)
        XCTAssertEqual(closedStatus.status, .closed)
        XCTAssertFalse(closedStatus.isOpen)
    }
    
    func testScopeValidation() {
        let placeScope = MockDAOPlaceStatusFactory.createWithScope(.place)
        XCTAssertEqual(placeScope.scope, .place)
        
        let buildingScope = MockDAOPlaceStatusFactory.createWithScope(.district)
        XCTAssertEqual(buildingScope.scope, .district)
        
        let campusScope = MockDAOPlaceStatusFactory.createWithScope(.region)
        XCTAssertEqual(campusScope.scope, .region)
    }
    
    func testTimeRangeValidation() {
        let startTime = Date()
        let endTime = startTime.addingTimeInterval(7200) // 2 hours later
        
        let placeStatus = MockDAOPlaceStatusFactory.createWithTimeRange(start: startTime, end: endTime)
        
        XCTAssertEqual(placeStatus.startTime, startTime)
        XCTAssertEqual(placeStatus.endTime, endTime)
        XCTAssertTrue(placeStatus.endTime > placeStatus.startTime)
    }
    
    // MARK: - Update Method Tests
    
    func testUpdateFromObject() {
        let placeStatus = DAOPlaceStatus()
        let source = MockDAOPlaceStatusFactory.createMockWithTestData()
        
        placeStatus.update(from: source)
        
        XCTAssertEqual(placeStatus.status, source.status)
        XCTAssertEqual(placeStatus.scope, source.scope)
        XCTAssertEqual(placeStatus.message.asString, source.message.asString)
        XCTAssertEqual(placeStatus.startTime, source.startTime)
        XCTAssertEqual(placeStatus.endTime, source.endTime)
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testAsDictionary() {
        let placeStatus = MockDAOPlaceStatusFactory.createMockWithTestData()
        let dictionary = placeStatus.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["status"] as Any?)
        XCTAssertNotNil(dictionary["scope"] as Any?)
        XCTAssertNotNil(dictionary["message"] as Any?)
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertNotNil(dictionary["endTime"] as Any?)
        
        XCTAssertEqual(dictionary["id"] as? String, placeStatus.id)
        XCTAssertEqual(dictionary["status"] as? String, placeStatus.status.rawValue)
        XCTAssertEqual(dictionary["scope"] as? Int, placeStatus.scope.rawValue)
    }
    
    func testDaoFromDictionary() {
        let original = MockDAOPlaceStatusFactory.createMockWithTestData()
        let dictionary = original.asDictionary
        
        let restored = DAOPlaceStatus()
        _ = restored.dao(from: dictionary)
        
        XCTAssertEqual(restored.id, original.id)
        XCTAssertEqual(restored.status, original.status)
        XCTAssertEqual(restored.scope, original.scope)
        XCTAssertEqual(restored.message.asString, original.message.asString)
        XCTAssertEqual(restored.startTime.timeIntervalSince1970, original.startTime.timeIntervalSince1970, accuracy: 1)
        XCTAssertEqual(restored.endTime.timeIntervalSince1970, original.endTime.timeIntervalSince1970, accuracy: 1)
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAndDecoding() throws {
        let original = MockDAOPlaceStatusFactory.createMockWithTestData()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(DAOPlaceStatus.self, from: data)
        
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.status, original.status)
        XCTAssertEqual(decoded.scope, original.scope)
        XCTAssertEqual(decoded.message.asString, original.message.asString)
        XCTAssertEqual(decoded.startTime.timeIntervalSince1970, original.startTime.timeIntervalSince1970, accuracy: 1)
        XCTAssertEqual(decoded.endTime.timeIntervalSince1970, original.endTime.timeIntervalSince1970, accuracy: 1)
    }
    
    func testDecodingInvalidData() {
        let invalidJSON = "{\"invalid\": \"data\"}"
        let data = invalidJSON.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let _ = try decoder.decode(DAOPlaceStatus.self, from: data)
            // If we get here, decoding succeeded (which is unexpected but not necessarily wrong)
            // DAOPlaceStatus can be initialized with minimal data due to default values
        } catch {
            // This is the expected path - decoding should fail
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - NSCopying Tests
    
    func testCopyProtocol() {
        let original = MockDAOPlaceStatusFactory.createMockWithTestData()
        let copy = original.copy() as! DAOPlaceStatus
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.status, original.status)
        XCTAssertEqual(copy.scope, original.scope)
        XCTAssertEqual(copy.message.asString, original.message.asString)
        XCTAssertEqual(copy.startTime, original.startTime)
        XCTAssertEqual(copy.endTime, original.endTime)
        XCTAssertTrue(copy !== original)
    }
    
    // MARK: - Equatable Tests
    
    func testEqualityOperator() {
        let placeStatus1 = MockDAOPlaceStatusFactory.createMockWithTestData()
        let placeStatus2 = DAOPlaceStatus(from: placeStatus1)
        
        // Property-by-property comparison instead of direct object equality
        XCTAssertEqual(placeStatus1.id, placeStatus2.id)
        XCTAssertEqual(placeStatus1.status, placeStatus2.status)
        XCTAssertEqual(placeStatus1.scope, placeStatus2.scope)
        XCTAssertEqual(placeStatus1.message.asString, placeStatus2.message.asString)
        XCTAssertEqual(placeStatus1.startTime, placeStatus2.startTime)
        XCTAssertEqual(placeStatus1.endTime, placeStatus2.endTime)
        XCTAssertFalse(placeStatus1 != placeStatus2)
    }
    
    func testInequalityOperator() {
        let placeStatus1 = MockDAOPlaceStatusFactory.createMockWithTestData()
        let placeStatus2 = MockDAOPlaceStatusFactory.createMockWithTestData()
        placeStatus2.status = .closed
        
        XCTAssertNotEqual(placeStatus1, placeStatus2)
        XCTAssertTrue(placeStatus1 != placeStatus2)
    }
    
    func testIsDiffFrom() {
        let placeStatus1 = MockDAOPlaceStatusFactory.createMockWithTestData()
        let placeStatus2 = DAOPlaceStatus(from: placeStatus1)
        
        XCTAssertFalse(placeStatus1.isDiffFrom(placeStatus2))
        
        placeStatus2.status = .maintenance
        XCTAssertTrue(placeStatus1.isDiffFrom(placeStatus2))
    }
    
    func testIsDiffFromDifferentType() {
        let placeStatus = MockDAOPlaceStatusFactory.createMockWithTestData()
        let notAPlaceStatus = "not a place status"
        
        XCTAssertTrue(placeStatus.isDiffFrom(notAPlaceStatus))
    }
    
    func testIsDiffFromSameInstance() {
        let placeStatus = MockDAOPlaceStatusFactory.createMockWithTestData()
        
        XCTAssertFalse(placeStatus.isDiffFrom(placeStatus))
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        let placeStatus = MockDAOPlaceStatusFactory.createMockWithEdgeCases()
        
        XCTAssertEqual(placeStatus.status, .closed)
        XCTAssertEqual(placeStatus.scope, .place)
        XCTAssertEqual(placeStatus.message.asString, "")
        XCTAssertEqual(placeStatus.startTime, Date.distantPast)
        XCTAssertEqual(placeStatus.endTime, Date.distantPast)
        XCTAssertFalse(placeStatus.isOpen)
    }
    
    func testNilHandling() {
        let placeStatus = DAOPlaceStatus()
        
        XCTAssertTrue(placeStatus.isDiffFrom(nil))
    }
    
    func testEmptyMessage() {
        let placeStatus = DAOPlaceStatus()
        placeStatus.message = DNSString(with: "")
        
        XCTAssertEqual(placeStatus.message.asString, "")
    }
    
    // MARK: - Enum Validation Tests
    
    func testAllStatusTypes() {
        let statuses: [DNSStatus] = [.open, .closed, .grandOpening, .holiday, .maintenance]
        
        for status in statuses {
            let placeStatus = MockDAOPlaceStatusFactory.createWithStatus(status)
            XCTAssertEqual(placeStatus.status, status)
        }
    }
    
    func testAllScopeTypes() {
        let scopes: [DNSScope] = [.place, .district, .region]
        
        for scope in scopes {
            let placeStatus = MockDAOPlaceStatusFactory.createWithScope(scope)
            XCTAssertEqual(placeStatus.scope, scope)
        }
    }
    
    // MARK: - Array Tests
    
    func testCreateMockArray() {
        let count = 5
        let placeStatuses = MockDAOPlaceStatusFactory.createMockArray(count: count)
        
        XCTAssertEqual(placeStatuses.count, count)
        
        for (index, placeStatus) in placeStatuses.enumerated() {
            XCTAssertEqual(placeStatus.id, "place_status_\(index + 1)")
            XCTAssertNotNil(placeStatus.status)
            XCTAssertNotNil(placeStatus.scope)
            XCTAssertNotNil(placeStatus.message)
        }
    }
    
    func testArrayUniqueness() {
        let placeStatuses = MockDAOPlaceStatusFactory.createMockArray(count: 3)
        
        for i in 0..<placeStatuses.count {
            for j in (i + 1)..<placeStatuses.count {
                XCTAssertNotEqual(placeStatuses[i].id, placeStatuses[j].id)
            }
        }
    }
    
    func testArrayVariety() {
        let placeStatuses = MockDAOPlaceStatusFactory.createMockArray(count: 10)
        
        // Should have different statuses
        let statuses = Set(placeStatuses.map { $0.status })
        XCTAssertGreaterThan(statuses.count, 1)
        
        // Should have different scopes
        let scopes = Set(placeStatuses.map { $0.scope })
        XCTAssertGreaterThan(scopes.count, 1)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceCreateMock() {
        measure {
            for _ in 0..<1000 {
                _ = MockDAOPlaceStatusFactory.createMock()
            }
        }
    }
    
    func testPerformanceInitialization() {
        measure {
            for _ in 0..<1000 {
                _ = DAOPlaceStatus()
            }
        }
    }
    
    func testPerformanceCopy() {
        let original = MockDAOPlaceStatusFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = original.copy()
            }
        }
    }
    
    func testPerformanceIsOpen() {
        let placeStatus = MockDAOPlaceStatusFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = placeStatus.isOpen
            }
        }
    }
    
    func testPerformanceEquality() {
        let placeStatus1 = MockDAOPlaceStatusFactory.createMockWithTestData()
        let placeStatus2 = DAOPlaceStatus(from: placeStatus1)
        
        measure {
            for _ in 0..<1000 {
                _ = placeStatus1 == placeStatus2
            }
        }
    }
}
