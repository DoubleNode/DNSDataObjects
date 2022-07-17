//
//  DAOUserChangeRequest.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOUserChangeRequest: DAOChangeRequest {
    public enum CodingKeys: String, CodingKey {
        case user, requestedRole
    }
    
    public var user: DAOUser?
    public var requestedRole: DNSUserRole = .user
    
    // MARK: - Initializers -
    public init(user: DAOUser) {
        self.user = user
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DAOUserChangeRequest) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOUserChangeRequest) {
        super.update(from: object)
        self.user = object.user
        self.requestedRole = object.requestedRole
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOChangeRequest {
        _ = super.dao(from: dictionary)
        let userData: [String: Any?] = dictionary["user"] as? [String : Any?] ?? [:]
        self.user = DAOUser(from: userData)
        let roleData = self.int(from: dictionary["requestedRole"] as Any?) ?? self.requestedRole.rawValue
        self.requestedRole = DNSUserRole(rawValue: roleData) ?? .user
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
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
        var container = encoder.container(keyedBy: CodingKeys.self)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOChangeRequest(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOChangeRequest else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return false
    }
}
