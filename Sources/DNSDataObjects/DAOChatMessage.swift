//
//  DAOChatMessage.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOChatMessage: PTCLCFGBaseObject {
    var chatMessageType: DAOChatMessage.Type { get }
    func chatMessage<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOChatMessage? where K: CodingKey
    func chatMessageArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOChatMessage] where K: CodingKey
}

public protocol PTCLCFGChatMessageObject: PTCLCFGDAOChat, PTCLCFGDAOMedia {
}
public class CFGChatMessageObject: PTCLCFGChatMessageObject {
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
open class DAOChatMessage: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGChatMessageObject
    public static var config: Config = CFGChatMessageObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createChat() -> DAOChat { config.chatType.init() }
    open class func createChat(from object: DAOChat) -> DAOChat { config.chatType.init(from: object) }
    open class func createChat(from data: DNSDataDictionary) -> DAOChat? { config.chatType.init(from: data) }

    open class func createMedia() -> DAOMedia { config.mediaType.init() }
    open class func createMedia(from object: DAOMedia) -> DAOMedia { config.mediaType.init(from: object) }
    open class func createMedia(from data: DNSDataDictionary) -> DAOMedia? { config.mediaType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case body, chat, media
    }

    open var body = ""
    @CodableConfiguration(from: DAOChatMessage.self) open var chat = DAOChat()
    @CodableConfiguration(from: DAOChatMessage.self) open var media: DAOMedia? = nil

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOChatMessage) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOChatMessage) {
        super.update(from: object)
        self.body = object.body
        // swiftlint:disable force_cast
        self.chat = object.chat.copy() as! DAOChat
        self.media = object.media?.copy() as? DAOMedia
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOChatMessage{
        _ = super.dao(from: data)
        self.body = self.string(from: data[field(.body)] as Any?) ?? self.body
        let chatData = self.dictionary(from: data[field(.chat)] as Any?)
        self.chat = Self.createChat(from: chatData) ?? self.chat
        let mediaData = self.dictionary(from: data[field(.media)] as Any?)
        self.media = Self.createMedia(from: mediaData) ?? self.media
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.body): self.body,
            field(.chat): self.chat.asDictionary,
        ]) { (current, _) in current }
        if let media = self.media {
            retval.merge([
                field(.media): media.asDictionary,
            ]) { (current, _) in current }
        }
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
        body = self.string(from: container, forKey: .body) ?? body
        chat = self.daoChat(with: configuration, from: container, forKey: .chat) ?? chat
        media = self.daoMedia(with: configuration, from: container, forKey: .media)
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(chat, forKey: .chat, configuration: configuration)
        try container.encode(media, forKey: .media, configuration: configuration)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOChatMessage(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOChatMessage else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.media?.isDiffFrom(rhs.media) ?? (lhs.media != rhs.media)) ||
            lhs.body != rhs.body ||
            lhs.chat != rhs.chat
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOChatMessage, rhs: DAOChatMessage) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOChatMessage, rhs: DAOChatMessage) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
