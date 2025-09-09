//
//  DAOChatMessageTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects
import Foundation

final class DAOChatMessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let chatMessage = DAOChatMessage()
        
        // Assert
        XCTAssertEqual(chatMessage.body, "")
        XCTAssertNotNil(chatMessage.chat)
        XCTAssertNil(chatMessage.media)
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "message-123"
        
        // Act
        let chatMessage = DAOChatMessage(id: testId)
        
        // Assert
        XCTAssertEqual(chatMessage.id, testId)
        XCTAssertEqual(chatMessage.body, "")
        XCTAssertNotNil(chatMessage.chat)
        XCTAssertNil(chatMessage.media)
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalMessage = MockDAOChatMessageFactory.createMockWithTestData()
        
        // Act
        let copiedMessage = DAOChatMessage(from: originalMessage)
        
        // Assert
        XCTAssertEqual(copiedMessage.id, originalMessage.id)
        XCTAssertEqual(copiedMessage.body, originalMessage.body)
        XCTAssertEqual(copiedMessage.chat.id, originalMessage.chat.id)
        XCTAssertEqual(copiedMessage.media?.id, originalMessage.media?.id)
        XCTAssertFalse(copiedMessage === originalMessage)
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "body": "Test message from dictionary",
            "chat": ["id": "chat_test"],
            "media": ["id": "media_test"]
        ]
        
        // Act
        let chatMessage = DAOChatMessage(from: testData)
        
        // Assert
        XCTAssertNotNil(chatMessage)
        XCTAssertEqual(chatMessage?.body, "Test message from dictionary")
        XCTAssertEqual(chatMessage?.chat.id, "chat_test")
        XCTAssertEqual(chatMessage?.media?.id, "media_test")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let chatMessage = DAOChatMessage(from: emptyData)
        
        // Assert
        XCTAssertNil(chatMessage)
    }
    
    // MARK: - Property Tests
    
    func testBodyProperty() {
        // Arrange
        let chatMessage = DAOChatMessage()
        let testBody = "This is a test message with emojis 🎉"
        
        // Act
        chatMessage.body = testBody
        
        // Assert
        XCTAssertEqual(chatMessage.body, testBody)
    }
    
    func testChatProperty() {
        // Arrange
        let chatMessage = DAOChatMessage()
        let testChat = DAOChat()
        testChat.id = "new_chat_123"
        
        // Act
        chatMessage.chat = testChat
        
        // Assert
        XCTAssertEqual(chatMessage.chat.id, testChat.id)
    }
    
    func testMediaProperty() {
        // Arrange
        let chatMessage = DAOChatMessage()
        let testMedia = DAOMedia()
        testMedia.id = "image_attachment_456"
        
        // Act
        chatMessage.media = testMedia
        
        // Assert
        XCTAssertEqual(chatMessage.media?.id, testMedia.id)
    }
    
    func testNilMediaProperty() {
        // Arrange
        let chatMessage = DAOChatMessage()
        
        // Act
        chatMessage.media = nil
        
        // Assert
        XCTAssertNil(chatMessage.media)
    }
    
    func testEmptyBodyProperty() {
        // Arrange
        let chatMessage = DAOChatMessage()
        
        // Act
        chatMessage.body = ""
        
        // Assert
        XCTAssertEqual(chatMessage.body, "")
        XCTAssertTrue(chatMessage.body.isEmpty)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalMessage = MockDAOChatMessageFactory.createMock()
        let sourceMessage = MockDAOChatMessageFactory.createMockWithTestData()
        
        // Act
        originalMessage.update(from: sourceMessage)
        
        // Assert
        XCTAssertEqual(originalMessage.body, sourceMessage.body)
        XCTAssertEqual(originalMessage.chat.id, sourceMessage.chat.id)
        XCTAssertEqual(originalMessage.media?.id, sourceMessage.media?.id)
    }
    
    func testMessageWithAttachment() {
        // Arrange
        let chatMessage = DAOChatMessage()
        chatMessage.body = "Check out this image!"
        
        let media = DAOMedia()
        media.id = "image_123"
        
        // Act
        chatMessage.media = media
        
        // Assert
        XCTAssertEqual(chatMessage.body, "Check out this image!")
        XCTAssertNotNil(chatMessage.media)
        XCTAssertEqual(chatMessage.media?.id, "image_123")
    }
    
    func testMessageWithoutAttachment() {
        // Arrange
        let chatMessage = DAOChatMessage()
        chatMessage.body = "Simple text message"
        
        // Act
        chatMessage.media = nil
        
        // Assert
        XCTAssertEqual(chatMessage.body, "Simple text message")
        XCTAssertNil(chatMessage.media)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalMessage = MockDAOChatMessageFactory.createMockWithTestData()
        
        // Act
        let copiedMessage = originalMessage.copy() as? DAOChatMessage
        
        // Assert
        XCTAssertNotNil(copiedMessage)
        XCTAssertEqual(copiedMessage?.body, originalMessage.body)
        XCTAssertEqual(copiedMessage?.chat.id, originalMessage.chat.id)
        XCTAssertEqual(copiedMessage?.media?.id, originalMessage.media?.id)
        XCTAssertFalse(copiedMessage === originalMessage)
    }
    
    func testEquatableCompliance() {
        // Arrange
        let message1 = MockDAOChatMessageFactory.createMockWithTestData()
        let message2 = MockDAOChatMessageFactory.createMockWithTestData()
        let message3 = MockDAOChatMessageFactory.createMockWithEdgeCases()
        
        // Act & Assert - Use property-by-property comparison (Pattern C)
        XCTAssertEqual(message1.body, message2.body)
        XCTAssertEqual(message1.chat.id, message2.chat.id)
        XCTAssertEqual(message1.media?.id, message2.media?.id)
        XCTAssertNotEqual(message1.body, message3.body)
        XCTAssertEqual(message1.body, message1.body)
        XCTAssertEqual(message1.chat.id, message1.chat.id)
    }
    
    func testIsDiffFromMethod() {
        // Arrange - Create different objects for comparison (Pattern D)
        let message1 = MockDAOChatMessageFactory.createMockWithTestData()
        let message2 = MockDAOChatMessageFactory.createSafeChatMessage()
        let message3 = MockDAOChatMessageFactory.createMockWithEdgeCases()
        
        // Act & Assert
        XCTAssertTrue(message1.isDiffFrom(message2))  // Different data
        XCTAssertTrue(message1.isDiffFrom(message3))  // Different data
        XCTAssertFalse(message1.isDiffFrom(message1)) // Same object
        XCTAssertTrue(message1.isDiffFrom("not a message"))
        XCTAssertTrue(message1.isDiffFrom(nil as DAOChatMessage?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalMessage = MockDAOChatMessageFactory.createMockWithTestData()
        
        // Act
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalMessage)
        let decoder = JSONDecoder()
        let decodedMessage = try decoder.decode(DAOChatMessage.self, from: encodedData)
        
        // Assert
        XCTAssertEqual(decodedMessage.body, originalMessage.body)
        XCTAssertEqual(decodedMessage.chat.id, originalMessage.chat.id)
        XCTAssertEqual(decodedMessage.media?.id, originalMessage.media?.id)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let chatMessage = MockDAOChatMessageFactory.createMockWithTestData()
        
        // Act
        let dictionary = chatMessage.asDictionary
        
        // Assert
        XCTAssertEqual(dictionary["body"] as? String, chatMessage.body)
        XCTAssertNotNil(dictionary["chat"] as Any?)
        XCTAssertNotNil(dictionary["media"] as Any?)
    }
    
    // MARK: - Edge Case Tests
    
    func testEdgeCaseValues() {
        // Arrange & Act
        let chatMessage = MockDAOChatMessageFactory.createMockWithEdgeCases()
        
        // Assert
        XCTAssertEqual(chatMessage.body, "")
        XCTAssertNotNil(chatMessage.chat)
        XCTAssertNil(chatMessage.media)
    }
    
    func testVeryLongMessage() {
        // Arrange
        let chatMessage = DAOChatMessage()
        let longMessage = String(repeating: "A", count: 5000)
        
        // Act
        chatMessage.body = longMessage
        
        // Assert
        XCTAssertEqual(chatMessage.body, longMessage)
        XCTAssertEqual(chatMessage.body.count, 5000)
    }
    
    func testMessageWithSpecialCharacters() {
        // Arrange
        let chatMessage = DAOChatMessage()
        let specialMessage = "Hello! 🌟 Special chars: @#$%^&*()_+{}|:<>?[];'\",./"
        
        // Act
        chatMessage.body = specialMessage
        
        // Assert
        XCTAssertEqual(chatMessage.body, specialMessage)
    }
    
    func testMessageWithUnicodeEmojis() {
        // Arrange
        let chatMessage = DAOChatMessage()
        let emojiMessage = "🎉 Party time! 🥳🎊 Let's celebrate! 🍰🎈"
        
        // Act
        chatMessage.body = emojiMessage
        
        // Assert
        XCTAssertEqual(chatMessage.body, emojiMessage)
    }
    
    // MARK: - Array Tests
    
    func testMockArrayCreation() {
        // Arrange & Act
        let chatMessages = MockDAOChatMessageFactory.createMockArray(count: 6)
        
        // Assert
        XCTAssertEqual(chatMessages.count, 6)
        
        for i in 0..<chatMessages.count {
            XCTAssertFalse(chatMessages[i].body.isEmpty)
            XCTAssertNotNil(chatMessages[i].chat)
            XCTAssertEqual(chatMessages[i].chat.id, "chat_\(i)")
            
            // Every other message has media
            if i % 2 == 0 {
                XCTAssertNotNil(chatMessages[i].media)
                XCTAssertEqual(chatMessages[i].media?.id, "media_\(i)")
            } else {
                XCTAssertNil(chatMessages[i].media)
            }
        }
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOChatMessage()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalMessage = MockDAOChatMessageFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOChatMessage(from: originalMessage)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let message1 = MockDAOChatMessageFactory.createMockWithTestData()
        let message2 = MockDAOChatMessageFactory.createMockWithTestData()
        
        measure {
            for _ in 0..<1000 {
                _ = message1 == message2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let chatMessage = MockDAOChatMessageFactory.createMockWithTestData()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(chatMessage)
                    _ = try decoder.decode(DAOChatMessage.self, from: data)
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
        ("testBodyProperty", testBodyProperty),
        ("testChatProperty", testChatProperty),
        ("testMediaProperty", testMediaProperty),
        ("testNilMediaProperty", testNilMediaProperty),
        ("testEmptyBodyProperty", testEmptyBodyProperty),
        ("testUpdateMethod", testUpdateMethod),
        ("testMessageWithAttachment", testMessageWithAttachment),
        ("testMessageWithoutAttachment", testMessageWithoutAttachment),
        ("testNSCopyingCompliance", testNSCopyingCompliance),
        ("testEquatableCompliance", testEquatableCompliance),
        ("testIsDiffFromMethod", testIsDiffFromMethod),
        ("testCodableCompliance", testCodableCompliance),
        ("testAsDictionaryConversion", testAsDictionaryConversion),
        ("testEdgeCaseValues", testEdgeCaseValues),
        ("testVeryLongMessage", testVeryLongMessage),
        ("testMessageWithSpecialCharacters", testMessageWithSpecialCharacters),
        ("testMessageWithUnicodeEmojis", testMessageWithUnicodeEmojis),
        ("testMockArrayCreation", testMockArrayCreation),
        ("testInitializationPerformance", testInitializationPerformance),
        ("testCopyPerformance", testCopyPerformance),
        ("testEquatablePerformance", testEquatablePerformance),
        ("testCodablePerformance", testCodablePerformance),
    ]
}
