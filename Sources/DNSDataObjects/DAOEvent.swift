//
//  DAOEvent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import Foundation

public protocol PTCLCFGDAOEvent: PTCLCFGBaseObject {
    var eventType: DAOEvent.Type { get }
    func event<K>(from container: KeyedDecodingContainer<K>,
                  forKey key: KeyedDecodingContainer<K>.Key) -> DAOEvent? where K: CodingKey
    func eventArray<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEvent] where K: CodingKey
}

public protocol PTCLCFGEventObject: PTCLCFGDAOChat, PTCLCFGDAOEventDay, PTCLCFGDAOMedia, PTCLCFGDAOPricing {
}
public class CFGEventObject: PTCLCFGEventObject {
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
    
    public var eventDayType: DAOEventDay.Type = DAOEventDay.self
    open func eventDay<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDay? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOEventDay.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func eventDayArray<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDay] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOEventDay].self, forKey: key, configuration: self) ?? [] } catch { }
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
    
    public var pricingType: DAOPricing.Type = DAOPricing.self
    open func pricing<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricing? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPricing.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func pricingArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricing] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPricing].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOEvent: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGEventObject
    public static var config: Config = CFGEventObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createChat() -> DAOChat { config.chatType.init() }
    open class func createChat(from object: DAOChat) -> DAOChat { config.chatType.init(from: object) }
    open class func createChat(from data: DNSDataDictionary) -> DAOChat? { config.chatType.init(from: data) }

    open class func createEventDay() -> DAOEventDay { config.eventDayType.init() }
    open class func createEventDay(from object: DAOEventDay) -> DAOEventDay { config.eventDayType.init(from: object) }
    open class func createEventDay(from data: DNSDataDictionary) -> DAOEventDay? { config.eventDayType.init(from: data) }

    open class func createMedia() -> DAOMedia { config.mediaType.init() }
    open class func createMedia(from object: DAOMedia) -> DAOMedia { config.mediaType.init(from: object) }
    open class func createMedia(from data: DNSDataDictionary) -> DAOMedia? { config.mediaType.init(from: data) }

    open class func createPricing() -> DAOPricing { config.pricingType.init() }
    open class func createPricing(from object: DAOPricing) -> DAOPricing { config.pricingType.init(from: object) }
    open class func createPricing(from data: DAOPricing) -> DAOPricing? { config.pricingType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case address, attachments, body, chat, days, distribution, enabled, geopoint
        case mediaItems, pricing, title
    }

    open var address: DNSPostalAddress?
    open var body = DNSString()
    open var days: [DAOEventDay] = [] {
        didSet {
            self.days.sort { $0.date < $1.date }
        }
    }
    open var distribution = DNSVisibility.everyone
    open var enabled = false
    open var geopoint: CLLocation?
    open var pricing: DAOPricing = DAOPricing()
    open var title = DNSString()
    @CodableConfiguration(from: DAOEvent.self) open var attachments: [DAOMedia] = []
    @CodableConfiguration(from: DAOEvent.self) open var chat = DAOChat()
    @CodableConfiguration(from: DAOEvent.self) open var mediaItems: [DAOMedia] = []

    public var startDate: Date {
        guard let startDay = days.first else { return Date() }
        let startTime = DNSTimeOfDay(hour: 0, minute: 0)
        return startTime.time(on: startDay.date)
    }
    public var endDate: Date {
        guard let endDay = days.last else { return Date() }
        let endTime = DNSTimeOfDay(hour: 23, minute: 59)
        return endTime.time(on: endDay.date)
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOEvent) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOEvent) {
        super.update(from: object)
        self.address = object.address
        self.distribution = object.distribution
        self.enabled = object.enabled
        self.geopoint = object.geopoint
        // swiftlint:disable force_cast
        self.attachments = object.attachments.map { $0.copy() as! DAOMedia }
        self.body = object.body.copy() as! DNSString
        self.chat = object.chat.copy() as! DAOChat
        self.days = object.days.map { $0.copy() as! DAOEventDay }
        self.mediaItems = object.mediaItems.map { $0.copy() as! DAOMedia }
        self.pricing = object.pricing.copy() as! DAOPricing
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOEvent {
        _ = super.dao(from: data)
        let attachmentsData = self.dataarray(from: data[field(.attachments)] as Any?)
        self.address = self.dnsPostalAddress(from: data[field(.address)] as Any?) ?? self.address
        self.attachments = attachmentsData.compactMap { Self.createMedia(from: $0) }
        self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
        let chatData = self.dictionary(from: data[field(.chat)] as Any?)
        self.chat = Self.createChat(from: chatData) ?? self.chat
        let daysData = self.dataarray(from: data[field(.days)] as Any?)
        self.days = daysData.compactMap { Self.createEventDay(from: $0) }
        let distributionData = self.string(from: data[field(.distribution)] as Any?) ?? self.distribution.rawValue
        self.distribution = DNSVisibility(rawValue: distributionData) ?? .everyone
        self.enabled = self.bool(from: data[field(.enabled)] as Any?) ?? self.enabled
        self.geopoint = self.location(from: data[field(.geopoint)] as Any?) ?? self.geopoint
        let mediaItemsData = self.dataarray(from: data[field(.mediaItems)] as Any?)
        self.mediaItems = mediaItemsData.compactMap { Self.createMedia(from: $0) }
        self.pricing = self.daoPricing(from: data[field(.pricing)] as Any?) ?? self.pricing
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
            field(.days): self.days.map { $0.asDictionary },
            field(.distribution): self.distribution.rawValue,
            field(.enabled): self.enabled,
            field(.mediaItems): self.mediaItems.map { $0.asDictionary },
            field(.pricing): self.pricing.asDictionary,
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
        days = self.daoEventDayArray(with: configuration, from: container, forKey: .days)
        distribution = try container.decodeIfPresent(Swift.type(of: distribution), forKey: .distribution) ?? distribution
        enabled = self.bool(from: container, forKey: .enabled) ?? enabled
        let geopointData = try container.decodeIfPresent([String: Double].self, forKey: .geopoint) ?? [:]
        geopoint = CLLocation(from: geopointData)
        mediaItems = self.daoMediaArray(with: configuration, from: container, forKey: .mediaItems)
        pricing = self.daoPricing(with: configuration, from: container, forKey: .pricing) ?? pricing
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
        try container.encode(days, forKey: .days, configuration: configuration)
        try container.encode(distribution, forKey: .distribution)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(geopoint?.asDictionary as? [String: Double], forKey: .geopoint)
        try container.encode(mediaItems, forKey: .mediaItems, configuration: configuration)
        try container.encode(pricing, forKey: .pricing)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOEvent(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOEvent else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.address?.isDiffFrom(rhs.address) ?? (lhs.address != rhs.address)) ||
            lhs.attachments.hasDiffElementsFrom(rhs.attachments) ||
            lhs.mediaItems.hasDiffElementsFrom(rhs.mediaItems) ||
            lhs.days.hasDiffElementsFrom(rhs.days) ||
            lhs.body != rhs.body ||
            lhs.chat != rhs.chat ||
            lhs.distribution != rhs.distribution ||
            lhs.enabled != rhs.enabled ||
            lhs.geopoint != rhs.geopoint ||
            lhs.pricing != rhs.pricing ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOEvent, rhs: DAOEvent) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOEvent, rhs: DAOEvent) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
