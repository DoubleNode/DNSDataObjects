//
//  DAODocument.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAODocument: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case title, url
    }

    public var title = DNSString()
    public var url = DNSURL()

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    public init(title: DNSString,
                url: DNSURL) {
        self.title = title
        self.url = url
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAODocument) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAODocument) {
        super.update(from: object)
        self.title = object.title
        self.url = object.url
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAODocument {
        _ = super.dao(from: dictionary)
        self.title = self.dnsstring(from: dictionary[CodingKeys.title.rawValue] as Any?) ?? self.title
        self.url = self.dnsurl(from: dictionary[CodingKeys.url.rawValue] as Any?) ?? self.url
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.title.rawValue: self.title.asDictionary,
            CodingKeys.url.rawValue: self.url.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(DNSString.self, forKey: .title)
        url = try container.decode(DNSURL.self, forKey: .url)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAODocument(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAODocument else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.title != rhs.title
            || lhs.url != rhs.url
    }
}
