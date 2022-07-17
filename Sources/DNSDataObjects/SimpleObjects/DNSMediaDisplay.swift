//
//  DNSMediaDisplay.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

open class DNSMediaDisplay {
    public var imageView: UIImageView
    public var progressView: UIProgressView?
    public var secondaryImageViews: [UIImageView] = []
    
    public init(imageView: UIImageView,
                progressView: UIProgressView? = nil,
                secondaryImageViews: [UIImageView] = []) {
        self.imageView = imageView
        self.progressView = progressView
        self.secondaryImageViews = secondaryImageViews
    }
    
    open func display(from media: DAOMedia) { }
    
    // MARK: - Utility methods -
    open func utilityDisplayPrepareForReuse(videoOnly: Bool = false) { }
}
