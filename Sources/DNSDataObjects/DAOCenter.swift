//
//  DAOCenter.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOCenter: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case centerNum, code, name, activities
    }

    public var centerNum: Int16 = 0
    public var code: String = ""
    public var name: String = ""
    open var activities: [DAOActivity] = []

    override public init() {
        super.init()
    }
    override public init(id: String) {
        super.init(id: id)
    }
    public init(centerNum: Int16, code: String, name: String) {
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
        self.centerNum = object.centerNum
        self.code = object.code
        self.name = object.name
        self.activities = object.activities
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOCenter {
        _ = super.dao(from: dictionary)
        self.centerNum = Int16(self.int(from: dictionary["id"] as Any?) ?? Int(self.centerNum))
        self.code = self.string(from: dictionary["code"] as Any?) ?? self.code
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name

        var activities: [DAOActivity] = []
        let activitiesData: [[String: Any?]] = (dictionary["activities"] as? [[String: Any?]]) ?? []
        activitiesData.forEach { (activityData) in
            activities.append(DAOActivity(from: activityData))
        }
        self.activities = activities
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            "centerNum": self.centerNum,
            "code": self.code,
            "name": self.name,
            "activities": self.activities.map { $0.asDictionary },
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        centerNum = try container.decode(Int16.self, forKey: .centerNum)
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)
        activities = try container.decode([DAOActivity].self, forKey: .activities)
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
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOCenter(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOCenter else { return true }
        let lhs = self
        return lhs.centerNum != rhs.centerNum
            || lhs.code != rhs.code
            || lhs.name != rhs.name
            || lhs.activities != rhs.activities
    }
}
