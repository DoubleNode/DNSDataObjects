//
//  MockDAOMediaFactory.swift
//  DNSDataObjects Tests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOMediaFactory -
struct MockDAOMediaFactory: MockDAOFactory {
    typealias DAOType = DAOMedia
    
    static func createMock() -> DAOMedia {
        let media = DAOMedia()
        media.title = DNSString(with: "Test Media")
        return media
    }
    
    static func createMockWithTestData() -> DAOMedia {
        let media = DAOMedia()
        media.path = "/media/images"
        media.preloadUrl = DNSURL(with: URL(string: "https://cdn.example.com/preload.jpg"))
        media.title = DNSString(with: "Sample Image")
        media.type = .staticImage
        media.url = DNSURL(with: URL(string: "https://example.com/sample.jpg"))
        return media
    }
    
    static func createMockWithEdgeCases() -> DAOMedia {
        let media = DAOMedia()
        media.path = "/media/videos/promotional"
        media.preloadUrl = DNSURL(with: URL(string: "https://cdn.example.com/video-thumbnail.jpg"))
        media.title = DNSString(with: "Product Demonstration Video")
        media.type = .video
        media.url = DNSURL(with: URL(string: "https://example.com/demo.mp4"))
        return media
    }
    
    static func createMockArray(count: Int) -> [DAOMedia] {
        let types: [DNSMediaType] = [.staticImage, .video, .animatedImage, .unknown]
        
        return (0..<count).map { i in
            let media = DAOMedia()
            media.id = "media\(i)" // Set explicit ID to match test expectations
            media.title = DNSString(with: "Media \(i)")
            media.type = types[i % types.count]
            media.url = DNSURL(with: URL(string: "https://example.com/media\(i)"))
            return media
        }
    }
    
    // MARK: - Additional helper methods for complex testing
    
    static func createMockMediaWithDifferentTypes() -> [DAOMedia] {
        var mediaItems: [DAOMedia] = []
        
        // Image media
        let imageMedia = DAOMedia()
        imageMedia.title = DNSString(with: "Image Media")
        imageMedia.type = .staticImage
        imageMedia.url = DNSURL(with: URL(string: "https://example.com/image.jpg"))
        mediaItems.append(imageMedia)
        
        // Video media
        let videoMedia = DAOMedia()
        videoMedia.title = DNSString(with: "Video Media")
        videoMedia.type = .video
        videoMedia.url = DNSURL(with: URL(string: "https://example.com/video.mp4"))
        mediaItems.append(videoMedia)
        
        // Animated image media
        let animatedMedia = DAOMedia()
        animatedMedia.title = DNSString(with: "Animated Media")
        animatedMedia.type = .animatedImage
        animatedMedia.url = DNSURL(with: URL(string: "https://example.com/animated.gif"))
        mediaItems.append(animatedMedia)
        
        // Unknown type media
        let unknownMedia = DAOMedia()
        unknownMedia.title = DNSString(with: "Unknown Media")
        unknownMedia.type = .unknown
        unknownMedia.url = DNSURL(with: URL(string: "https://example.com/unknown"))
        mediaItems.append(unknownMedia)
        
        return mediaItems
    }
    
    // Dictionary creation for testing
    static func createMockMediaDictionary() -> DNSDataDictionary {
        return [
            "title": "Test Media Dictionary",
            "type": DNSMediaType.staticImage.rawValue,
            "url": "https://example.com/test.jpg",
            "path": "/test/media"
        ]
    }
    
    // MARK: - Test compatibility methods
    
    static func createCompleteMedia() -> DAOMedia {
        return createMockWithTestData()
    }
    
    static func createMinimalMedia() -> DAOMedia {
        let media = DAOMedia()
        media.title = DNSString(with: "Minimal Media")
        media.type = .unknown
        return media
    }
    
    static func createTypicalMedia() -> DAOMedia {
        return createMock()
    }
    
    static func createMediaWithDifferentTypes() -> [DAOMedia] {
        return createMockMediaWithDifferentTypes()
    }
}

// MARK: - Type alias for test compatibility
typealias DefaultMockDAOMediaFactory = MockDAOMediaFactory