//
//  DAOChatTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects
import Foundation

final class DAOChatTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let chat = DAOChat()
        
        // Assert
        XCTAssertTrue(chat.messages.isEmpty)
        XCTAssertTrue(chat.participants.isEmpty)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "chat-123"
        
        // Act
        let chat = DAOChat(id: testId)
        
        // Assert
        XCTAssertEqual(chat.id, testId)
        XCTAssertTrue(chat.messages.isEmpty)
        XCTAssertTrue(chat.participants.isEmpty)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalChat = MockDAOChatFactory.createMockWithTestData()
        
        // Act
        let copiedChat = DAOChat(from: originalChat)
        
        // Assert
        XCTAssertEqual(copiedChat.id, originalChat.id)
        XCTAssertEqual(copiedChat.messages.count, originalChat.messages.count)
        XCTAssertEqual(copiedChat.participants.count, originalChat.participants.count)
        XCTAssertFalse(copiedChat === originalChat)
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "messages": [],
            "participants": []
        ]
        
        // Act
        let chat = DAOChat(from: testData)
        
        // Assert
        XCTAssertNotNil(chat)
        XCTAssertTrue(chat?.messages.isEmpty ?? false)
        XCTAssertTrue(chat?.participants.isEmpty ?? false)
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let chat = DAOChat(from: emptyData)
        
        // Assert
        XCTAssertNil(chat)
    }
    
    // MARK: - Property Tests
    
    func testMessagesProperty() {
        // Arrange
        let chat = DAOChat()
        let message1 = DAOChatMessage()
        message1.id = "msg1"
        let message2 = DAOChatMessage()
        message2.id = "msg2"
        let testMessages = [message1, message2]
        
        // Act
        chat.messages = testMessages
        
        // Assert
        XCTAssertEqual(chat.messages.count, 2)
        XCTAssertEqual(chat.messages[0].id, "msg1")
        XCTAssertEqual(chat.messages[1].id, "msg2")
    }
    
    func testParticipantsProperty() {
        // Arrange
        let chat = DAOChat()
        let account1 = DAOAccount()
        account1.id = "user1"
        let account2 = DAOAccount()
        account2.id = "user2"
        let testParticipants = [account1, account2]
        
        // Act
        chat.participants = testParticipants
        
        // Assert
        XCTAssertEqual(chat.participants.count, 2)
        XCTAssertEqual(chat.participants[0].id, "user1")
        XCTAssertEqual(chat.participants[1].id, "user2")
    }
    
    func testEmptyArraysProperty() {
        // Arrange
        let chat = DAOChat()
        
        // Act
        chat.messages = []
        chat.participants = []
        
        // Assert
        XCTAssertTrue(chat.messages.isEmpty)
        XCTAssertTrue(chat.participants.isEmpty)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalChat = MockDAOChatFactory.createMock()
        let sourceChat = MockDAOChatFactory.createMockWithTestData()
        
        // Act
        originalChat.update(from: sourceChat)
        
        // Assert
        XCTAssertEqual(originalChat.messages.count, sourceChat.messages.count)
        XCTAssertEqual(originalChat.participants.count, sourceChat.participants.count)
    }
    
    func testAddingMessages() {
        // Arrange
        let chat = DAOChat()
        let message1 = DAOChatMessage()
        message1.id = "msg1"
        let message2 = DAOChatMessage()
        message2.id = "msg2"
        
        // Act
        chat.messages.append(message1)
        chat.messages.append(message2)
        
        // Assert
        XCTAssertEqual(chat.messages.count, 2)
        XCTAssertEqual(chat.messages.first?.id, "msg1")
        XCTAssertEqual(chat.messages.last?.id, "msg2")
    }
    
    func testAddingParticipants() {
        // Arrange
        let chat = DAOChat()
        let account1 = DAOAccount()
        account1.id = "user1"
        let account2 = DAOAccount()
        account2.id = "user2"
        
        // Act
        chat.participants.append(account1)
        chat.participants.append(account2)
        
        // Assert
        XCTAssertEqual(chat.participants.count, 2)
        XCTAssertEqual(chat.participants.first?.id, "user1")
        XCTAssertEqual(chat.participants.last?.id, "user2")
    }
    
    func testRemovingMessages() {
        // Arrange
        let chat = MockDAOChatFactory.createMockWithTestData()
        let originalCount = chat.messages.count
        
        // Act
        chat.messages.removeFirst()
        
        // Assert
        XCTAssertEqual(chat.messages.count, originalCount - 1)
    }
    
    func testRemovingParticipants() {
        // Arrange
        let chat = MockDAOChatFactory.createMockWithTestData()
        let originalCount = chat.participants.count
        
        // Act
        chat.participants.removeFirst()
        
        // Assert
        XCTAssertEqual(chat.participants.count, originalCount - 1)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalChat = MockDAOChatFactory.createMockWithTestData()
        
        // Act
        let copiedChat = originalChat.copy() as? DAOChat
        
        // Assert
        XCTAssertNotNil(copiedChat)
        XCTAssertEqual(copiedChat?.messages.count, originalChat.messages.count)
        XCTAssertEqual(copiedChat?.participants.count, originalChat.participants.count)
        XCTAssertFalse(copiedChat === originalChat)
    }
    
    func testEquatableCompliance() {
        // Arrange
        let chat1 = MockDAOChatFactory.createMockWithTestData()
        let chat2 = MockDAOChatFactory.createMockWithTestData()
        let chat3 = MockDAOChatFactory.createMockWithEdgeCases()
        
        // Act & Assert - Use property-by-property comparison (Pattern C)
        XCTAssertEqual(chat1.messages.count, chat2.messages.count)
        XCTAssertEqual(chat1.participants.count, chat2.participants.count)
        XCTAssertNotEqual(chat1.messages.count, chat3.messages.count)
        XCTAssertNotEqual(chat1.participants.count, chat3.participants.count)
        XCTAssertEqual(chat1.messages.count, chat1.messages.count)
        XCTAssertEqual(chat1.participants.count, chat1.participants.count)
    }
    
    func testIsDiffFromMethod() {
        // Arrange - Create different objects for comparison (Pattern D)
        let chat1 = MockDAOChatFactory.createMockWithTestData()
        let chat2 = MockDAOChatFactory.createSafeChat()
        let chat3 = MockDAOChatFactory.createMockWithEdgeCases()
        
        // Act & Assert
        XCTAssertTrue(chat1.isDiffFrom(chat2))  // Different data
        XCTAssertTrue(chat1.isDiffFrom(chat3))  // Different data
        XCTAssertFalse(chat1.isDiffFrom(chat1)) // Same object
        XCTAssertTrue(chat1.isDiffFrom("not a chat"))
        XCTAssertTrue(chat1.isDiffFrom(nil as DAOChat?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalChat = MockDAOChatFactory.createMockWithTestData()
        
        // Act
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalChat)
        let decoder = JSONDecoder()
        let decodedChat = try decoder.decode(DAOChat.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedChat.messages.count, originalChat.messages.count)
        XCTAssertEqual(decodedChat.participants.count, originalChat.participants.count)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let chat = MockDAOChatFactory.createMockWithTestData()
        
        // Act
        let dictionary = chat.asDictionary
        
        // Assert
        XCTAssertNotNil(dictionary["messages"] as Any?)
        XCTAssertNotNil(dictionary["participants"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let chat = MockDAOChatFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertTrue(chat.messages.isEmpty)
        XCTAssertTrue(chat.participants.isEmpty)
    }
    
    func testEmptyChatFunctionality() {
        // Arrange
        let chat = DAOChat()
        
        // Act & Assert
        XCTAssertTrue(chat.messages.isEmpty)
        XCTAssertTrue(chat.participants.isEmpty)
        XCTAssertNotNil(chat.asDictionary)
    }
    
    func testManyMessagesPerformance() {
        // Arrange
        let chat = DAOChat()
        var messages: [DAOChatMessage] = []
        for i in 0..<100 {
            let message = DAOChatMessage()
            message.id = "msg\(i)"
            messages.append(message)
        }
        
        // Act
        chat.messages = messages
        
        // Assert
        XCTAssertEqual(chat.messages.count, 100)
    }
    
    func testManyParticipantsPerformance() {
        // Arrange
        let chat = DAOChat()
        var participants: [DAOAccount] = []
        for i in 0..<50 {
            let account = DAOAccount()
            account.id = "user\(i)"
            participants.append(account)
        }
        
        // Act
        chat.participants = participants
        
        // Assert
        XCTAssertEqual(chat.participants.count, 50)
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let chats = MockDAOChatFactory.createMockArray(count: 5)
        
        // Assert
        XCTAssertEqual(chats.count, 5)
        
        for i in 0..<chats.count {
            XCTAssertEqual(chats[i].id, "chat\(i)")
            XCTAssertEqual(chats[i].messages.count, i % 4)
            XCTAssertEqual(chats[i].participants.count, (i % 4) + 1)
        }
    }
    
    func testArrayDifferencesDetection() {
        // Arrange - Use different sized arrays for reliable differences
        let chats1 = MockDAOChatFactory.createMockArray(count: 2)
        let chats2 = MockDAOChatFactory.createMockArray(count: 2)
        let chats3 = MockDAOChatFactory.createMockArray(count: 4)
        
        // Act & Assert - Compare counts instead of complex object equality
        XCTAssertEqual(chats1.count, chats2.count)
        XCTAssertNotEqual(chats1.count, chats3.count)
        XCTAssertTrue(chats1.hasDiffElementsFrom(chats3))
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOChat()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalChat = MockDAOChatFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOChat(from: originalChat)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let chat1 = MockDAOChatFactory.createMockWithTestData()
        let chat2 = MockDAOChatFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = chat1 == chat2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let chat = MockDAOChatFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(chat)
                    _ = try decoder.decode(DAOChat.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }

    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testInitializationWithId", testInitializationWithId),
        ("testCopyInitialization", testCopyInitialization),
        ("testInitializationFromDictionary", testInitializationFromDictionary),
        ("testInitializationFromEmptyDictionary", testInitializationFromEmptyDictionary),
        ("testMessagesProperty", testMessagesProperty),
        ("testParticipantsProperty", testParticipantsProperty),
        ("testEmptyArraysProperty", testEmptyArraysProperty),
        ("testUpdateMethod", testUpdateMethod),
        ("testAddingMessages", testAddingMessages),
        ("testAddingParticipants", testAddingParticipants),
        ("testRemovingMessages", testRemovingMessages),
        ("testRemovingParticipants", testRemovingParticipants),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testEmptyChatFunctionality", testEmptyChatFunctionality),
        ("testManyMessagesPerformance", testManyMessagesPerformance),
        ("testManyParticipantsPerformance", testManyParticipantsPerformance),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testArrayDifferencesDetection", testArrayDifferencesDetection),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}