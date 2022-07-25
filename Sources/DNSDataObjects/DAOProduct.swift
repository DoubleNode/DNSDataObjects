//
//  DAOProduct.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOProduct: DAOBaseObject {
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
    required public init(from data: DNSDataDictionary) {
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
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        about = try container.decode(DNSString.self, forKey: .about)
        price = try container.decode(Float.self, forKey: .price)
        sku = try container.decode(String.self, forKey: .sku)
        title = try container.decode(DNSString.self, forKey: .title)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
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
        return lhs.about != rhs.about
            || lhs.price != rhs.price
            || lhs.sku != rhs.sku
            || lhs.title != rhs.title
    }
}
