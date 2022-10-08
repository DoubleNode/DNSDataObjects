//
//  DAOAppActionImages.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAppActionImages: DAOBaseObject {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case topUrl = "top"
    }

    open var topUrl = DNSURL()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppActionImages) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppActionImages) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.topUrl = object.topUrl.copy() as! DNSURL
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppActionImages {
        _ = super.dao(from: data)
        self.topUrl = self.dnsurl(from: data[field(.topUrl)] as Any?) ?? self.topUrl
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.topUrl): self.topUrl,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        topUrl = try container.decodeIfPresent(DNSURL.self, forKey: .topUrl) ?? topUrl
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topUrl, forKey: .topUrl)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppActionImages(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppActionImages else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.topUrl != rhs.topUrl
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAppActionImages, rhs: DAOAppActionImages) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAppActionImages, rhs: DAOAppActionImages) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
