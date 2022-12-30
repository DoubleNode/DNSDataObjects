//
//  DNSMediaDisplayAnimatedImage.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import AlamofireImage
import DNSCore
import DNSCoreThreading
import Gifu
import UIKit

open class DNSMediaDisplayAnimatedImage: DNSMediaDisplayStaticImage {
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
            guard let preloadUrl = media.preloadUrl.asURL else {
                self.utilityDisplayAnimatedImage(url: url)
                return
            }
            self.utilityDisplayStaticImage(url: preloadUrl,
                                           completion: { _/*success*/ in
                self.utilityDisplayAnimatedImage(url: url)
            })
        }
    }

    // MARK: - Utility methods -
    func utilityDisplayAnimatedImage(url: URL) {
        guard let imageView = self.imageView as? GIFImageView else {
            self.utilityDisplayStaticImage(url: url)
            return
        }
        let placeholderImage = imageView.image
        self.utilityDisplayPrepareForReuse(videoOnly: true)
        imageView.af
            .setImage(withURL: url,
                      cacheKey: url.absoluteString + Date().dnsDateTime(as: .fullSimple),
                      placeholderImage: placeholderImage,
                      progress: { (progress) in
                        self.progressView?.setProgress(Float(progress.fractionCompleted),
                                                       animated: true)
                        self.progressView?.isHidden = (progress.fractionCompleted >= 1.0)
                      },
                      imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                      completion: { response in
                        self.progressView?.isHidden = true
                        self.secondaryImageViews.forEach { $0.image = nil }
                        DNSUIThread.run(after: 0.5) {
                            self.secondaryImageViews.forEach { $0.image = nil }
                            guard let imageData = response.data else {
                                imageView.startAnimatingGIF()
                                return
                            }
                            imageView.animate(withGIFData: imageData)
                        }
                      })
    }
    override open func utilityDisplayPrepareForReuse(videoOnly: Bool = false) {
        super.utilityDisplayPrepareForReuse(videoOnly: videoOnly)
        guard videoOnly else { return }
        guard let imageView = self.imageView as? GIFImageView else { return }
        imageView.prepareForReuse()
    }
}
