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
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { accountType.init(from: data) }

    open class func createItem() -> DAOOrderItem { itemType.init() }
    open class func createItem(from object: DAOOrderItem) -> DAOOrderItem { itemType.init(from: object) }
    open class func createItem(from data: DNSDataDictionary) -> DAOOrderItem? { itemType.init(from: data) }

    open class func createPlace() -> DAOPlace { placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { placeType.init(from: data) }
    
    open class func createTransaction() -> DAOTransaction { transactionType.init() }
    open class func createTransaction(from object: DAOTransaction) -> DAOTransaction { transactionType.init(from: object) }
    open class func createTransaction(from data: DNSDataDictionary) -> DAOTransaction? { transactionType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, items, place, state, subtotal, tax, total, transaction
    }

    open var account: DAOAccount?
    open var items: [DAOOrderItem] = []
    open var place: DAOPlace?
    open var state = DNSOrderState.unknown
    open var subtotal: Float = 0
    open var tax: Float = 0
    open var total: Float = 0
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
       self.items = itemsData.compactMap { Self.createItem(from: $0) }
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        account = try container.decodeIfPresent(Self.accountType.self, forKey: .account) ?? account
        items = try container.decodeIfPresent([DAOOrderItem].self, forKey: .items) ?? items
        place = try container.decodeIfPresent(Self.placeType.self, forKey: .place) ?? place
        state = try container.decodeIfPresent(DNSOrderState.self, forKey: .state) ?? state
        subtotal = try container.decodeIfPresent(Float.self, forKey: .subtotal) ?? subtotal
        tax = try container.decodeIfPresent(Float.self, forKey: .tax) ?? tax
        total = try container.decodeIfPresent(Float.self, forKey: .total) ?? total
        transaction = try container.decodeIfPresent(Self.transactionType.self, forKey: .transaction) ?? transaction
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
        try container.encode(subtotal, forKey: .subtotal)
        try container.encode(tax, forKey: .tax)
        try container.encode(total, forKey: .total)
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
        return super.isDiffFrom(rhs) ||
            lhs.account != rhs.account ||
            lhs.items != rhs.items ||
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
