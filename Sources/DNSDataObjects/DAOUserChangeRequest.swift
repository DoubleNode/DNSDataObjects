//
//  DAOUserChangeRequest.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOUserChangeRequest: DAOChangeRequest {
    // MARK: - Class Factory methods -
    open class var userType: DAOUser.Type { return DAOUser.self }

    open class func createUser() -> DAOUser { userType.init() }
    open class func createUser(from object: DAOUser) -> DAOUser { userType.init(from: object) }
    open class func createUser(from data: DNSDataDictionary) -> DAOUser { userType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case requestedRole, user
    }
    
    open var requestedRole = DNSUserRole.endUser
    open var user: DAOUser?
    
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
    required public init(from data: DNSDataDictionary) {
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
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        requestedRole = try container.decode(DNSUserRole.self, forKey: .requestedRole)
        user = try container.decode(Self.userType.self, forKey: .user)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestedRole, forKey: .requestedRole)
        try container.encode(user, forKey: .user)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOUserChangeRequest(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOUserChangeRequest else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.requestedRole != rhs.requestedRole
            || lhs.user != rhs.user
    }
}
