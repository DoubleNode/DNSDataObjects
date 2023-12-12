//
//  DAOPricingSeason.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOPricingSeason: PTCLCFGBaseObject {
    var pricingSeasonType: DAOPricingSeason.Type { get }
    func pricingSeason<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingSeason? where K: CodingKey
    func pricingSeasonArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingSeason] where K: CodingKey
}

public protocol PTCLCFGPricingSeasonObject: PTCLCFGDAOPricingItem, PTCLCFGDAOPricingSeason {
}
public class CFGPricingSeasonObject: PTCLCFGPricingSeasonObject {
    public var pricingItemType: DAOPricingItem.Type = DAOPricingItem.self
    open func pricingItem<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingItem? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPricingItem.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func pricingItemArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingItem] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPricingItem].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var pricingSeasonType: DAOPricingSeason.Type = DAOPricingSeason.self
    open func pricingSeason<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingSeason? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPricingSeason.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func pricingSeasonArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingSeason] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPricingSeason].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOPricingSeason: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPricingSeasonObject
    public static var config: Config = CFGPricingSeasonObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createPricingItem() -> DAOPricingItem { config.pricingItemType.init() }
    open class func createPricingItem(from object: DAOPricingItem) -> DAOPricingItem { config.pricingItemType.init(from: object) }
    open class func createPricingItem(from data: DNSDataDictionary) -> DAOPricingItem? { config.pricingItemType.init(from: data) }

    open class func createPricingSeason() -> DAOPricingSeason { config.pricingSeasonType.init() }
    open class func createPricingSeason(from object: DAOPricingSeason) -> DAOPricingSeason { config.pricingSeasonType.init(from: object) }
    open class func createPricingSeason(from data: DNSDataDictionary) -> DAOPricingSeason? { config.pricingSeasonType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endTime, items, priority, startTime
    }

    public enum C {
        public static let defaultEndTime = Date(timeIntervalSinceReferenceDate: Date.Seconds.deltaOneYear * 30.0)
        public static let defaultStartTime = Date(timeIntervalSinceReferenceDate: 0.0)
    }

    open var endTime = C.defaultEndTime
    open var items: [DAOPricingItem] = []
    open var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }
    open var startTime = C.defaultStartTime

    public var isActive: Bool { isActive() }
    public func isActive(for time: Date = Date()) -> Bool {
        guard startTime != C.defaultStartTime && endTime != C.defaultEndTime else { return true }
        guard startTime != C.defaultStartTime else { return time < endTime }
        guard endTime != C.defaultEndTime else { return time > startTime }
        return time > startTime && time < endTime
    }

    open var item: DAOPricingItem? { item() }
    open func item(for time: Date = Date()) -> DAOPricingItem? {
        items
            .filter { $0.price(for: time) != nil }
            .sorted { $0.priority > $1.priority }
            .first
    }
    open var price: DNSPrice? { price() }
    open func price(for time: Date = Date()) -> DNSPrice? {
        items
            .filter { $0.price(for: time) != nil }
            .sorted { $0.priority > $1.priority }
            .compactMap { $0.price(for: time) }
            .first
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOPricingSeason) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPricingSeason) {
        super.update(from: object)
        self.endTime = object.endTime
        self.priority = object.priority
        self.startTime = object.startTime
        // swiftlint:disable force_cast
        self.items = object.items.map { $0.copy() as! DAOPricingItem }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPricingSeason {
        _ = super.dao(from: data)
        self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.endTime
        let itemsData = self.dataarray(from: data[field(.items)] as Any?)
        self.items = itemsData.compactMap { Self.createPricingItem(from: $0) }
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.endTime): self.endTime,
            field(.items): self.items.map { $0.asDictionary },
            field(.priority): self.priority,
            field(.startTime): self.startTime,
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
        endTime = self.date(from: container, forKey: .endTime) ?? endTime
        items = self.daoPricingItemArray(with: configuration, from: container, forKey: .items)
        priority = self.int(from: container, forKey: .priority) ?? priority
        startTime = self.date(from: container, forKey: .startTime) ?? startTime
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(items, forKey: .items, configuration: configuration)
        try container.encode(priority, forKey: .priority)
        try container.encode(startTime, forKey: .startTime)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPricingSeason(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPricingSeason else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.endTime != rhs.endTime ||
            lhs.items.hasDiffElementsFrom(rhs.items) ||
            lhs.priority != rhs.priority ||
            lhs.startTime != rhs.startTime
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPricingSeason, rhs: DAOPricingSeason) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPricingSeason, rhs: DAOPricingSeason) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
