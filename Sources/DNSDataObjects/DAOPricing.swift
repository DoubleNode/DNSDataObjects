//
//  DAOPricing.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOPricing: PTCLCFGBaseObject {
    var pricingType: DAOPricing.Type { get }
    func pricing<K>(from container: KeyedDecodingContainer<K>,
                    forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricing? where K: CodingKey
    func pricingArray<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricing] where K: CodingKey
}

public protocol PTCLCFGPricingObject: PTCLCFGDAOPricing, PTCLCFGDAOPricingTier {
}
public class CFGPricingObject: PTCLCFGPricingObject {
    public var pricingType: DAOPricing.Type = DAOPricing.self
    open func pricing<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricing? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPricing.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func pricingArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricing] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPricing].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    
    public var pricingTierType: DAOPricingTier.Type = DAOPricingTier.self
    open func pricingTier<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingTier? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPricingTier.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func pricingTierArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingTier] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPricingTier].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOPricing: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPricingObject
    public static var config: Config = CFGPricingObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createPricing() -> DAOPricing { config.pricingType.init() }
    open class func createPricing(from object: DAOPricing) -> DAOPricing { config.pricingType.init(from: object) }
    open class func createPricing(from data: DNSDataDictionary) -> DAOPricing? { config.pricingType.init(from: data) }

    open class func createPricingTier() -> DAOPricingTier { config.pricingTierType.init() }
    open class func createPricingTier(from object: DAOPricingTier) -> DAOPricingTier { config.pricingTierType.init(from: object) }
    open class func createPricingTier(from data: DNSDataDictionary) -> DAOPricingTier? { config.pricingTierType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case tiers
    }

    open var tiers: [DAOPricingTier] = []

    open func dataString(for tierId: String,
                         and stringId: String) -> DNSString? {
        self.tier(for: tierId)?.dataStrings[stringId]
    }
    open func dataStrings(for tierId: String) -> [String: DNSString] {
        self.tier(for: tierId)?.dataStrings ?? [:]
    }
    open func price(for tierId: String,
                    and time: Date = Date()) -> DNSPrice? {
        self.tier(for: tierId)?.price(for: time)
    }
    open func tier(for tierId: String) -> DAOPricingTier? {
        let tier = tiers
            .filter { $0.id == tierId }
            .sorted { $0.priority > $1.priority }
            .first ?? tiers.first
        return tier
    }
    open func exceptionTitle(for tierId: String,
                             and time: Date = Date()) -> DNSString? {
        self.tier(for: tierId)?.exceptionTitle(for: time)
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOPricing) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPricing) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.tiers = object.tiers.map { $0.copy() as! DAOPricingTier }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPricing {
        _ = super.dao(from: data)
        let tiersData = self.dataarray(from: data[field(.tiers)] as Any?)
        self.tiers = tiersData.compactMap { Self.createPricingTier(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.tiers): self.tiers.map { $0.asDictionary },
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
        tiers = self.daoPricingTierArray(with: configuration, from: container, forKey: .tiers)
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tiers, forKey: .tiers, configuration: configuration)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPricing(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPricing else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.tiers.hasDiffElementsFrom(rhs.tiers)
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPricing, rhs: DAOPricing) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPricing, rhs: DAOPricing) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
