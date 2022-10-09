//
//  DAOUser.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation
import KeyedCodable

open class DAOUser: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var accountType: DAOAccount.Type { DAOAccount.self }
    open class var activityTypeType: DAOActivityType.Type { DAOActivityType.self }
    open class var cardType: DAOCard.Type { DAOCard.self }
    open class var placeType: DAOPlace.Type { DAOPlace.self }

    open class func createAccount() -> DAOAccount { accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { accountType.init(from: data) }

    open class func createActivityType() -> DAOActivityType { activityTypeType.init() }
    open class func createActivityType(from object: DAOActivityType) -> DAOActivityType { activityTypeType.init(from: object) }
    open class func createActivityType(from data: DNSDataDictionary) -> DAOActivityType? { activityTypeType.init(from: data) }

    open class func createCard() -> DAOCard { cardType.init() }
    open class func createCard(from object: DAOCard) -> DAOCard { cardType.init(from: object) }
    open class func createCard(from data: DNSDataDictionary) -> DAOCard? { cardType.init(from: data) }

    open class func createPlace() -> DAOPlace { placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { placeType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case accounts, cards, dob, email, favorites, myPlace, name, phone, type
    }

    @CodedBy<AccountArrayTransformer> open var accounts: [DAOAccount] = []
    @CodedBy<CardArrayTransformer> open var cards: [DAOCard] = []
    open var dob: Date?
    open var email: String = ""
    @CodedBy<ActivityTypeArrayTransformer> open var favorites: [DAOActivityType] = []
    open var name = PersonNameComponents()
    @CodedBy<PlaceTransformer> open var myPlace: DAOPlace?
    open var phone: String = ""
    open var type: DNSUserType = .unknown

    @available(*, deprecated, renamed: "name.givenName", message: "Please use new property - name.givenName")
    public var firstName: String? {
        get { self.name.givenName }
        set { self.name.givenName = newValue }
    }

    @available(*, deprecated, renamed: "name.familyName", message: "Please use new property - name.familyName")
    public var lastName: String? {
        get { self.name.familyName }
        set { self.name.familyName = newValue }
    }

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
    public init(id: String, email: String, name: String) {
        self.email = email
        self.name = PersonNameComponents.dnsBuildName(with: name) ?? self.name
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
        self.name = object.name
        self.phone = object.phone
        self.type = object.type
        // swiftlint:disable force_cast
        self.accounts = object.accounts.map { $0.copy() as! DAOAccount }
        self.cards = object.cards.map { $0.copy() as! DAOCard }
        self.favorites = object.favorites.map { $0.copy() as! DAOActivityType }
        self.myPlace = object.myPlace?.copy() as? DAOPlace
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOUser {
        _ = super.dao(from: data)
        let accountsData = data[field(.accounts)] as? [DNSDataDictionary] ?? []
        self.accounts = accountsData.compactMap { Self.createAccount(from: $0) }
        let cardsData = self.dataarray(from: data[field(.cards)] as Any?)
        self.cards = cardsData.compactMap { Self.createCard(from: $0) }
        self.dob = self.date(from: data[field(.dob)] as Any?) ?? self.dob
        self.email = self.string(from: data[field(.email)] as Any?) ?? self.email
        let favoritesData = self.dataarray(from: data[field(.favorites)] as Any?)
        self.favorites = favoritesData.compactMap { Self.createActivityType(from: $0) }
        let nameData = self.dictionary(from: data[field(.name)] as Any?)
        self.name = PersonNameComponents(from: nameData) ?? self.name
        let myPlaceData = self.dictionary(from: data[field(.myPlace)] as Any?)
        self.myPlace = Self.createPlace(from: myPlaceData)
        self.phone = self.string(from: data[field(.phone)] as Any?) ?? self.phone
        let typeData = self.string(from: data[field(.type)] as Any?) ?? ""
        self.type = DNSUserType(rawValue: typeData) ?? .unknown
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
            field(.name): self.name.asDictionary,
            field(.myPlace): self.myPlace?.asDictionary,
            field(.phone): self.phone,
            field(.type): self.type.rawValue,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accounts = self.daoAccountArray(from: container, forKey: .accounts)
        do {
            accounts = try container.decodeIfPresent(Swift.type(of: accounts), forKey: .accounts) ?? []
        } catch { }
        cards = self.daoCardArray(from: container, forKey: .cards)
        do {
            cards = try container.decodeIfPresent(Swift.type(of: cards), forKey: .cards) ?? []
        } catch { }
        dob = self.date(from: container, forKey: .dob) ?? dob
        email = self.string(from: container, forKey: .email) ?? email
        favorites = self.daoActivityTypeArray(from: container, forKey: .favorites)
        do {
            favorites = try container.decodeIfPresent(Swift.type(of: favorites), forKey: .favorites) ?? []
        } catch { }
        myPlace = self.daoPlace(from: container, forKey: .myPlace) ?? myPlace
        do {
            myPlace = try container.decodeIfPresent(Swift.type(of: myPlace), forKey: .myPlace) ?? myPlace
        } catch { }
        name = self.personName(from: container, forKey: .name) ?? name
        phone = self.string(from: container, forKey: .phone) ?? phone

//        accounts = try container.decodeIfPresent(Swift.type(of: accounts), forKey: .accounts) ?? accounts
//        cards = try container.decodeIfPresent(Swift.type(of: cards), forKey: .cards) ?? cards
//        favorites = try container.decodeIfPresent(Swift.type(of: favorites), forKey: .favorites) ?? favorites
//        myPlace = try container.decodeIfPresent(Swift.type(of: myPlace), forKey: .myPlace) ?? myPlace
        type = try container.decodeIfPresent(Swift.type(of: type), forKey: .type) ?? type
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accounts, forKey: .accounts)
        try container.encode(cards, forKey: .cards)
        try container.encode(dob, forKey: .dob)
        try container.encode(email, forKey: .email)
        try container.encode(favorites, forKey: .favorites)
        try container.encode(name, forKey: .name)
        try container.encode(myPlace, forKey: .myPlace)
        try container.encode(phone, forKey: .phone)
        try container.encode(type, forKey: .type)
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
            lhs.name != rhs.name ||
            lhs.myPlace != rhs.myPlace ||
            lhs.phone != rhs.phone ||
            lhs.type != rhs.type
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOUser, rhs: DAOUser) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOUser, rhs: DAOUser) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
