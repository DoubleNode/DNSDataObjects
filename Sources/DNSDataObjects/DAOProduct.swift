//
//  DAOProduct.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOProduct: PTCLCFGBaseObject {
    var productType: DAOProduct.Type { get }
    func productArray<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> [DAOProduct] where K: CodingKey
}

public protocol PTCLCFGProductObject: PTCLCFGBaseObject {
}
public class CFGProductObject: PTCLCFGProductObject {
}
open class DAOProduct: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGProductObject
    public static var config: Config = CFGProductObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case about, price, sku, title
    }
    
    open var about = DNSString()
    open var price: Float = 0
    open var sku = ""
    open var title = DNSString()
    
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
        self.about = object.about
        self.price = object.price
        self.sku = object.sku
        self.title = object.title
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOProduct {
        _ = super.dao(from: data)
        self.about = self.dnsstring(from: data[field(.about)] as Any?) ?? self.about
        self.price = self.float(from: data[field(.price)] as Any?) ?? self.price
        self.sku = self.string(from: data[field(.sku)] as Any?) ?? self.sku
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.about): self.about.asDictionary,
            field(.price): self.price,
            field(.sku): self.sku,
            field(.title): self.title.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder, configuration: PTCLCFGBaseObject) throws {
        fatalError("init(from:configuration:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        about = self.dnsstring(from: container, forKey: .about) ?? about
        price = self.float(from: container, forKey: .price) ?? price
        sku = self.string(from: container, forKey: .sku) ?? sku
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(about, forKey: .about)
        try container.encode(price, forKey: .price)
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.about != rhs.about ||
            lhs.price != rhs.price ||
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
