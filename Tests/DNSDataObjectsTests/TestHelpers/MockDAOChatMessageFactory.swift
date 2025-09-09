//
//  MockDAOChatMessageFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOChatMessageFactory -
struct MockDAOChatMessageFactory: MockDAOFactory {
    typealias DAOType = DAOChatMessage
    
    static func createMock() -> DAOChatMessage {
        let chatMessage = DAOChatMessage()
        // Basic valid object with minimal data
        chatMessage.body = "Test message"
        chatMessage.chat = DAOChat()
        chatMessage.media = nil
        return chatMessage
    }
    
    static func createMockWithTestData() -> DAOChatMessage {
        let chatMessage = DAOChatMessage()
        
        // Realistic test data
        chatMessage.body = "Hello everyone! Hope you're having a great day."
        
        // Create test chat with participants
        let chat = DAOChat()
        chat.id = "chat_123"
        let account1 = DAOAccount()
        account1.id = "user_1"
        let account2 = DAOAccount()
        account2.id = "user_2"
        chat.participants = [account1, account2]
        chatMessage.chat = chat
        
        // Create test media attachment
        let media = DAOMedia()
        media.id = "media_1"
        chatMessage.media = media
        
        return chatMessage
    }
    
    static func createMockWithEdgeCases() -> DAOChatMessage {
        let chatMessage = DAOChatMessage()
        
        // Edge cases and boundary values
        chatMessage.body = "" // Empty message body
        chatMessage.chat = DAOChat() // Empty chat
        chatMessage.media = nil // No media
        
        return chatMessage
    }
    
    // MARK: - Safe Factory Methods (Pattern A)
    
    static func createSafeChatMessage() -> DAOChatMessage {
        let chatMessage = DAOChatMessage()
        // Create simple, different data to avoid complex copying issues
        chatMessage.body = "Safe test message"
        
        let safeChat = DAOChat()
        safeChat.id = "safe_chat"
        chatMessage.chat = safeChat
        
        let safeMedia = DAOMedia()
        safeMedia.id = "safe_media"
        chatMessage.media = safeMedia
        
        return chatMessage
    }
    
    static func createMockArray(count: Int) -> [DAOChatMessage] {
        var chatMessages: [DAOChatMessage] = []
        
        let messageTemplates = ["Hello!", "How are you?", "Great job!", "See you later", "Thanks!", "Good morning"]
        
        for i in 0..<count {
            let chatMessage = DAOChatMessage()
            chatMessage.id = "chatmessage\(i)" // Explicit ID already set correctly
            
            chatMessage.body = "\(messageTemplates[i % messageTemplates.count]) (\(i + 1))"
            
            // Create associated chat
            let chat = DAOChat()
            chat.id = "chat_\(i)"
            chatMessage.chat = chat
            
            // Every other gets media
            if i % 2 == 0 {
                let media = DAOMedia()
                media.id = "media_\(i)"
                chatMessage.media = media
            } else {
                chatMessage.media = nil
            }
            
            chatMessages.append(chatMessage)
        }
        
        return chatMessages
    }
}