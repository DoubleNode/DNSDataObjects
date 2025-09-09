//
//  MockDAOChatFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOChatFactory -
struct MockDAOChatFactory: MockDAOFactory {
    typealias DAOType = DAOChat
    
    static func createMock() -> DAOChat {
        let chat = DAOChat()
        // Basic valid object with minimal data
        chat.messages = []
        chat.participants = []
        return chat
    }
    
    static func createMockWithTestData() -> DAOChat {
        let chat = DAOChat()
        
        // Create test messages
        let message1 = DAOChatMessage()
        message1.id = "msg_1"
        let message2 = DAOChatMessage()
        message2.id = "msg_2"
        chat.messages = [message1, message2]
        
        // Create test participants (accounts)
        let account1 = DAOAccount()
        account1.id = "account_1"
        let account2 = DAOAccount()
        account2.id = "account_2"
        chat.participants = [account1, account2]
        
        return chat
    }
    
    static func createMockWithEdgeCases() -> DAOChat {
        let chat = DAOChat()
        
        // Edge cases and boundary values - empty collections
        chat.messages = []
        chat.participants = []
        
        return chat
    }
    
    // MARK: - Safe Factory Methods (Pattern A)
    
    static func createSafeChat() -> DAOChat {
        let chat = DAOChat()
        // Create simple, different data to avoid complex copying issues
        let safeMessage = DAOChatMessage()
        safeMessage.id = "safe_msg"
        chat.messages = [safeMessage]
        
        let safeAccount = DAOAccount()
        safeAccount.id = "safe_account"
        chat.participants = [safeAccount]
        
        return chat
    }
    
    static func createMockArray(count: Int) -> [DAOChat] {
        var chats: [DAOChat] = []
        
        for i in 0..<count {
            let chat = DAOChat()
            chat.id = "chat\(i)" // Explicit ID already set correctly
            
            // Variable number of messages (0 to 3)
            let messageCount = i % 4
            var messages: [DAOChatMessage] = []
            for j in 0..<messageCount {
                let message = DAOChatMessage()
                message.id = "msg_\(i)_\(j)"
                messages.append(message)
            }
            chat.messages = messages
            
            // Variable number of participants (1 to 4)
            let participantCount = (i % 4) + 1
            var participants: [DAOAccount] = []
            for j in 0..<participantCount {
                let account = DAOAccount()
                account.id = "account_\(i)_\(j)"
                participants.append(account)
            }
            chat.participants = participants
            
            chats.append(chat)
        }
        
        return chats
    }
    
    // MARK: - Dictionary creation for testing
    
    static func createMockChatDictionary() -> DNSDataDictionary {
        return [
            "id": "test_chat",
            "messages": [],
            "participants": []
        ]
    }
}