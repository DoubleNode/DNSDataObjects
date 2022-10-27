//
//  DAOOrder.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOOrder: PTCLCFGBaseObject {
    var orderType: DAOOrder.Type { get }
    func order<K>(from container: KeyedDecodingContainer<K>,
                  forKey key: KeyedDecodingContainer<K>.Key) -> DAOOrder? where K: CodingKey
    func orderArray<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOOrder] where K: CodingKey
}

public protocol PTCLCFGOrderObject: PTCLCFGDAOAccount, PTCLCFGDAOOrderItem, PTCLCFGDAOPlace, PTCLCFGDAOTransaction {
}
public class CFGOrderObject: PTCLCFGOrderObject {
    public var accountType: DAOAccount.Type = DAOAccount.self
    public var orderItemType: DAOOrderItem.Type = DAOOrderItem.self
    public var placeType: DAOPlace.Type = DAOPlace.self
    public var transactionType: DAOTransaction.Type = DAOTransaction.self

    open func account<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccount? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAccount.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func orderItem<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOOrderItem? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOOrderItem.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func place<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlace? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPlace.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func transaction<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOTransaction? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOTransaction.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }

    open func accountArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccount] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAccount].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func orderItemArray<K>(from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOOrderItem] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOOrderItem].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func placeArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlace].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func transactionArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOTransaction] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOTransaction].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOOrder: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGOrderObject
    public static var config: Config = CFGOrderObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAccount() -> DAOAccount { config.accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { config.accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { config.accountType.init(from: data) }

    open class func createOrderItem() -> DAOOrderItem { config.orderItemType.init() }
    open class func createOrderItem(from object: DAOOrderItem) -> DAOOrderItem { config.orderItemType.init(from: object) }
    open class func createOrderItem(from data: DNSDataDictionary) -> DAOOrderItem? { config.orderItemType.init(from: data) }

    open class func createPlace() -> DAOPlace { config.placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { config.placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { config.placeType.init(from: data) }
    
    open class func createTransaction() -> DAOTransaction { config.transactionType.init() }
    open class func createTransaction(from object: DAOTransaction) -> DAOTransaction { config.transactionType.init(from: object) }
    open class func createTransaction(from data: DNSDataDictionary) -> DAOTransaction? { config.transactionType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, items, place, state, subtotal, tax, total, transaction
    }

    open var state = DNSOrderState.unknown
    open var subtotal: Float = 0
    open var tax: Float = 0
    open var total: Float = 0
    @CodableConfiguration(from: DAOOrder.self) open var account: DAOAccount? = nil
    @CodableConfiguration(from: DAOOrder.self) open var items: [DAOOrderItem] = []
    @CodableConfiguration(from: DAOOrder.self) open var place: DAOPlace? = nil
    @CodableConfiguration(from: DAOOrder.self) open var transaction: DAOTransaction? = nil

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
   required public init(from object: DAOOrder) {
       super.init(from: object)
       self.update(from: object)
   }
   open func update(from object: DAOOrder) {
       super.update(from: object)
       self.state = object.state
       self.subtotal = object.subtotal
       self.tax = object.tax
       self.total = object.total
       // swiftlint:disable force_cast
       self.items = object.items.map { $0.copy() as! DAOOrderItem }
       self.account = object.account?.copy() as? DAOAccount
       self.place = object.place?.copy() as? DAOPlace
       self.transaction = object.transaction?.copy() as? DAOTransaction
       // swiftlint:enable force_cast
   }

    // MARK: - DAO translation methods -
   required public init?(from data: DNSDataDictionary) {
       guard !data.isEmpty else { return nil }
       super.init(from: data)
   }
   override open func dao(from data: DNSDataDictionary) -> DAOOrder {
       _ = super.dao(from: data)
       let accountData = self.dictionary(from: data[field(.account)] as Any?)
       self.account = Self.createAccount(from: accountData)
       let itemsData = self.dataarray(from: data[field(.items)] as Any?)
       self.items = itemsData.compactMap { Self.createOrderItem(from: $0) }
       let placeData = self.dictionary(from: data[field(.place)] as Any?)
       self.place = Self.createPlace(from: placeData)
       let stateData = self.string(from: data[field(.state)] as Any?) ?? ""
       self.state = DNSOrderState(rawValue: stateData) ?? self.state
       self.subtotal = self.float(from: data[field(.subtotal)] as Any?) ?? self.subtotal
       self.tax = self.float(from: data[field(.tax)] as Any?) ?? self.tax
       self.total = self.float(from: data[field(.total)] as Any?) ?? self.total
       let transactionData = data[field(.transaction)] as? DNSDataDictionary ?? [:]
       self.transaction = Self.createTransaction(from: transactionData)
       return self
   }
   override open var asDictionary: DNSDataDictionary {
       var retval = super.asDictionary
       retval.merge([
           field(.account): self.account?.asDictionary,
           field(.items): self.items.map { $0.asDictionary },
           field(.place): self.place?.asDictionary,
           field(.state): self.state.rawValue,
           field(.subtotal): self.subtotal,
           field(.tax): self.tax,
           field(.total): self.total,
           field(.transaction): self.transaction?.asDictionary,
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
        account = self.daoAccount(with: configuration, from: container, forKey: .account) ?? account
        items = self.daoOrderItemArray(with: configuration, from: container, forKey: .items)
        place = self.daoPlace(with: configuration, from: container, forKey: .place) ?? place
        subtotal = self.float(from: container, forKey: .subtotal) ?? subtotal
        tax = self.float(from: container, forKey: .tax) ?? tax
        total = self.float(from: container, forKey: .total) ?? total
        transaction = self.daoTransaction(with: configuration, from: container, forKey: .transaction) ?? transaction

        state = try container.decodeIfPresent(Swift.type(of: state), forKey: .state) ?? state
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(account, forKey: .account, configuration: configuration)
        try container.encode(items, forKey: .items, configuration: configuration)
        try container.encode(place, forKey: .place, configuration: configuration)
        try container.encode(state, forKey: .state)
        try container.encode(subtotal, forKey: .subtotal)
        try container.encode(tax, forKey: .tax)
        try container.encode(total, forKey: .total)
        try container.encode(transaction, forKey: .transaction, configuration: configuration)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOOrder(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOOrder else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.items.hasDiffElementsFrom(rhs.items) ||
            lhs.account != rhs.account ||
            lhs.place != rhs.place ||
            lhs.state != rhs.state ||
            lhs.subtotal != rhs.subtotal ||
            lhs.tax != rhs.tax ||
            lhs.total != rhs.total ||
            lhs.transaction != rhs.transaction
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOOrder, rhs: DAOOrder) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOOrder, rhs: DAOOrder) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
