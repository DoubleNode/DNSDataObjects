//
//  DAONotification.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAONotification: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case body, deepLink, title, type
    }

    public var body = ""
    public var deepLink: DNSURL = DNSURL()
    public var title = ""
    public var type: DNSNotificationType = .unknown
    
    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    public init(type: DNSNotificationType) {
        self.type = type
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DAONotification) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAONotification) {
        super.update(from: object)
        self.body = object.body
        self.deepLink = object.deepLink
        self.title = object.title
        self.type = object.type
    }

    // MARK: - DAO translation methods -
    public override init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAONotification {
        _ = super.dao(from: dictionary)
        self.body = self.string(from: dictionary[CodingKeys.body.rawValue] as Any?) ?? self.body
        self.deepLink = self.dnsurl(from: dictionary[CodingKeys.deepLink.rawValue] as Any?) ?? self.deepLink
        self.title = self.string(from: dictionary[CodingKeys.title.rawValue] as Any?) ?? self.title
        self.type = DNSNotificationType(rawValue: self.string(from: dictionary[CodingKeys.type.rawValue] as Any?) ?? "") ?? .unknown
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.body.rawValue: self.body,
            CodingKeys.deepLink.rawValue: self.deepLink,
            CodingKeys.title.rawValue: self.title,
            CodingKeys.type.rawValue: self.type,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decode(String.self, forKey: .body)
        deepLink = try container.decode(DNSURL.self, forKey: .deepLink)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(DNSNotificationType.self, forKey: .type)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(deepLink, forKey: .deepLink)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAONotification(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAONotification else { return true }
        let lhs = self
        return lhs.body != rhs.body
            || lhs.deepLink != rhs.deepLink
            || lhs.title != rhs.title
            || lhs.type != rhs.type
    }
}
