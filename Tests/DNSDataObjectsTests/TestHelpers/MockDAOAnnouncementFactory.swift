//
//  MockDAOAnnouncementFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOAnnouncementFactory -
struct MockDAOAnnouncementFactory: MockDAOFactory {
    typealias DAOType = DAOAnnouncement
    
    static func createMock() -> DAOAnnouncement {
        let announcement = DAOAnnouncement()
        announcement.title = DNSString(with: "Test Announcement")
        announcement.body = DNSString(with: "Test announcement body")
        announcement.distribution = DNSVisibility.everyone
        return announcement
    }
    
    static func createMockWithTestData() -> DAOAnnouncement {
        let announcement = DAOAnnouncement()
        announcement.id = "announcement123"
        
        announcement.body = DNSString(with: "This is the body of the announcement")
        announcement.distribution = DNSVisibility.everyone
        announcement.endTime = Date().addingTimeInterval(86400 * 30) // 30 days from now
        announcement.startTime = Date()
        announcement.subtitle = DNSString(with: "Announcement Subtitle")
        announcement.title = DNSString(with: "Important Announcement")
        
        // Create mock attachments
        let media1 = DAOMedia()
        media1.id = "media_1"
        let media2 = DAOMedia()
        media2.id = "media_2"
        announcement.attachments = [media1, media2]
        
        // Create mock chat
        let chat = DAOChat()
        chat.id = "chat_123"
        announcement.chat = chat
        
        // Create mock media items
        let mediaItem1 = DAOMedia()
        mediaItem1.id = "media_item_1"
        let mediaItem2 = DAOMedia()
        mediaItem2.id = "media_item_2"
        announcement.mediaItems = [mediaItem1, mediaItem2]
        
        return announcement
    }
    
    static func createMockWithEdgeCases() -> DAOAnnouncement {
        let announcement = DAOAnnouncement()
        
        // Edge cases
        announcement.title = DNSString() // Empty title
        announcement.body = DNSString() // Empty body
        announcement.distribution = DNSVisibility.everyone
        announcement.startTime = Date.distantPast
        announcement.endTime = Date.distantFuture
        announcement.subtitle = DNSString()
        announcement.attachments = [] // Empty attachments
        announcement.mediaItems = [] // Empty media items
        announcement.chat = DAOChat() // Default chat object
        
        return announcement
    }
    
    static func createMockArray(count: Int) -> [DAOAnnouncement] {
        let visibilityTypes: [DNSVisibility] = [.everyone, .adultsOnly, .staffOnly]
        
        return (0..<count).map { i in
            let announcement = DAOAnnouncement()
            announcement.id = "announcement\(i)" // Set explicit ID to match test expectations
            announcement.title = DNSString(with: "Announcement \(i)")
            announcement.body = DNSString(with: "Body for announcement \(i)")
            announcement.distribution = visibilityTypes[i % visibilityTypes.count]
            announcement.startTime = Date()
            announcement.endTime = Date().addingTimeInterval(TimeInterval(86400 * (i + 1))) // Different end times
            return announcement
        }
    }
    
    // MARK: - Additional helper methods for complex testing
    
    static func createMockAnnouncementWithAllVisibilityTypes() -> [DAOAnnouncement] {
        let visibilityTypes: [DNSVisibility] = [.everyone, .adultsOnly, .staffOnly]
        
        return visibilityTypes.enumerated().map { index, visibility in
            let announcement = createMock()
            announcement.id = "announcement_\(visibility.rawValue)"
            announcement.distribution = visibility
            announcement.title = DNSString(with: "Announcement for \(visibility.rawValue)")
            return announcement
        }
    }
    
    static func createMockAnnouncementWithTimeRanges() -> [DAOAnnouncement] {
        let now = Date()
        let pastAnnouncement = createMock()
        pastAnnouncement.id = "past_announcement"
        pastAnnouncement.startTime = now.addingTimeInterval(-86400 * 7) // 7 days ago
        pastAnnouncement.endTime = now.addingTimeInterval(-86400) // 1 day ago
        pastAnnouncement.title = DNSString(with: "Past Announcement")
        
        let currentAnnouncement = createMock()
        currentAnnouncement.id = "current_announcement"
        currentAnnouncement.startTime = now.addingTimeInterval(-86400) // 1 day ago
        currentAnnouncement.endTime = now.addingTimeInterval(86400 * 7) // 7 days from now
        currentAnnouncement.title = DNSString(with: "Current Announcement")
        
        let futureAnnouncement = createMock()
        futureAnnouncement.id = "future_announcement"
        futureAnnouncement.startTime = now.addingTimeInterval(86400) // 1 day from now
        futureAnnouncement.endTime = now.addingTimeInterval(86400 * 14) // 14 days from now
        futureAnnouncement.title = DNSString(with: "Future Announcement")
        
        return [pastAnnouncement, currentAnnouncement, futureAnnouncement]
    }
    
    // MARK: - Dictionary Creation
    
    static func createMockAnnouncementDictionary() -> DNSDataDictionary {
        return [
            "id": "announcement123",
            "body": "This is the body of the announcement",
            "distribution": DNSVisibility.everyone.rawValue,
            "endTime": Date().addingTimeInterval(86400 * 30),
            "startTime": Date(),
            "subtitle": "Announcement Subtitle",
            "title": "Important Announcement",
            "attachments": [
                createMockMediaDictionary(),
                createMockMediaDictionary()
            ],
            "chat": createMockChatDictionary(),
            "mediaItems": [
                createMockMediaDictionary(),
                createMockMediaDictionary()
            ]
        ]
    }
    
    static func createInvalidAnnouncementDictionary() -> DNSDataDictionary {
        return [
            "invalidProperty": "invalidValue",
            "distribution": "invalidVisibility"
        ]
    }
    
    // MARK: - Validation Helpers
    
    static func validateAnnouncementProperties(_ announcement: DAOAnnouncement) -> Bool {
        // Validate required properties exist and have expected types
        guard !announcement.title.asString.isEmpty else { return false }
        guard announcement.startTime <= announcement.endTime else { return false }
        
        // Validate distribution enum
        switch announcement.distribution {
        case .everyone, .adultsOnly, .staffYouth, .staffOnly, .adminOnly:
            break
//        default:
//            return false
        }
        
        return true
    }
    
    static func validateAnnouncementEquality(_ announcement1: DAOAnnouncement, _ announcement2: DAOAnnouncement) -> Bool {
        return announcement1.id == announcement2.id &&
               announcement1.body.asString == announcement2.body.asString &&
               announcement1.distribution == announcement2.distribution &&
               announcement1.title.asString == announcement2.title.asString &&
               announcement1.subtitle.asString == announcement2.subtitle.asString &&
               announcement1.startTime == announcement2.startTime &&
               announcement1.endTime == announcement2.endTime
    }
    
    // MARK: - Missing test methods expected by DAOAnnouncementTests
    
    static func createMockAnnouncement() -> DAOAnnouncement {
        return createMockWithTestData()
    }
    
    static func createMockAnnouncementArray(count: Int) -> [DAOAnnouncement] {
        return createMockArray(count: count)
    }
    
    static func createMockAnnouncementWithMinimalData() -> DAOAnnouncement {
        let announcement = DAOAnnouncement()
        announcement.title = DNSString(with: "Minimal Announcement")
        announcement.body = DNSString(with: "Minimal body")
        announcement.distribution = DNSVisibility.everyone
        return announcement
    }
    
    // MARK: - Dictionary methods used by existing factory code
    
    static func createMockMediaDictionary() -> DNSDataDictionary {
        return [
            "id": "media_123",
            "url": "https://example.com/media.jpg"
        ]
    }
    
    static func createMockChatDictionary() -> DNSDataDictionary {
        return [
            "id": "chat_123",
            "title": "Test Chat"
        ]
    }
}

// MARK: - Extensions for Test Support

extension DAOAnnouncement {
    var isActive: Bool {
        let now = Date()
        return startTime <= now && now <= endTime
    }
    
    var isPast: Bool {
        return endTime < Date()
    }
    
    var isFuture: Bool {
        return startTime > Date()
    }
}
