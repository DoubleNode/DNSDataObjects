//
//  DAOOrderItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOOrderItem: PTCLCFGBaseObject {
    var orderItemType: DAOOrderItem.Type { get }
    func orderItem<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOOrderItem? where K: CodingKey
    func orderItemArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOOrderItem] where K: CodingKey
}

public protocol PTCLCFGOrderItemObject: PTCLCFGDAOAccount, PTCLCFGDAOOrder, PTCLCFGDAOPlace {
}
public class CFGOrderItemObject: PTCLCFGOrderItemObject {
    public var accountType: DAOAccount.Type = DAOAccount.self
    public var orderType: DAOOrder.Type = DAOOrder.self
    public var placeType: DAOPlace.Type = DAOPlace.self

    open func account<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccount? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAccount.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func order<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOOrder? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOOrder.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func place<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlace? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPlace.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }

    open func accountArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccount] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAccount].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func orderArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOOrder] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOOrder].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func placeArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlace].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOOrderItem: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGOrderItemObject
    public static var config: Config = CFGOrderItemObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAccount() -> DAOAccount { config.accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { config.accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { config.accountType.init(from: data) }
    
    open class func createOrder() -> DAOOrder { config.orderType.init() }
    open class func createOrder(from object: DAOOrder) -> DAOOrder { config.orderType.init(from: object) }
    open class func createOrder(from data: DNSDataDictionary) -> DAOOrder? { config.orderType.init(from: data) }
    
    open class func createPlace() -> DAOPlace { config.placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { config.placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { config.placeType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, order, place, quantity
    }
    
    open var quantity: Int = 0
    @CodableConfiguration(from: DAOOrderItem.self) open var account: DAOAccount? = nil
    @CodableConfiguration(from: DAOOrderItem.self) open var order: DAOOrder? = nil
    @CodableConfiguration(from: DAOOrderItem.self) open var place: DAOPlace? = nil
    
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
    required public init(from object: DAOOrderItem) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOOrderItem) {
        super.update(from: object)
        self.quantity = object.quantity
        // swiftlint:disable force_cast
        self.account = object.account?.copy() as? DAOAccount
        self.order = object.order?.copy() as? DAOOrder
        self.place = object.place?.copy() as? DAOPlace
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOOrderItem {
        _ = super.dao(from: data)
        let accountData = self.dictionary(from: data[field(.account)] as Any?)
        self.account = Self.createAccount(from: accountData)
        let orderData = self.dictionary(from: data[field(.order)] as Any?)
        self.order = Self.createOrder(from: orderData)
        let placeData = self.dictionary(from: data[field(.place)] as Any?)
        self.place = Self.createPlace(from: placeData)
        self.quantity = self.int(from: data[field(.quantity)] as Any?) ?? self.quantity
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.account): self.account?.asDictionary ?? [:],
            field(.order): self.order?.asDictionary ?? [:],
            field(.place): self.place?.asDictionary ?? [:],
            field(.quantity): self.quantity,
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
        order = self.daoOrder(with: configuration, from: container, forKey: .order) ?? order
        place = self.daoPlace(with: configuration, from: container, forKey: .place) ?? place
        quantity = self.int(from: container, forKey: .quantity) ?? quantity
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(account, forKey: .account, configuration: configuration)
        try container.encode(order, forKey: .order, configuration: configuration)
        try container.encode(place, forKey: .place, configuration: configuration)
        try container.encode(quantity, forKey: .quantity)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOOrderItem(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOOrderItem else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.account?.isDiffFrom(rhs.account) ?? true) ||
            (lhs.order?.isDiffFrom(rhs.order) ?? true) ||
            (lhs.place?.isDiffFrom(rhs.place) ?? true) ||
            lhs.quantity != rhs.quantity
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOOrderItem, rhs: DAOOrderItem) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOOrderItem, rhs: DAOOrderItem) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
