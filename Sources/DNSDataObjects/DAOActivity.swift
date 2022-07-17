//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOActivity: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case baseType, blackouts, bookingEndTime, bookingStartTime, code, name
    }

    public var baseType: DAOActivityType?
    public var blackouts: [DAOActivityBlackout] = []
    public var bookingEndTime: Date?
    public var bookingStartTime: Date?
    public var code: String = ""
    public var name: String = ""

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    override public init(id: String) {
        super.init(id: id)
    }
    public init(code: String, name: String) {
        self.code = code
        self.name = name
        super.init(id: code)
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOActivity) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOActivity) {
        super.update(from: object)
        self.baseType = object.baseType
        self.blackouts = object.blackouts
        self.bookingEndTime = object.bookingEndTime
        self.bookingStartTime = object.bookingStartTime
        self.code = object.code
        self.name = object.name
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOActivity {
        _ = super.dao(from: dictionary)
        // TODO: Implement baseType import
        let baseTypeData = dictionary[CodingKeys.baseType.rawValue] as? [String: Any?] ?? [:]
        self.baseType = DAOActivityType(from: baseTypeData)
        self.bookingEndTime = self.date(from: dictionary[CodingKeys.bookingEndTime.rawValue] as Any?)
        self.bookingStartTime = self.date(from: dictionary[CodingKeys.bookingStartTime.rawValue] as Any?)
        self.code = self.string(from: dictionary[CodingKeys.code.rawValue] as Any?) ?? self.code
        self.name = self.string(from: dictionary[CodingKeys.name.rawValue] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.baseType.rawValue: self.baseType?.asDictionary,
            CodingKeys.bookingEndTime.rawValue: self.bookingEndTime,
            CodingKeys.bookingStartTime.rawValue: self.bookingStartTime,
            CodingKeys.code.rawValue: self.code,
            CodingKeys.name.rawValue: self.name,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseType = try container.decode(DAOActivityType?.self, forKey: .baseType)
        blackouts = try container.decode([DAOActivityBlackout].self, forKey: .blackouts)
        bookingEndTime = try container.decode(Date?.self, forKey: .bookingEndTime)
        bookingStartTime = try container.decode(Date?.self, forKey: .bookingStartTime)
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseType, forKey: .baseType)
        try container.encode(blackouts, forKey: .blackouts)
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
        let lhs = self
        return lhs.baseType != rhs.baseType
            || lhs.blackouts != rhs.blackouts
            || lhs.bookingEndTime != rhs.bookingEndTime
            || lhs.bookingStartTime != rhs.bookingStartTime
            || lhs.code != rhs.code
            || lhs.name != rhs.name
    }
}
