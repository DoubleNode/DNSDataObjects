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
        case billingAddress, cardHolderName, cardNumber, expiration, nickname, pinNumber, transactions
    }

    open var billingAddress: DNSPostalAddress = DNSPostalAddress()
    open var cardHolderName = PersonNameComponents()
    open var cardNumber = ""
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
        self.cardHolderName = object.cardHolderName
        self.cardNumber = object.cardNumber
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
        self.cardHolderName = self.personName(from: data[field(.cardHolderName)] as Any?) ?? self.cardHolderName
        self.cardNumber = self.string(from: data[field(.cardNumber)] as Any?) ?? self.cardNumber
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
            field(.cardHolderName): self.cardHolderName.asDictionary,
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
        cardHolderName = self.personName(from: container, forKey: .cardHolderName) ?? cardHolderName
        cardNumber = self.string(from: container, forKey: .cardNumber) ?? cardNumber
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
        try container.encode(cardHolderName, forKey: .cardHolderName)
        try container.encode(cardNumber, forKey: .cardNumber)
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
            lhs.cardHolderName != rhs.cardHolderName ||
            lhs.cardNumber != rhs.cardNumber ||
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
