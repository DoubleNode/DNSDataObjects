//
//  DAOPlaceStatus.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

open class DAOPlaceStatus: DAOBaseObject {
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
        self.message = object.message
        self.scope = object.scope
        self.startTime = object.startTime
        self.status = object.status
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endTime = try container.decodeIfPresent(Date.self, forKey: .endTime) ?? endTime
        message = try container.decodeIfPresent(DNSString.self, forKey: .message) ?? message
        scope = try container.decodeIfPresent(DNSScope.self, forKey: .scope) ?? scope
        startTime = try container.decodeIfPresent(Date.self, forKey: .startTime) ?? startTime
        status = try container.decodeIfPresent(DNSStatus.self, forKey: .status) ?? status
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
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
