//
//  DAOAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation
import KeyedCodable

open class DAOAccount: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var cardType: DAOCard.Type { DAOCard.self }
    open class var cardArrayType: [DAOCard].Type { [DAOCard].self }
    open class var userType: DAOUser.Type { DAOUser.self }
    open class var userArrayType: [DAOUser].Type { [DAOUser].self }

    open class func createCard() -> DAOCard { cardType.init() }
    open class func createCard(from object: DAOCard) -> DAOCard { cardType.init(from: object) }
    open class func createCard(from data: DNSDataDictionary) -> DAOCard? { cardType.init(from: data) }

    open class func createUser() -> DAOUser { userType.init() }
    open class func createUser(from object: DAOUser) -> DAOUser { userType.init(from: object) }
    open class func createUser(from data: DNSDataDictionary) -> DAOUser? { userType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case cards, dob, emailNotifications, name, pushNotifications, users
    }

    open var cards: [DAOCard] = []
    open var dob: Date?
    open var emailNotifications = false
    open var name = PersonNameComponents()
    open var pushNotifications = false
    open var users: [DAOUser] = []

    // name formatted output
    public var nameAbbreviated: String { self.name.dnsFormatName(style: .abbreviated) }
    public var nameMedium: String { self.name.dnsFormatName(style: .medium) }
    public var nameLong: String { self.name.dnsFormatName(style: .long) }
    public var nameShort: String { self.name.dnsFormatName(style: .short) }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(name: String = "") {
        self.name = PersonNameComponents.dnsBuildName(with: name) ?? self.name
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAccount) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAccount) {
        super.update(from: object)
        self.dob = object.dob
        self.emailNotifications = object.emailNotifications
        self.name = object.name
        self.pushNotifications = object.pushNotifications
        // swiftlint:disable force_cast
        self.cards = object.cards.map { $0.copy() as! DAOCard }
        self.users = object.users.map { $0.copy() as! DAOUser }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAccount {
        _ = super.dao(from: data)
        let cardsData = self.dataarray(from: data[field(.cards)] as Any?)
        self.cards = cardsData.compactMap { Self.createCard(from: $0) }
        self.dob = self.date(from: data[field(.dob)] as Any?) ?? self.dob
        self.emailNotifications = self.bool(from: data[field(.emailNotifications)] ??
                                            self.emailNotifications)!
        let nameData = self.dictionary(from: data[field(.name)] as Any?)
        self.name = PersonNameComponents(from: nameData) ?? self.name
        self.pushNotifications = self.bool(from: data[field(.pushNotifications)] ??
                                           self.pushNotifications)!
        let usersData = self.dataarray(from: data[field(.users)] as Any?)
        self.users = usersData.compactMap { Self.createUser(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.cards): self.cards.map { $0.asDictionary },
            field(.dob): self.dob,
            field(.emailNotifications): self.emailNotifications,
            field(.name): self.name.asDictionary,
            field(.pushNotifications): self.pushNotifications,
            field(.users): self.users.map { $0.asDictionary },
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cards = self.daoCardArray(of: Self.cardArrayType, from: container, forKey: .cards)
        dob = self.date(from: container, forKey: .dob) ?? dob
        emailNotifications = self.bool(from: container, forKey: .emailNotifications) ?? emailNotifications
        name = self.personName(from: container, forKey: .name) ?? name
        pushNotifications = self.bool(from: container, forKey: .pushNotifications) ?? pushNotifications
        users = self.daoUserArray(of: Self.userArrayType, from: container, forKey: .users)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cards, forKey: .cards)
        try container.encode(dob, forKey: .dob)
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
        return super.isDiffFrom(rhs) ||
            lhs.cards != rhs.cards ||
            lhs.dob != rhs.dob ||
            lhs.emailNotifications != rhs.emailNotifications ||
            lhs.name != rhs.name ||
            lhs.pushNotifications != rhs.pushNotifications ||
            lhs.users != rhs.users
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAccount, rhs: DAOAccount) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAccount, rhs: DAOAccount) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
