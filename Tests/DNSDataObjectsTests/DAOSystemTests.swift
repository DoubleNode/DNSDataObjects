//
//  DAOSystemTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOSystemTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInit_Default_CreatesValidObject() {
        let system = DAOSystem()
        
        XCTAssertNotNil(system)
        XCTAssertTrue(system.message.isEmpty)
        XCTAssertTrue(system.name.isEmpty)
        XCTAssertNotNil(system.currentState)
        XCTAssertTrue(system.endPoints.isEmpty)
        XCTAssertTrue(system.historyState.isEmpty)
    }
    
    func testInit_WithId_CreatesValidObjectWithId() {
        let id = "test_system_id"
        let system = DAOSystem(id: id)
        
        XCTAssertEqual(system.id, id)
        XCTAssertTrue(system.message.isEmpty)
        XCTAssertTrue(system.name.isEmpty)
        XCTAssertNotNil(system.currentState)
        XCTAssertTrue(system.endPoints.isEmpty)
        XCTAssertTrue(system.historyState.isEmpty)
    }
    
    func testInit_FromObject_CopiesAllProperties() {
        let original = MockDAOSystemFactory.createMockWithTestData()
        let copy = DAOSystem(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertEqual(copy.message, original.message)
        XCTAssertEqual(copy.name.asString, original.name.asString)
        XCTAssertEqual(copy.currentState.id, original.currentState.id)
        XCTAssertEqual(copy.endPoints.count, original.endPoints.count)
        XCTAssertEqual(copy.historyState.count, original.historyState.count)
    }
    
    func testInit_FromDictionary_ValidData_CreatesObject() {
        let data: DNSDataDictionary = [
            "id": "system_id",
            "name": "Test System",
            "message": "System running",
            "currentState": ["id": "current_state"],
            "endPoints": [["id": "endpoint1"], ["id": "endpoint2"]],
            "historyState": [["id": "state1"], ["id": "state2"]]
        ]
        
        let system = DAOSystem(from: data)
        
        XCTAssertNotNil(system)
        XCTAssertEqual(system?.id, "system_id")
        XCTAssertEqual(system?.name.asString, "Test System")
        XCTAssertEqual(system?.message.asString, "System running")
        XCTAssertEqual(system?.endPoints.count, 2)
        XCTAssertEqual(system?.historyState.count, 2)
    }
    
    func testInit_FromDictionary_EmptyData_ReturnsNil() {
        let data: DNSDataDictionary = [:]
        let system = DAOSystem(from: data)
        
        XCTAssertNil(system)
    }
    
    // MARK: - Property Tests
    
    func testMessage_SetAndGet_WorksCorrectly() {
        let system = DAOSystem()
        let testMessage = DNSString(with: "Test message")
        
        system.message = testMessage
        
        XCTAssertEqual(system.message, testMessage)
        XCTAssertEqual(system.message.asString, "Test message")
    }
    
    func testName_SetAndGet_WorksCorrectly() {
        let system = DAOSystem()
        let testName = DNSString(with: "Test System")
        
        system.name = testName
        
        XCTAssertEqual(system.name, testName)
        XCTAssertEqual(system.name.asString, "Test System")
    }
    
    func testCurrentState_SetAndGet_WorksCorrectly() {
        let system = DAOSystem()
        let testState = DAOSystemState()
        testState.id = "test_state"
        
        system.currentState = testState
        
        XCTAssertEqual(system.currentState.id, "test_state")
    }
    
    func testEndPoints_SetAndGet_WorksCorrectly() {
        let system = DAOSystem()
        let endpoint1 = DAOSystemEndPoint()
        endpoint1.id = "endpoint1"
        let endpoint2 = DAOSystemEndPoint()
        endpoint2.id = "endpoint2"
        
        system.endPoints = [endpoint1, endpoint2]
        
        XCTAssertEqual(system.endPoints.count, 2)
        XCTAssertEqual(system.endPoints[0].id, "endpoint1")
        XCTAssertEqual(system.endPoints[1].id, "endpoint2")
    }
    
    func testHistoryState_SetAndGet_WorksCorrectly() {
        let system = DAOSystem()
        let state1 = DAOSystemState()
        state1.id = "state1"
        let state2 = DAOSystemState()
        state2.id = "state2"
        
        system.historyState = [state1, state2]
        
        XCTAssertEqual(system.historyState.count, 2)
        XCTAssertEqual(system.historyState[0].id, "state1")
        XCTAssertEqual(system.historyState[1].id, "state2")
    }
    
    // MARK: - Update Tests
    
    func testUpdate_FromObject_UpdatesAllProperties() {
        let system = DAOSystem()
        let other = MockDAOSystemFactory.createMockWithTestData()
        
        system.update(from: other)
        
        XCTAssertEqual(system.message, other.message)
        XCTAssertEqual(system.name.asString, other.name.asString)
        XCTAssertEqual(system.currentState.id, other.currentState.id)
        XCTAssertEqual(system.endPoints.count, other.endPoints.count)
        XCTAssertEqual(system.historyState.count, other.historyState.count)
    }
    
    func testUpdate_FromEmptyObject_ClearsProperties() {
        let system = MockDAOSystemFactory.createMockWithTestData()
        let empty = DAOSystem()
        
        system.update(from: empty)
        
        XCTAssertTrue(system.message.isEmpty)
        XCTAssertTrue(system.name.isEmpty)
        XCTAssertTrue(system.endPoints.isEmpty)
        XCTAssertTrue(system.historyState.isEmpty)
    }
    
    // MARK: - Dictionary Conversion Tests
    
    func testAsDictionary_ContainsAllProperties() {
        let system = MockDAOSystemFactory.createMockWithTestData()
        let dictionary = system.asDictionary
        
        XCTAssertNotNil(dictionary["id"] as Any?)
        XCTAssertNotNil(dictionary["name"] as Any?)
        XCTAssertNotNil(dictionary["message"] as Any?)
        XCTAssertNotNil(dictionary["currentState"] as Any?)
        XCTAssertNotNil(dictionary["endPoints"] as Any?)
        XCTAssertNotNil(dictionary["historyState"] as Any?)
    }
    
    func testAsDictionary_EndPointsArrayFormat() {
        let system = MockDAOSystemFactory.createMockWithTestData()
        let dictionary = system.asDictionary
        
        guard let endPointsArray = dictionary["endPoints"] as? [DNSDataDictionary] else {
            XCTFail("endPoints should be array of dictionaries")
            return
        }
        
        XCTAssertEqual(endPointsArray.count, 2)
        XCTAssertNotNil(endPointsArray[0]["id"] as Any?)
        XCTAssertNotNil(endPointsArray[1]["id"] as Any?)
    }
    
    func testAsDictionary_HistoryStateArrayFormat() {
        let system = MockDAOSystemFactory.createMockWithTestData()
        let dictionary = system.asDictionary
        
        guard let historyArray = dictionary["historyState"] as? [DNSDataDictionary] else {
            XCTFail("historyState should be array of dictionaries")
            return
        }
        
        XCTAssertEqual(historyArray.count, 2)
        XCTAssertNotNil(historyArray[0]["id"] as Any?)
        XCTAssertNotNil(historyArray[1]["id"] as Any?)
    }
    
    func testDao_FromDictionary_ReturnsCorrectData() {
        let system = DAOSystem()
        let data: DNSDataDictionary = [
            "name": "Updated System",
            "message": "Updated message",
            "currentState": ["id": "updated_state"],
            "endPoints": [["id": "new_endpoint"]],
            "historyState": [["id": "new_state"]]
        ]
        
        let result = system.dao(from: data)
        
        XCTAssertEqual(result.name.asString, "Updated System")
        XCTAssertEqual(result.message.asString, "Updated message")
        XCTAssertEqual(result.endPoints.count, 1)
        XCTAssertEqual(result.historyState.count, 1)
    }
    
    // MARK: - Codable Tests
    
    func testCodable_EncodeAndDecode_PreservesData() throws {
        let original = MockDAOSystemFactory.createMockWithTestData()
        
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(DAOSystem.self, from: encoded)
        
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.name.asString, original.name.asString)
        XCTAssertEqual(decoded.message.asString, original.message.asString)
        XCTAssertEqual(decoded.currentState.id, original.currentState.id)
        XCTAssertEqual(decoded.endPoints.count, original.endPoints.count)
        XCTAssertEqual(decoded.historyState.count, original.historyState.count)
    }
    
    func testCodable_EmptyObject_EncodesAndDecodes() throws {
        let original = DAOSystem()
        
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(DAOSystem.self, from: encoded)
        
        XCTAssertTrue(decoded.name.isEmpty)
        XCTAssertTrue(decoded.message.isEmpty)
        XCTAssertTrue(decoded.endPoints.isEmpty)
        XCTAssertTrue(decoded.historyState.isEmpty)
    }
    
    // MARK: - Copy Tests
    
    func testCopy_CreatesIndependentObject() {
        let original = MockDAOSystemFactory.createMockWithTestData()
        let copy = original.copy() as! DAOSystem
        
        XCTAssertTrue(original !== copy)
        XCTAssertEqual(original.id, copy.id)
        XCTAssertEqual(original.name.asString, copy.name.asString)
        XCTAssertEqual(original.message, copy.message)
    }
    
    func testCopy_ModifyingCopyDoesNotAffectOriginal() {
        let original = MockDAOSystemFactory.createMockWithTestData()
        let copy = original.copy() as! DAOSystem
        
        copy.name = DNSString(with: "Modified Name")
        copy.message = DNSString(with: "Modified Message")
        
        XCTAssertNotEqual(original.name, copy.name)
        XCTAssertNotEqual(original.message, copy.message)
    }
    
    // MARK: - Equality Tests
    
    func testEquality_SameObjects_ReturnsTrue() {
        let system1 = MockDAOSystemFactory.createMockWithTestData()
        let system2 = DAOSystem(from: system1)
        
        XCTAssertTrue(system1 == system2)
        XCTAssertFalse(system1 != system2)
    }
    
    func testEquality_DifferentNames_ReturnsFalse() {
        let system1 = MockDAOSystemFactory.createMockWithTestData()
        let system2 = DAOSystem(from: system1)
        system2.name = DNSString(with: "Different Name")
        
        XCTAssertFalse(system1 == system2)
        XCTAssertTrue(system1 != system2)
    }
    
    func testEquality_DifferentMessages_ReturnsFalse() {
        let system1 = MockDAOSystemFactory.createMockWithTestData()
        let system2 = DAOSystem(from: system1)
        system2.message = DNSString(with: "Different Message")
        
        XCTAssertFalse(system1 == system2)
        XCTAssertTrue(system1 != system2)
    }
    
    func testEquality_DifferentEndPoints_ReturnsFalse() {
        let system1 = MockDAOSystemFactory.createMockWithTestData()
        let system2 = DAOSystem(from: system1)
        system2.endPoints = []
        
        XCTAssertFalse(system1 == system2)
        XCTAssertTrue(system1 != system2)
    }
    
    func testEquality_DifferentHistoryState_ReturnsFalse() {
        let system1 = MockDAOSystemFactory.createMockWithTestData()
        let system2 = DAOSystem(from: system1)
        system2.historyState = []
        
        XCTAssertFalse(system1 == system2)
        XCTAssertTrue(system1 != system2)
    }
    
    func testIsDiffFrom_SameObjects_ReturnsFalse() {
        let system1 = MockDAOSystemFactory.createMockWithTestData()
        let system2 = DAOSystem(from: system1)
        
        XCTAssertFalse(system1.isDiffFrom(system2))
    }
    
    func testIsDiffFrom_DifferentObjects_ReturnsTrue() {
        let system1 = MockDAOSystemFactory.createMockWithTestData()
        let system2 = MockDAOSystemFactory.createMock()
        
        XCTAssertTrue(system1.isDiffFrom(system2))
    }
    
    func testIsDiffFrom_SameReference_ReturnsFalse() {
        let system = MockDAOSystemFactory.createMockWithTestData()
        
        XCTAssertFalse(system.isDiffFrom(system))
    }
    
    func testIsDiffFrom_NilObject_ReturnsTrue() {
        let system = MockDAOSystemFactory.createMockWithTestData()
        
        XCTAssertTrue(system.isDiffFrom(nil))
    }
    
    func testIsDiffFrom_DifferentType_ReturnsTrue() {
        let system = MockDAOSystemFactory.createMockWithTestData()
        let string = "not a system"
        
        XCTAssertTrue(system.isDiffFrom(string))
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyArrays_DoNotCauseCrash() {
        let system = DAOSystem()
        system.endPoints = []
        system.historyState = []
        
        XCTAssertNoThrow(system.asDictionary)
        XCTAssertNoThrow(system.copy())
    }
    
    func testLargeArrays_HandleCorrectly() {
        let system = DAOSystem()
        
        // Create large arrays
        let endpoints = (0..<100).map { _ in DAOSystemEndPoint() }
        let states = (0..<100).map { _ in DAOSystemState() }
        
        system.endPoints = endpoints
        system.historyState = states
        
        XCTAssertEqual(system.endPoints.count, 100)
        XCTAssertEqual(system.historyState.count, 100)
    }
    
    func testNilCurrentState_HandledCorrectly() {
        let system = DAOSystem()
        // currentState is initialized automatically in DAOSystem init
        XCTAssertNotNil(system.currentState)
    }
    
    // MARK: - Factory Method Tests
    
    func testCreateSystemEndPoint_ReturnsValidObject() {
        let endpoint = DAOSystem.createSystemEndPoint()
        
        XCTAssertNotNil(endpoint)
        XCTAssertTrue(endpoint is DAOSystemEndPoint)
    }
    
    func testCreateSystemState_ReturnsValidObject() {
        let state = DAOSystem.createSystemState()
        
        XCTAssertNotNil(state)
        XCTAssertTrue(state is DAOSystemState)
    }
    
    func testCreateSystemEndPoint_FromObject_CopiesCorrectly() {
        let original = DAOSystemEndPoint()
        original.id = "test_endpoint"
        
        let copy = DAOSystem.createSystemEndPoint(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertTrue(original !== copy)
    }
    
    func testCreateSystemState_FromObject_CopiesCorrectly() {
        let original = DAOSystemState()
        original.id = "test_state"
        
        let copy = DAOSystem.createSystemState(from: original)
        
        XCTAssertEqual(copy.id, original.id)
        XCTAssertTrue(original !== copy)
    }
    
    static var allTests = [
        ("testInit_Default_CreatesValidObject", testInit_Default_CreatesValidObject),
        ("testInit_WithId_CreatesValidObjectWithId", testInit_WithId_CreatesValidObjectWithId),
        ("testInit_FromObject_CopiesAllProperties", testInit_FromObject_CopiesAllProperties),
        ("testInit_FromDictionary_ValidData_CreatesObject", testInit_FromDictionary_ValidData_CreatesObject),
        ("testInit_FromDictionary_EmptyData_ReturnsNil", testInit_FromDictionary_EmptyData_ReturnsNil),
        ("testMessage_SetAndGet_WorksCorrectly", testMessage_SetAndGet_WorksCorrectly),
        ("testName_SetAndGet_WorksCorrectly", testName_SetAndGet_WorksCorrectly),
        ("testCurrentState_SetAndGet_WorksCorrectly", testCurrentState_SetAndGet_WorksCorrectly),
        ("testEndPoints_SetAndGet_WorksCorrectly", testEndPoints_SetAndGet_WorksCorrectly),
        ("testHistoryState_SetAndGet_WorksCorrectly", testHistoryState_SetAndGet_WorksCorrectly),
        ("testUpdate_FromObject_UpdatesAllProperties", testUpdate_FromObject_UpdatesAllProperties),
        ("testUpdate_FromEmptyObject_ClearsProperties", testUpdate_FromEmptyObject_ClearsProperties),
        ("testAsDictionary_ContainsAllProperties", testAsDictionary_ContainsAllProperties),
        ("testAsDictionary_EndPointsArrayFormat", testAsDictionary_EndPointsArrayFormat),
        ("testAsDictionary_HistoryStateArrayFormat", testAsDictionary_HistoryStateArrayFormat),
        ("testDao_FromDictionary_ReturnsCorrectData", testDao_FromDictionary_ReturnsCorrectData),
        ("testCodable_EncodeAndDecode_PreservesData", testCodable_EncodeAndDecode_PreservesData),
        ("testCodable_EmptyObject_EncodesAndDecodes", testCodable_EmptyObject_EncodesAndDecodes),
        ("testCopy_CreatesIndependentObject", testCopy_CreatesIndependentObject),
        ("testCopy_ModifyingCopyDoesNotAffectOriginal", testCopy_ModifyingCopyDoesNotAffectOriginal),
        ("testEquality_SameObjects_ReturnsTrue", testEquality_SameObjects_ReturnsTrue),
        ("testEquality_DifferentNames_ReturnsFalse", testEquality_DifferentNames_ReturnsFalse),
        ("testEquality_DifferentMessages_ReturnsFalse", testEquality_DifferentMessages_ReturnsFalse),
        ("testEquality_DifferentEndPoints_ReturnsFalse", testEquality_DifferentEndPoints_ReturnsFalse),
        ("testEquality_DifferentHistoryState_ReturnsFalse", testEquality_DifferentHistoryState_ReturnsFalse),
        ("testIsDiffFrom_SameObjects_ReturnsFalse", testIsDiffFrom_SameObjects_ReturnsFalse),
        ("testIsDiffFrom_DifferentObjects_ReturnsTrue", testIsDiffFrom_DifferentObjects_ReturnsTrue),
        ("testIsDiffFrom_SameReference_ReturnsFalse", testIsDiffFrom_SameReference_ReturnsFalse),
        ("testIsDiffFrom_NilObject_ReturnsTrue", testIsDiffFrom_NilObject_ReturnsTrue),
        ("testIsDiffFrom_DifferentType_ReturnsTrue", testIsDiffFrom_DifferentType_ReturnsTrue),
        ("testEmptyArrays_DoNotCauseCrash", testEmptyArrays_DoNotCauseCrash),
        ("testLargeArrays_HandleCorrectly", testLargeArrays_HandleCorrectly),
        ("testNilCurrentState_HandledCorrectly", testNilCurrentState_HandledCorrectly),
        ("testCreateSystemEndPoint_ReturnsValidObject", testCreateSystemEndPoint_ReturnsValidObject),
        ("testCreateSystemState_ReturnsValidObject", testCreateSystemState_ReturnsValidObject),
        ("testCreateSystemEndPoint_FromObject_CopiesCorrectly", testCreateSystemEndPoint_FromObject_CopiesCorrectly),
        ("testCreateSystemState_FromObject_CopiesCorrectly", testCreateSystemState_FromObject_CopiesCorrectly),
    ]
}
