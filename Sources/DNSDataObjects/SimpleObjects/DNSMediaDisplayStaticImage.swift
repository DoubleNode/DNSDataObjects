//
//  DNSMediaDisplayStaticImage.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSCoreThreading
import UIKit

open class DNSMediaDisplayStaticImage: DNSMediaDisplay {
    override open func display(from media: DAOMedia?) {
        DNSUIThread.run {
            guard let media else {
                self.imageView.image = self.placeholderImage
                return
            }
            guard let url = media.url.asURL else {
                self.imageView.image = self.placeholderImage
                return
            }
            self.utilityDisplayStaticImage(url: url)
        }
    }

    // MARK: - Utility methods -
    override open func utilityDisplayPrepareForReuse(videoOnly: Bool = false) {
        super.utilityDisplayPrepareForReuse(videoOnly: videoOnly)
    }
    func utilityDisplayStaticImage(url: URL,
                                   completion: DNSBoolBlock? = nil) {
        self.utilityDisplayPrepareForReuse()
        imageView.af
            .setImage(withURL: url,
                      cacheKey: url.absoluteString,
                      progress: { (progress) in
                        self.progressView?.setProgress(Float(progress.fractionCompleted),
                                                       animated: true)
                        self.progressView?.isHidden = (progress.fractionCompleted >= 1.0)
                      },
                      imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                      completion: { imageDataResponse in
                        self.progressView?.isHidden = true
                        if case .success(let image) = imageDataResponse.result {
                            self.secondaryImageViews.forEach { $0.image = image }
                            completion?(true)
                        } else {
                            completion?(false)
                        }
                      })
    }
}
