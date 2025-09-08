//
//  DAOProduct.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOProduct: PTCLCFGBaseObject {
    var productType: DAOProduct.Type { get }
    func product<K>(from container: KeyedDecodingContainer<K>,
                    forKey key: KeyedDecodingContainer<K>.Key) -> DAOProduct? where K: CodingKey
    func productArray<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> [DAOProduct] where K: CodingKey
}

public protocol PTCLCFGProductObject: PTCLCFGBaseObject, PTCLCFGDAOMedia, PTCLCFGDAOPricing {
}
public class CFGProductObject: PTCLCFGProductObject {
    public var mediaType: DAOMedia.Type = DAOMedia.self
    open func media<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOMedia? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOMedia.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func mediaArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOMedia] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOMedia].self, forKey: key, configuration: self) ?? [] } catch { }
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
open class DAOProduct: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGProductObject
    public static var config: Config = CFGProductObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createMedia() -> DAOMedia { config.mediaType.init() }
    open class func createMedia(from object: DAOMedia) -> DAOMedia { config.mediaType.init(from: object) }
    open class func createMedia(from data: DNSDataDictionary) -> DAOMedia? { config.mediaType.init(from: data) }

    open class func createPricing() -> DAOPricing { config.pricingType.init() }
    open class func createPricing(from object: DAOPricing) -> DAOPricing { config.pricingType.init(from: object) }
    open class func createPricing(from data: DAOPricing) -> DAOPricing? { config.pricingType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case about, mediaItems, pricing, sku, title
    }
    
    open var about = DNSString()
    open var pricing: DAOPricing = DAOPricing()
    open var sku = ""
    open var title = DNSString()
    @CodableConfiguration(from: DAOProduct.self) open var mediaItems: [DAOMedia] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOProduct) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOProduct) {
        super.update(from: object)
        self.sku = object.sku
        // swiftlint:disable force_cast
        self.about = object.about.copy() as! DNSString
        self.mediaItems = object.mediaItems.map { $0.copy() as! DAOMedia }
        self.pricing = object.pricing.copy() as! DAOPricing
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOProduct {
        _ = super.dao(from: data)
        self.about = self.dnsstring(from: data[field(.about)] as Any?) ?? self.about
        let mediaItemsData = self.dataarray(from: data[field(.mediaItems)] as Any?)
        self.mediaItems = mediaItemsData.compactMap { Self.createMedia(from: $0) }
        self.pricing = self.daoPricing(from: data[field(.pricing)] as Any?) ?? self.pricing
        self.sku = self.string(from: data[field(.sku)] as Any?) ?? self.sku
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.about): self.about.asDictionary,
            field(.mediaItems): self.mediaItems.map { $0.asDictionary },
            field(.pricing): self.pricing.asDictionary,
            field(.sku): self.sku,
            field(.title): self.title.asDictionary,
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
        about = self.dnsstring(from: container, forKey: .about) ?? about
        mediaItems = self.daoMediaArray(with: configuration, from: container, forKey: .mediaItems)
        pricing = self.daoPricing(with: configuration, from: container, forKey: .pricing) ?? pricing
        sku = self.string(from: container, forKey: .sku) ?? sku
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(about, forKey: .about)
        try container.encode(mediaItems, forKey: .mediaItems, configuration: configuration)
        try container.encode(pricing, forKey: .pricing)
        try container.encode(sku, forKey: .sku)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOProduct(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOProduct else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.about != rhs.about ||
            lhs.mediaItems.hasDiffElementsFrom(rhs.mediaItems) ||
            lhs.pricing != rhs.pricing ||
            lhs.sku != rhs.sku ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOProduct, rhs: DAOProduct) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOProduct, rhs: DAOProduct) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
