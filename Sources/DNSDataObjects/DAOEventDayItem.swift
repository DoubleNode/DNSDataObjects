//
//  DAOEventDayItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOEventDayItem: PTCLCFGBaseObject {
    var eventDayItemType: DAOEventDayItem.Type { get }
    func eventDayItem<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDayItem? where K: CodingKey
    func eventDayItemArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDayItem] where K: CodingKey
}

public protocol PTCLCFGEventDayItemObject: PTCLCFGBaseObject {
}
public class CFGEventDayItemObject: PTCLCFGEventDayItemObject {
}
open class DAOEventDayItem: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGEventDayItemObject
    public static var config: Config = CFGEventDayItemObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case about, endTimeOfDay, startTimeOfDay, title
    }

    open var about = DNSString()
    open var endTimeOfDay = DNSTimeOfDay()
    open var startTimeOfDay = DNSTimeOfDay()
    open var title = DNSString()
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOEventDayItem) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOEventDayItem) {
        super.update(from: object)
        self.endTimeOfDay = object.endTimeOfDay
        self.startTimeOfDay = object.startTimeOfDay
        // swiftlint:disable force_cast
        self.about = object.about.copy() as! DNSString
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOEventDayItem {
        _ = super.dao(from: data)
        self.about = self.dnsstring(from: data[field(.about)] as Any?) ?? self.about
        self.endTimeOfDay = self.timeOfDay(from: data[field(.endTimeOfDay)] as Any?) ?? self.endTimeOfDay
        self.startTimeOfDay = self.timeOfDay(from: data[field(.startTimeOfDay)] as Any?) ?? self.startTimeOfDay
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.about): self.about.asDictionary,
            field(.endTimeOfDay): self.endTimeOfDay,
            field(.startTimeOfDay): self.startTimeOfDay,
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
        about = self.dnsstring(from: container, forKey: .about) ?? about
        endTimeOfDay = self.timeOfDay(from: container, forKey: .endTimeOfDay) ?? endTimeOfDay
        startTimeOfDay = self.timeOfDay(from: container, forKey: .startTimeOfDay) ?? startTimeOfDay
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(about, forKey: .about)
        try container.encode(endTimeOfDay, forKey: .endTimeOfDay)
        try container.encode(startTimeOfDay, forKey: .startTimeOfDay)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOEventDayItem(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOEventDayItem else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.about != rhs.about ||
            lhs.endTimeOfDay != rhs.endTimeOfDay ||
            lhs.startTimeOfDay != rhs.startTimeOfDay ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOEventDayItem, rhs: DAOEventDayItem) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOEventDayItem, rhs: DAOEventDayItem) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
