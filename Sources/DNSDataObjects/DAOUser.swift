//
//  DAOUser.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataContracts
import DNSDataTypes
import Foundation
import KeyedCodable

public protocol PTCLCFGDAOUser: PTCLCFGBaseObject {
    var userType: DAOUser.Type { get }
    func user<K>(from container: KeyedDecodingContainer<K>,
                 forKey key: KeyedDecodingContainer<K>.Key) -> DAOUser? where K: CodingKey
    func userArray<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> [DAOUser] where K: CodingKey
}

public protocol PTCLCFGUserObject: PTCLCFGDAOAccount, PTCLCFGDAOActivityType,
                                   PTCLCFGDAOCard, PTCLCFGDAOPlace {
}
public class CFGUserObject: PTCLCFGUserObject {
    public var accountType: DAOAccount.Type = DAOAccount.self
    public var activityTypeType: DAOActivityType.Type = DAOActivityType.self
    public var cardType: DAOCard.Type = DAOCard.self
    public var placeType: DAOPlace.Type = DAOPlace.self

    open func account<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccount? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAccount.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func activityType<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityType? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOActivityType.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func card<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOCard? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOCard.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func place<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlace? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPlace.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }

    open func accountArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccount] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAccount].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func activityTypeArray<K>(from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityType] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOActivityType].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func cardArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOCard] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOCard].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func placeArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlace].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOUser: DAOBaseObject, DAOUserProtocol, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGUserObject
    public static var config: Config = CFGUserObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAccount() -> DAOAccount { config.accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { config.accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { config.accountType.init(from: data) }

    open class func createActivityType() -> DAOActivityType { config.activityTypeType.init() }
    open class func createActivityType(from object: DAOActivityType) -> DAOActivityType { config.activityTypeType.init(from: object) }
    open class func createActivityType(from data: DNSDataDictionary) -> DAOActivityType? { config.activityTypeType.init(from: data) }

    open class func createCard() -> DAOCard { config.cardType.init() }
    open class func createCard(from object: DAOCard) -> DAOCard { config.cardType.init(from: object) }
    open class func createCard(from data: DNSDataDictionary) -> DAOCard? { config.cardType.init(from: data) }

    open class func createPlace() -> DAOPlace { config.placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { config.placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { config.placeType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case accounts, cards, consent, consentBy, dob, email, favorites, myPlace, name, phone, type
    }

    open var consent: Date?
    open var consentBy: String = ""
    open var dob: Date?
    open var name = PersonNameComponents()
    open var phone: String = ""
    open var type: DNSUserType = .unknown
    @CodableConfiguration(from: DAOTransaction.self) open var accounts: [DAOAccount] = []
    @CodableConfiguration(from: DAOTransaction.self) open var cards: [DAOCard] = []
    @CodableConfiguration(from: DAOTransaction.self) open var favorites: [DAOActivityType] = []
    @CodableConfiguration(from: DAOTransaction.self) open var myPlace: DAOPlace? = nil
    
    // Additional properties for protocol conformance
    open var username: String?
    open var userRole: DNSUserRole = .endUser  
    open var status: DNSStatus = .open
    open var visibility: DNSVisibility = .everyone
    
    // Internal storage for non-optional email
    private var _email: String = ""

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
    public var nameSortable: String { self.name.dnsSortableName }

    public var hasConsent: Bool {
        !isUnder13 || (consent != nil && !consentBy.isEmpty)
    }
    public var isAdult: Bool {
        [.adult].contains(self.type)
    }
    public var isMinor: Bool {
        [.unknown, .child, .youth].contains(self.type)
    }
    public var isUnder13: Bool {
        [.unknown, .child].contains(self.type)
    }
    
    // MARK: - DAOUserProtocol conformance -
    public var email: String? {
        get { _email.isEmpty ? nil : _email }
        set { _email = newValue ?? "" }
    }
    
    public var phoneNumber: String? {
        get { phone.isEmpty ? nil : phone }
        set { phone = newValue ?? "" }
    }
    
    public var userType: DNSUserType {
        get { type }
        set { type = newValue }
    }
    
    public var displayName: String? {
        get { 
            let formatted = nameMedium
            return formatted.isEmpty ? nil : formatted 
        }
        set { 
            if let newValue = newValue {
                name = PersonNameComponents.dnsBuildName(with: newValue) ?? name
            }
        }
    }
    
    // Legacy email access for internal use
    public var emailString: String {
        get { _email }
        set { _email = newValue }
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(id: String, email: String, name: String) {
        self._email = email
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
        self.consent = object.consent
        self.consentBy = object.consentBy
        self.dob = object.dob
        self._email = object._email
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
        self.consent = self.time(from: data[field(.consent)] as Any?) ?? self.consent
        self.consentBy = self.string(from: data[field(.consentBy)] as Any?) ?? self.consentBy
        self.dob = self.date(from: data[field(.dob)] as Any?) ?? self.dob
        self._email = self.string(from: data[field(.email)] as Any?) ?? self._email
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
            field(.consent): self.consent,
            field(.consentBy): self.consentBy,
            field(.dob): self.dob?.dnsDate(as: .shortMilitary),
            field(.email): self._email,
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
        super.init()
        try commonInit(from: decoder, configuration: Self.config)
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accounts = self.daoAccountArray(with: configuration, from: container, forKey: .accounts)
        cards = self.daoCardArray(with: configuration, from: container, forKey: .cards)
        consent = self.time(from: container, forKey: .consent) ?? consent
        consentBy = self.string(from: container, forKey: .consentBy) ?? consentBy
        dob = self.date(from: container, forKey: .dob) ?? dob
        _email = self.string(from: container, forKey: .email) ?? _email
        favorites = self.daoActivityTypeArray(with: configuration, from: container, forKey: .favorites)
        myPlace = self.daoPlace(with: configuration, from: container, forKey: .myPlace) ?? myPlace
        name = self.personName(from: container, forKey: .name) ?? name
        phone = self.string(from: container, forKey: .phone) ?? phone
        type = try container.decodeIfPresent(Swift.type(of: type), forKey: .type) ?? type
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accounts, forKey: .accounts, configuration: configuration)
        try container.encode(cards, forKey: .cards, configuration: configuration)
        try container.encode(consent, forKey: .consent)
        try container.encode(consentBy, forKey: .consentBy)
        try container.encode(dob?.dnsDate(as: .shortMilitary), forKey: .dob)
        try container.encode(_email, forKey: .email)
        try container.encode(favorites, forKey: .favorites, configuration: configuration)
        try container.encode(myPlace, forKey: .myPlace, configuration: configuration)
        try container.encode(name, forKey: .name)
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
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.myPlace?.isDiffFrom(rhs.myPlace) ?? (lhs.myPlace != rhs.myPlace)) ||
            lhs.accounts.hasDiffElementsFrom(rhs.accounts) ||
            lhs.cards.hasDiffElementsFrom(rhs.cards) ||
            lhs.favorites.hasDiffElementsFrom(rhs.favorites) ||
            lhs.consent != rhs.consent ||
            lhs.consentBy != rhs.consentBy ||
            lhs.dob != rhs.dob ||
            lhs._email != rhs._email ||
            lhs.name != rhs.name ||
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
