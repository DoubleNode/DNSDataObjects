//
//  DAOAccountLinkRequest.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOAccountLinkRequest: PTCLCFGBaseObject {
    var accountLinkRequestType: DAOAccountLinkRequest.Type { get }
    func accountLinkRequest<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccountLinkRequest? where K: CodingKey
    func accountLinkRequestArray<K>(from container: KeyedDecodingContainer<K>,
                                    forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccountLinkRequest] where K: CodingKey
}

public protocol PTCLCFGAccountLinkRequestObject: DAOChangeRequest.Config, PTCLCFGDAOAccount, PTCLCFGDAOAccountLinkRequest, PTCLCFGDAOUser {
}
public class CFGAccountLinkRequestObject: PTCLCFGAccountLinkRequestObject {
    public var accountType: DAOAccount.Type = DAOAccount.self
    open func account<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccount? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAccount.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func accountArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccount] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAccount].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var accountLinkRequestType: DAOAccountLinkRequest.Type = DAOAccountLinkRequest.self
    open func accountLinkRequest<K>(from container: KeyedDecodingContainer<K>,
                                    forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccountLinkRequest? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAccountLinkRequest.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func accountLinkRequestArray<K>(from container: KeyedDecodingContainer<K>,
                                         forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccountLinkRequest] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAccountLinkRequest].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var userType: DAOUser.Type = DAOUser.self
    open func user<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOUser? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOUser.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func userArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOUser] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOUser].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOAccountLinkRequest: DAOChangeRequest, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAccountLinkRequestObject
    public static var config: Config = CFGAccountLinkRequestObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAccount() -> DAOAccount { config.accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { config.accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { config.accountType.init(from: data) }

    open class func createAccountLinkRequest() -> DAOAccountLinkRequest { config.accountLinkRequestType.init() }
    open class func createAccountLinkRequest(from object: DAOAccountLinkRequest) -> DAOAccountLinkRequest { config.accountLinkRequestType.init(from: object) }
    open class func createAccountLinkRequest(from data: DNSDataDictionary) -> DAOAccountLinkRequest? { config.accountLinkRequestType.init(from: data) }

    open class func createUser() -> DAOUser { config.userType.init() }
    open class func createUser(from object: DAOUser) -> DAOUser { config.userType.init(from: object) }
    open class func createUser(from data: DNSDataDictionary) -> DAOUser? { config.userType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case account, approved, approvedBy, requested, user
    }
    
    open var approved: Date?
    open var approvedBy = ""
    open var requested = Date()
    @CodableConfiguration(from: DAOAccountLinkRequest.self) open var account: DAOAccount? = nil
    @CodableConfiguration(from: DAOAccountLinkRequest.self) open var user: DAOUser? = nil
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(user: DAOUser) {
        self.user = user
        super.init()
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOChangeRequest) {
        fatalError("init(from:) has not been implemented")
    }
    required public init(from object: DAOAccountLinkRequest) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAccountLinkRequest) {
        super.update(from: object)
        self.approved = object.approved
        self.approvedBy = object.approvedBy
        self.requested = object.requested
        // swiftlint:disable force_cast
        self.account = object.account?.copy() as? DAOAccount
        self.user = object.user?.copy() as? DAOUser
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAccountLinkRequest {
        _ = super.dao(from: data)
        self.approved = self.time(from: data[field(.approved)] as Any?) ?? self.approved
        self.approvedBy = self.string(from: data[field(.approvedBy)] as Any?) ?? self.approvedBy
        self.requested = self.time(from: data[field(.requested)] as Any?) ?? self.requested
        let accountData = self.dictionary(from: data[field(.account)] as Any?)
        self.account = Self.createAccount(from: accountData)
        let userData = self.dictionary(from: data[field(.user)] as Any?)
        self.user = Self.createUser(from: userData)
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.account): self.account?.asDictionary,
            field(.approved): self.approved,
            field(.approvedBy): self.approvedBy,
            field(.requested): self.requested,
            field(.user): self.user?.asDictionary,
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
    required public init(from decoder: Decoder, configuration: DAOChangeRequest.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        approved = self.time(from: container, forKey: .approved) ?? approved
        approvedBy = self.string(from: container, forKey: .approvedBy) ?? approvedBy
        requested = self.time(from: container, forKey: .requested) ?? requested
        account = self.daoAccount(with: configuration, from: container, forKey: .account) ?? account
        user = self.daoUser(with: configuration, from: container, forKey: .user) ?? user
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(approved, forKey: .approved)
        try container.encode(approvedBy, forKey: .approvedBy)
        try container.encode(requested, forKey: .requested)
        try container.encode(account, forKey: .account, configuration: configuration)
        try container.encode(user, forKey: .user, configuration: configuration)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOUserChangeRequest(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAccountLinkRequest else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.approved != rhs.approved ||
            lhs.approvedBy != rhs.approvedBy ||
            lhs.requested != rhs.requested ||
            lhs.account != rhs.account ||
            lhs.user != rhs.user
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAccountLinkRequest, rhs: DAOAccountLinkRequest) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAccountLinkRequest, rhs: DAOAccountLinkRequest) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
