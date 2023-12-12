//
//  DAOAnnouncement.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOAnnouncement: PTCLCFGBaseObject {
    var announcementType: DAOAnnouncement.Type { get }
    func announcement<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAnnouncement? where K: CodingKey
    func announcementArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAnnouncement] where K: CodingKey
}

public protocol PTCLCFGAnnouncementObject: PTCLCFGDAOAnnouncement, PTCLCFGDAOChat, PTCLCFGDAOMedia {
}
public class CFGAnnouncementObject: PTCLCFGAnnouncementObject {
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
open class DAOAnnouncement: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAnnouncementObject
    public static var config: Config = CFGAnnouncementObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAnnouncement() -> DAOAnnouncement { config.announcementType.init() }
    open class func createAnnouncement(from object: DAOAnnouncement) -> DAOAnnouncement { config.announcementType.init(from: object) }
    open class func createAnnouncement(from data: DNSDataDictionary) -> DAOAnnouncement? { config.announcementType.init(from: data) }

    open class func createChat() -> DAOChat { config.chatType.init() }
    open class func createChat(from object: DAOChat) -> DAOChat { config.chatType.init(from: object) }
    open class func createChat(from data: DNSDataDictionary) -> DAOChat? { config.chatType.init(from: data) }

    open class func createMedia() -> DAOMedia { config.mediaType.init() }
    open class func createMedia(from object: DAOMedia) -> DAOMedia { config.mediaType.init(from: object) }
    open class func createMedia(from data: DNSDataDictionary) -> DAOMedia? { config.mediaType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case attachments, body, chat, distribution, endTime, mediaItems, startTime, subtitle, title
    }

    open var body = DNSString()
    open var distribution = DNSVisibility.everyone
    open var endTime = Date().nextMonth
    open var startTime = Date()
    open var subtitle = DNSString()
    open var title = DNSString()
    @CodableConfiguration(from: DAOAnnouncement.self) open var attachments: [DAOMedia] = []
    @CodableConfiguration(from: DAOAnnouncement.self) open var chat = DAOChat()
    @CodableConfiguration(from: DAOAnnouncement.self) open var mediaItems: [DAOMedia] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOAnnouncement) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAnnouncement) {
        super.update(from: object)
        self.distribution = object.distribution
        self.endTime = object.endTime
        self.startTime = object.startTime
        // swiftlint:disable force_cast
        self.attachments = object.attachments.map { $0.copy() as! DAOMedia }
        self.body = object.body.copy() as! DNSString
        self.chat = object.chat.copy() as! DAOChat
        self.mediaItems = object.mediaItems.map { $0.copy() as! DAOMedia }
        self.subtitle = object.subtitle.copy() as! DNSString
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAnnouncement {
        _ = super.dao(from: data)
        let attachmentsData = self.dataarray(from: data[field(.attachments)] as Any?)
        self.attachments = attachmentsData.compactMap { Self.createMedia(from: $0) }
        self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
        let chatData = self.dictionary(from: data[field(.chat)] as Any?)
        self.chat = Self.createChat(from: chatData) ?? self.chat
        let distributionData = self.string(from: data[field(.distribution)] as Any?) ?? self.distribution.rawValue
        self.distribution = DNSVisibility(rawValue: distributionData) ?? .everyone
        let mediaItemsData = self.dataarray(from: data[field(.mediaItems)] as Any?)
        self.mediaItems = mediaItemsData.compactMap { Self.createMedia(from: $0) }
        self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
        self.subtitle = self.dnsstring(from: data[field(.subtitle)] as Any?) ?? self.subtitle
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.startTime.nextMonth
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.attachments): self.attachments.map { $0.asDictionary },
            field(.body): self.body.asDictionary,
            field(.chat): self.chat.asDictionary,
            field(.distribution): self.distribution.rawValue,
            field(.endTime): self.endTime,
            field(.mediaItems): self.mediaItems.map { $0.asDictionary },
            field(.startTime): self.startTime,
            field(.subtitle): self.subtitle.asDictionary,
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
        attachments = self.daoMediaArray(with: configuration, from: container, forKey: .attachments)
        body = self.dnsstring(from: container, forKey: .body) ?? body
        chat = self.daoChat(with: configuration, from: container, forKey: .chat) ?? chat
        distribution = try container.decodeIfPresent(Swift.type(of: distribution), forKey: .distribution) ?? distribution
        endTime = self.time(from: container, forKey: .endTime) ?? startTime.nextMonth
        mediaItems = self.daoMediaArray(with: configuration, from: container, forKey: .mediaItems)
        startTime = self.time(from: container, forKey: .startTime) ?? startTime
        subtitle = self.dnsstring(from: container, forKey: .subtitle) ?? subtitle
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(attachments, forKey: .attachments, configuration: configuration)
        try container.encode(body, forKey: .body)
        try container.encode(chat, forKey: .chat, configuration: configuration)
        try container.encode(distribution, forKey: .distribution)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(mediaItems, forKey: .mediaItems, configuration: configuration)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAnnouncement(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAnnouncement else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.attachments.hasDiffElementsFrom(rhs.attachments) ||
            lhs.mediaItems.hasDiffElementsFrom(rhs.mediaItems) ||
            lhs.body != rhs.body ||
            lhs.chat != rhs.chat ||
            lhs.distribution != rhs.distribution ||
            lhs.endTime != rhs.endTime ||
            lhs.startTime != rhs.startTime ||
            lhs.subtitle != rhs.subtitle ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAnnouncement, rhs: DAOAnnouncement) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAnnouncement, rhs: DAOAnnouncement) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
