//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOActivityType: PTCLCFGBaseObject {
    var activityTypeType: DAOActivityType.Type { get }
    func activityType<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityType? where K: CodingKey
    func activityTypeArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityType] where K: CodingKey
}

public protocol PTCLCFGActivityTypeObject: PTCLCFGDAOActivityType, PTCLCFGDAOPricing {
}
public class CFGActivityTypeObject: PTCLCFGActivityTypeObject {
    public var activityTypeType: DAOActivityType.Type = DAOActivityType.self
    open func activityType<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityType? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOActivityType.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func activityTypeArray<K>(from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityType] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOActivityType].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    
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
}
open class DAOActivityType: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGActivityTypeObject
    public static var config: Config = CFGActivityTypeObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createActivityType() -> DAOActivityType { config.activityTypeType.init() }
    open class func createActivityType(from object: DAOActivityType) -> DAOActivityType { config.activityTypeType.init(from: object) }
    open class func createActivityType(from data: DNSDataDictionary) -> DAOActivityType? { config.activityTypeType.init(from: data) }

    open class func createPricing() -> DAOPricing { config.pricingType.init() }
    open class func createPricing(from object: DAOPricing) -> DAOPricing { config.pricingType.init(from: object) }
    open class func createPricing(from data: DAOPricing) -> DAOPricing? { config.pricingType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case code, name, pricing
    }

    open var code = ""
    open var name = DNSString()
    open var pricing: DAOPricing = DAOPricing()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(code: String, name: DNSString) {
        self.code = code
        self.name = name
        super.init(id: code)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOActivityType) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOActivityType) {
        super.update(from: object)
        self.code = object.code
        // swiftlint:disable force_cast
        self.name = object.name.copy() as! DNSString
        self.pricing = object.pricing.copy() as! DAOPricing
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOActivityType {
        _ = super.dao(from: data)
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        self.pricing = self.daoPricing(from: data[field(.pricing)] as Any?) ?? self.pricing
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.code): self.code,
            field(.name): self.name.asDictionary,
            field(.pricing): self.pricing.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        try commonInit(from: decoder, configuration: Self.config)
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
        code = self.string(from: container, forKey: .code) ?? code
        name = self.dnsstring(from: container, forKey: .name) ?? name
        pricing = self.daoPricing(with: configuration, from: container, forKey: .pricing) ?? pricing
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(pricing, forKey: .pricing)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOActivityType(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOActivityType else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.code != rhs.code ||
            lhs.name != rhs.name ||
            lhs.pricing != rhs.pricing
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOActivityType, rhs: DAOActivityType) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOActivityType, rhs: DAOActivityType) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
