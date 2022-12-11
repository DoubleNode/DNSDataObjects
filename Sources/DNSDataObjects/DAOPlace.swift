//
//  DAOPlace.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import Foundation

public protocol PTCLCFGDAOPlace: PTCLCFGBaseObject {
    var placeType: DAOPlace.Type { get }
    func place<K>(from container: KeyedDecodingContainer<K>,
                  forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlace? where K: CodingKey
    func placeArray<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey
}

public protocol PTCLCFGPlaceObject: PTCLCFGDAOActivity, PTCLCFGDAOAlert, PTCLCFGDAOAnnouncement, PTCLCFGDAOChat,
                                    PTCLCFGDAOEvent, PTCLCFGDAOMedia, PTCLCFGDAOPlaceHours, PTCLCFGDAOPlaceStatus,
                                    PTCLCFGDAOSection {
}
public class CFGPlaceObject: PTCLCFGPlaceObject {
    public var activityType: DAOActivity.Type = DAOActivity.self
    open func activity<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivity? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOActivity.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func activityArray<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivity] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOActivity].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var alertType: DAOAlert.Type = DAOAlert.self
    open func alert<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOAlert? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAlert.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func alertArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAlert] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAlert].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var announcementType: DAOAnnouncement.Type = DAOAnnouncement.self
    open func announcement<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOAnnouncement? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAnnouncement.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func announcementArray<K>(from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAnnouncement] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAnnouncement].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var chatType: DAOChat.Type = DAOChat.self
    open func chat<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOChat? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOChat.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func chatArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOChat] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOChat].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var eventType: DAOEvent.Type = DAOEvent.self
    open func event<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOEvent? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOEvent.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func eventArray<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEvent] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOEvent].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var mediaType: DAOMedia.Type = DAOMedia.self
    open func media<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOMedia? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOMedia.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func mediaArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOMedia] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOMedia].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var placeHoursType: DAOPlaceHours.Type = DAOPlaceHours.self
    open func placeHours<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlaceHours? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPlaceHours.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func placeHoursArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceHours] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlaceHours].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var placeStatusType: DAOPlaceStatus.Type = DAOPlaceStatus.self
    open func placeStatus<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlaceStatus? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPlaceStatus.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func placeStatusArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceStatus] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlaceStatus].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var sectionType: DAOSection.Type = DAOSection.self
    open func section<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOSection.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func sectionArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOSection].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOPlace: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPlaceObject
    public static var config: Config = CFGPlaceObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createActivity() -> DAOActivity { config.activityType.init() }
    open class func createActivity(from object: DAOActivity) -> DAOActivity { config.activityType.init(from: object) }
    open class func createActivity(from data: DNSDataDictionary) -> DAOActivity? { config.activityType.init(from: data) }

    open class func createAlert() -> DAOAlert { config.alertType.init() }
    open class func createAlert(from object: DAOAlert) -> DAOAlert { config.alertType.init(from: object) }
    open class func createAlert(from data: DNSDataDictionary) -> DAOAlert? { config.alertType.init(from: data) }

    open class func createAnnouncement() -> DAOAnnouncement { config.announcementType.init() }
    open class func createAnnouncement(from object: DAOAnnouncement) -> DAOAnnouncement { config.announcementType.init(from: object) }
    open class func createAnnouncement(from data: DNSDataDictionary) -> DAOAnnouncement? { config.announcementType.init(from: data) }

    open class func createChat() -> DAOChat { config.chatType.init() }
    open class func createChat(from object: DAOChat) -> DAOChat { config.chatType.init(from: object) }
    open class func createChat(from data: DNSDataDictionary) -> DAOChat? { config.chatType.init(from: data) }

    open class func createEvent() -> DAOEvent { config.eventType.init() }
    open class func createEvent(from object: DAOEvent) -> DAOEvent { config.eventType.init(from: object) }
    open class func createEvent(from data: DNSDataDictionary) -> DAOEvent? { config.eventType.init(from: data) }

    open class func createMedia() -> DAOMedia { config.mediaType.init() }
    open class func createMedia(from object: DAOMedia) -> DAOMedia { config.mediaType.init(from: object) }
    open class func createMedia(from data: DNSDataDictionary) -> DAOMedia? { config.mediaType.init(from: data) }

    open class func createPlaceHours() -> DAOPlaceHours { config.placeHoursType.init() }
    open class func createPlaceHours(from object: DAOPlaceHours) -> DAOPlaceHours { config.placeHoursType.init(from: object) }
    open class func createPlaceHours(from data: DNSDataDictionary) -> DAOPlaceHours? { config.placeHoursType.init(from: data) }

    open class func createPlaceStatus() -> DAOPlaceStatus { config.placeStatusType.init() }
    open class func createPlaceStatus(from object: DAOPlaceStatus) -> DAOPlaceStatus { config.placeStatusType.init(from: object) }
    open class func createPlaceStatus(from data: DNSDataDictionary) -> DAOPlaceStatus? { config.placeStatusType.init(from: data) }

    open class func createSection() -> DAOSection { config.sectionType.init() }
    open class func createSection(from object: DAOSection) -> DAOSection { config.sectionType.init(from: object) }
    open class func createSection(from data: DNSDataDictionary) -> DAOSection? { config.sectionType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case activities, address, alerts, announcements, chat, code, events, geohashes
        case geopoint, hours, logo, name, phone, section, statuses, timeZone
    }

    open var address: DNSPostalAddress = DNSPostalAddress()
    open var code = ""
    open var geohashes: [String] = []
    open var geopoint: CLLocation?
    open var name = DNSString()
    open var phone = ""
    @CodableConfiguration(from: DAOPlace.self) open var activities: [DAOActivity] = []
    @CodableConfiguration(from: DAOPlace.self) open var alerts: [DAOAlert] = []
    @CodableConfiguration(from: DAOPlace.self) open var announcements: [DAOAnnouncement] = []
    @CodableConfiguration(from: DAOPlace.self) open var chat = DAOChat()
    @CodableConfiguration(from: DAOPlace.self) open var events: [DAOEvent] = []
    @CodableConfiguration(from: DAOPlace.self) open var hours: DAOPlaceHours = DAOPlaceHours()
    @CodableConfiguration(from: DAOPlace.self) open var logo: DAOMedia? = nil
    @CodableConfiguration(from: DAOPlace.self) open var section: DAOSection? = nil
    @CodableConfiguration(from: DAOPlace.self) open var statuses: [DAOPlaceStatus] = [] {
        didSet {
            self.statuses.filter { $0.id.isEmpty }
                .forEach {
                    $0.id = "\(code):\($0.status.rawValue):\(Int($0.startTime.timeIntervalSince1970))"
                }
        }
    }
    open var timeZone: TimeZone = TimeZone.current
    // MARK: - Initializers -
    required public init() {
        hours = Self.createPlaceHours()
        super.init()
    }
    required public init(id: String) {
        hours = Self.createPlaceHours()
        super.init(id: id)
    }
    public init(code: String, name: DNSString) {
        hours = Self.createPlaceHours()
        self.code = code
        self.name = name
        super.init(id: code)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOPlace) {
        hours = Self.createPlaceHours()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPlace) {
        super.update(from: object)
        self.address = object.address
        self.code = object.code
        self.geohashes = object.geohashes
        self.geopoint = object.geopoint
        self.phone = object.phone
        self.section = object.section?.copy() as? DAOSection
        self.timeZone = object.timeZone
        // swiftlint:disable force_cast
        self.activities = object.activities.map { $0.copy() as! DAOActivity }
        self.alerts = object.alerts.map { $0.copy() as! DAOAlert }
        self.announcements = object.announcements.map { $0.copy() as! DAOAnnouncement }
        self.chat = object.chat.copy() as! DAOChat
        self.events = object.events.map { $0.copy() as! DAOEvent }
        self.hours = object.hours.copy() as! DAOPlaceHours
        self.logo = object.logo?.copy() as? DAOMedia
        self.name = object.name.copy() as! DNSString
        self.statuses = object.statuses.map { $0.copy() as! DAOPlaceStatus }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        hours = Self.createPlaceHours()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPlace {
        _ = super.dao(from: data)
        let activitiesData = self.dataarray(from: data[field(.activities)] as Any?)
        self.activities = activitiesData.compactMap { Self.createActivity(from: $0) }
        self.address = self.dnsPostalAddress(from: data[field(.address)] as Any?) ?? self.address
        let alertsData = self.dataarray(from: data[field(.alerts)] as Any?)
        self.alerts = alertsData.compactMap { Self.createAlert(from: $0) }
        let announcementsData = self.dataarray(from: data[field(.announcements)] as Any?)
        self.announcements = announcementsData.compactMap { Self.createAnnouncement(from: $0) }
        let chatData = self.dictionary(from: data[field(.chat)] as Any?)
        self.chat = Self.createChat(from: chatData) ?? self.chat
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        let eventsData = self.dataarray(from: data[field(.events)] as Any?)
        self.events = eventsData.compactMap { Self.createEvent(from: $0) }
        let geohashesData = self.array(from: data[field(.geohashes)] as Any?)
        self.geohashes = geohashesData.compactMap { self.string(from: $0 as Any?) }
        let hoursData = self.dictionary(from: data[field(.hours)] as Any?)
        self.hours = Self.createPlaceHours(from: hoursData) ?? self.hours
        let logoData = self.dictionary(from: data[field(.logo)] as Any?)
        self.logo = Self.createMedia(from: logoData) ?? self.logo
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        self.phone = self.string(from: data[field(.phone)] as Any?) ?? self.phone
        let sectionData = self.dictionary(from: data[field(.section)] as Any?)
        self.section = Self.createSection(from: sectionData) ?? self.section
        let statusesData = self.dataarray(from: data[field(.statuses)] as Any?)
        self.statuses = statusesData.compactMap { Self.createPlaceStatus(from: $0) }
        self.timeZone = self.timeZone(from: data[field(.timeZone)] as Any?) ?? self.timeZone
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        if let logo = self.logo {
            retval.merge([
                field(.logo): logo.asDictionary,
            ]) { (current, _) in current }
        }
        retval.merge([
            field(.activities): self.activities.map { $0.asDictionary },
            field(.address): self.address.asDictionary,
            field(.alerts): self.alerts.map { $0.asDictionary },
            field(.announcements): self.announcements.map { $0.asDictionary },
            field(.chat): self.chat.asDictionary,
            field(.code): self.code,
            field(.events): self.events.map { $0.asDictionary },
            field(.geohashes): self.geohashes.map { $0 },
            field(.geopoint): self.geopoint?.asDictionary,
            field(.hours): self.hours.asDictionary,
            field(.name): self.name,
            field(.phone): self.phone,
            field(.section): self.section?.asDictionary ?? .empty,
            field(.statuses): self.statuses.map { $0.asDictionary },
            field(.timeZone): self.timeZone.identifier,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
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
        activities = self.daoActivityArray(with: configuration, from: container, forKey: .activities)
        address = self.dnsPostalAddress(from: container, forKey: .address) ?? address
        alerts = self.daoAlertArray(with: configuration, from: container, forKey: .alerts)
        announcements = self.daoAnnouncementArray(with: configuration, from: container, forKey: .announcements)
        chat = self.daoChat(with: configuration, from: container, forKey: .chat) ?? chat
        code = self.string(from: container, forKey: .code) ?? code
        events = self.daoEventArray(with: configuration, from: container, forKey: .events)
        hours = self.daoPlaceHours(with: configuration, from: container, forKey: .hours) ?? hours
        logo = self.daoMedia(with: configuration, from: container, forKey: .logo)
        name = self.dnsstring(from: container, forKey: .name) ?? name
        phone = self.string(from: container, forKey: .phone) ?? phone
        section = self.daoSection(with: configuration, from: container, forKey: .section) ?? section
        statuses = self.daoPlaceStatusArray(with: configuration, from: container, forKey: .statuses)
        timeZone = self.timeZone(from: container, forKey: .timeZone) ?? timeZone

        geohashes = try container.decodeIfPresent(Swift.type(of: geohashes), forKey: .geohashes) ?? geohashes
        let geopointData = try container.decodeIfPresent([String: Double].self, forKey: .geopoint) ?? [:]
        geopoint = CLLocation(from: geopointData)
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activities, forKey: .activities, configuration: configuration)
        try container.encode(address, forKey: .address)
        try container.encode(alerts, forKey: .alerts, configuration: configuration)
        try container.encode(announcements, forKey: .announcements, configuration: configuration)
        try container.encode(chat, forKey: .chat, configuration: configuration)
        try container.encode(code, forKey: .code)
        try container.encode(events, forKey: .events, configuration: configuration)
        try container.encode(geohashes, forKey: .geohashes)
        try container.encode(geopoint?.asDictionary as? [String: Double], forKey: .geopoint)
        try container.encode(hours, forKey: .hours, configuration: configuration)
        try container.encode(logo, forKey: .logo, configuration: configuration)
        try container.encode(name, forKey: .name)
        try container.encode(phone, forKey: .phone)
        try container.encode(section, forKey: .section, configuration: configuration)
        try container.encode(statuses, forKey: .statuses, configuration: configuration)
        try container.encode(timeZone, forKey: .timeZone)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPlace(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPlace else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.logo?.isDiffFrom(rhs.logo) ?? (lhs.logo != rhs.logo)) ||
            (lhs.section?.isDiffFrom(rhs.section) ?? (lhs.section != rhs.section)) ||
            lhs.activities.hasDiffElementsFrom(rhs.activities) ||
            lhs.alerts.hasDiffElementsFrom(rhs.alerts) ||
            lhs.announcements.hasDiffElementsFrom(rhs.announcements) ||
            lhs.events.hasDiffElementsFrom(rhs.events) ||
            lhs.statuses.hasDiffElementsFrom(rhs.statuses) ||
            lhs.address != rhs.address ||
            lhs.chat != rhs.chat ||
            lhs.code != rhs.code ||
            lhs.geohashes != rhs.geohashes ||
            lhs.geopoint != rhs.geopoint ||
            lhs.hours != rhs.hours ||
            lhs.name != rhs.name ||
            lhs.phone != rhs.phone ||
            lhs.timeZone != rhs.timeZone
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPlace, rhs: DAOPlace) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPlace, rhs: DAOPlace) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
