//
//  DAOTransaction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOTransaction: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var cardType: DAOCard.Type { return DAOCard.self }
    open class var orderType: DAOOrder.Type { return DAOOrder.self }

    open class func createCard() -> DAOCard { cardType.init() }
    open class func createCard(from object: DAOCard) -> DAOCard { cardType.init(from: object) }
    open class func createCard(from data: DNSDataDictionary) -> DAOCard { cardType.init(from: data) }
    
    open class func createOrder() -> DAOOrder { orderType.init() }
    open class func createOrder(from object: DAOOrder) -> DAOOrder { orderType.init(from: object) }
    open class func createOrder(from data: DNSDataDictionary) -> DAOOrder { orderType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case amount, card, confirmation, order, type
    }

    open var amount: Float = 0
    open var card: DAOCard?
    open var confirmation = ""
    open var order: DAOOrder?
    open var type = ""

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
        self.card = object.card
        self.confirmation = object.confirmation
        self.order = object.order
        self.type = object.type
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOTransaction {
        _ = super.dao(from: data)
        self.amount = self.float(from: data[field(.amount)] as Any?) ?? self.amount
        let cardData = data[field(.card)] as? DNSDataDictionary ?? [:]
        self.card = Self.createCard(from: cardData)
        self.confirmation = self.string(from: data[field(.confirmation)] as Any?) ?? self.confirmation
        let orderData = data[field(.order)] as? DNSDataDictionary ?? [:]
        self.order = Self.createOrder(from: orderData)
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
            field(.type): self.type,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Float.self, forKey: .amount)
        card = try container.decode(Self.cardType.self, forKey: .card)
        confirmation = try container.decode(String.self, forKey: .confirmation)
        order = try container.decode(Self.orderType.self, forKey: .order)
        type = try container.decode(String.self, forKey: .type)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(card, forKey: .card)
        try container.encode(confirmation, forKey: .confirmation)
        try container.encode(order, forKey: .order)
        try container.encode(type, forKey: .type)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOTransaction(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOTransaction else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.amount != rhs.amount
            || lhs.card != rhs.card
            || lhs.confirmation != rhs.confirmation
            || lhs.order != rhs.order
            || lhs.type != rhs.type
    }
}
