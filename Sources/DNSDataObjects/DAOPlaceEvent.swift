//
//  DAOPlaceEvent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOPlaceEvent: DAOBaseObject {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endDate, name, startDate, timeZone, type
    }

    open var endDate = Date()
    open var name = DNSString()
    open var startDate = Date()
    open var timeZone = TimeZone.current
    open var type = ""

    public var endTime: DNSTimeOfDay {
        let endTimeStr = self.endDate.dnsTime(as: .shortMilitary, in: timeZone).dnsSplit(every: 2).joined(separator: ":")
        return self.timeOfDay(from: endTimeStr) ?? DNSTimeOfDay()
    }
    public var startTime: DNSTimeOfDay {
        let startTimeStr = self.startDate.dnsTime(as: .shortMilitary, in: timeZone).dnsSplit(every: 2).joined(separator: ":")
        return self.timeOfDay(from: startTimeStr) ?? DNSTimeOfDay()
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOPlaceEvent) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPlaceEvent) {
        super.update(from: object)
        self.endDate = object.endDate
        self.name = object.name
        self.startDate = object.startDate
        self.timeZone = object.timeZone
        self.type = object.type
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPlaceEvent {
        _ = super.dao(from: data)
        self.endDate = self.time(from: data[field(.endDate)] as Any?) ?? self.endDate
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        self.startDate = self.time(from: data[field(.startDate)] as Any?) ?? self.startDate
        let timeZoneData = self.string(from: data[field(.timeZone)] as Any?) ?? self.timeZone.identifier
        self.timeZone = TimeZone(identifier: timeZoneData) ?? self.timeZone
        self.type = self.string(from: data[field(.type)] as Any?) ?? self.type
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.endDate): self.endDate,
            field(.name): self.name.asDictionary,
            field(.startDate): self.startDate,
            field(.timeZone): self.timeZone.identifier,
            field(.type): self.type,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endDate = try container.decodeIfPresent(Date.self, forKey: .endDate) ?? endDate
        name = try container.decodeIfPresent(DNSString.self, forKey: .name) ?? name
        startDate = try container.decodeIfPresent(Date.self, forKey: .startDate) ?? startDate
        timeZone = try container.decodeIfPresent(TimeZone.self, forKey: .timeZone) ?? timeZone
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? type
        try super.init(from: decoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(timeZone, forKey: .timeZone)
        try container.encode(type, forKey: .type)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPlaceEvent(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPlaceEvent else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.endDate != rhs.endDate ||
            lhs.name != rhs.name ||
            lhs.startDate != rhs.startDate ||
            lhs.timeZone != rhs.timeZone ||
            lhs.type != rhs.type
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPlaceEvent, rhs: DAOPlaceEvent) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPlaceEvent, rhs: DAOPlaceEvent) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
