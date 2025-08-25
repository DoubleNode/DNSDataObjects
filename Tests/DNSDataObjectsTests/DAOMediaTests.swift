//
//  DAOMediaTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import UIKit
import DNSCore
@testable import DNSDataObjects

final class DAOMediaTests: XCTestCase {
    
    func testDAOMediaInitializationWithId() {
        let testId = "test-media-id"
        let media = DAOMedia(id: testId)
        
        XCTAssertEqual(media.id, testId)
    }
    
    func testDAOMediaCopyConstructor() {
        let originalMedia = DAOMedia(id: "original-id")
        let copiedMedia = DAOMedia(from: originalMedia)
        
        XCTAssertEqual(copiedMedia.id, originalMedia.id)
        XCTAssertFalse(copiedMedia === originalMedia) // Different instances
    }
    
    func testDAOMediaFromDataDictionary() {
        let testData: DNSDataDictionary = [
            "id": "test-id",
            "path": "test/path",
            "title": "Test Media",
            "type": "image",
            "url": "https://example.com/media.jpg"
        ]
        
        guard let media = DAOMedia.createMedia(from: testData) else {
            XCTFail("Failed to create media from data dictionary")
            return
        }
        
        XCTAssertEqual(media.id, "test-id")
    }
    
    func testDAOMediaCopyMethod() {
        let originalMedia = DAOMedia(id: "copy-test")
        let copiedMedia = originalMedia.copy() as! DAOMedia
        
        XCTAssertEqual(copiedMedia.id, originalMedia.id)
        XCTAssertFalse(copiedMedia === originalMedia)
    }
    
    func testDAOMediaEquality() {
        let media1 = DAOMedia(id: "same-id")
        let media2 = DAOMedia(id: "same-id")
        let media3 = DAOMedia(id: "different-id")
        
        media2.meta = media1.meta
        media3.meta = media1.meta

        XCTAssertTrue(media1 == media2)
        XCTAssertFalse(media1 == media3)
    }
    
    func testDAOMediaIsDiffFrom() {
        let media1 = DAOMedia(id: "test-id")
        let media2 = DAOMedia(id: "test-id")
        let media3 = DAOMedia(id: "different-id")
        
        media2.meta = media1.meta
        media3.meta = media1.meta

        XCTAssertFalse(media1.isDiffFrom(media2))
        XCTAssertTrue(media1.isDiffFrom(media3))
        XCTAssertTrue(media1.isDiffFrom("not a media object"))
    }
    
    func testDAOMediaAsDictionary() {
        let media = DAOMedia(id: "dictionary-test")
        let dictionary = media.asDictionary
        
        XCTAssertEqual(dictionary["id"] as? String, "dictionary-test")
        XCTAssertNotNil((dictionary["meta"] as? [String: Any] ?? [:])["created"])
        XCTAssertNotNil((dictionary["meta"] as? [String: Any] ?? [:])["updated"])
    }
    
    func testDAOMediaDisplayExtension() {
        MainActor.assumeIsolated {
            let imageView = UIImageView()
            let mediaDisplay = DNSMediaDisplay(imageView: imageView)
            let media = DAOMedia(id: "display-test")
            
            // Test that the display method exists and doesn't crash
            media.display(using: mediaDisplay)
            
            // This test mainly verifies that the method compiles and runs without error
            XCTAssertTrue(true, "Display method executed without crashing")
        }
    }
    
    func testDAOMediaClassFactory() {
        let media1 = DAOMedia.createMedia()
        let media2 = DAOMedia.createMedia(from: media1)
        
        XCTAssertNotNil(media1)
        XCTAssertNotNil(media2)
        XCTAssertEqual(media1.id, media2.id)
        XCTAssertFalse(media1 === media2)
    }
    
    func testDAOMediaConfiguration() {
        XCTAssertNotNil(DAOMedia.config)
        XCTAssertTrue(DAOMedia.config is CFGMediaObject)
        XCTAssertTrue(DAOMedia.config.mediaType == DAOMedia.self)
    }
    
    nonisolated(unsafe) static var allTests = [
        ("testDAOMediaInitializationWithId", testDAOMediaInitializationWithId),
        ("testDAOMediaCopyConstructor", testDAOMediaCopyConstructor),
        ("testDAOMediaFromDataDictionary", testDAOMediaFromDataDictionary),
        ("testDAOMediaCopyMethod", testDAOMediaCopyMethod),
        ("testDAOMediaEquality", testDAOMediaEquality),
        ("testDAOMediaIsDiffFrom", testDAOMediaIsDiffFrom),
        ("testDAOMediaAsDictionary", testDAOMediaAsDictionary),
        ("testDAOMediaDisplayExtension", testDAOMediaDisplayExtension),
        ("testDAOMediaClassFactory", testDAOMediaClassFactory),
        ("testDAOMediaConfiguration", testDAOMediaConfiguration),
    ]
}
