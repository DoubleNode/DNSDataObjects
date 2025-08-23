//
//  DNSMediaDisplay.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
@preconcurrency import UIKit

open class DNSMediaDisplay: Equatable, NSCopying, @unchecked Sendable {
    @MainActor open var imageView: UIImageView
    @MainActor open var placeholderImage: UIImage?
    @MainActor open var progressView: UIProgressView?
    @MainActor open var secondaryImageViews: [UIImageView] = []

    nonisolated public init(imageView: UIImageView,
                            placeholderImage: UIImage? = nil,
                            progressView: UIProgressView? = nil,
                            secondaryImageViews: [UIImageView] = []) {
        self.imageView = imageView
        self.placeholderImage = placeholderImage
        self.progressView = progressView
        self.secondaryImageViews = secondaryImageViews
        self.contentInit()
    }

    nonisolated open func contentInit() { }
    @MainActor open func display(from media: DAOMedia?) { }

    // NSCopying protocol methods
    nonisolated open func copy(with zone: NSZone? = nil) -> Any {
        let imageView = MainActor.assumeIsolated { self.imageView }
        let placeholderImage = MainActor.assumeIsolated { self.placeholderImage }
        let progressView = MainActor.assumeIsolated { self.progressView }
        let secondaryImageViews = MainActor.assumeIsolated { self.secondaryImageViews }
        
        let copy = DNSMediaDisplay(imageView: imageView,
                                   placeholderImage: placeholderImage,
                                   progressView: progressView,
                                   secondaryImageViews: secondaryImageViews)
        return copy
    }
    nonisolated open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSMediaDisplay else { return true }
        
        let lhsImageView = MainActor.assumeIsolated { self.imageView }
        let lhsProgressView = MainActor.assumeIsolated { self.progressView }
        let lhsSecondaryImageViews = MainActor.assumeIsolated { self.secondaryImageViews }
        
        let rhsImageView = MainActor.assumeIsolated { rhs.imageView }
        let rhsProgressView = MainActor.assumeIsolated { rhs.progressView }
        let rhsSecondaryImageViews = MainActor.assumeIsolated { rhs.secondaryImageViews }
        
        return lhsImageView != rhsImageView ||
               lhsProgressView != rhsProgressView ||
               lhsSecondaryImageViews != rhsSecondaryImageViews
    }

    // MARK: - Equatable protocol methods -
    nonisolated static public func !=(lhs: DNSMediaDisplay, rhs: DNSMediaDisplay) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    nonisolated static public func ==(lhs: DNSMediaDisplay, rhs: DNSMediaDisplay) -> Bool {
        !lhs.isDiffFrom(rhs)
    }

    // MARK: - Utility methods -
    @MainActor open func utilityDisplayPrepareForReuse(videoOnly: Bool = false) { }
}
