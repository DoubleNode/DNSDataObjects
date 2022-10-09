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
    open class var activityTypeType: DAOActivityType.Type { DAOActivityType.self }
    open class var activityBlackoutType: DAOActivityBlackout.Type { DAOActivityBlackout.self }
    open class var activityBlackoutArrayType: [DAOActivityBlackout].Type { [DAOActivityBlackout].self }

    open class func createActivityType() -> DAOActivityType { activityTypeType.init() }
    open class func createActivityType(from object: DAOActivityType) -> DAOActivityType { activityTypeType.init(from: object) }
    open class func createActivityType(from data: DNSDataDictionary) -> DAOActivityType? { activityTypeType.init(from: data) }

    open class func createActivityBlackout() -> DAOActivityBlackout { activityBlackoutType.init() }
    open class func createActivityBlackout(from object: DAOActivityBlackout) -> DAOActivityBlackout { activityBlackoutType.init(from: object) }
    open class func createActivityBlackout(from data: DNSDataDictionary) -> DAOActivityBlackout? { activityBlackoutType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case baseType, blackouts, bookingEndTime, bookingStartTime, code, name
    }

    open var baseType: DAOActivityType
    open var blackouts: [DAOActivityBlackout] = []
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
        self.name = object.name
        // swiftlint:disable force_cast
        self.blackouts = object.blackouts.map { $0.copy() as! DAOActivityBlackout }
        self.baseType = object.baseType.copy() as! DAOActivityType
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
        baseType = Self.createActivityType()
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseType = self.daoActivityType(of: Self.activityTypeType, from: container, forKey: .baseType) ?? baseType
        blackouts = self.daoActivityBlackoutArray(of: Self.activityBlackoutArrayType, from: container, forKey: .blackouts)
        bookingEndTime = self.date(from: container, forKey: .bookingEndTime) ?? bookingEndTime
        bookingStartTime = self.date(from: container, forKey: .bookingStartTime) ?? bookingStartTime
        code = self.string(from: container, forKey: .code) ?? code
        name = self.dnsstring(from: container, forKey: .name) ?? name
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
        return super.isDiffFrom(rhs) ||
            lhs.baseType != rhs.baseType ||
            lhs.blackouts != rhs.blackouts ||
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
