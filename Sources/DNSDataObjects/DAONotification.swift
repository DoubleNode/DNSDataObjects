//
//  DAONotification.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAONotification: PTCLCFGBaseObject {
    var notificationType: DAONotification.Type { get }
    func notificationArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAONotification] where K: CodingKey
}

public protocol PTCLCFGNotificationObject: PTCLCFGBaseObject {
}
public class CFGNotificationObject: PTCLCFGNotificationObject {
}
open class DAONotification: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGNotificationObject
    public static var config: Config = CFGNotificationObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case body, deepLink, title, type
    }

    open var body = DNSString()
    open var deepLink: URL?
    open var title = DNSString()
    open var type: DNSNotificationType = .unknown
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(type: DNSNotificationType) {
        self.type = type
        super.init()
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAONotification) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAONotification) {
        super.update(from: object)
        self.body = object.body
        self.deepLink = object.deepLink
        self.title = object.title
        self.type = object.type
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAONotification {
        _ = super.dao(from: data)
        self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
        self.deepLink = self.url(from: data[field(.deepLink)] as Any?) ?? self.deepLink
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        let typeData = self.string(from: data[field(.type)] as Any?) ?? ""
        self.type = DNSNotificationType(rawValue: typeData) ?? .unknown
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.body): self.body.asDictionary,
            field(.deepLink): self.deepLink,
            field(.title): self.title.asDictionary,
            field(.type): self.type.rawValue,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        fatalError("init(from:configuration:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = self.dnsstring(from: container, forKey: .body) ?? body
        deepLink = self.url(from: container, forKey: .deepLink) ?? deepLink
        title = self.dnsstring(from: container, forKey: .title) ?? title

        type = try container.decodeIfPresent(Swift.type(of: type), forKey: .type) ?? type
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(deepLink, forKey: .deepLink)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAONotification(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAONotification else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.body != rhs.body ||
            lhs.deepLink != rhs.deepLink ||
            lhs.title != rhs.title ||
            lhs.type != rhs.type
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAONotification, rhs: DAONotification) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAONotification, rhs: DAONotification) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
