//
//  DAOPlaceStatus.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

public protocol PTCLCFGDAOPlaceStatus: PTCLCFGBaseObject {
    var placeStatusType: DAOPlaceStatus.Type { get }
    func placeStatus<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlaceStatus? where K: CodingKey
    func placeStatusArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceStatus] where K: CodingKey
}

public protocol PTCLCFGPlaceStatusObject: PTCLCFGBaseObject {
}
public class CFGPlaceStatusObject: PTCLCFGPlaceStatusObject {
}
open class DAOPlaceStatus: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPlaceStatusObject
    public static var config: Config = CFGPlaceStatusObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endTime, message, scope, startTime, status
    }

    open var endTime = Date()
    open var message = DNSString(with: "")
    open var scope = DNSScope.place
    open var startTime = Date()
    open var status = DNSStatus.open

    public var isOpen: Bool { utilityIsOpen() }
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    required public init(status: DNSStatus) {
        super.init()
        self.status = status
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOPlaceStatus) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPlaceStatus) {
        super.update(from: object)
        self.endTime = object.endTime
        self.scope = object.scope
        self.startTime = object.startTime
        self.status = object.status
        // swiftlint:disable force_cast
        self.message = object.message.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPlaceStatus {
        _ = super.dao(from: data)
        self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.endTime
        self.message = self.dnsstring(from: data[field(.message)] as Any?) ?? self.message
        let scopeData = self.int(from: data[field(.scope)] as Any?) ?? self.scope.rawValue
        self.scope = DNSScope(rawValue: scopeData) ?? .place
        self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
        let statusData = self.string(from: data[field(.status)] as Any?) ?? self.status.rawValue
        self.status = DNSStatus(rawValue: statusData) ?? .open
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.endTime): self.endTime,
            field(.message): self.message.asDictionary,
            field(.scope): self.scope.rawValue,
            field(.startTime): self.startTime,
            field(.status): self.status.rawValue,
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

        scope = try container.decodeIfPresent(Swift.type(of: scope), forKey: .scope) ?? scope
        status = try container.decodeIfPresent(Swift.type(of: status), forKey: .status) ?? status
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(message, forKey: .message)
        try container.encode(scope.rawValue, forKey: .scope)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(status.rawValue, forKey: .status)
    }

    // NSCopying protocol methods
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPlaceStatus(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPlaceStatus else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.endTime != rhs.endTime ||
            lhs.message != rhs.message ||
            lhs.scope != rhs.scope ||
            lhs.startTime != rhs.startTime ||
            lhs.status != rhs.status
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPlaceStatus, rhs: DAOPlaceStatus) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPlaceStatus, rhs: DAOPlaceStatus) -> Bool {
        !lhs.isDiffFrom(rhs)
    }

    // MARK: - Utility methods -
    open func utilityIsOpen() -> Bool {
        return [.open, .grandOpening, .holiday].contains(self.status)
    }
}
