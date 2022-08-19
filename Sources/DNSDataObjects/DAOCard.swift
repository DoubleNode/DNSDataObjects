//
//  DAOCard.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOCard: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var transactionType: DAOTransaction.Type { return DAOTransaction.self }

    open class func createTransaction() -> DAOTransaction { transactionType.init() }
    open class func createTransaction(from object: DAOTransaction) -> DAOTransaction { transactionType.init(from: object) }
    open class func createTransaction(from data: DNSDataDictionary) -> DAOTransaction { transactionType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case cardNumber, expiration, nickname, pinNumber, transactions
    }

    open var cardNumber = ""
    open var expiration: Date?
    open var nickname = ""
    open var pinNumber = ""
    open var transactions: [DAOTransaction] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(cardNumber: String, nickname: String, pinNumber: String) {
        self.cardNumber = cardNumber
        self.nickname = nickname
        self.pinNumber = pinNumber
        super.init(id: cardNumber)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOCard) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOCard) {
        super.update(from: object)
        self.cardNumber = object.cardNumber
        self.expiration = object.expiration
        self.nickname = object.nickname
        self.pinNumber = object.pinNumber
        // swiftlint:disable force_cast
        self.transactions = object.transactions.map { $0.copy() as! DAOTransaction }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOCard {
        _ = super.dao(from: data)
        self.cardNumber = self.string(from: data[field(.cardNumber)] as Any?) ?? self.cardNumber
        self.expiration = self.time(from: data[field(.expiration)] as Any?) ?? self.expiration
        self.nickname = self.string(from: data[field(.nickname)] as Any?) ?? self.nickname
        self.pinNumber = self.string(from: data[field(.pinNumber)] as Any?) ?? self.pinNumber
        let transactionsData = self.dataarray(from: data[field(.transactions)] as Any?)
        self.transactions = transactionsData.map { Self.createTransaction(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.cardNumber): self.cardNumber,
            field(.expiration): self.expiration,
            field(.nickname): self.nickname,
            field(.pinNumber): self.pinNumber,
            field(.transactions): self.transactions.map { $0.asDictionary },
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cardNumber = try container.decode(String.self, forKey: .cardNumber)
        expiration = try container.decode(Date.self, forKey: .expiration)
        nickname = try container.decode(String.self, forKey: .nickname)
        pinNumber = try container.decode(String.self, forKey: .pinNumber)
        transactions = try container.decode([DAOTransaction].self, forKey: .transactions)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(expiration, forKey: .expiration)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(pinNumber, forKey: .pinNumber)
        try container.encode(transactions, forKey: .transactions)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOCard(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOCard else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.cardNumber != rhs.cardNumber ||
            lhs.expiration != rhs.expiration ||
            lhs.nickname != rhs.nickname ||
            lhs.pinNumber != rhs.pinNumber ||
            lhs.transactions != rhs.transactions
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOCard, rhs: DAOCard) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOCard, rhs: DAOCard) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
