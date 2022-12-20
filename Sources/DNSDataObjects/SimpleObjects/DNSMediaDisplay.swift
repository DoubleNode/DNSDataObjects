//
//  DNSMediaDisplay.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

open class DNSMediaDisplay: Equatable, NSCopying {
    open var imageView: UIImageView
    open var placeholderImage: UIImage?
    open var progressView: UIProgressView?
    open var secondaryImageViews: [UIImageView] = []

    public init(imageView: UIImageView,
                placeholderImage: UIImage? = nil,
                progressView: UIProgressView? = nil,
                secondaryImageViews: [UIImageView] = []) {
        self.imageView = imageView
        self.progressView = progressView
        self.secondaryImageViews = secondaryImageViews
        self.contentInit()
    }

    open func contentInit() { }
    open func display(from media: DAOMedia?) { }

    // NSCopying protocol methods
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSMediaDisplay(imageView: imageView)
        copy.imageView = imageView
        copy.progressView = progressView
        copy.secondaryImageViews = secondaryImageViews
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSMediaDisplay else { return true }
        let lhs = self
        return lhs.imageView != rhs.imageView ||
            lhs.progressView != rhs.progressView ||
            lhs.secondaryImageViews != rhs.secondaryImageViews
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSMediaDisplay, rhs: DNSMediaDisplay) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DNSMediaDisplay, rhs: DNSMediaDisplay) -> Bool {
        !lhs.isDiffFrom(rhs)
    }

    // MARK: - Utility methods -
    open func utilityDisplayPrepareForReuse(videoOnly: Bool = false) { }
}
