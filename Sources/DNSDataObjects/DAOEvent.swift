//
//  DAOEvent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOEvent: PTCLCFGBaseObject {
    var eventType: DAOEvent.Type { get }
    func event<K>(from container: KeyedDecodingContainer<K>,
                  forKey key: KeyedDecodingContainer<K>.Key) -> DAOEvent? where K: CodingKey
    func eventArray<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEvent] where K: CodingKey
}

public protocol PTCLCFGEventObject: PTCLCFGDAOEventDay {
}
public class CFGEventObject: PTCLCFGEventObject {
    public var eventDayType: DAOEventDay.Type = DAOEventDay.self
    open func eventDay<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDay? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOEventDay.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func eventDayArray<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDay] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOEventDay].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOEvent: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGEventObject
    public static var config: Config = CFGEventObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createEventDay() -> DAOEventDay { config.eventDayType.init() }
    open class func createEventDay(from object: DAOEventDay) -> DAOEventDay { config.eventDayType.init(from: object) }
    open class func createEventDay(from data: DNSDataDictionary) -> DAOEventDay? { config.eventDayType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case body, days, distribution, enabled, title
    }

    open var body = DNSString()
    open var days: [DAOEventDay] = []
    open var distribution = DNSVisibility.everyone
    open var enabled = false
    open var title = DNSString()
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOEvent) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOEvent) {
        super.update(from: object)
        self.distribution = object.distribution
        self.enabled = object.enabled
        // swiftlint:disable force_cast
        self.body = object.body.copy() as! DNSString
        self.days = object.days.map { $0.copy() as! DAOEventDay }
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOEvent {
        _ = super.dao(from: data)
        self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
        let daysData = self.dataarray(from: data[field(.days)] as Any?)
        self.days = daysData.compactMap { Self.createEventDay(from: $0) }
        let distributionData = self.string(from: data[field(.distribution)] as Any?) ?? self.distribution.rawValue
        self.distribution = DNSVisibility(rawValue: distributionData) ?? .everyone
        self.enabled = self.bool(from: data[field(.enabled)] as Any?) ?? self.enabled
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.body): self.body.asDictionary,
            field(.days): self.days.map { $0.asDictionary },
            field(.distribution): self.distribution.rawValue,
            field(.enabled): self.enabled,
            field(.title): self.title.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = self.dnsstring(from: container, forKey: .body) ?? body
        days = self.daoEventDayArray(with: configuration, from: container, forKey: .days)
        distribution = try container.decodeIfPresent(Swift.type(of: distribution), forKey: .distribution) ?? distribution
        enabled = self.bool(from: container, forKey: .enabled) ?? enabled
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(days, forKey: .days, configuration: configuration)
        try container.encode(distribution, forKey: .distribution)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOEvent(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOEvent else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.days.hasDiffElementsFrom(rhs.days) ||
            lhs.body != rhs.body ||
            lhs.distribution != rhs.distribution ||
            lhs.enabled != rhs.enabled ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOEvent, rhs: DAOEvent) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOEvent, rhs: DAOEvent) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
