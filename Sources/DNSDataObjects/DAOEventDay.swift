//
//  DAOEventDay.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOEventDay: PTCLCFGBaseObject {
    var eventDayType: DAOEventDay.Type { get }
    func eventDay<K>(from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDay? where K: CodingKey
    func eventDayArray<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDay] where K: CodingKey
}

public protocol PTCLCFGEventDayObject: PTCLCFGDAOEventDayItem {
}
public class CFGEventDayObject: PTCLCFGEventDayObject {
    public var eventDayItemType: DAOEventDayItem.Type = DAOEventDayItem.self
    open func eventDayItem<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDayItem? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOEventDayItem.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func eventDayItemArray<K>(from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDayItem] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOEventDayItem].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOEventDay: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGEventDayObject
    public static var config: Config = CFGEventDayObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createEventDayItem() -> DAOEventDayItem { config.eventDayItemType.init() }
    open class func createEventDayItem(from object: DAOEventDayItem) -> DAOEventDayItem { config.eventDayItemType.init(from: object) }
    open class func createEventDayItem(from data: DNSDataDictionary) -> DAOEventDayItem? { config.eventDayItemType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case about, date, items, title
    }

    open var about = DNSString()
    open var date = Date()
    open var items: [DAOEventDayItem] = []
    open var title = DNSString()
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOEventDay) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOEventDay) {
        super.update(from: object)
        self.about = object.about
        self.date = object.date
        self.items = object.items
        self.title = object.title
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOEventDay {
        _ = super.dao(from: data)
        self.about = self.dnsstring(from: data[field(.about)] as Any?) ?? self.about
        self.date = self.date(from: data[field(.date)] as Any?) ?? self.date
        let itemsData = self.dataarray(from: data[field(.items)] as Any?)
        self.items = itemsData.compactMap { Self.createEventDayItem(from: $0) }
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.about): self.about.asDictionary,
            field(.date): self.date,
            field(.items): self.items,
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
        date = self.date(from: container, forKey: .date) ?? date
        items = self.daoEventDayItemArray(with: configuration, from: container, forKey: .items)
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(about, forKey: .about)
        try container.encode(date, forKey: .date)
        try container.encode(items, forKey: .items, configuration: configuration)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOEventDay(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOEventDay else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.items.hasDiffElementsFrom(rhs.items) ||
            lhs.about != rhs.about ||
            lhs.date != rhs.date ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOEventDay, rhs: DAOEventDay) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOEventDay, rhs: DAOEventDay) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
