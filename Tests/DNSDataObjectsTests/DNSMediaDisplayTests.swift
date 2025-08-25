//
//  DNSMediaDisplayTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import UIKit
@testable import DNSDataObjects

final class DNSMediaDisplayTests: XCTestCase {
    
    // Create UI components within each test method to avoid actor isolation issues
    @MainActor
    private static func createMockComponents() -> (UIImageView, UIProgressView, [UIImageView]) {
        let imageView = UIImageView()
        let progressView = UIProgressView()
        let secondaryImageViews = [UIImageView(), UIImageView()]
        return (imageView, progressView, secondaryImageViews)
    }
    
    // MARK: - DNSMediaDisplay Tests
    
    func testDNSMediaDisplayInitialization() {
        MainActor.assumeIsolated {
            let (imageView, progressView, secondaryImageViews) = Self.createMockComponents()
            let display = DNSMediaDisplay(
                imageView: imageView,
                placeholderImage: UIImage(),
                progressView: progressView,
                secondaryImageViews: secondaryImageViews
            )
            
            XCTAssertEqual(display.imageView, imageView)
            XCTAssertNotNil(display.placeholderImage)
            XCTAssertEqual(display.progressView, progressView)
            XCTAssertEqual(display.secondaryImageViews.count, 2)
        }
    }
    
    func testDNSMediaDisplayMinimalInitialization() {
        MainActor.assumeIsolated {
            let (imageView, _, _) = Self.createMockComponents()
            let display = DNSMediaDisplay(imageView: imageView)
            
            XCTAssertEqual(display.imageView, imageView)
            XCTAssertNil(display.placeholderImage)
            XCTAssertNil(display.progressView)
            XCTAssertEqual(display.secondaryImageViews.count, 0)
        }
    }
    
    func testDNSMediaDisplayCopy() {
        MainActor.assumeIsolated {
            let (imageView, progressView, secondaryImageViews) = Self.createMockComponents()
            let placeholderImage = UIImage()
            let originalDisplay = DNSMediaDisplay(
                imageView: imageView,
                placeholderImage: placeholderImage,
                progressView: progressView,
                secondaryImageViews: secondaryImageViews
            )
            
            let copiedDisplay = originalDisplay.copy() as! DNSMediaDisplay
            
            XCTAssertEqual(copiedDisplay.imageView, imageView)
            XCTAssertEqual(copiedDisplay.placeholderImage, placeholderImage)
            XCTAssertEqual(copiedDisplay.progressView, progressView)
            XCTAssertEqual(copiedDisplay.secondaryImageViews.count, 2)
        }
    }
    
    func testDNSMediaDisplayEquality() {
        MainActor.assumeIsolated {
            let (imageView, _, _) = Self.createMockComponents()
            let display1 = DNSMediaDisplay(imageView: imageView)
            let display2 = DNSMediaDisplay(imageView: imageView)
            let display3 = DNSMediaDisplay(imageView: UIImageView())
            
            XCTAssertEqual(display1, display2)
            XCTAssertNotEqual(display1, display3)
        }
    }
    
    func testDNSMediaDisplayIsDiffFrom() {
        MainActor.assumeIsolated {
            let (imageView, _, _) = Self.createMockComponents()
            let display1 = DNSMediaDisplay(imageView: imageView)
            let display2 = DNSMediaDisplay(imageView: imageView)
            let display3 = DNSMediaDisplay(imageView: UIImageView())
            
            XCTAssertFalse(display1.isDiffFrom(display2))
            XCTAssertTrue(display1.isDiffFrom(display3))
            XCTAssertTrue(display1.isDiffFrom("not a display"))
        }
    }
    
    // MARK: - DNSMediaDisplayStaticImage Tests
    
    func testDNSMediaDisplayStaticImageInheritance() {
        MainActor.assumeIsolated {
            let (imageView, _, _) = Self.createMockComponents()
            let staticDisplay = DNSMediaDisplayStaticImage(imageView: imageView)
            XCTAssertTrue(staticDisplay is DNSMediaDisplay)
        }
    }
    
    // MARK: - DNSMediaDisplayVideo Tests
    
    func testDNSMediaDisplayVideoInheritance() {
        MainActor.assumeIsolated {
            let (imageView, _, _) = Self.createMockComponents()
            let videoDisplay = DNSMediaDisplayVideo(imageView: imageView)
            XCTAssertTrue(videoDisplay is DNSMediaDisplayStaticImage)
            XCTAssertTrue(videoDisplay is DNSMediaDisplay)
        }
    }
    
    // MARK: - DNSMediaDisplayAnimatedImage Tests
    
    func testDNSMediaDisplayAnimatedImageInheritance() {
        MainActor.assumeIsolated {
            let (imageView, _, _) = Self.createMockComponents()
            let animatedDisplay = DNSMediaDisplayAnimatedImage(imageView: imageView)
            XCTAssertTrue(animatedDisplay is DNSMediaDisplayStaticImage)
            XCTAssertTrue(animatedDisplay is DNSMediaDisplay)
        }
    }
    
    nonisolated(unsafe) static var allTests = [
        ("testDNSMediaDisplayInitialization", testDNSMediaDisplayInitialization),
        ("testDNSMediaDisplayMinimalInitialization", testDNSMediaDisplayMinimalInitialization),
        ("testDNSMediaDisplayCopy", testDNSMediaDisplayCopy),
        ("testDNSMediaDisplayEquality", testDNSMediaDisplayEquality),
        ("testDNSMediaDisplayIsDiffFrom", testDNSMediaDisplayIsDiffFrom),
        ("testDNSMediaDisplayStaticImageInheritance", testDNSMediaDisplayStaticImageInheritance),
        ("testDNSMediaDisplayVideoInheritance", testDNSMediaDisplayVideoInheritance),
        ("testDNSMediaDisplayAnimatedImageInheritance", testDNSMediaDisplayAnimatedImageInheritance),
    ]
}