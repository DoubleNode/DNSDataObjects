//
//  DAOCenter.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOCenter: DAOBaseObject {
    public var centerNum: Int16
    public var code: String
    public var name: String
    open var activities: [DAOActivity]
    open var beacons: [DAOBeacon]

    private enum CodingKeys: String, CodingKey {
        case centerNum, code, name, activities, beacons
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        centerNum = try container.decode(Int16.self, forKey: .centerNum)
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)
        activities = try container.decode([DAOActivity].self, forKey: .activities)
        beacons = try container.decode([DAOBeacon].self, forKey: .beacons)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(centerNum, forKey: .centerNum)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(activities, forKey: .activities)
        try container.encode(beacons, forKey: .beacons)
    }

    override public init() {
        self.centerNum = 0
        self.code = ""
        self.name = ""
        self.activities = []
        self.beacons = []
        super.init()
    }
    override public init(id: String) {
        self.centerNum = 0
        self.code = ""
        self.name = ""
        self.activities = []
        self.beacons = []
        super.init(id: id)
    }
    override public init(from dictionary: [String: Any?]) {
        self.centerNum = 0
        self.code = ""
        self.name = ""
        self.activities = []
        self.beacons = []
        super.init()
        _ = self.dao(from: dictionary)
    }
    
    public init(from object: DAOCenter) {
        self.centerNum = object.centerNum
        self.code = object.code
        self.name = object.name
        self.activities = object.activities
        self.beacons = object.beacons
        super.init(from: object)
    }
    public init(centerNum: Int16, code: String, name: String) {
        self.centerNum = centerNum
        self.code = code
        self.name = name
        self.activities = []
        self.beacons = []
        super.init(id: code)
    }
    
    open func update(from object: DAOCenter) {
        self.centerNum = object.centerNum
        self.code = object.code
        self.name = object.name
        self.activities = object.activities
        self.beacons = object.beacons
        super.update(from: object)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOCenter {
        self.centerNum = Int16(self.int(from: dictionary["id"] as Any?) ?? Int(self.centerNum))
        self.code = self.string(from: dictionary["code"] as Any?) ?? self.code
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name

        var activities: [DAOActivity] = []
        let activitiesData: [[String: Any?]] = (dictionary["activities"] as? [[String: Any?]]) ?? []
        activitiesData.forEach { (activityData) in
            activities.append(DAOActivity(from: activityData))
        }
        self.activities = activities
        
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
            "code": self.code,
            "name": self.name,
            "activities": self.activities.map { $0.dictionary() },
            "beacons": self.beacons.map { $0.dictionary() },
        ]) { (current, _) in current }
        return retval
    }
}
