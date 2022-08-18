//
//  DAOActivityBlackout.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOActivityBlackout: DAOBaseObject {
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
        self.message = object.message
        self.startTime = object.startTime
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endTime = try container.decode(Date?.self, forKey: .endTime)
        message = try container.decode(DNSString.self, forKey: .message)
        startTime = try container.decode(Date?.self, forKey: .startTime)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
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
