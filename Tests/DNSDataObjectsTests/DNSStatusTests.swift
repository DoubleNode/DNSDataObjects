//
//  DNSStatusTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
@testable import DNSDataObjects

final class DNSStatusTests: XCTestCase {
    
    func testDNSStatusAllCases() {
        let allCases = DNSStatus.allCases
        
        XCTAssertFalse(allCases.isEmpty)
        XCTAssertTrue(allCases.contains(.open))
        XCTAssertTrue(allCases.contains(.closed))
        XCTAssertTrue(allCases.contains(.hidden))
        XCTAssertEqual(allCases.count, 11) // All defined cases
    }
    
    func testDNSStatusRawValues() {
        XCTAssertEqual(DNSStatus.open.rawValue, "open")
        XCTAssertEqual(DNSStatus.closed.rawValue, "closed")
        XCTAssertEqual(DNSStatus.hidden.rawValue, "hidden")
        XCTAssertEqual(DNSStatus.maintenance.rawValue, "maintenance")
    }
    
    func testDNSStatusFromRawValue() {
        XCTAssertEqual(DNSStatus(rawValue: "open"), .open)
        XCTAssertEqual(DNSStatus(rawValue: "closed"), .closed)
        XCTAssertEqual(DNSStatus(rawValue: "hidden"), .hidden)
        XCTAssertNil(DNSStatus(rawValue: "invalid"))
    }
    
    func testDNSStatusCodable() throws {
        let status = DNSStatus.open
        
        let encodedData = try JSONEncoder().encode(status)
        let decodedStatus = try JSONDecoder().decode(DNSStatus.self, from: encodedData)
        
        XCTAssertEqual(decodedStatus, status)
    }
    
    func testDNSStatusStringConvertible() {
        XCTAssertEqual("\(DNSStatus.open)", "open")
        XCTAssertEqual("\(DNSStatus.closed)", "closed")
        XCTAssertEqual("\(DNSStatus.hidden)", "hidden")
    }
    
    func testDNSStatusComparison() {
        XCTAssertEqual(DNSStatus.open, DNSStatus.open)
        XCTAssertNotEqual(DNSStatus.open, DNSStatus.closed)
        XCTAssertNotEqual(DNSStatus.hidden, DNSStatus.open)
    }
    
    nonisolated(unsafe) static var allTests = [
        ("testDNSStatusAllCases", testDNSStatusAllCases),
        ("testDNSStatusRawValues", testDNSStatusRawValues),
        ("testDNSStatusFromRawValue", testDNSStatusFromRawValue),
        ("testDNSStatusCodable", testDNSStatusCodable),
        ("testDNSStatusStringConvertible", testDNSStatusStringConvertible),
        ("testDNSStatusComparison", testDNSStatusComparison),
    ]
}