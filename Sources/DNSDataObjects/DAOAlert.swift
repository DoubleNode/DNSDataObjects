//
//  DAOAlert.swift
//  Main Event App
//
//  Created by Darren.Ehlers on 1/9/20.
//  Copyright © 2020 Main Event Entertainment LP. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAlert: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case endTime, imageUrl, name, priority, scope
        case startTime, tagLine, title
    }

    public static var defaultEndTime = Date(timeIntervalSinceReferenceDate: Date.Seconds.deltaOneYear * 30.0)
    public static var defaultStartTime = Date(timeIntervalSinceReferenceDate: 0.0)

    public var endTime = defaultEndTime
    public var imageUrl = DNSURL()
    public var name = ""
    public var priority: Int = 100
    public var scope: DNSAlertScope = .all
    public var startTime = defaultStartTime
    public var tagLine = DNSString()
    public var title = DNSString()

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    public init(title: DNSString,
                tagLine: DNSString,
                startTime: Date = defaultStartTime,
                endTime: Date = defaultEndTime) {
        self.title = title
        self.tagLine = tagLine
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOAlert) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAlert) {
        super.update(from: object)
        self.endTime = object.endTime
        self.imageUrl = object.imageUrl
        self.name = object.name
        self.priority = object.priority
        self.scope = object.scope
        self.startTime = object.startTime
        self.tagLine = object.tagLine
        self.title = object.title
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOAlert {
        _ = super.dao(from: dictionary)
        self.endTime = self.time(from: dictionary[CodingKeys.endTime.rawValue] as Any?) ?? self.endTime
        self.imageUrl = self.dnsurl(from: dictionary[CodingKeys.imageUrl.rawValue] as Any?) ?? self.imageUrl
        self.name = self.string(from: dictionary[CodingKeys.name.rawValue] as Any?) ?? self.name
        self.priority = self.int(from: dictionary[CodingKeys.priority.rawValue] as Any?) ?? self.priority
        let scopeData = self.string(from: dictionary[CodingKeys.scope.rawValue] as Any?) ?? self.scope.rawValue
        self.scope = DNSAlertScope(rawValue: scopeData) ?? .all
        self.startTime = self.time(from: dictionary[CodingKeys.startTime.rawValue] as Any?) ?? self.startTime
        self.tagLine = self.dnsstring(from: dictionary[CodingKeys.tagLine.rawValue] as Any?) ?? self.tagLine
        self.title = self.dnsstring(from: dictionary[CodingKeys.title.rawValue] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.endTime.rawValue: self.endTime,
            CodingKeys.imageUrl.rawValue: self.imageUrl.asDictionary,
            CodingKeys.name.rawValue: self.name,
            CodingKeys.priority.rawValue: self.priority,
            CodingKeys.scope.rawValue: self.scope.rawValue,
            CodingKeys.startTime.rawValue: self.startTime,
            CodingKeys.tagLine.rawValue: self.tagLine.asDictionary,
            CodingKeys.title.rawValue: self.title.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endTime = try container.decode(Date.self, forKey: .endTime)
        imageUrl = try container.decode(DNSURL.self, forKey: .imageUrl)
        name = try container.decode(String.self, forKey: .name)
        priority = try container.decode(Int.self, forKey: .priority)
        scope = try container.decode(DNSAlertScope.self, forKey: .scope)
        startTime = try container.decode(Date.self, forKey: .startTime)
        tagLine = try container.decode(DNSString.self, forKey: .tagLine)
        title = try container.decode(DNSString.self, forKey: .title)

        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(name, forKey: .name)
        try container.encode(priority, forKey: .priority)
        try container.encode(scope, forKey: .scope)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(tagLine, forKey: .tagLine)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAlert(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAlert else { return true }
        let lhs = self
        return lhs.endTime != rhs.endTime
            || lhs.imageUrl != rhs.imageUrl
            || lhs.name != rhs.name
            || lhs.priority != rhs.priority
            || lhs.scope != rhs.scope
            || lhs.startTime != rhs.startTime
            || lhs.tagLine != rhs.tagLine
            || lhs.title != rhs.title
    }
}
