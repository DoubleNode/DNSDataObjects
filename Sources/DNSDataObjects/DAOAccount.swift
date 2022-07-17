//
//  DAOAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOAccount: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case name, user, cards, emailNotifications, pushNotifications
    }

    public var name: String = ""
    public var user: DAOUser?
    public var cards: [DAOCard] = []

    public var emailNotifications: Bool = false
    public var pushNotifications: Bool = false

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    override public init(id: String) {
        super.init(id: id)
    }
    public init(name: String = "", user: DAOUser? = nil) {
        self.name = name
        self.user = user
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOAccount) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAccount) {
        super.update(from: object)
        self.name = object.name
        self.user = object.user
        self.cards = object.cards
        self.emailNotifications = object.emailNotifications
        self.pushNotifications = object.pushNotifications
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOAccount {
        _ = super.dao(from: dictionary)
        self.name = self.string(from: dictionary[CodingKeys.name.rawValue] as Any?) ?? self.name
        self.user = DAOUser(from: dictionary[CodingKeys.user.rawValue] as? [String: Any?] ?? [:])
        
        let cards = dictionary[CodingKeys.cards.rawValue] as? [[String: Any?]] ?? []
        self.cards = cards.map { DAOCard(from: $0) }
        self.emailNotifications = self.bool(from: dictionary[CodingKeys.emailNotifications.rawValue] ??
                                            self.emailNotifications)!
        self.pushNotifications = self.bool(from: dictionary[CodingKeys.pushNotifications.rawValue] ??
                                           self.pushNotifications)!
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.name.rawValue: self.name,
            CodingKeys.user.rawValue: self.user?.asDictionary,
            CodingKeys.cards.rawValue: self.cards.map { $0.asDictionary },
            CodingKeys.emailNotifications.rawValue: self.emailNotifications,
            CodingKeys.pushNotifications.rawValue: self.pushNotifications,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        user = try container.decode(DAOUser.self, forKey: .user)
        cards = try container.decode([DAOCard].self, forKey: .cards)
        emailNotifications = try container.decode(Bool.self, forKey: .emailNotifications)
        pushNotifications = try container.decode(Bool.self, forKey: .pushNotifications)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        if user != nil { try container.encode(user, forKey: .user) }
        try container.encode(cards, forKey: .cards)
        try container.encode(emailNotifications, forKey: .emailNotifications)
        try container.encode(pushNotifications, forKey: .pushNotifications)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAccount(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAccount else { return true }
        let lhs = self
        return lhs.name != rhs.name
            || lhs.user != rhs.user
            || lhs.cards != rhs.cards
            || lhs.emailNotifications != rhs.emailNotifications
            || lhs.pushNotifications != rhs.pushNotifications
    }
}
