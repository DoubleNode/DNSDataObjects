//
//  DAOAlert.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAlert: DAOBaseObject {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endTime, imageUrl, name, priority, scope
        case startTime, status, tagLine, title
    }

    public static var defaultEndTime = Date(timeIntervalSinceReferenceDate: Date.Seconds.deltaOneYear * 30.0)
    public static var defaultStartTime = Date(timeIntervalSinceReferenceDate: 0.0)

    public var endTime = defaultEndTime
    public var imageUrl = DNSURL()
    public var name = ""
    public var priority: Int = 100
    public var scope: DNSAlertScope = .all
    public var startTime = defaultStartTime
    public var status: DNSStatus = .tempClosed
    public var tagLine = DNSString()
    public var title = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(status: DNSStatus,
                title: DNSString,
                tagLine: DNSString,
                startTime: Date = defaultStartTime,
                endTime: Date = defaultEndTime) {
        self.status = status
        self.title = title
        self.tagLine = tagLine
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAlert) {
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
        self.status = object.status
        self.tagLine = object.tagLine
        self.title = object.title
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAlert {
        _ = super.dao(from: data)
        self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.endTime
        self.imageUrl = self.dnsurl(from: data[field(.imageUrl)] as Any?) ?? self.imageUrl
        self.name = self.string(from: data[field(.name)] as Any?) ?? self.name
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        let scopeData = self.string(from: data[field(.scope)] as Any?) ?? self.scope.rawValue
        self.scope = DNSAlertScope(rawValue: scopeData) ?? .all
        self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
        let statusData = self.string(from: data[field(.status)] as Any?) ?? self.status.rawValue
        self.status = DNSStatus(rawValue: statusData) ?? .open
        self.tagLine = self.dnsstring(from: data[field(.tagLine)] as Any?) ?? self.tagLine
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.endTime): self.endTime,
            field(.imageUrl): self.imageUrl.asDictionary,
            field(.name): self.name,
            field(.priority): self.priority,
            field(.scope): self.scope.rawValue,
            field(.startTime): self.startTime,
            field(.status): self.status.rawValue,
            field(.tagLine): self.tagLine.asDictionary,
            field(.title): self.title.asDictionary,
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
        status = DNSStatus(rawValue: try container.decode(String.self, forKey: .status)) ?? .tempClosed
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
        try container.encode(status.rawValue, forKey: .status)
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.endTime != rhs.endTime
            || lhs.imageUrl != rhs.imageUrl
            || lhs.name != rhs.name
            || lhs.priority != rhs.priority
            || lhs.scope != rhs.scope
            || lhs.startTime != rhs.startTime
            || lhs.status != rhs.status
            || lhs.tagLine != rhs.tagLine
            || lhs.title != rhs.title
    }
}
