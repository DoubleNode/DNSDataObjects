//
//  DAOPricingPrice.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOPricingPrice: PTCLCFGBaseObject {
    var pricingPriceType: DAOPricingPrice.Type { get }
    func pricingPrice<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingPrice? where K: CodingKey
    func pricingPriceArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingPrice] where K: CodingKey
}

public protocol PTCLCFGPricingPriceObject: PTCLCFGDAOPricingPrice {
}
public class CFGPricingPriceObject: PTCLCFGPricingPriceObject {
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
open class DAOPricingPrice: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPricingPriceObject
    public static var config: Config = CFGPricingPriceObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createPricingPrice() -> DAOPricingPrice { config.pricingPriceType.init() }
    open class func createPricingPrice(from object: DAOPricingPrice) -> DAOPricingPrice { config.pricingPriceType.init(from: object) }
    open class func createPricingPrice(from data: DNSDataDictionary) -> DAOPricingPrice? { config.pricingPriceType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case prices
    }

    open var prices: [DNSPrice] = []

    open var price: DNSPrice? { price() }
    open func price(for time: Date = Date()) -> DNSPrice? {
        prices
            .filter { $0.isActive(for: time) }
            .sorted { $0.priority > $1.priority }
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
    required public init(from object: DAOPricingPrice) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPricingPrice) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.prices = object.prices.map { $0.copy() as! DNSPrice }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPricingPrice {
        _ = super.dao(from: data)
        let pricesData = self.dataarray(from: data[field(.prices)] as Any?)
        self.prices = pricesData.compactMap { DNSPrice(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.prices): self.prices.map { $0.asDictionary },
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
        prices = try container.decodeIfPresent([DNSPrice].self, forKey: .prices) ?? []
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prices, forKey: .prices)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPricingPrice(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPricingPrice else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.prices.hasDiffElementsFrom(rhs.prices)
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPricingPrice, rhs: DAOPricingPrice) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPricingPrice, rhs: DAOPricingPrice) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
