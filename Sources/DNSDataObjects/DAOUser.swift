//
//  DAOUser.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOUser: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var activityType: DAOActivityType.Type { return DAOActivityType.self }
    open class var cardType: DAOCard.Type { return DAOCard.self }
    open class var centerType: DAOCenter.Type { return DAOCenter.self }

    open class func createActivity() -> DAOActivityType { activityType.init() }
    open class func createActivity(from object: DAOActivityType) -> DAOActivityType { activityType.init(from: object) }
    open class func createActivity(from data: DNSDataDictionary) -> DAOActivityType { activityType.init(from: data) }

    open class func createCard() -> DAOCard { cardType.init() }
    open class func createCard(from object: DAOCard) -> DAOCard { cardType.init(from: object) }
    open class func createCard(from data: DNSDataDictionary) -> DAOCard { cardType.init(from: data) }

    open class func createCenter() -> DAOCenter { centerType.init() }
    open class func createCenter(from object: DAOCenter) -> DAOCenter { centerType.init(from: object) }
    open class func createCenter(from data: DNSDataDictionary) -> DAOCenter { centerType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case email, firstName, lastName, phone, dob
        case cards, favorites, myCenter
    }

    public var email: String = ""
    public var firstName: String = ""
    public var lastName: String = ""
    public var phone: String = ""
    public var dob: Date?
    public var cards: [DAOCard] = []
    public var favorites: [DAOActivityType] = []
    open var myCenter: DAOCenter?

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(id: String, email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = ""
        self.dob = nil
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOUser) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOUser) {
        super.update(from: object)
        self.email = object.email
        self.firstName = object.firstName
        self.lastName = object.lastName
        self.phone = object.phone
        self.dob = object.dob
        self.cards = object.cards
        self.favorites = object.favorites
        self.myCenter = object.myCenter
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOUser {
        _ = super.dao(from: data)
        self.email = self.string(from: data[field(.email)]  as Any?) ?? self.email
        self.firstName = self.string(from: data[field(.firstName)] as Any?) ?? self.firstName
        self.lastName = self.string(from: data[field(.lastName)] as Any?) ?? self.lastName
        self.phone = self.string(from: data[field(.phone)] as Any?) ?? self.phone
        self.dob = self.date(from: data[field(.dob)] as Any?) ?? self.dob

        let cardsData = data[field(.cards)] as? [DNSDataDictionary] ?? []
        self.cards = cardsData.map { Self.createCard(from: $0) }

        let favoritesData = data[field(.favorites)] as? [DNSDataDictionary] ?? []
        self.favorites = favoritesData.map { Self.createActivity(from: $0) }

        let myCenterData = data[field(.myCenter)] as? DNSDataDictionary ?? [:]
        self.myCenter = Self.createCenter(from: myCenterData)
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.email): self.email,
            field(.firstName): self.firstName,
            field(.lastName): self.lastName,
            field(.phone): self.phone,
            field(.dob): self.dob,
            field(.cards): self.cards.map { $0.asDictionary },
            field(.favorites): self.favorites.map { $0.asDictionary },
            field(.myCenter): self.myCenter?.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phone = try container.decode(String.self, forKey: .phone)
        dob = try container.decode(Date?.self, forKey: .dob)
        cards = try container.decode([DAOCard].self, forKey: .cards)
        favorites = try container.decode([DAOActivityType].self, forKey: .favorites)
        myCenter = try container.decode(DAOCenter.self, forKey: .myCenter)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phone, forKey: .phone)
        try container.encode(dob, forKey: .dob)
        try container.encode(cards, forKey: .cards)
        try container.encode(favorites, forKey: .favorites)
        try container.encode(myCenter, forKey: .myCenter)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOUser(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOUser else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.email != rhs.email
            || lhs.firstName != rhs.firstName
            || lhs.lastName != rhs.lastName
            || lhs.phone != rhs.phone
            || lhs.dob != rhs.dob
            || lhs.cards != rhs.cards
            || lhs.favorites != rhs.favorites
            || lhs.myCenter != rhs.myCenter
    }
}
