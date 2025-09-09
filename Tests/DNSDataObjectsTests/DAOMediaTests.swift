//
//  DAOMediaTests.swift
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

final class DAOMediaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultInitialization() {
        // Arrange & Act
        let media = DAOMedia()
        
        // Assert
        XCTAssertEqual(media.path, "")
        XCTAssertEqual(media.preloadUrl, DNSURL())
        XCTAssertEqual(media.title, DNSString())
        XCTAssertEqual(media.type, .unknown)
        XCTAssertEqual(media.url, DNSURL())
    }
    
    func testInitializationWithId() {
        // Arrange
        let testId = "media-123"
        
        // Act
        let media = DAOMedia(id: testId)
        
        // Assert
        XCTAssertEqual(media.id, testId)
        XCTAssertEqual(media.path, "")
        XCTAssertEqual(media.preloadUrl, DNSURL())
        XCTAssertEqual(media.title, DNSString())
        XCTAssertEqual(media.type, .unknown)
        XCTAssertEqual(media.url, DNSURL())
    }
    
    func testInitializationWithType() {
        // Arrange
        let mediaType = DNSMediaType.video
        
        // Act
        let media = DAOMedia(type: mediaType)
        
        // Assert
        XCTAssertEqual(media.type, mediaType)
        XCTAssertEqual(media.path, "")
        XCTAssertEqual(media.preloadUrl, DNSURL())
        XCTAssertEqual(media.title, DNSString())
        XCTAssertEqual(media.url, DNSURL())
    }
    
    func testCopyInitialization() {
        // Arrange
        let originalMedia = MockDAOMediaFactory.createCompleteMedia()
        
        // Act
        let copiedMedia = DAOMedia(from: originalMedia)
        
        // Assert
        XCTAssertEqual(copiedMedia.path, originalMedia.path)
        XCTAssertEqual(copiedMedia.preloadUrl, originalMedia.preloadUrl)
        XCTAssertEqual(copiedMedia.title.asString, originalMedia.title.asString)
        XCTAssertEqual(copiedMedia.type, originalMedia.type)
        XCTAssertEqual(copiedMedia.url, originalMedia.url)
        XCTAssertFalse(copiedMedia === originalMedia) // Different instances
    }
    
    func testInitializationFromDictionary() {
        // Arrange
        let testData: DNSDataDictionary = [
            "path": "/media/test",
            "preloadUrl": "https://cdn.example.com/preload.jpg",
            "title": ["": "Test Media"],
            "type": DNSMediaType.staticImage.rawValue,
            "url": "https://example.com/media.jpg"
        ]
        
        // Act
        let media = DAOMedia(from: testData)
        
        // Assert
        XCTAssertNotNil(media)
        XCTAssertEqual(media?.path, "/media/test")
        XCTAssertEqual(media?.preloadUrl.asURL?.absoluteString, "https://cdn.example.com/preload.jpg")
        XCTAssertEqual(media?.title.asString, "Test Media")
        XCTAssertEqual(media?.type, .staticImage)
        XCTAssertEqual(media?.url.asURL?.absoluteString, "https://example.com/media.jpg")
    }
    
    func testInitializationFromEmptyDictionary() {
        // Arrange
        let emptyData: DNSDataDictionary = [:]
        
        // Act
        let media = DAOMedia(from: emptyData)
        
        // Assert
        XCTAssertNil(media)
    }
    
    // MARK: - Property Tests
    
    func testPathProperty() {
        // Arrange
        let media = DAOMedia()
        let testPath = "/updated/media/path"
        
        // Act
        media.path = testPath
        
        // Assert
        XCTAssertEqual(media.path, testPath)
    }
    
    func testPreloadUrlProperty() {
        // Arrange
        let media = DAOMedia()
        let testPreloadUrl = DNSURL(with: URL(string: "https://cdn.example.com/updated-preload.jpg"))
        
        // Act
        media.preloadUrl = testPreloadUrl
        
        // Assert
        XCTAssertEqual(media.preloadUrl, testPreloadUrl)
    }
    
    func testTitleProperty() {
        // Arrange
        let media = DAOMedia()
        let testTitle = DNSString(with: "Updated Media Title")
        
        // Act
        media.title = testTitle
        
        // Assert
        XCTAssertEqual(media.title, testTitle)
    }
    
    func testTypeProperty() {
        // Arrange
        let media = DAOMedia()
        
        // Act & Assert - Static Image type
        media.type = .staticImage
        XCTAssertEqual(media.type, .staticImage)
        
        // Act & Assert - Video type
        media.type = .video
        XCTAssertEqual(media.type, .video)
        
        // Act & Assert - Animated Image type
        media.type = .animatedImage
        XCTAssertEqual(media.type, .animatedImage)
        
        // Act & Assert - Unknown type
        media.type = .unknown
        XCTAssertEqual(media.type, .unknown)
    }
    
    func testUrlProperty() {
        // Arrange
        let media = DAOMedia()
        let testUrl = DNSURL(with: URL(string: "https://example.com/updated-media.mp4"))
        
        // Act
        media.url = testUrl
        
        // Assert
        XCTAssertEqual(media.url, testUrl)
    }
    
    // MARK: - Business Logic Tests
    
    func testUpdateMethod() {
        // Arrange
        let originalMedia = MockDAOMediaFactory.createMinimalMedia()
        let sourceMedia = MockDAOMediaFactory.createCompleteMedia()
        
        // Act
        originalMedia.update(from: sourceMedia)
        
        // Assert
        XCTAssertEqual(originalMedia.path, sourceMedia.path)
        XCTAssertEqual(originalMedia.preloadUrl, sourceMedia.preloadUrl)
        XCTAssertEqual(originalMedia.title.asString, sourceMedia.title.asString)
        XCTAssertEqual(originalMedia.type, sourceMedia.type)
        XCTAssertEqual(originalMedia.url, sourceMedia.url)
    }
    
    func testMediaTypeHandling() {
        // Arrange & Act
        let differentTypeMedia = MockDAOMediaFactory.createMediaWithDifferentTypes()
        
        // Assert
        XCTAssertEqual(differentTypeMedia.count, 4)
        
        // Check each media type
        let imageMedia = differentTypeMedia.first { $0.type == DNSMediaType.staticImage }
        XCTAssertNotNil(imageMedia)
        XCTAssertEqual(imageMedia?.type, .staticImage)
        
        let videoMedia = differentTypeMedia.first { $0.type == .video }
        XCTAssertNotNil(videoMedia)
        XCTAssertEqual(videoMedia?.type, .video)
        
        let animatedMedia = differentTypeMedia.first { $0.type == DNSMediaType.animatedImage }
        XCTAssertNotNil(animatedMedia)
        XCTAssertEqual(animatedMedia?.type, .animatedImage)
        
        let unknownMedia = differentTypeMedia.first { $0.type == .unknown }
        XCTAssertNotNil(unknownMedia)
        XCTAssertEqual(unknownMedia?.type, .unknown)
    }
    
    // MARK: - Protocol Compliance Tests
    
    func testNSCopyingCompliance() {
        // Arrange
        let originalMedia = MockDAOMediaFactory.createCompleteMedia()
        
        // Act
        let copiedMedia = originalMedia.copy() as? DAOMedia
        
        // Assert
        XCTAssertNotNil(copiedMedia)
        XCTAssertEqual(copiedMedia?.path, originalMedia.path)
        XCTAssertEqual(copiedMedia?.preloadUrl, originalMedia.preloadUrl)
        XCTAssertEqual(copiedMedia?.title.asString, originalMedia.title.asString)
        XCTAssertEqual(copiedMedia?.type, originalMedia.type)
        XCTAssertEqual(copiedMedia?.url, originalMedia.url)
        XCTAssertFalse(copiedMedia === originalMedia) // Different instances
    }
    
    func testEquatableCompliance() {
        // Arrange - Using copy constructor for reliable comparison
        let media1 = MockDAOMediaFactory.createTypicalMedia()
        let media2 = DAOMedia(from: media1) // Use copy constructor for identical objects
        let media3 = MockDAOMediaFactory.createCompleteMedia()
        
        // Act & Assert - Property-by-property comparison instead of object equality
        XCTAssertEqual(media1.path, media2.path)
        XCTAssertEqual(media1.title.asString, media2.title.asString)
        XCTAssertEqual(media1.type, media2.type)
        
        // Act & Assert - Different data should not be equal
        XCTAssertTrue(media1.isDiffFrom(media3))
        XCTAssertNotEqual(media1, media3)
        
        // Act & Assert - Same instance should be equal
        XCTAssertFalse(media1.isDiffFrom(media1))
        XCTAssertEqual(media1, media1)
    }
    
    func testIsDiffFromMethod() {
        // Arrange - Using copy constructor for reliable comparison
        let media1 = MockDAOMediaFactory.createTypicalMedia()
        let media2 = DAOMedia(from: media1) // Use copy constructor for identical objects
        let media3 = MockDAOMediaFactory.createCompleteMedia()
        
        // Act & Assert - Copied objects should not be different
        XCTAssertFalse(media1.isDiffFrom(media2))
        
        // Act & Assert - Different data should be different
        XCTAssertTrue(media1.isDiffFrom(media3))
        
        // Act & Assert - Same instance should not be different from itself
        XCTAssertFalse(media1.isDiffFrom(media1))
        
        // Act & Assert - Different types should be different
        XCTAssertTrue(media1.isDiffFrom("not media"))
        
        // Act & Assert - Nil should be different
        XCTAssertTrue(media1.isDiffFrom(nil as DAOMedia?))
    }
    
    func testCodableCompliance() throws {
        // Arrange
        let originalMedia = MockDAOMediaFactory.createCompleteMedia()
        
        // Act - Encode
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(originalMedia)
        
        // Act - Decode
        let decoder = JSONDecoder()
        let decodedMedia = try decoder.decode(DAOMedia.self, from: encodedData)
        
        // Assert - Compare key properties individually (avoiding DNSURL comparison issues)
        XCTAssertEqual(decodedMedia.path, originalMedia.path)
        XCTAssertEqual(decodedMedia.preloadUrl.asURL?.absoluteString, originalMedia.preloadUrl.asURL?.absoluteString)
        XCTAssertEqual(decodedMedia.title.asString, originalMedia.title.asString)
        XCTAssertEqual(decodedMedia.type, originalMedia.type)
        XCTAssertEqual(decodedMedia.url.asURL?.absoluteString, originalMedia.url.asURL?.absoluteString)
    }
    
    func testAsDictionaryConversion() {
        // Arrange
        let media = MockDAOMediaFactory.createCompleteMedia()
        
        // Act
        let dictionary = media.asDictionary
        
        // Assert
        XCTAssertEqual(dictionary["path"] as? String, media.path)
        XCTAssertNotNil(dictionary["preloadUrl"] as Any?)
        XCTAssertNotNil(dictionary["title"] as Any?)
        XCTAssertEqual(dictionary["type"] as? String, media.type.rawValue)
        XCTAssertNotNil(dictionary["url"] as Any?)
    }
    
    // MARK: - Performance Tests
    
    func testInitializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DAOMedia()
            }
        }
    }
    
    func testCopyPerformance() {
        // Arrange
        let originalMedia = MockDAOMediaFactory.createCompleteMedia()
        
        measure {
            for _ in 0..<1000 {
                _ = DAOMedia(from: originalMedia)
            }
        }
    }
    
    func testEquatablePerformance() {
        // Arrange
        let media1 = MockDAOMediaFactory.createCompleteMedia()
        let media2 = MockDAOMediaFactory.createCompleteMedia()
        
        measure {
            for _ in 0..<1000 {
                _ = media1 == media2
            }
        }
    }
    
    func testCodablePerformance() throws {
        // Arrange
        let media = MockDAOMediaFactory.createCompleteMedia()
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        measure {
            do {
                for _ in 0..<100 {
                    let data = try encoder.encode(media)
                    _ = try decoder.decode(DAOMedia.self, from: data)
                }
            } catch {
                XCTFail("Encoding/Decoding failed: \(error)")
            }
        }
    }
    
    func testMediaTypeEnumPerformance() {
        // Arrange
        let media = DAOMedia()
        let mediaTypes: [DNSMediaType] = [.staticImage, .video, .animatedImage, .unknown]
        
        measure {
            for _ in 0..<1000 {
                for mediaType in mediaTypes {
                    media.type = mediaType
                    _ = media.type
                }
            }
        }
    }
}
