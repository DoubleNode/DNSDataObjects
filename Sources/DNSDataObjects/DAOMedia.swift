//
//  DAOMedia.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOMedia: DAOBaseObject {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case type, url, preloadUrl
    }

    open var type: DNSMediaType = .unknown
    open var url = DNSURL()
    open var preloadUrl = DNSURL()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(type: DNSMediaType) {
        self.type = type
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOMedia) {
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
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOMedia {
        _ = super.dao(from: data)
        let typeData = self.string(from: data[field(.type)] as Any?) ?? self.type.rawValue
        self.type = DNSMediaType(rawValue: typeData) ?? .unknown
        self.url = self.dnsurl(from: data[field(.url)] as Any?) ?? self.url
        self.preloadUrl = self.dnsurl(from: data[field(.preloadUrl)] as Any?) ?? self.preloadUrl
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.type): self.type.rawValue,
            field(.url): self.url.asDictionary,
            field(.preloadUrl): self.preloadUrl.asDictionary,
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.type != rhs.type ||
            lhs.url != rhs.url ||
            lhs.preloadUrl != rhs.preloadUrl
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOMedia, rhs: DAOMedia) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOMedia, rhs: DAOMedia) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
