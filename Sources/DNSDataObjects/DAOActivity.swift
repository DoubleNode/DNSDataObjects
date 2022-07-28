//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOActivity: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var baseType: DAOActivityType.Type { return DAOActivityType.self }
    open class var blackoutType: DAOActivityBlackout.Type { return DAOActivityBlackout.self }

    open class func createBase() -> DAOActivityType { baseType.init() }
    open class func createBase(from object: DAOActivityType) -> DAOActivityType { baseType.init(from: object) }
    open class func createBase(from data: DNSDataDictionary) -> DAOActivityType { baseType.init(from: data) }

    open class func createBlackout() -> DAOActivityBlackout { blackoutType.init() }
    open class func createBlackout(from object: DAOActivityBlackout) -> DAOActivityBlackout { blackoutType.init(from: object) }
    open class func createBlackout(from data: DNSDataDictionary) -> DAOActivityBlackout { blackoutType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case baseType, blackouts, bookingEndTime, bookingStartTime, code, name
    }

    open var baseType = DAOActivity.createBase()
    open var blackouts: [DAOActivityBlackout] = []
    open var bookingEndTime: Date?
    open var bookingStartTime: Date?
    open var code = ""
    open var name = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(code: String, name: DNSString) {
        self.code = code
        self.name = name
        super.init(id: code)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOActivity) {
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
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOActivity {
        _ = super.dao(from: data)
        // TODO: Implement baseType import
        let baseTypeData = self.dictionary(from: data[field(.baseType)] as Any?)
        self.baseType = Self.createBase(from: baseTypeData)
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
            field(.bookingEndTime): self.bookingEndTime,
            field(.bookingStartTime): self.bookingStartTime,
            field(.code): self.code,
            field(.name): self.name.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseType = try container.decode(Self.baseType.self, forKey: .baseType)
        blackouts = try container.decode([DAOActivityBlackout].self, forKey: .blackouts)
        bookingEndTime = try container.decode(Date?.self, forKey: .bookingEndTime)
        bookingStartTime = try container.decode(Date?.self, forKey: .bookingStartTime)
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(DNSString.self, forKey: .name)
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.baseType != rhs.baseType
            || lhs.blackouts != rhs.blackouts
            || lhs.bookingEndTime != rhs.bookingEndTime
            || lhs.bookingStartTime != rhs.bookingStartTime
            || lhs.code != rhs.code
            || lhs.name != rhs.name
    }
}
