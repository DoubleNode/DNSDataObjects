//
//  DNSPriceTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Currency
import DNSCore
@testable import DNSDataObjects

final class DNSPriceTests: XCTestCase {
    
    func testDNSPriceInitialization() {
        let price = DNSPrice()
        
        XCTAssertNotNil(price)
        XCTAssertEqual(price.price.exactAmount, Decimal(0))
        XCTAssertEqual(price.priority, DNSPriority.normal)
        XCTAssertEqual(price.startTime, Date.zeroTime)
        XCTAssertEqual(price.endTime, Date.zeroTime)
    }
    
    func testDNSPriceFromDataDictionary() {
        let testData: DNSDataDictionary = [
            "price": 25.50,
            "priority": DNSPriority.high,
            "startTime": Date().timeIntervalSince1970,
            "endTime": Date().addingTimeInterval(3600).timeIntervalSince1970
        ]
        
        let price = DNSPrice(from: testData)
        
        XCTAssertEqual(price.price.exactAmount, Decimal(25.50))
        XCTAssertEqual(price.priority, DNSPriority.high)
    }
    
    func testDNSPriceAsDictionary() {
        let price = DNSPrice()
        price.price = USD(exactAmount: Decimal(15.75))
        price.priority = DNSPriority.low
        
        let dictionary = price.asDictionary
        
        XCTAssertEqual(dictionary["price"] as? Decimal, Decimal(15.75))
        XCTAssertEqual(dictionary["priority"] as? Int, DNSPriority.low)
        XCTAssertNotNil(dictionary["startTime"] as Any?)
        XCTAssertNotNil(dictionary["endTime"] as Any?)
    }
    
    func testDNSPriceCopy() {
        let originalPrice = DNSPrice()
        originalPrice.price = USD(exactAmount: Decimal(100.00))
        originalPrice.priority = DNSPriority.highest
        
        let copiedPrice = originalPrice.copy() as! DNSPrice
        
        XCTAssertEqual(copiedPrice.price.exactAmount, originalPrice.price.exactAmount)
        XCTAssertEqual(copiedPrice.priority, originalPrice.priority)
        XCTAssertFalse(copiedPrice === originalPrice)
    }
    
    func testDNSPriceEquality() {
        let price1 = DNSPrice()
        price1.price = USD(exactAmount: Decimal(50.00))
        price1.priority = DNSPriority.normal
        
        let price2 = DNSPrice()
        price2.price = USD(exactAmount: Decimal(50.00))
        price2.priority = DNSPriority.normal
        
        let price3 = DNSPrice()
        price3.price = USD(exactAmount: Decimal(60.00))
        price3.priority = DNSPriority.normal
        
        XCTAssertTrue(price1 == price2)
        XCTAssertFalse(price1 == price3)
    }
    
    func testDNSPriceIsDiffFrom() {
        let price1 = DNSPrice()
        price1.price = USD(exactAmount: Decimal(25.00))
        
        let price2 = DNSPrice()
        price2.price = USD(exactAmount: Decimal(25.00))
        
        let price3 = DNSPrice()
        price3.price = USD(exactAmount: Decimal(30.00))
        
        XCTAssertFalse(price1.isDiffFrom(price2))
        XCTAssertTrue(price1.isDiffFrom(price3))
        XCTAssertTrue(price1.isDiffFrom("not a price"))
    }
    
    func testDNSPriceZeroAmount() {
        let price = DNSPrice()
        price.price = USD(exactAmount: Decimal(0))
        
        XCTAssertEqual(price.price.exactAmount, Decimal(0))
    }
    
    func testDNSPriceNegativeAmount() {
        let price = DNSPrice()
        price.price = USD(exactAmount: Decimal(-10.50))
        
        XCTAssertEqual(price.price.exactAmount, Decimal(-10.50))
    }
    
    func testDNSPricePriorityValidation() {
        let price = DNSPrice()
        
        // Test priority bounds
        price.priority = DNSPriority.highest + 10
        XCTAssertEqual(price.priority, DNSPriority.highest)
        
        price.priority = DNSPriority.none - 10
        XCTAssertEqual(price.priority, DNSPriority.none)
        
        price.priority = DNSPriority.normal
        XCTAssertEqual(price.priority, DNSPriority.normal)
    }
    
    func testDNSPriceCodable() throws {
        let originalPrice = DNSPrice()
        originalPrice.price = USD(exactAmount: Decimal(42.99))
        originalPrice.priority = DNSPriority.high
        
        let encodedData = try JSONEncoder().encode(originalPrice)
        let decodedPrice = try JSONDecoder().decode(DNSPrice.self, from: encodedData)
        
        XCTAssertEqual(decodedPrice.price.exactAmount, originalPrice.price.exactAmount)
        XCTAssertEqual(decodedPrice.priority, originalPrice.priority)
    }
    
    func testDNSPriceIsActive() {
        let price = DNSPrice()
        let now = Date()
        
        // Test active price (current time between start and end)
        price.startTime = now.addingTimeInterval(-3600).dnsTimePart // 1 hour ago
        price.endTime = now.addingTimeInterval(3600).dnsTimePart // 1 hour from now
        XCTAssertTrue(price.isActive)
        
        // Test inactive price (current time before start)
        price.startTime = now.addingTimeInterval(3600).dnsTimePart // 1 hour from now
        price.endTime = now.addingTimeInterval(7200).dnsTimePart // 2 hours from now
        XCTAssertFalse(price.isActive)
        
        // Test inactive price (current time after end)
        price.startTime = now.addingTimeInterval(-7200).dnsTimePart // 2 hours ago
        price.endTime = now.addingTimeInterval(-3600).dnsTimePart // 1 hour ago
        XCTAssertFalse(price.isActive)
    }
    
    nonisolated(unsafe) static var allTests = [
        ("testDNSPriceInitialization", testDNSPriceInitialization),
        ("testDNSPriceFromDataDictionary", testDNSPriceFromDataDictionary),
        ("testDNSPriceAsDictionary", testDNSPriceAsDictionary),
        ("testDNSPriceCopy", testDNSPriceCopy),
        ("testDNSPriceEquality", testDNSPriceEquality),
        ("testDNSPriceIsDiffFrom", testDNSPriceIsDiffFrom),
        ("testDNSPriceZeroAmount", testDNSPriceZeroAmount),
        ("testDNSPriceNegativeAmount", testDNSPriceNegativeAmount),
        ("testDNSPricePriorityValidation", testDNSPricePriorityValidation),
        ("testDNSPriceCodable", testDNSPriceCodable),
        ("testDNSPriceIsActive", testDNSPriceIsActive),
    ]
}
