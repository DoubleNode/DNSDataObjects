//
//  DNSMediaDisplayVideo.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSCoreThreading
import UIKit

open class DNSMediaDisplayVideo: DNSMediaDisplayStaticImage {
    override open func display(from media: DAOMedia) {
        DNSUIThread.run {
            guard let url = media.url.asURL else { return }
            guard let preloadUrl = media.preloadUrl.asURL else {
                self.utilityDisplayVideo(url: url)
                return
            }
            self.utilityDisplayStaticImage(url: preloadUrl,
                                           completion: { _/*success*/ in
                self.utilityDisplayVideo(url: url)
            })
        }
    }

    // MARK: - Utility methods -
    override open func utilityDisplayPrepareForReuse(videoOnly: Bool = false) {
//        if self.videoPlayer != nil {
//            self.videoPlayer?.pause()
//            self.videoPlayer?.rate = 0.0
//            self.videoPlayer = nil
//            self.videoPlayerLayer?.removeFromSuperlayer()
//            self.videoPlayerLayer = nil
//        }
        guard !videoOnly else { return }
        super.utilityDisplayPrepareForReuse(videoOnly: videoOnly)
    }
    func utilityDisplayVideo(url: URL) {
        self.utilityDisplayPrepareForReuse()
        self.secondaryImageViews.forEach { $0.image = nil }
//        let playerAsset = AVAsset(url: url)
//        let playerItem = AVPlayerItem(asset: playerAsset)
//        self.videoPlayer = AVQueuePlayer(playerItem: playerItem)
//        self.videoLooper = AVPlayerLooper(player: self.videoPlayer!, templateItem: playerItem)
//
//        self.videoPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
//        self.videoPlayerLayer!.frame = self.activityImageView.frame
//        self.videoPlayerLayer!.backgroundColor = UIColor.clear.cgColor
//        self.videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        self.activityImageView.layer.addSublayer(self.videoPlayerLayer!)
//        self.videoPlayer!.play()
    }
}
