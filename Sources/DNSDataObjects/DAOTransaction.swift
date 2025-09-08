//
//  DAOTransaction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOTransaction: PTCLCFGBaseObject {
    var transactionType: DAOTransaction.Type { get }
    func transaction<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOTransaction? where K: CodingKey
    func transactionArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOTransaction] where K: CodingKey
}

public protocol PTCLCFGTransactionObject: PTCLCFGDAOCard, PTCLCFGDAOOrder {
}
public class CFGTransactionObject: PTCLCFGTransactionObject {
    public var cardType: DAOCard.Type = DAOCard.self
    open func card<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOCard? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOCard.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func cardArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOCard] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOCard].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var orderType: DAOOrder.Type = DAOOrder.self
    open func order<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOOrder? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOOrder.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func orderArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOOrder] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOOrder].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOTransaction: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGTransactionObject
    public static var config: Config = CFGTransactionObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createCard() -> DAOCard { config.cardType.init() }
    open class func createCard(from object: DAOCard) -> DAOCard { config.cardType.init(from: object) }
    open class func createCard(from data: DNSDataDictionary) -> DAOCard? { config.cardType.init(from: data) }
    
    open class func createOrder() -> DAOOrder { config.orderType.init() }
    open class func createOrder(from object: DAOOrder) -> DAOOrder { config.orderType.init(from: object) }
    open class func createOrder(from data: DNSDataDictionary) -> DAOOrder? { config.orderType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case amount, card, confirmation, order, tax, tip, type
    }

    open var amount: Float = 0
    open var confirmation = ""
    open var tax: Float = 0
    open var tip: Float = 0
    open var type = ""
    @CodableConfiguration(from: DAOTransaction.self) open var card: DAOCard? = nil
    @CodableConfiguration(from: DAOTransaction.self) open var order: DAOOrder? = nil

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOTransaction) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOTransaction) {
        super.update(from: object)
        self.amount = object.amount
        self.confirmation = object.confirmation
        self.tax = object.tax
        self.tip = object.tip
        self.type = object.type
        // swiftlint:disable force_cast
        self.card = object.card?.copy() as? DAOCard
        self.order = object.order?.copy() as? DAOOrder
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOTransaction {
        _ = super.dao(from: data)
        self.amount = self.float(from: data[field(.amount)] as Any?) ?? self.amount
        let cardData = self.dictionary(from: data[field(.card)] as Any?)
        self.card = Self.createCard(from: cardData)
        self.confirmation = self.string(from: data[field(.confirmation)] as Any?) ?? self.confirmation
        let orderData = self.dictionary(from: data[field(.order)] as Any?)
        self.order = Self.createOrder(from: orderData)
        self.tax = self.float(from: data[field(.tax)] as Any?) ?? self.tax
        self.tip = self.float(from: data[field(.tip)] as Any?) ?? self.tip
        self.type = self.string(from: data[field(.type)] as Any?) ?? self.type
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.amount): self.amount,
            field(.card): self.card?.asDictionary ?? [:],
            field(.confirmation): self.confirmation,
            field(.order): self.order?.asDictionary ?? [:],
            field(.tax): self.tax,
            field(.tip): self.tip,
            field(.type): self.type,
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
        amount = self.float(from: container, forKey: .amount) ?? amount
        card = self.daoCard(with: configuration, from: container, forKey: .card) ?? card
        confirmation = self.string(from: container, forKey: .confirmation) ?? confirmation
        order = self.daoOrder(with: configuration, from: container, forKey: .order) ?? order
        tax = self.float(from: container, forKey: .tax) ?? tax
        tip = self.float(from: container, forKey: .tip) ?? tip
        type = self.string(from: container, forKey: .type) ?? type
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(card, forKey: .card, configuration: configuration)
        try container.encode(confirmation, forKey: .confirmation)
        try container.encode(order, forKey: .order, configuration: configuration)
        try container.encode(tax, forKey: .tax)
        try container.encode(tip, forKey: .tip)
        try container.encode(type, forKey: .type)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOTransaction(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOTransaction else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.card?.isDiffFrom(rhs.card) ?? (lhs.card != rhs.card)) ||
            (lhs.order?.isDiffFrom(rhs.order) ?? (lhs.order != rhs.order)) ||
            lhs.amount != rhs.amount ||
            lhs.confirmation != rhs.confirmation ||
            lhs.tax != rhs.tax ||
            lhs.tip != rhs.tip ||
            lhs.type != rhs.type
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOTransaction, rhs: DAOTransaction) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOTransaction, rhs: DAOTransaction) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
