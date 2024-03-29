//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOActivity: PTCLCFGBaseObject {
    var activityType: DAOActivity.Type { get }
    func activity<K>(from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivity? where K: CodingKey
    func activityArray<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivity] where K: CodingKey
}

public protocol PTCLCFGActivityObject: PTCLCFGDAOActivity, PTCLCFGDAOActivityType, PTCLCFGDAOActivityBlackout {
}
public class CFGActivityObject: PTCLCFGActivityObject {
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

    public var activityTypeType: DAOActivityType.Type = DAOActivityType.self
    open func activityType<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityType? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOActivityType.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func activityTypeArray<K>(from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityType] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOActivityType].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOActivity: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGActivityObject
    public static var config: Config = CFGActivityObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createActivity() -> DAOActivity { config.activityType.init() }
    open class func createActivity(from object: DAOActivity) -> DAOActivity { config.activityType.init(from: object) }
    open class func createActivity(from data: DNSDataDictionary) -> DAOActivity? { config.activityType.init(from: data) }

    open class func createActivityType() -> DAOActivityType { config.activityTypeType.init() }
    open class func createActivityType(from object: DAOActivityType) -> DAOActivityType { config.activityTypeType.init(from: object) }
    open class func createActivityType(from data: DNSDataDictionary) -> DAOActivityType? { config.activityTypeType.init(from: data) }

    open class func createActivityBlackout() -> DAOActivityBlackout { config.activityBlackoutType.init() }
    open class func createActivityBlackout(from object: DAOActivityBlackout) -> DAOActivityBlackout { config.activityBlackoutType.init(from: object) }
    open class func createActivityBlackout(from data: DNSDataDictionary) -> DAOActivityBlackout? { config.activityBlackoutType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case baseType, blackouts, bookingEndTime, bookingStartTime, code, name
    }

    @CodableConfiguration(from: DAOActivity.self) open var baseType: DAOActivityType = DAOActivityType()
    @CodableConfiguration(from: DAOActivity.self) open var blackouts: [DAOActivityBlackout] = []
    open var bookingEndTime: Date?
    open var bookingStartTime: Date?
    open var code = ""
    open var name = DNSString()

    // MARK: - Initializers -
    required public init() {
        baseType = Self.createActivityType()
        super.init()
    }
    required public init(id: String) {
        baseType = Self.createActivityType()
        super.init(id: id)
    }
    public init(code: String, name: DNSString) {
        baseType = Self.createActivityType()
        self.code = code
        self.name = name
        super.init(id: code)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOActivity) {
        baseType = Self.createActivityType()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOActivity) {
        super.update(from: object)
        self.bookingEndTime = object.bookingEndTime
        self.bookingStartTime = object.bookingStartTime
        self.code = object.code
        // swiftlint:disable force_cast
        self.blackouts = object.blackouts.map { $0.copy() as! DAOActivityBlackout }
        self.baseType = object.baseType.copy() as! DAOActivityType
        self.name = object.name.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        baseType = Self.createActivityType()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOActivity {
        _ = super.dao(from: data)
        // TODO: Implement baseType import
        let baseTypeData = self.dictionary(from: data[field(.baseType)] as Any?)
        self.baseType = Self.createActivityType(from: baseTypeData) ?? self.baseType
        let blackoutsData = self.dataarray(from: data[field(.blackouts)] as Any?)
        self.blackouts = blackoutsData.compactMap { Self.createActivityBlackout(from: $0) }
        self.bookingEndTime = self.date(from: data[field(.bookingEndTime)] as Any?)
        self.bookingStartTime = self.date(from: data[field(.bookingStartTime)] as Any?)
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.baseType): self.baseType.asDictionary,
            field(.blackouts): self.blackouts.map { $0.asDictionary },
            field(.bookingEndTime): self.bookingEndTime,
            field(.bookingStartTime): self.bookingStartTime,
            field(.code): self.code,
            field(.name): self.name.asDictionary,
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
        baseType = self.daoActivityType(with: configuration, from: container, forKey: .baseType) ?? baseType
        blackouts = self.daoActivityBlackoutArray(with: configuration, from: container, forKey: .blackouts)
        bookingEndTime = self.date(from: container, forKey: .bookingEndTime) ?? bookingEndTime
        bookingStartTime = self.date(from: container, forKey: .bookingStartTime) ?? bookingStartTime
        code = self.string(from: container, forKey: .code) ?? code
        name = self.dnsstring(from: container, forKey: .name) ?? name
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseType, forKey: .baseType, configuration: configuration)
        try container.encode(blackouts, forKey: .blackouts, configuration: configuration)
        try container.encode(bookingEndTime, forKey: .bookingEndTime)
        try container.encode(bookingStartTime, forKey: .bookingStartTime)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOActivity(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOActivity else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.blackouts.hasDiffElementsFrom(rhs.blackouts) ||
            lhs.baseType != rhs.baseType ||
            lhs.bookingEndTime != rhs.bookingEndTime ||
            lhs.bookingStartTime != rhs.bookingStartTime ||
            lhs.code != rhs.code ||
            lhs.name != rhs.name
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOActivity, rhs: DAOActivity) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOActivity, rhs: DAOActivity) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
