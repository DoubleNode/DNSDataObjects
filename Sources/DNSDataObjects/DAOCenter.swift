//
//  DAOCenter.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOCenter: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case activities, centerNum, code, district, name
    }

    open var activities: [DAOActivity] = []
    public var centerNum: Int16 = 0
    public var code = ""
    public var district = DAODistrict()
    public var name = DNSString()

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    override public init(id: String) {
        super.init(id: id)
    }
    public init(centerNum: Int16, code: String, name: DNSString) {
        self.centerNum = centerNum
        self.code = code
        self.name = name
        super.init(id: code)
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DAOCenter) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOCenter) {
        super.update(from: object)
        self.activities = object.activities
        self.centerNum = object.centerNum
        self.code = object.code
        self.district = object.district
        self.name = object.name
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOCenter {
        _ = super.dao(from: dictionary)
        var activities: [DAOActivity] = []
        let activitiesData: [[String: Any?]] = (dictionary[CodingKeys.activities.rawValue] as? [[String: Any?]]) ?? []
        activitiesData.forEach { (activityData) in
            activities.append(DAOActivity(from: activityData))
        }
        self.activities = activities
        self.centerNum = Int16(self.int(from: dictionary[CodingKeys.centerNum.rawValue] as Any?) ?? Int(self.centerNum))
        self.code = self.string(from: dictionary[CodingKeys.code.rawValue] as Any?) ?? self.code
        let districtData = dictionary[CodingKeys.district.rawValue] as? [String: Any?] ?? [:]
        self.district = DAODistrict(from: districtData)
        self.name = self.dnsstring(from: dictionary[CodingKeys.name.rawValue] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.activities.rawValue: self.activities.map { $0.asDictionary },
            CodingKeys.centerNum.rawValue: self.centerNum,
            CodingKeys.code.rawValue: self.code,
            CodingKeys.district.rawValue: self.district.asDictionary,
            CodingKeys.name.rawValue: self.name,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activities = try container.decode([DAOActivity].self, forKey: .activities)
        centerNum = try container.decode(Int16.self, forKey: .centerNum)
        code = try container.decode(String.self, forKey: .code)
        district = try container.decode(DAODistrict.self, forKey: .district)
        name = try container.decode(DNSString.self, forKey: .name)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activities, forKey: .activities)
        try container.encode(centerNum, forKey: .centerNum)
        try container.encode(code, forKey: .code)
        try container.encode(district, forKey: .district)
        try container.encode(name, forKey: .name)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOCenter(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOCenter else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.activities != rhs.activities
            || lhs.centerNum != rhs.centerNum
            || lhs.code != rhs.code
            || lhs.district != rhs.district
            || lhs.name != rhs.name
    }
}
