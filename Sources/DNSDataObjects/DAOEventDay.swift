//
//  DAOEventDay.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import Foundation

public protocol PTCLCFGDAOEventDay: PTCLCFGBaseObject {
    var eventDayType: DAOEventDay.Type { get }
    func eventDay<K>(from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDay? where K: CodingKey
    func eventDayArray<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDay] where K: CodingKey
}

public protocol PTCLCFGEventDayObject: PTCLCFGDAOChat, PTCLCFGDAOEventDayItem, PTCLCFGDAOMedia {
}
public class CFGEventDayObject: PTCLCFGEventDayObject {
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

    public var eventDayItemType: DAOEventDayItem.Type = DAOEventDayItem.self
    open func eventDayItem<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDayItem? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOEventDayItem.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func eventDayItemArray<K>(from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDayItem] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOEventDayItem].self, forKey: key, configuration: self) ?? [] } catch { }
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
}
open class DAOEventDay: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGEventDayObject
    public static var config: Config = CFGEventDayObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createChat() -> DAOChat { config.chatType.init() }
    open class func createChat(from object: DAOChat) -> DAOChat { config.chatType.init(from: object) }
    open class func createChat(from data: DNSDataDictionary) -> DAOChat? { config.chatType.init(from: data) }

    open class func createEventDayItem() -> DAOEventDayItem { config.eventDayItemType.init() }
    open class func createEventDayItem(from object: DAOEventDayItem) -> DAOEventDayItem { config.eventDayItemType.init(from: object) }
    open class func createEventDayItem(from data: DNSDataDictionary) -> DAOEventDayItem? { config.eventDayItemType.init(from: data) }

    open class func createMedia() -> DAOMedia { config.mediaType.init() }
    open class func createMedia(from object: DAOMedia) -> DAOMedia { config.mediaType.init(from: object) }
    open class func createMedia(from data: DNSDataDictionary) -> DAOMedia? { config.mediaType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case address, attachments, body, chat, date, distribution, geopoint, items, mediaItems, notes, title
    }

    open var address: DNSPostalAddress?
    open var body = DNSString()
    open var date = Date()
    open var distribution = DNSVisibility.everyone
    open var geopoint: CLLocation?
    open var items: [DAOEventDayItem] = []  {
        didSet {
            self.items.sort { $0.startTime < $1.startTime }
        }
    }
    open var notes: [DNSNote] = []
    open var title = DNSString()
    @CodableConfiguration(from: DAOEventDay.self) open var attachments: [DAOMedia] = []
    @CodableConfiguration(from: DAOEventDay.self) open var chat = DAOChat()
    @CodableConfiguration(from: DAOEventDay.self) open var mediaItems: [DAOMedia] = []

    public var startTime: Date {
        guard let startItem = items.first else { return date }
        return startItem.startTime.time(on: date)
    }
    public var endTime: Date {
        guard let endItem = items.last else { return date }
        return endItem.endTime.time(on: date)
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOEventDay) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOEventDay) {
        super.update(from: object)
        self.address = object.address
        self.date = object.date
        self.distribution = object.distribution
        self.geopoint = object.geopoint
        // swiftlint:disable force_cast
        self.attachments = object.attachments.map { $0.copy() as! DAOMedia }
        self.body = object.body.copy() as! DNSString
        self.chat = object.chat.copy() as! DAOChat
        self.items = object.items.map { $0.copy() as! DAOEventDayItem }
        self.mediaItems = object.mediaItems.map { $0.copy() as! DAOMedia }
        self.notes = object.notes.map { $0.copy() as! DNSNote }
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOEventDay {
        _ = super.dao(from: data)
        let attachmentsData = self.dataarray(from: data[field(.attachments)] as Any?)
        self.address = self.dnsPostalAddress(from: data[field(.address)] as Any?) ?? self.address
        self.attachments = attachmentsData.compactMap { Self.createMedia(from: $0) }
        self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
        let chatData = self.dictionary(from: data[field(.chat)] as Any?)
        self.chat = Self.createChat(from: chatData) ?? self.chat
        self.date = self.date(from: data[field(.date)] as Any?) ?? self.date
        let distributionData = self.string(from: data[field(.distribution)] as Any?) ?? self.distribution.rawValue
        self.distribution = DNSVisibility(rawValue: distributionData) ?? .everyone
        self.geopoint = self.location(from: data[field(.geopoint)] as Any?) ?? self.geopoint
        let itemsData = self.dataarray(from: data[field(.items)] as Any?)
        self.items = itemsData.compactMap { Self.createEventDayItem(from: $0) }
        let mediaItemsData = self.dataarray(from: data[field(.mediaItems)] as Any?)
        self.mediaItems = mediaItemsData.compactMap { Self.createMedia(from: $0) }
        let notesData = self.dataarray(from: data[field(.notes)] as Any?)
        self.notes = notesData.compactMap { DNSNote(from: $0) }
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        if let address {
            retval.merge([
                field(.address): address.asDictionary,
            ]) { (current, _) in current }
        }
        if let geopoint {
            retval.merge([
                field(.geopoint): geopoint.asDictionary,
            ]) { (current, _) in current }
        }
        retval.merge([
            field(.attachments): self.attachments.map { $0.asDictionary },
            field(.body): self.body.asDictionary,
            field(.chat): self.chat.asDictionary,
            field(.date): self.date.dnsDate(as: .shortMilitary),
            field(.distribution): self.distribution.rawValue,
            field(.items): self.items.map { $0.asDictionary },
            field(.mediaItems): self.mediaItems.map { $0.asDictionary },
            field(.notes): self.notes.map { $0.asDictionary },
            field(.title): self.title.asDictionary,
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
        address = self.dnsPostalAddress(from: container, forKey: .address) ?? address
        attachments = self.daoMediaArray(with: configuration, from: container, forKey: .attachments)
        body = self.dnsstring(from: container, forKey: .body) ?? body
        chat = self.daoChat(with: configuration, from: container, forKey: .chat) ?? chat
        date = self.date(from: container, forKey: .date) ?? date
        distribution = try container.decodeIfPresent(Swift.type(of: distribution), forKey: .distribution) ?? distribution
        let geopointData = try container.decodeIfPresent([String: Double].self, forKey: .geopoint) ?? [:]
        geopoint = CLLocation(from: geopointData)
        items = self.daoEventDayItemArray(with: configuration, from: container, forKey: .items)
        mediaItems = self.daoMediaArray(with: configuration, from: container, forKey: .mediaItems)
        notes = try container.decodeIfPresent([DNSNote].self, forKey: .notes) ?? []
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(attachments, forKey: .attachments, configuration: configuration)
        try container.encode(body, forKey: .body)
        try container.encode(chat, forKey: .chat, configuration: configuration)
        try container.encode(date.dnsDate(as: .shortMilitary), forKey: .date)
        try container.encode(distribution, forKey: .distribution)
        try container.encode(geopoint?.asDictionary as? [String: Double], forKey: .geopoint)
        try container.encode(items, forKey: .items, configuration: configuration)
        try container.encode(mediaItems, forKey: .mediaItems, configuration: configuration)
        try container.encode(notes, forKey: .notes)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOEventDay(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOEventDay else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.address != rhs.address ||
            lhs.attachments.hasDiffElementsFrom(rhs.attachments) ||
            lhs.items.hasDiffElementsFrom(rhs.items) ||
            lhs.mediaItems.hasDiffElementsFrom(rhs.mediaItems) ||
            lhs.notes.hasDiffElementsFrom(rhs.notes) ||
            lhs.body != rhs.body ||
            lhs.chat != rhs.chat ||
            lhs.date != rhs.date ||
            lhs.distribution != rhs.distribution ||
            lhs.geopoint != rhs.geopoint ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOEventDay, rhs: DAOEventDay) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOEventDay, rhs: DAOEventDay) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
