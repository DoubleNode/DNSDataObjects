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
    open class var accountType: DAOAccount.Type { return DAOAccount.self }
    open class var activityType: DAOActivityType.Type { return DAOActivityType.self }
    open class var cardType: DAOCard.Type { return DAOCard.self }
    open class var placeType: DAOPlace.Type { return DAOPlace.self }

    open class func createAccount() -> DAOAccount { accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount { accountType.init(from: data) }

    open class func createActivity() -> DAOActivityType { activityType.init() }
    open class func createActivity(from object: DAOActivityType) -> DAOActivityType { activityType.init(from: object) }
    open class func createActivity(from data: DNSDataDictionary) -> DAOActivityType { activityType.init(from: data) }

    open class func createCard() -> DAOCard { cardType.init() }
    open class func createCard(from object: DAOCard) -> DAOCard { cardType.init(from: object) }
    open class func createCard(from data: DNSDataDictionary) -> DAOCard { cardType.init(from: data) }

    open class func createPlace() -> DAOPlace { placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace { placeType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case accounts, cards, dob, email, favorites, firstName, lastName, myPlace, phone
    }

    open var accounts: [DAOAccount] = []
    open var cards: [DAOCard] = []
    open var dob: Date?
    open var email: String = ""
    open var favorites: [DAOActivityType] = []
    open var firstName: String = ""
    open var lastName: String = ""
    open var myPlace: DAOPlace?
    open var phone: String = ""

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(id: String, email: String, firstName: String, lastName: String) {
        self.dob = nil
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = ""
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOUser) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOUser) {
        super.update(from: object)
        self.dob = object.dob
        self.email = object.email
        self.firstName = object.firstName
        self.lastName = object.lastName
        self.phone = object.phone
        // swiftlint:disable force_cast
        self.accounts = object.accounts.map { $0.copy() as! DAOAccount }
        self.cards = object.cards.map { $0.copy() as! DAOCard }
        self.favorites = object.favorites.map { $0.copy() as! DAOActivityType }
        self.myPlace = object.myPlace?.copy() as? DAOPlace
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOUser {
        _ = super.dao(from: data)
        let accountsData = data[field(.accounts)] as? [DNSDataDictionary] ?? []
        self.accounts = accountsData.map { Self.createAccount(from: $0) }
        let cardsData = self.dataarray(from: data[field(.cards)] as Any?)
        self.cards = cardsData.map { Self.createCard(from: $0) }
        self.dob = self.date(from: data[field(.dob)] as Any?) ?? self.dob
        self.email = self.string(from: data[field(.email)]  as Any?) ?? self.email
        let favoritesData = self.dataarray(from: data[field(.favorites)] as Any?)
        self.favorites = favoritesData.map { Self.createActivity(from: $0) }
        self.firstName = self.string(from: data[field(.firstName)] as Any?) ?? self.firstName
        self.lastName = self.string(from: data[field(.lastName)] as Any?) ?? self.lastName
        let myPlaceData = self.dictionary(from: data[field(.myPlace)] as Any?)
        self.myPlace = Self.createPlace(from: myPlaceData)
        self.phone = self.string(from: data[field(.phone)] as Any?) ?? self.phone
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.accounts): self.accounts.map { $0.asDictionary },
            field(.cards): self.cards.map { $0.asDictionary },
            field(.dob): self.dob,
            field(.email): self.email,
            field(.favorites): self.favorites.map { $0.asDictionary },
            field(.firstName): self.firstName,
            field(.lastName): self.lastName,
            field(.myPlace): self.myPlace?.asDictionary,
            field(.phone): self.phone,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accounts = try container.decode([DAOAccount].self, forKey: .accounts)
        cards = try container.decode([DAOCard].self, forKey: .cards)
        dob = try container.decode(Date?.self, forKey: .dob)
        email = try container.decode(String.self, forKey: .email)
        favorites = try container.decode([DAOActivityType].self, forKey: .favorites)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        myPlace = try container.decode(Self.placeType.self, forKey: .myPlace)
        phone = try container.decode(String.self, forKey: .phone)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accounts, forKey: .accounts)
        try container.encode(cards, forKey: .cards)
        try container.encode(dob, forKey: .dob)
        try container.encode(email, forKey: .email)
        try container.encode(favorites, forKey: .favorites)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(myPlace, forKey: .myPlace)
        try container.encode(phone, forKey: .phone)
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
        return super.isDiffFrom(rhs) ||
            lhs.accounts != rhs.accounts ||
            lhs.cards != rhs.cards ||
            lhs.dob != rhs.dob ||
            lhs.email != rhs.email ||
            lhs.favorites != rhs.favorites ||
            lhs.firstName != rhs.firstName ||
            lhs.lastName != rhs.lastName ||
            lhs.myPlace != rhs.myPlace ||
            lhs.phone != rhs.phone
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOUser, rhs: DAOUser) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOUser, rhs: DAOUser) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
