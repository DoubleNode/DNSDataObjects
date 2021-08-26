//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOActivity: DAOBaseObject {
    public var baseType: DAOActivityType?
    public var bookingEndTime: Date?
    public var bookingStartTime: Date?
    public var code: String
    public var name: String
    open var beacons: [DAOBeacon] = []

    private enum CodingKeys: String, CodingKey {
        case baseType, bookingEndTime, bookingStartTime, code, name /*, beacons*/
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseType = try container.decode(DAOActivityType.self, forKey: .baseType)
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
        if baseType != nil { try container.encode(baseType, forKey: .baseType) }
        try container.encode(bookingEndTime, forKey: .bookingEndTime)
        try container.encode(bookingStartTime, forKey: .bookingStartTime)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
    }

    override public init() {
        self.baseType = nil
        self.code = ""
        self.name = ""
        self.beacons = []
        super.init()
    }
    override public init(id: String) {
        self.baseType = nil
        self.code = ""
        self.name = ""
        self.beacons = []
        super.init(id: id)
    }
    override public init(from dictionary: [String: Any?]) {
        self.baseType = nil
        self.code = ""
        self.name = ""
        self.beacons = []
        super.init()
        _ = self.dao(from: dictionary)
    }
    public init(from object: DAOActivity) {
        self.baseType = object.baseType
        self.bookingEndTime = object.bookingEndTime
        self.bookingStartTime = object.bookingStartTime
        self.code = object.code
        self.name = object.name
        self.beacons = object.beacons
        super.init(from: object)
    }
    public init(code: String, name: String) {
        self.baseType = nil
        self.code = code
        self.name = name
        self.beacons = []
        super.init(id: code)
    }
    open func update(from object: DAOActivity) {
        self.baseType = object.baseType
        self.bookingEndTime = object.bookingEndTime
        self.bookingStartTime = object.bookingStartTime
        self.code = object.code
        self.name = object.name
        self.beacons = object.beacons
        super.update(from: object)
    }

    override open func dao(from dictionary: [String: Any?]) -> DAOActivity {
        // TODO: Implement baseType import
        self.bookingEndTime = self.date(from: dictionary["bookingEndTime"] as Any?)
        self.bookingStartTime = self.date(from: dictionary["bookingStartTime"] as Any?)
        self.code = self.string(from: dictionary["code"] as Any?) ?? self.code
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name
        var beacons: [DAOBeacon] = []
        let beaconsData: [[String: Any?]] = (dictionary["beacons"] as? [[String: Any?]]) ?? []
        beaconsData.forEach { (beaconData) in
            beacons.append(DAOBeacon(from: beaconData))
        }
        self.beacons = beacons
        _ = super.dao(from: dictionary)
        return self
    }
    override open func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "baseType": self.baseType?.code,
            "bookingEndTime": self.bookingEndTime,
            "bookingStartTime": self.bookingStartTime,
            "code": self.code,
            "name": self.name,
            "beacons": self.beacons.map { $0.dictionary() },
        ]) { (current, _) in current }
        return retval
    }
}
