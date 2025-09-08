//
//  DAOChatTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSDataObjects

final class DAOChatTests: XCTestCase {
    func testExample() {
        let chat = DAOChat()
        XCTAssertNotNil(chat)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}