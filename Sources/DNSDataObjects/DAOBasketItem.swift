//
//  DAOBasketItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOBasketItem: DAOProduct {
    // MARK: - Class Factory methods -
    open class var accountType: DAOAccount.Type { return DAOAccount.self }
    open class var basketType: DAOBasket.Type { return DAOBasket.self }
    open class var placeType: DAOPlace.Type { return DAOPlace.self }

    open class func createAccount() -> DAOAccount { accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount { accountType.init(from: data) }
    
    open class func createBasket() -> DAOBasket { basketType.init() }
    open class func createBasket(from object: DAOBasket) -> DAOBasket { basketType.init(from: object) }
    open class func createBasket(from data: DNSDataDictionary) -> DAOBasket { basketType.init(from: data) }
    
    open class func createPlace() -> DAOPlace { placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace { placeType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, basket, place, quantity
    }
    
    open var account: DAOAccount?
    open var basket: DAOBasket?
    open var place: DAOPlace?
    open var quantity: Int = 0
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOProduct) {
        fatalError("init(from:) has not been implemented")
    }
    required public init(from object: DAOBasketItem) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOBasketItem) {
        super.update(from: object)
        self.account = object.account
        self.basket = object.basket
        self.place = object.place
        self.quantity = object.quantity
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOBasketItem {
        _ = super.dao(from: data)
        let accountData = self.dictionary(from: data[field(.account)] as Any?)
        self.account = Self.createAccount(from: accountData)
        let basketData = self.dictionary(from: data[field(.basket)] as Any?)
        self.basket = Self.createBasket(from: basketData)
        let placeData = self.dictionary(from: data[field(.place)] as Any?)
        self.place = Self.createPlace(from: placeData)
        self.quantity = self.int(from: data[field(.quantity)] as Any?) ?? self.quantity
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.account): self.account?.asDictionary ?? [:],
            field(.basket): self.basket?.asDictionary ?? [:],
            field(.place): self.place?.asDictionary ?? [:],
            field(.quantity): self.quantity,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        account = try container.decode(Self.accountType.self, forKey: .account)
        basket = try container.decode(Self.basketType.self, forKey: .basket)
        place = try container.decode(Self.placeType.self, forKey: .place)
        quantity = try container.decode(Int.self, forKey: .quantity)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(account, forKey: .account)
        try container.encode(basket, forKey: .basket)
        try container.encode(place, forKey: .place)
        try container.encode(quantity, forKey: .quantity)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOBasketItem(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOBasketItem else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.account != rhs.account
            || lhs.basket != rhs.basket
            || lhs.place != rhs.place
            || lhs.quantity != rhs.quantity
    }
}
