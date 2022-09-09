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
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case title, url
    }

    open var title = DNSString()
    open var url = DNSURL()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(title: DNSString,
                url: DNSURL) {
        self.title = title
        self.url = url
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAODocument) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAODocument) {
        super.update(from: object)
        self.title = object.title
        self.url = object.url
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAODocument {
        _ = super.dao(from: data)
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        self.url = self.dnsurl(from: data[field(.url)] as Any?) ?? self.url
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.title): self.title.asDictionary,
            field(.url): self.url.asDictionary,
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
        return super.isDiffFrom(rhs) ||
            lhs.title != rhs.title ||
            lhs.url != rhs.url
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAODocument, rhs: DAODocument) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAODocument, rhs: DAODocument) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
