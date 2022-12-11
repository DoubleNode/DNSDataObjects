//
//  DAOActivityBlackout.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOActivityBlackout: PTCLCFGBaseObject {
    var activityBlackoutType: DAOActivityBlackout.Type { get }
    func activityBlackout<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityBlackout? where K: CodingKey
    func activityBlackoutArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityBlackout] where K: CodingKey
}

public protocol PTCLCFGActivityBlackoutObject: PTCLCFGDAOActivityBlackout {
}
public class CFGActivityBlackoutObject: PTCLCFGActivityBlackoutObject {
    public var activityBlackoutType: DAOActivityBlackout.Type = DAOActivityBlackout.self
    open func activityBlackout<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityBlackout? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOActivityBlackout.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func activityBlackoutArray<K>(from container: KeyedDecodingContainer<K>,
                                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityBlackout] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOActivityBlackout].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOActivityBlackout: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGActivityBlackoutObject
    public static var config: Config = CFGActivityBlackoutObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createActivityBlackout() -> DAOActivityBlackout { config.activityBlackoutType.init() }
    open class func createActivityBlackout(from object: DAOActivityBlackout) -> DAOActivityBlackout { config.activityBlackoutType.init(from: object) }
    open class func createActivityBlackout(from data: DNSDataDictionary) -> DAOActivityBlackout? { config.activityBlackoutType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endTime, message, startTime
    }

    open var endTime: Date?
    open var message = DNSString()
    open var startTime: Date?

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOActivityBlackout) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOActivityBlackout) {
        super.update(from: object)
        self.endTime = object.endTime
        self.startTime = object.startTime
        // swiftlint:disable force_cast
        self.message = object.message.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    open override func dao(from data: DNSDataDictionary) -> DAOActivityBlackout {
        _ = super.dao(from: data)
        self.endTime = self.date(from: data[field(.endTime)] as Any?) ?? self.endTime
        self.message = self.dnsstring(from: data[field(.message)] as Any?) ?? self.message
        self.startTime = self.date(from: data[field(.startTime)] as Any?) ?? self.startTime
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.endTime): self.endTime,
            field(.message): self.message.asDictionary,
            field(.startTime): self.startTime,
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
        endTime = self.date(from: container, forKey: .endTime) ?? endTime
        message = self.dnsstring(from: container, forKey: .message) ?? message
        startTime = self.date(from: container, forKey: .startTime) ?? startTime
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(message, forKey: .message)
        try container.encode(startTime, forKey: .startTime)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOActivityBlackout(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOActivityBlackout else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.endTime != rhs.endTime ||
            lhs.message != rhs.message ||
            lhs.startTime != rhs.startTime
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOActivityBlackout, rhs: DAOActivityBlackout) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOActivityBlackout, rhs: DAOActivityBlackout) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
