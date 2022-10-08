//
//  DAOBasket.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOBasket: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var accountType: DAOAccount.Type { return DAOAccount.self }
    open class var itemType: DAOBasketItem.Type { return DAOBasketItem.self }
    open class var placeType: DAOPlace.Type { return DAOPlace.self }

    open class func createAccount() -> DAOAccount { accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { accountType.init(from: data) }

    open class func createItem() -> DAOBasketItem { itemType.init() }
    open class func createItem(from object: DAOBasketItem) -> DAOBasketItem { itemType.init(from: object) }
    open class func createItem(from data: DNSDataDictionary) -> DAOBasketItem? { itemType.init(from: data) }

    open class func createPlace() -> DAOPlace { placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { placeType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, items, place
    }

    open var account: DAOAccount?
    open var items: [DAOBasketItem] = []
    open var place: DAOPlace?

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
   required public init(from object: DAOBasket) {
       super.init(from: object)
       self.update(from: object)
   }
   open func update(from object: DAOBasket) {
       super.update(from: object)
       self.account = object.account
       self.place = object.place
       // swiftlint:disable force_cast
       self.items = object.items.map { $0.copy() as! DAOBasketItem }
       self.account = object.account?.copy() as? DAOAccount
       self.place = object.place?.copy() as? DAOPlace
       // swiftlint:enable force_cast
   }

    // MARK: - DAO translation methods -
   required public init?(from data: DNSDataDictionary) {
       guard !data.isEmpty else { return nil }
       super.init(from: data)
   }
   override open func dao(from data: DNSDataDictionary) -> DAOBasket {
       _ = super.dao(from: data)
       let accountData = self.dictionary(from: data[field(.account)] as Any?)
       self.account = Self.createAccount(from: accountData)
       let itemsData = self.dataarray(from: data[field(.items)] as Any?)
       self.items = itemsData.compactMap { Self.createItem(from: $0) }
       let placeData = self.dictionary(from: data[field(.place)] as Any?)
       self.place = Self.createPlace(from: placeData)
       return self
   }
   override open var asDictionary: DNSDataDictionary {
       var retval = super.asDictionary
       retval.merge([
           field(.account): self.account?.asDictionary,
           field(.items): self.items.map { $0.asDictionary },
           field(.place): self.place?.asDictionary,
       ]) { (current, _) in current }
       return retval
   }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        account = try container.decodeIfPresent(Self.accountType.self, forKey: .account) ?? account
        items = try container.decodeIfPresent([DAOBasketItem].self, forKey: .items) ?? items
        place = try container.decodeIfPresent(Self.placeType.self, forKey: .place) ?? place
        try super.init(from: decoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(account, forKey: .account)
        try container.encode(items, forKey: .items)
        try container.encode(place, forKey: .place)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOBasket(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOBasket else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.account != rhs.account ||
            lhs.items != rhs.items ||
            lhs.place != rhs.place
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOBasket, rhs: DAOBasket) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOBasket, rhs: DAOBasket) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
