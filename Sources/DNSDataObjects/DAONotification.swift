//
//  DAONotification.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAONotification: DAOBaseObject {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case body, deepLink, title, type
    }

    public var body = ""
    public var deepLink: URL?
    public var title = ""
    public var type: DNSNotificationType = .unknown
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(type: DNSNotificationType) {
        self.type = type
        super.init()
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAONotification) {
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
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAONotification {
        _ = super.dao(from: data)
        self.body = self.string(from: data[field(.body)] as Any?) ?? self.body
        self.deepLink = self.url(from: data[field(.deepLink)] as Any?) ?? self.deepLink
        self.title = self.string(from: data[field(.title)] as Any?) ?? self.title
        self.type = DNSNotificationType(rawValue: self.string(from: data[field(.type)] as Any?) ?? "") ?? .unknown
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.body): self.body,
            field(.deepLink): self.deepLink,
            field(.title): self.title,
            field(.type): self.type,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decode(String.self, forKey: .body)
        deepLink = try container.decode(URL.self, forKey: .deepLink)
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.body != rhs.body
            || lhs.deepLink != rhs.deepLink
            || lhs.title != rhs.title
            || lhs.type != rhs.type
    }
}
