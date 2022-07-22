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
        case user, requestedRole
    }
    
    public var user: DAOUser?
    public var requestedRole: DNSUserRole = .user
    
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
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOUserChangeRequest) {
        super.update(from: object)
        self.user = object.user
        self.requestedRole = object.requestedRole
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOChangeRequest {
        _ = super.dao(from: data)
        let userData: DNSDataDictionary = data[field(.user)] as? [String : Any?] ?? [:]
        self.user = Self.createUser(from: userData)
        let roleData = self.int(from: data[field(.requestedRole)] as Any?) ?? self.requestedRole.rawValue
        self.requestedRole = DNSUserRole(rawValue: roleData) ?? .user
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.user): self.user?.asDictionary,
            field(.requestedRole): self.requestedRole.rawValue,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
//        var container = encoder.container(keyedBy: CodingKeys.self)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOChangeRequest(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOChangeRequest else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
//        let lhs = self
        return false
    }
}
