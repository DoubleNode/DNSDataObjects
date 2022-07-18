//
//  DAOFaqSection.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOFaqSection: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case code, title, iconKey
    }

    public var code = ""
    public var title = DNSString()
    public var iconKey = ""

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    public init(code: String, title: DNSString, iconKey: String) {
        self.code = code
        self.title = title
        self.iconKey = iconKey
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOFaqSection) {
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
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOFaqSection {
        _ = super.dao(from: dictionary)
        self.code = self.string(from: dictionary[CodingKeys.code.rawValue] as Any?) ?? self.code
        self.title = self.dnsstring(from: dictionary[CodingKeys.title.rawValue] as Any?) ?? self.title
        self.iconKey = self.string(from: dictionary[CodingKeys.iconKey.rawValue] as Any?) ?? self.iconKey
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.code.rawValue: self.code,
            CodingKeys.title.rawValue: self.title.asDictionary,
            CodingKeys.iconKey.rawValue: self.iconKey,
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
        let lhs = self
        return lhs.code != rhs.code
            || lhs.title != rhs.title
            || lhs.iconKey != rhs.iconKey
    }
}
