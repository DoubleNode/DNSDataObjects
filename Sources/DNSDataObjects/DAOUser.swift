//
//  DAOUser.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOUser: DAOBaseObject {
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
    override public init() {
        super.init()
    }
    override public init(id: String) {
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
    public init(from object: DAOUser) {
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
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOUser {
        _ = super.dao(from: dictionary)
        self.email = self.string(from: dictionary[CodingKeys.email.rawValue]  as Any?) ?? self.email
        self.firstName = self.string(from: dictionary[CodingKeys.firstName.rawValue] as Any?) ?? self.firstName
        self.lastName = self.string(from: dictionary[CodingKeys.lastName.rawValue] as Any?) ?? self.lastName
        self.phone = self.string(from: dictionary[CodingKeys.phone.rawValue] as Any?) ?? self.phone
        self.dob = self.date(from: dictionary[CodingKeys.dob.rawValue] as Any?) ?? self.dob

        let cardsData = dictionary[CodingKeys.cards.rawValue] as? [[String: Any?]] ?? []
        self.cards = cardsData.map { DAOCard(from: $0) }

        let favoritesData = dictionary[CodingKeys.favorites.rawValue] as? [[String: Any?]] ?? []
        self.favorites = favoritesData.map { DAOActivityType(from: $0) }

        let myCenterData = dictionary[CodingKeys.myCenter.rawValue] as? [String: Any?] ?? [:]
        self.myCenter = DAOCenter(from: myCenterData)
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.email.rawValue: self.email,
            CodingKeys.firstName.rawValue: self.firstName,
            CodingKeys.lastName.rawValue: self.lastName,
            CodingKeys.phone.rawValue: self.phone,
            CodingKeys.dob.rawValue: self.dob,
            CodingKeys.cards.rawValue: self.cards.map { $0.asDictionary },
            CodingKeys.favorites.rawValue: self.favorites.map { $0.asDictionary },
            CodingKeys.myCenter.rawValue: self.myCenter?.asDictionary,
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
