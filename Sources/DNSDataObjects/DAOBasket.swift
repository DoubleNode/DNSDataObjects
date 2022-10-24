//
//  DAOBasket.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOBasket: PTCLCFGBaseObject {
    var basketType: DAOBasket.Type { get }
    func basketArray<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> [DAOBasket] where K: CodingKey
}

public protocol PTCLCFGBasketObject: PTCLCFGDAOAccount, PTCLCFGDAOBasketItem, PTCLCFGDAOPlace {
}
public class CFGBasketObject: PTCLCFGBasketObject {
    public var accountType: DAOAccount.Type = DAOAccount.self
    public var basketItemType: DAOBasketItem.Type = DAOBasketItem.self
    public var placeType: DAOPlace.Type = DAOPlace.self

    open func account<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccount? where K: CodingKey {
        do { return try container.decodeIfPresent(self.accountType, forKey: key,
                                                  configuration: self) ?? nil } catch { }
        return nil
    }

    open func accountArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccount] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAccount].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func basketItemArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOBasketItem] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOBasketItem].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func placeArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlace].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOBasket: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGBasketObject
    public static var config: Config = CFGBasketObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAccount() -> DAOAccount { config.accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { config.accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { config.accountType.init(from: data) }

    open class func createBasketItem() -> DAOBasketItem { config.basketItemType.init() }
    open class func createBasketItem(from object: DAOBasketItem) -> DAOBasketItem { config.basketItemType.init(from: object) }
    open class func createBasketItem(from data: DNSDataDictionary) -> DAOBasketItem? { config.basketItemType.init(from: data) }

    open class func createPlace() -> DAOPlace { config.placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { config.placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { config.placeType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, items, place
    }

    @CodableConfiguration(from: DAOBasket.self) open var account: DAOAccount? = nil
    @CodableConfiguration(from: DAOBasket.self) open var items: [DAOBasketItem] = []
    @CodableConfiguration(from: DAOBasket.self) open var place: DAOPlace? = nil

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
       self.items = itemsData.compactMap { Self.createBasketItem(from: $0) }
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
        items = self.daoBasketItemArray(with: configuration, from: container, forKey: .items)
        place = self.daoPlace(with: configuration, from: container, forKey: .place) ?? place
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(account, forKey: .account, configuration: configuration)
        try container.encode(items, forKey: .items, configuration: configuration)
        try container.encode(place, forKey: .place, configuration: configuration)
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
