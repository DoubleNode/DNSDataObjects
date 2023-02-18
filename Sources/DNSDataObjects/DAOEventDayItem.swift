//
//  DAOEventDayItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
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
        case address, distribution, endTime, geopoint, startTime, subtitle, title
    }

    open var address: DNSPostalAddress?
    open var distribution = DNSVisibility.everyone
    open var endTime = DNSTimeOfDay()
    open var geopoint: CLLocation?
    open var startTime = DNSTimeOfDay()
    open var subtitle = DNSString()
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
        self.address = object.address
        self.distribution = object.distribution
        self.endTime = object.endTime
        self.geopoint = object.geopoint
        self.startTime = object.startTime
        // swiftlint:disable force_cast
        self.subtitle = object.subtitle.copy() as! DNSString
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
        self.address = self.dnsPostalAddress(from: data[field(.address)] as Any?) ?? self.address
        let distributionData = self.string(from: data[field(.distribution)] as Any?) ?? self.distribution.rawValue
        self.distribution = DNSVisibility(rawValue: distributionData) ?? .everyone
        self.endTime = self.timeOfDay(from: data[field(.endTime)] as Any?) ?? self.endTime
        self.geopoint = self.location(from: data[field(.geopoint)] as Any?) ?? self.geopoint
        self.startTime = self.timeOfDay(from: data[field(.startTime)] as Any?) ?? self.startTime
        self.subtitle = self.dnsstring(from: data[field(.subtitle)] as Any?) ?? self.subtitle
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        if let address {
            retval.merge([
                field(.address): address.asDictionary,
            ]) { (current, _) in current }
        }
        if let geopoint {
            retval.merge([
                field(.geopoint): geopoint.asDictionary,
            ]) { (current, _) in current }
        }
        retval.merge([
            field(.distribution): self.distribution.rawValue,
            field(.endTime): self.endTime,
            field(.startTime): self.startTime,
            field(.subtitle): self.subtitle.asDictionary,
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
        address = self.dnsPostalAddress(from: container, forKey: .address) ?? address
        distribution = try container.decodeIfPresent(Swift.type(of: distribution), forKey: .distribution) ?? distribution
        endTime = self.timeOfDay(from: container, forKey: .endTime) ?? endTime
        let geopointData = try container.decodeIfPresent([String: Double].self, forKey: .geopoint) ?? [:]
        geopoint = CLLocation(from: geopointData)
        startTime = self.timeOfDay(from: container, forKey: .startTime) ?? startTime
        subtitle = self.dnsstring(from: container, forKey: .subtitle) ?? subtitle
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(distribution, forKey: .distribution)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(geopoint?.asDictionary as? [String: Double], forKey: .geopoint)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(subtitle, forKey: .subtitle)
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
            lhs.address != rhs.address ||
            lhs.distribution != rhs.distribution ||
            lhs.endTime != rhs.endTime ||
            lhs.geopoint != rhs.geopoint ||
            lhs.startTime != rhs.startTime ||
            lhs.subtitle != rhs.subtitle ||
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
