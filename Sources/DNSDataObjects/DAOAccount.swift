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
        case cards, emailNotifications, name, pushNotifications, users
    }

    open var cards: [DAOCard] = []
    open var emailNotifications = false
    open var name = ""
    open var pushNotifications = false
    open var users: [DAOUser] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(name: String = "") {
        self.name = name
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAccount) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAccount) {
        super.update(from: object)
        self.cards = object.cards
        self.emailNotifications = object.emailNotifications
        self.name = object.name
        self.pushNotifications = object.pushNotifications
        self.users = object.users
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAccount {
        _ = super.dao(from: data)
        let cardsData = self.dataarray(from: data[field(.cards)] as Any?) ?? []
        self.cards = cardsData.map { Self.createCard(from: $0) }
        self.emailNotifications = self.bool(from: data[field(.emailNotifications)] ??
                                            self.emailNotifications)!
        self.name = self.string(from: data[field(.name)] as Any?) ?? self.name
        self.pushNotifications = self.bool(from: data[field(.pushNotifications)] ??
                                           self.pushNotifications)!
        let usersData = self.dataarray(from: data[field(.users)] as Any?) ?? []
        self.users = usersData.map { Self.createUser(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.cards): self.cards.map { $0.asDictionary },
            field(.emailNotifications): self.emailNotifications,
            field(.name): self.name,
            field(.pushNotifications): self.pushNotifications,
            field(.users): self.users.map { $0.asDictionary },
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cards = try container.decode([DAOCard].self, forKey: .cards)
        emailNotifications = try container.decode(Bool.self, forKey: .emailNotifications)
        name = try container.decode(String.self, forKey: .name)
        pushNotifications = try container.decode(Bool.self, forKey: .pushNotifications)
        users = try container.decode([DAOUser].self, forKey: .users)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cards, forKey: .cards)
        try container.encode(emailNotifications, forKey: .emailNotifications)
        try container.encode(name, forKey: .name)
        try container.encode(pushNotifications, forKey: .pushNotifications)
        try container.encode(users, forKey: .users)
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
        return lhs.cards != rhs.cards
            || lhs.emailNotifications != rhs.emailNotifications
            || lhs.name != rhs.name
            || lhs.pushNotifications != rhs.pushNotifications
            || lhs.users != rhs.users
    }
}
