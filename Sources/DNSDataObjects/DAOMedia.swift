//
//  DAOMedia.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DAOMedia: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case type, url, preloadUrl
    }

    var type: DNSMediaType = .unknown
    var url: DNSURL = DNSURL()
    var preloadUrl: DNSURL = DNSURL()

    public init(type: DNSMediaType) {
        self.type = type
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOMedia) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOMedia) {
        super.update(from: object)
        self.type = object.type
        self.url = object.url
        self.preloadUrl = object.preloadUrl
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOMedia {
        _ = super.dao(from: dictionary)
        let typeData = self.string(from: dictionary["type"] as Any?) ?? self.type.rawValue
        self.type = DNSMediaType(rawValue: typeData) ?? .unknown
        self.url = self.dnsurl(from: dictionary["url"] as Any?) ?? self.url
        self.preloadUrl = self.dnsurl(from: dictionary["preloadUrl"] as Any?) ?? self.preloadUrl
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            "type": self.type.rawValue,
            "url": self.url.asDictionary,
            "preloadUrl": self.preloadUrl.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(DNSMediaType.self, forKey: .type)
        url = try container.decode(DNSURL.self, forKey: .url)
        preloadUrl = try container.decode(DNSURL.self, forKey: .preloadUrl)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
        try container.encode(preloadUrl, forKey: .preloadUrl)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOMedia(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOMedia else { return true }
        let lhs = self
        return lhs.type != rhs.type
            || lhs.url != rhs.url
            || lhs.preloadUrl != rhs.preloadUrl
    }
}
public extension DAOMedia {
    func display(using helper: DNSMediaDisplay) {
        helper.display(from: self)
    }
}