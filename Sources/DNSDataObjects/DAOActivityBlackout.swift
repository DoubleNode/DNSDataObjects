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
    public enum CodingKeys: String, CodingKey {
        case endTime, message, startTime
    }

    public var endTime: Date?
    public var message: DNSString = DNSString()
    public var startTime: Date?

    // MARK: - Initializers -
    public override init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOActivityBlackout) {
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
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    open override func dao(from dictionary: [String: Any?]) -> DAOActivityBlackout {
        _ = super.dao(from: dictionary)
        self.endTime = self.date(from: dictionary[CodingKeys.endTime.rawValue] as Any?) ?? self.endTime
        self.message = self.dnsstring(from: dictionary[CodingKeys.message.rawValue] as Any?) ?? self.message
        self.startTime = self.date(from: dictionary[CodingKeys.startTime.rawValue] as Any?) ?? self.startTime
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.endTime.rawValue: self.endTime,
            CodingKeys.message.rawValue: self.message.asDictionary,
            CodingKeys.startTime.rawValue: self.startTime,
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
        return lhs.endTime != rhs.endTime
            || lhs.message != rhs.message
            || lhs.startTime != rhs.startTime
    }
}
