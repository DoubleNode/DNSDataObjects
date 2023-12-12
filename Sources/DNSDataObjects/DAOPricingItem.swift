//
//  DAOPricingItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOPricingItem: PTCLCFGBaseObject {
    var pricingItemType: DAOPricingItem.Type { get }
    func pricingItem<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingItem? where K: CodingKey
    func pricingItemArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingItem] where K: CodingKey
}

public protocol PTCLCFGPricingItemObject: PTCLCFGDAOPricingItem, PTCLCFGDAOPricingPrice {
}
public class CFGPricingItemObject: PTCLCFGPricingItemObject {
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

    public var pricingPriceType: DAOPricingPrice.Type = DAOPricingPrice.self
    open func pricingPrice<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingPrice? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPricingPrice.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func pricingPriceArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingPrice] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPricingPrice].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOPricingItem: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPricingItemObject
    public static var config: Config = CFGPricingItemObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createPricingItem() -> DAOPricingItem { config.pricingItemType.init() }
    open class func createPricingItem(from object: DAOPricingItem) -> DAOPricingItem { config.pricingItemType.init(from: object) }
    open class func createPricingItem(from data: DNSDataDictionary) -> DAOPricingItem? { config.pricingItemType.init(from: data) }

    open class func createPricingPrice() -> DAOPricingPrice { config.pricingPriceType.init() }
    open class func createPricingPrice(from object: DAOPricingPrice) -> DAOPricingPrice { config.pricingPriceType.init(from: object) }
    open class func createPricingPrice(from data: DNSDataDictionary) -> DAOPricingPrice? { config.pricingPriceType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case priceDefault
        case priceFriday, priceMonday, priceSaturday, priceSunday, priceThursday
        case priceTuesday, priceWednesday
        case priority
    }

    open var priceDefault: DAOPricingPrice?
    open var priceFriday: DAOPricingPrice?
    open var priceMonday: DAOPricingPrice?
    open var priceSaturday: DAOPricingPrice?
    open var priceSunday: DAOPricingPrice?
    open var priceThursday: DAOPricingPrice?
    open var priceTuesday: DAOPricingPrice?
    open var priceWednesday: DAOPricingPrice?
    open var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }

    open var price: DNSPrice? { price() }
    open func price(for time: Date = Date()) -> DNSPrice? {
        var retval = priceDefault?.price(for: time)
        switch time.dnsDayOfWeek {
        case .friday: retval = priceFriday?.price(for: time) ?? retval
        case .monday: retval = priceMonday?.price(for: time) ?? retval
        case .saturday: retval = priceSaturday?.price(for: time) ?? retval
        case .sunday: retval = priceSunday?.price(for: time) ?? retval
        case .thursday: retval = priceThursday?.price(for: time) ?? retval
        case .tuesday: retval = priceTuesday?.price(for: time) ?? retval
        case .wednesday: retval = priceWednesday?.price(for: time) ?? retval
        default: break
        }
        return retval
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOPricingItem) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPricingItem) {
        super.update(from: object)
        self.priceDefault = object.priceDefault?.copy() as? DAOPricingPrice
        self.priceFriday = object.priceFriday?.copy() as? DAOPricingPrice
        self.priceMonday = object.priceMonday?.copy() as? DAOPricingPrice
        self.priceSaturday = object.priceSaturday?.copy() as? DAOPricingPrice
        self.priceSunday = object.priceSunday?.copy() as? DAOPricingPrice
        self.priceThursday = object.priceThursday?.copy() as? DAOPricingPrice
        self.priceTuesday = object.priceTuesday?.copy() as? DAOPricingPrice
        self.priceWednesday = object.priceWednesday?.copy() as? DAOPricingPrice
        self.priority = object.priority
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPricingItem {
        _ = super.dao(from: data)
        self.priceDefault = Self.createPricingPrice(from: self.dictionary(from: data[field(.priceDefault)] as Any?))
        self.priceFriday = Self.createPricingPrice(from: self.dictionary(from: data[field(.priceFriday)] as Any?))
        self.priceMonday = Self.createPricingPrice(from: self.dictionary(from: data[field(.priceMonday)] as Any?))
        self.priceSaturday = Self.createPricingPrice(from: self.dictionary(from: data[field(.priceSaturday)] as Any?))
        self.priceSunday = Self.createPricingPrice(from: self.dictionary(from: data[field(.priceSunday)] as Any?))
        self.priceThursday = Self.createPricingPrice(from: self.dictionary(from: data[field(.priceThursday)] as Any?))
        self.priceTuesday = Self.createPricingPrice(from: self.dictionary(from: data[field(.priceTuesday)] as Any?))
        self.priceWednesday = Self.createPricingPrice(from: self.dictionary(from: data[field(.priceWednesday)] as Any?))
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        if let priceDefault { retval.merge([ field(.priceDefault): priceDefault.asDictionary ]) { (current, _) in current } }
        if let priceFriday { retval.merge([ field(.priceFriday): priceFriday.asDictionary ]) { (current, _) in current } }
        if let priceMonday { retval.merge([ field(.priceMonday): priceMonday.asDictionary ]) { (current, _) in current } }
        if let priceSaturday { retval.merge([ field(.priceSaturday): priceSaturday.asDictionary ]) { (current, _) in current } }
        if let priceSunday { retval.merge([ field(.priceSunday): priceSunday.asDictionary ]) { (current, _) in current } }
        if let priceThursday { retval.merge([ field(.priceThursday): priceThursday.asDictionary ]) { (current, _) in current } }
        if let priceTuesday { retval.merge([ field(.priceTuesday): priceTuesday.asDictionary ]) { (current, _) in current } }
        if let priceWednesday { retval.merge([ field(.priceWednesday): priceWednesday.asDictionary ]) { (current, _) in current } }
        retval.merge([
            field(.priority): self.priority,
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
        priceDefault = self.daoPricingPrice(with: configuration, from: container, forKey: .priceDefault) ?? priceDefault
        priceFriday = self.daoPricingPrice(with: configuration, from: container, forKey: .priceFriday) ?? priceFriday
        priceMonday = self.daoPricingPrice(with: configuration, from: container, forKey: .priceMonday) ?? priceMonday
        priceSaturday = self.daoPricingPrice(with: configuration, from: container, forKey: .priceSaturday) ?? priceSaturday
        priceSunday = self.daoPricingPrice(with: configuration, from: container, forKey: .priceSunday) ?? priceSunday
        priceThursday = self.daoPricingPrice(with: configuration, from: container, forKey: .priceThursday) ?? priceThursday
        priceTuesday = self.daoPricingPrice(with: configuration, from: container, forKey: .priceTuesday) ?? priceTuesday
        priceWednesday = self.daoPricingPrice(with: configuration, from: container, forKey: .priceWednesday) ?? priceWednesday
        priority = self.int(from: container, forKey: .priority) ?? priority
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(priceDefault, forKey: .priceDefault, configuration: configuration)
        try container.encode(priceFriday, forKey: .priceFriday, configuration: configuration)
        try container.encode(priceMonday, forKey: .priceMonday, configuration: configuration)
        try container.encode(priceSaturday, forKey: .priceSaturday, configuration: configuration)
        try container.encode(priceSunday, forKey: .priceSunday, configuration: configuration)
        try container.encode(priceThursday, forKey: .priceThursday, configuration: configuration)
        try container.encode(priceTuesday, forKey: .priceTuesday, configuration: configuration)
        try container.encode(priceWednesday, forKey: .priceWednesday, configuration: configuration)
        try container.encode(priority, forKey: .priority)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPricingItem(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPricingItem else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.priceDefault?.isDiffFrom(rhs.priceDefault) ?? (lhs.priceDefault != rhs.priceDefault)) ||
            (lhs.priceFriday?.isDiffFrom(rhs.priceFriday) ?? (lhs.priceFriday != rhs.priceFriday)) ||
            (lhs.priceMonday?.isDiffFrom(rhs.priceMonday) ?? (lhs.priceMonday != rhs.priceMonday)) ||
            (lhs.priceSaturday?.isDiffFrom(rhs.priceSaturday) ?? (lhs.priceSaturday != rhs.priceSaturday)) ||
            (lhs.priceSunday?.isDiffFrom(rhs.priceSunday) ?? (lhs.priceSunday != rhs.priceSunday)) ||
            (lhs.priceThursday?.isDiffFrom(rhs.priceThursday) ?? (lhs.priceThursday != rhs.priceThursday)) ||
            (lhs.priceTuesday?.isDiffFrom(rhs.priceTuesday) ?? (lhs.priceTuesday != rhs.priceTuesday)) ||
            (lhs.priceWednesday?.isDiffFrom(rhs.priceWednesday) ?? (lhs.priceWednesday != rhs.priceWednesday)) ||
            lhs.priority != rhs.priority
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPricingItem, rhs: DAOPricingItem) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPricingItem, rhs: DAOPricingItem) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
