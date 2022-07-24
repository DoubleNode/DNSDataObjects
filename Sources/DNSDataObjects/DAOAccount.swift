//
//  DAOAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAccount: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var cardType: DAOCard.Type { return DAOCard.self }
    open class var userType: DAOUser.Type { return DAOUser.self }

    open class func createCard() -> DAOCard { cardType.init() }
    open class func createCard(from object: DAOCard) -> DAOCard { cardType.init(from: object) }
    open class func createCard(from data: DNSDataDictionary) -> DAOCard { cardType.init(from: data) }

    open class func createUser() -> DAOUser { userType.init() }
    open class func createUser(from object: DAOUser) -> DAOUser { userType.init(from: object) }
    open class func createUser(from data: DNSDataDictionary) -> DAOUser { userType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case name, user, cards, emailNotifications, pushNotifications
    }

    open var name = ""
    open var user = DAOAccount.createUser()
    open var cards: [DAOCard] = []

    open var emailNotifications = false
    open var pushNotifications = false

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(name: String = "", user: DAOUser? = nil) {
        self.name = name
        self.user = user ?? self.user
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAccount) {
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
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAccount {
        _ = super.dao(from: data)
        self.name = self.string(from: data[field(.name)] as Any?) ?? self.name
        self.user = Self.createUser(from: data[field(.user)] as? DNSDataDictionary ?? [:])
        
        let cards = data[field(.cards)] as? [DNSDataDictionary] ?? []
        self.cards = cards.map { Self.createCard(from: $0) }
        self.emailNotifications = self.bool(from: data[field(.emailNotifications)] ??
                                            self.emailNotifications)!
        self.pushNotifications = self.bool(from: data[field(.pushNotifications)] ??
                                           self.pushNotifications)!
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.name): self.name,
            field(.user): self.user.asDictionary,
            field(.cards): self.cards.map { $0.asDictionary },
            field(.emailNotifications): self.emailNotifications,
            field(.pushNotifications): self.pushNotifications,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        user = try container.decode(Self.userType.self, forKey: .user)
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
        try container.encode(user, forKey: .user)
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.name != rhs.name
            || lhs.user != rhs.user
            || lhs.cards != rhs.cards
            || lhs.emailNotifications != rhs.emailNotifications
            || lhs.pushNotifications != rhs.pushNotifications
    }
}
