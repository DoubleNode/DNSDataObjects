//
//  DAOUserChangeRequest.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOUserChangeRequest: PTCLCFGBaseObject {
    var userChangeRequestType: DAOUserChangeRequest.Type { get }
    func userChangeRequest<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOUserChangeRequest? where K: CodingKey
    func userChangeRequestArray<K>(from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOUserChangeRequest] where K: CodingKey
}

public protocol PTCLCFGUserChangeRequestObject: DAOChangeRequest.Config, PTCLCFGDAOUser {
}
public class CFGUserChangeRequestObject: PTCLCFGUserChangeRequestObject {
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
open class DAOUserChangeRequest: DAOChangeRequest, DecodingConfigurationProviding, EncodingConfigurationProviding, @unchecked Sendable {
    public typealias Config = PTCLCFGUserChangeRequestObject
    nonisolated(unsafe) public static var config: any Config = CFGUserChangeRequestObject()

    public static var decodingConfiguration: any DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: any DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createUser() -> DAOUser { config.userType.init() }
    open class func createUser(from object: DAOUser) -> DAOUser { config.userType.init(from: object) }
    open class func createUser(from data: DNSDataDictionary) -> DAOUser? { config.userType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case requestedRole, user
    }
    
    open var requestedRole = DNSUserRole.endUser
    @CodableConfiguration(from: DAOUserChangeRequest.self) open var user: DAOUser? = nil
    
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
    required public init(from object: DAOUserChangeRequest) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOUserChangeRequest) {
        super.update(from: object)
        self.requestedRole = object.requestedRole
        self.user = object.user
        // swiftlint:disable force_cast
        self.user = object.user?.copy() as? DAOUser
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOUserChangeRequest {
        _ = super.dao(from: data)
        let roleData = self.int(from: data[field(.requestedRole)] as Any?) ?? self.requestedRole.rawValue
        self.requestedRole = DNSUserRole(rawValue: roleData) ?? .endUser
        let userData = self.dictionary(from: data[field(.user)] as Any?)
        self.user = Self.createUser(from: userData)
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.requestedRole): self.requestedRole.rawValue,
            field(.user): self.user?.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    override open func encode(to encoder: any Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: any Decoder, configuration: any DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: any Decoder, configuration: any DAOChangeRequest.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: any Decoder, configuration: any Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: any Decoder, configuration: any Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        requestedRole = try container.decodeIfPresent(Swift.type(of: requestedRole), forKey: .requestedRole) ?? requestedRole
        user = self.daoUser(with: configuration, from: container, forKey: .user) ?? user
    }
    override open func encode(to encoder: any Encoder, configuration: any DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: any Encoder, configuration: any Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestedRole, forKey: .requestedRole)
        try container.encode(user, forKey: .user, configuration: configuration)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOUserChangeRequest(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOUserChangeRequest else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.user?.isDiffFrom(rhs.user) ?? (lhs.user != rhs.user)) ||
            lhs.requestedRole != rhs.requestedRole
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOUserChangeRequest, rhs: DAOUserChangeRequest) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOUserChangeRequest, rhs: DAOUserChangeRequest) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
