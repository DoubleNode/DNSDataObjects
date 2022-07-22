//
//  DAOFaqSection.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOFaqSection: DAOBaseObject {
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case code, title, iconKey
    }

    public var code = ""
    public var title = DNSString()
    public var iconKey = ""

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(code: String, title: DNSString, iconKey: String) {
        self.code = code
        self.title = title
        self.iconKey = iconKey
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOFaqSection) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOFaqSection) {
        super.update(from: object)
        self.code = object.code
        self.title = object.title
        self.iconKey = object.iconKey
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOFaqSection {
        _ = super.dao(from: data)
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        self.iconKey = self.string(from: data[field(.iconKey)] as Any?) ?? self.iconKey
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.code): self.code,
            field(.title): self.title.asDictionary,
            field(.iconKey): self.iconKey,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        title = try container.decode(DNSString.self, forKey: .title)
        iconKey = try container.decode(String.self, forKey: .iconKey)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(title, forKey: .title)
        try container.encode(iconKey, forKey: .iconKey)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOFaqSection(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOFaqSection else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.code != rhs.code
            || lhs.title != rhs.title
            || lhs.iconKey != rhs.iconKey
    }
}
