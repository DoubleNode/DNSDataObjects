//
//  DAOChat.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOChat: PTCLCFGBaseObject {
    var chatType: DAOChat.Type { get }
    func chat<K>(from container: KeyedDecodingContainer<K>,
                 forKey key: KeyedDecodingContainer<K>.Key) -> DAOChat? where K: CodingKey
    func chatArray<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> [DAOChat] where K: CodingKey
}

public protocol PTCLCFGChatObject: PTCLCFGDAOAccount, PTCLCFGDAOChatMessage {
}
public class CFGChatObject: PTCLCFGChatObject {
    public var accountType: DAOAccount.Type = DAOAccount.self
    public var chatMessageType: DAOChatMessage.Type = DAOChatMessage.self

    open func account<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccount? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAccount.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func chatMessage<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOChatMessage? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOChatMessage.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }

    open func accountArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccount] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAccount].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func chatMessageArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOChatMessage] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOChatMessage].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOChat: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGChatObject
    public static var config: Config = CFGChatObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAccount() -> DAOAccount { config.accountType.init() }
    open class func createAccount(from object: DAOAccount) -> DAOAccount { config.accountType.init(from: object) }
    open class func createAccount(from data: DNSDataDictionary) -> DAOAccount? { config.accountType.init(from: data) }

    open class func createChatMessage() -> DAOChatMessage { config.chatMessageType.init() }
    open class func createChatMessage(from object: DAOChatMessage) -> DAOChatMessage { config.chatMessageType.init(from: object) }
    open class func createChatMessage(from data: DNSDataDictionary) -> DAOChatMessage? { config.chatMessageType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case messages, participants
    }

    @CodableConfiguration(from: DAOCard.self) open var messages: [DAOChatMessage] = []
    @CodableConfiguration(from: DAOCard.self) open var participants: [DAOAccount] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOChat) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOChat) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.messages = object.messages.map { $0.copy() as! DAOChatMessage }
        self.participants = object.participants.map { $0.copy() as! DAOAccount }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOChat{
        _ = super.dao(from: data)
        let messagesData = self.dataarray(from: data[field(.messages)] as Any?)
        self.messages = messagesData.compactMap { Self.createChatMessage(from: $0) }
        let participantsData = self.dataarray(from: data[field(.participants)] as Any?)
        self.participants = participantsData.compactMap { Self.createAccount(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.messages): self.messages.map { $0.asDictionary },
            field(.participants): self.participants.map { $0.asDictionary },
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
        messages = self.daoChatMessageArray(with: configuration, from: container, forKey: .messages)
        participants = self.daoAccountArray(with: configuration, from: container, forKey: .participants)
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(messages, forKey: .messages, configuration: configuration)
        try container.encode(participants, forKey: .participants, configuration: configuration)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOChat(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOChat else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.messages.hasDiffElementsFrom(rhs.messages) ||
            lhs.participants.hasDiffElementsFrom(rhs.participants)
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOChat, rhs: DAOChat) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOChat, rhs: DAOChat) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
