//
//  DAOBasketItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOBasketItem: PTCLCFGBaseObject {
    var basketItemType: DAOBasketItem.Type { get }
    func basketItemArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOBasketItem] where K: CodingKey
}

public protocol PTCLCFGBasketItemObject: PTCLCFGDAOAccount, PTCLCFGDAOBasket, PTCLCFGDAOPlace {
}
public class CFGBasketItemObject: PTCLCFGBasketItemObject {
    public var accountType: DAOAccount.Type = DAOAccount.self
    public var basketType: DAOBasket.Type = DAOBasket.self
    public var placeType: DAOPlace.Type = DAOPlace.self

    open func accountArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccount] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAccount].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func basketArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOBasket] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOBasket].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func placeArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlace].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOBasketItem: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGBasketItemObject
    public static var config: Config = CFGBasketItemObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAccount() -> DAOAccount { config.accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { config.accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { config.accountType.init(from: data) }
    
    open class func createBasket() -> DAOBasket { config.basketType.init() }
    open class func createBasket(from object: DAOBasket) -> DAOBasket { config.basketType.init(from: object) }
    open class func createBasket(from data: DNSDataDictionary) -> DAOBasket? { config.basketType.init(from: data) }
    
    open class func createPlace() -> DAOPlace { config.placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { config.placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { config.placeType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, basket, place, quantity
    }
    
    @CodableConfiguration(from: DAOBasketItem.self) open var account: DAOAccount? = nil
    @CodableConfiguration(from: DAOBasketItem.self) open var basket: DAOBasket? = nil
    @CodableConfiguration(from: DAOBasketItem.self) open var place: DAOPlace? = nil
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
        self.quantity = object.quantity
        // swiftlint:disable force_cast
        self.account = object.account?.copy() as? DAOAccount
        self.basket = object.basket?.copy() as? DAOBasket
        self.place = object.place?.copy() as? DAOPlace
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
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
        fatalError("init(from:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        fatalError("init(from:configuration:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        account = self.daoAccount(with: configuration, from: container, forKey: .account) ?? account
        basket = self.daoBasket(with: configuration, from: container, forKey: .basket) ?? basket
        place = self.daoPlace(with: configuration, from: container, forKey: .place) ?? place
        quantity = self.int(from: container, forKey: .quantity) ?? quantity
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(account, forKey: .account, configuration: configuration)
        try container.encode(basket, forKey: .basket, configuration: configuration)
        try container.encode(place, forKey: .place, configuration: configuration)
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
        return super.isDiffFrom(rhs) ||
            lhs.account != rhs.account ||
            lhs.basket != rhs.basket ||
            lhs.place != rhs.place ||
            lhs.quantity != rhs.quantity
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOBasketItem, rhs: DAOBasketItem) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOBasketItem, rhs: DAOBasketItem) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
