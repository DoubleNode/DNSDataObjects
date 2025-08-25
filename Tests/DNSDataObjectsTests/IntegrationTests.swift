//
//  IntegrationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import UIKit
import Currency
import DNSCore
@testable import DNSDataObjects

final class IntegrationTests: XCTestCase {
    
    // MARK: - Full DAO Object Lifecycle Tests
    
    func testCompleteDAOMediaWorkflow() {
        // Create a media object
        let media = DAOMedia()
        let originalId = media.id
        
        // Verify initial state
        XCTAssertFalse(media.id.isEmpty)
        XCTAssertNotNil(media.meta)
        
        // Test copying
        let copiedMedia = DAOMedia(from: media)
        XCTAssertEqual(copiedMedia.id, originalId)
        XCTAssertFalse(copiedMedia === media)
        
        // Test dictionary conversion
        let dictionary = media.asDictionary
        XCTAssertEqual(dictionary["id"] as? String, originalId)
        
        // Test creation from dictionary
        guard let recreatedMedia = DAOMedia.createMedia(from: dictionary) else {
            XCTFail("Failed to recreate media from dictionary")
            return
        }
        XCTAssertEqual(recreatedMedia.id, originalId)
    }
    
    func testMediaDisplayIntegration() {
        MainActor.assumeIsolated {
            // Create UI components
            let imageView = UIImageView()
            let progressView = UIProgressView()
            let secondaryImageViews = [UIImageView(), UIImageView()]
            
            // Create media display
            let mediaDisplay = DNSMediaDisplay(
                imageView: imageView,
                placeholderImage: UIImage(),
                progressView: progressView,
                secondaryImageViews: secondaryImageViews
            )
            
            // Create media object
            let media = DAOMedia()
            
            // Test the integration
            media.display(using: mediaDisplay)
            
            // Verify the display components are properly configured
            XCTAssertEqual(mediaDisplay.imageView, imageView)
            XCTAssertEqual(mediaDisplay.progressView, progressView)
            XCTAssertEqual(mediaDisplay.secondaryImageViews.count, 2)
        }
    }
    
    func testDAOObjectHierarchy() {
        let user = DAOUser()
        let media = DAOMedia()
        let baseObject = DAOBaseObject()
        
        // Test inheritance
        XCTAssertTrue(user is DAOBaseObject)
        XCTAssertTrue(media is DAOBaseObject)
        
        // Test common functionality
        XCTAssertFalse(user.id.isEmpty)
        XCTAssertFalse(media.id.isEmpty)
        XCTAssertFalse(baseObject.id.isEmpty)
        
        // Test metadata
        XCTAssertNotNil(user.meta)
        XCTAssertNotNil(media.meta)
        XCTAssertNotNil(baseObject.meta)
        
        // Test analytics data
        XCTAssertEqual(user.analyticsData.count, 0)
        XCTAssertEqual(media.analyticsData.count, 0)
        XCTAssertEqual(baseObject.analyticsData.count, 0)
    }
    
    func testCodingIntegration() {
        let media = DAOMedia(id: "test-media-coding")
        
        do {
            // Test encoding
            let encodedData = try JSONEncoder().encode(media)
            XCTAssertFalse(encodedData.isEmpty)
            
            // Test decoding
            let decodedMedia = try JSONDecoder().decode(DAOMedia.self, from: encodedData)
            XCTAssertEqual(decodedMedia.id, media.id)
            XCTAssertEqual(decodedMedia.analyticsData.count, media.analyticsData.count)
            
        } catch {
            XCTFail("Coding integration failed: \(error)")
        }
    }
    
    func testConfigurationSystem() {
        // Test that configuration objects exist and work
        XCTAssertNotNil(DAOMedia.config)
        XCTAssertNotNil(DAOUser.config)
        
        // Test factory methods work through configuration
        let media1 = DAOMedia.createMedia()
        let media2 = DAOMedia.createMedia(from: media1)
        
        XCTAssertNotNil(media1)
        XCTAssertNotNil(media2)
        XCTAssertEqual(media1.id, media2.id)
        
        let user1 = DAOUser()
        let user2 = DAOUser(from: user1)
        
        XCTAssertNotNil(user1)
        XCTAssertNotNil(user2)
        XCTAssertEqual(user1.id, user2.id)
    }
    
    func testSimpleObjectIntegration() {
        // Test that simple objects work correctly
        let activeData: [String : Any] = [
            "price": Decimal(string: "19.99")!,
            "priority": DNSPriority.normal,
            "startTime": Date.yesterday,
            "endTime": Date.tomorrow
        ]
        let inactiveData: [String : Any] = [
            "price": Decimal(string: "29.99")!,
            "priority": DNSPriority.high,
            "startTime": Date.tomorrow,
            "endTime": Date.now.nextWeek
        ]
        
        let activePrice = DNSPrice(from: activeData)
        let inactivePrice = DNSPrice(from: inactiveData)
        let metadata = DNSMetadata()
        
        // Test simple object functionality
        XCTAssertEqual(activePrice.price.exactAmount, Decimal(string: "19.99")!)
        XCTAssertEqual(activePrice.priority, DNSPriority.normal)
        XCTAssertTrue(activePrice.isActive)
        XCTAssertEqual(inactivePrice.price.exactAmount, Decimal(string: "29.99")!)
        XCTAssertEqual(inactivePrice.priority, DNSPriority.high)
        XCTAssertFalse(inactivePrice.isActive)
        XCTAssertNotNil(metadata.uid)
        
        // Test that simple objects can be used in DAO objects
        let baseObject = DAOBaseObject()
        baseObject.meta = metadata
        
        XCTAssertEqual(baseObject.meta.uid, metadata.uid)
    }
    
    func testDataTransformationRoundTrip() {
        // Create a complex data structure
        let originalData: DNSDataDictionary = [
            "id": "roundtrip-test",
            "analyticsData": [
                [
                    "id": "analytics-1",
                    "meta": [
                        "created": Date().timeIntervalSince1970,
                        "updated": Date().timeIntervalSince1970,
                        "uid": UUID().uuidString
                    ]
                ]
            ],
            "meta": [
                "created": Date().timeIntervalSince1970,
                "updated": Date().timeIntervalSince1970,
                "uid": UUID().uuidString
            ]
        ]
        
        // Create object from data
        guard let baseObject = DAOBaseObject(from: originalData) else {
            XCTFail("Failed to create object from data")
            return
        }
        
        // Convert back to dictionary
        let roundTripData = baseObject.asDictionary
        
        // Verify key fields survived the round trip
        XCTAssertEqual(roundTripData["id"] as? String, "roundtrip-test")
        XCTAssertNotNil(roundTripData["meta"] as Any?)
        XCTAssertNotNil(roundTripData["analyticsData"] as Any?)
        
        // Create another object from the round-trip data
        guard let secondObject = DAOBaseObject(from: roundTripData) else {
            XCTFail("Failed to create object from round-trip data")
            return
        }
        
        XCTAssertEqual(secondObject.id, baseObject.id)
        XCTAssertEqual(secondObject.analyticsData.count, baseObject.analyticsData.count)
    }
    
    func testSwift6ConcurrencyCompliance() {
        // Test that our objects work correctly with Swift 6 concurrency
        let media = DAOMedia()
        let user = DAOUser()
        
        // Test that these objects are sendable and work across concurrency boundaries
        let mediaId = media.id
        let userId = user.id
        
        XCTAssertFalse(mediaId.isEmpty)
        XCTAssertFalse(userId.isEmpty)
        
        // Test that copying works
        let copiedMedia = DAOMedia(from: media)
        XCTAssertEqual(copiedMedia.id, media.id)
    }
    
    nonisolated(unsafe) static var allTests = [
        ("testCompleteDAOMediaWorkflow", testCompleteDAOMediaWorkflow),
        ("testMediaDisplayIntegration", testMediaDisplayIntegration),
        ("testDAOObjectHierarchy", testDAOObjectHierarchy),
        ("testCodingIntegration", testCodingIntegration),
        ("testConfigurationSystem", testConfigurationSystem),
        ("testSimpleObjectIntegration", testSimpleObjectIntegration),
        ("testDataTransformationRoundTrip", testDataTransformationRoundTrip),
        ("testSwift6ConcurrencyCompliance", testSwift6ConcurrencyCompliance),
    ]
}
