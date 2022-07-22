//
//  DAOAppEvent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAppEvent: DAOBaseObject {
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endTime, priority, startTime, title
    }

    public static var defaultEndTime = Date(timeIntervalSinceReferenceDate: Date.Seconds.deltaOneYear * 30.0)
    public static var defaultStartTime = Date(timeIntervalSinceReferenceDate: 0.0)

    public var endTime: Date = DAOAppEvent.defaultEndTime
    public var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }
    public var startTime: Date = DAOAppEvent.defaultStartTime
    public var title: DNSString = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(title: DNSString = DNSString(),
                startTime: Date = DAOAppEvent.defaultStartTime,
                endTime: Date = DAOAppEvent.defaultEndTime) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppEvent) {
        super.init(from: object)
        self.update(from: object)
    }
    public func update(from object: DAOAppEvent) {
        super.update(from: object)
        self.endTime = object.endTime
        self.priority = object.priority
        self.startTime = object.startTime
        self.title = object.title
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppEvent {
        _ = super.dao(from: data)
        self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.endTime
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.endTime): self.endTime,
            field(.priority): self.priority,
            field(.startTime): self.startTime,
            field(.title): self.title.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endTime = try container.decode(Date.self, forKey: .endTime)
        priority = try container.decode(Int.self, forKey: .priority)
        startTime = try container.decode(Date.self, forKey: .startTime)
        title = try container.decode(DNSString.self, forKey: .title)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(priority, forKey: .priority)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppEvent(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppEvent else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.endTime != rhs.endTime
            || lhs.priority != rhs.priority
            || lhs.startTime != rhs.startTime
            || lhs.title != rhs.title
    }
}
