//
//  DAOCard.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOCard: PTCLCFGBaseObject {
    var cardType: DAOCard.Type { get }
    func card<K>(from container: KeyedDecodingContainer<K>,
                 forKey key: KeyedDecodingContainer<K>.Key) -> DAOCard? where K: CodingKey
    func cardArray<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> [DAOCard] where K: CodingKey
}

public protocol PTCLCFGCardObject: PTCLCFGDAOTransaction {
}
public class CFGCardObject: PTCLCFGCardObject {
    public var transactionType: DAOTransaction.Type = DAOTransaction.self
    open func transaction<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOTransaction? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOTransaction.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func transactionArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOTransaction] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOTransaction].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOCard: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGCardObject
    public static var config: Config = CFGCardObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createTransaction() -> DAOTransaction { config.transactionType.init() }
    open class func createTransaction(from object: DAOTransaction) -> DAOTransaction { config.transactionType.init(from: object) }
    open class func createTransaction(from data: DNSDataDictionary) -> DAOTransaction? { config.transactionType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case billingAddress, cardHolderEmail, cardHolderName, cardHolderPhone
        case cardNumber, cardType, `default`, expiration, nickname, pinNumber, transactions
    }

    open var billingAddress: DNSPostalAddress = DNSPostalAddress()
    open var cardHolderEmail = ""
    open var cardHolderName = PersonNameComponents()
    open var cardHolderPhone = ""
    open var cardNumber = ""
    open var cardType = ""
    open var `default` = false
    open var expiration: Date?
    open var nickname = ""
    open var pinNumber = ""
    @CodableConfiguration(from: DAOCard.self) open var transactions: [DAOTransaction] = []

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
        self.billingAddress = object.billingAddress
        self.cardHolderEmail = object.cardHolderEmail
        self.cardHolderName = object.cardHolderName
        self.cardHolderPhone = object.cardHolderPhone
        self.cardNumber = object.cardNumber
        self.cardType = object.cardType
        self.default = object.default
        self.expiration = object.expiration
        self.nickname = object.nickname
        self.pinNumber = object.pinNumber
        // swiftlint:disable force_cast
        self.transactions = object.transactions.map { $0.copy() as! DAOTransaction }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOCard {
        _ = super.dao(from: data)
        self.billingAddress = self.dnsPostalAddress(from: data[field(.billingAddress)] as Any?) ?? self.billingAddress
        self.cardHolderEmail = self.string(from: data[field(.cardHolderEmail)] as Any?) ?? self.cardHolderEmail
        self.cardHolderName = self.personName(from: data[field(.cardHolderName)] as Any?) ?? self.cardHolderName
        self.cardHolderPhone = self.string(from: data[field(.cardHolderPhone)] as Any?) ?? self.cardHolderPhone
        self.cardNumber = self.string(from: data[field(.cardNumber)] as Any?) ?? self.cardNumber
        self.cardType = self.string(from: data[field(.cardType)] as Any?) ?? self.cardType
        self.default = self.bool(from: data[field(.default)] as Any?) ?? self.default
        self.expiration = self.time(from: data[field(.expiration)] as Any?) ?? self.expiration
        self.nickname = self.string(from: data[field(.nickname)] as Any?) ?? self.nickname
        self.pinNumber = self.string(from: data[field(.pinNumber)] as Any?) ?? self.pinNumber
        let transactionsData = self.dataarray(from: data[field(.transactions)] as Any?)
        self.transactions = transactionsData.compactMap { Self.createTransaction(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.billingAddress): self.billingAddress.asDictionary,
            field(.cardHolderEmail): self.cardHolderEmail,
            field(.cardHolderName): self.cardHolderName.asDictionary,
            field(.cardHolderPhone): self.cardHolderPhone,
            field(.cardNumber): self.cardNumber,
            field(.cardType): self.cardType,
            field(.default): self.default,
            field(.expiration): self.expiration,
            field(.nickname): self.nickname,
            field(.pinNumber): self.pinNumber,
            field(.transactions): self.transactions.map { $0.asDictionary },
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
        billingAddress = self.dnsPostalAddress(from: container, forKey: .billingAddress) ?? billingAddress
        cardHolderEmail = self.string(from: container, forKey: .cardHolderEmail) ?? cardHolderEmail
        cardHolderName = self.personName(from: container, forKey: .cardHolderName) ?? cardHolderName
        cardHolderPhone = self.string(from: container, forKey: .cardHolderPhone) ?? cardHolderPhone
        cardNumber = self.string(from: container, forKey: .cardNumber) ?? cardNumber
        cardType = self.string(from: container, forKey: .cardType) ?? cardType
        self.default = self.bool(from: container, forKey: .default) ?? self.default
        expiration = self.date(from: container, forKey: .expiration) ?? expiration
        nickname = self.string(from: container, forKey: .nickname) ?? nickname
        pinNumber = self.string(from: container, forKey: .pinNumber) ?? pinNumber
        transactions = self.daoTransactionArray(with: configuration, from: container, forKey: .transactions)
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(billingAddress, forKey: .billingAddress)
        try container.encode(cardHolderEmail, forKey: .cardHolderEmail)
        try container.encode(cardHolderName, forKey: .cardHolderName)
        try container.encode(cardHolderPhone, forKey: .cardHolderPhone)
        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(cardType, forKey: .cardType)
        try container.encode(self.default, forKey: .default)
        try container.encode(expiration, forKey: .expiration)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(pinNumber, forKey: .pinNumber)
        try container.encode(transactions, forKey: .transactions, configuration: configuration)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOCard(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOCard else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.transactions.hasDiffElementsFrom(rhs.transactions) ||
            lhs.billingAddress != rhs.billingAddress ||
            lhs.cardHolderEmail != rhs.cardHolderEmail ||
            lhs.cardHolderName != rhs.cardHolderName ||
            lhs.cardHolderPhone != rhs.cardHolderPhone ||
            lhs.cardNumber != rhs.cardNumber ||
            lhs.cardType != rhs.cardType ||
            lhs.default != rhs.default ||
            lhs.expiration != rhs.expiration ||
            lhs.nickname != rhs.nickname ||
            lhs.pinNumber != rhs.pinNumber
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOCard, rhs: DAOCard) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOCard, rhs: DAOCard) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
