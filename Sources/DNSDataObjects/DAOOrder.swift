//
//  DAOOrder.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOOrder: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var accountType: DAOAccount.Type { return DAOAccount.self }
    open class var itemType: DAOOrderItem.Type { return DAOOrderItem.self }
    open class var placeType: DAOPlace.Type { return DAOPlace.self }
    open class var transactionType: DAOTransaction.Type { return DAOTransaction.self }

    open class func createAccount() -> DAOAccount { accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount { accountType.init(from: data) }

    open class func createItem() -> DAOOrderItem { itemType.init() }
    open class func createItem(from object: DAOOrderItem) -> DAOOrderItem { itemType.init(from: object) }
    open class func createItem(from data: DNSDataDictionary) -> DAOOrderItem { itemType.init(from: data) }

    open class func createPlace() -> DAOPlace { placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace { placeType.init(from: data) }
    
    open class func createTransaction() -> DAOTransaction { transactionType.init() }
    open class func createTransaction(from object: DAOTransaction) -> DAOTransaction { transactionType.init(from: object) }
    open class func createTransaction(from data: DNSDataDictionary) -> DAOTransaction { transactionType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, items, place, state, transaction
    }

    open var account: DAOAccount?
    open var items: [DAOOrderItem] = []
    open var place: DAOPlace?
    open var state = DNSOrderState.unknown
    open var transaction: DAOTransaction?

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
       self.account = object.account
       self.items = object.items
       self.place = object.place
       self.state = object.state
       self.transaction = object.transaction
   }

    // MARK: - DAO translation methods -
   required public init(from data: DNSDataDictionary) {
       super.init(from: data)
   }
   override open func dao(from data: DNSDataDictionary) -> DAOOrder {
       _ = super.dao(from: data)
       let accountData = data[field(.account)] as? DNSDataDictionary ?? [:]
       self.account = Self.createAccount(from: accountData)
       let itemsData = data[field(.items)] as? [DNSDataDictionary] ?? []
       self.items = itemsData.map { Self.createItem(from: $0) }
       let placeData = data[field(.place)] as? DNSDataDictionary ?? [:]
       self.place = Self.createPlace(from: placeData)
       let stateData = self.string(from: data[field(.state)] as Any?) ?? ""
       self.state = DNSOrderState(rawValue: stateData) ?? self.state
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
           field(.transaction): self.transaction?.asDictionary,
       ]) { (current, _) in current }
       return retval
   }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        account = try container.decode(Self.accountType.self, forKey: .account)
        items = try container.decode([DAOOrderItem].self, forKey: .items)
        place = try container.decode(Self.placeType.self, forKey: .place)
        state = try container.decode(DNSOrderState.self, forKey: .state)
        transaction = try container.decode(Self.transactionType.self, forKey: .transaction)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(account, forKey: .account)
        try container.encode(items, forKey: .items)
        try container.encode(place, forKey: .place)
        try container.encode(state, forKey: .state)
        try container.encode(transaction, forKey: .transaction)
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
        return lhs.account != rhs.account
            || lhs.items != rhs.items
            || lhs.place != rhs.place
            || lhs.state != rhs.state
            || lhs.transaction != rhs.transaction
    }
}
