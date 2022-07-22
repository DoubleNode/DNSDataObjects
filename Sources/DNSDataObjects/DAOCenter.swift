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
    // MARK: - Class Factory methods -
    open class var activityType: DAOActivity.Type { return DAOActivity.self }
    open class var districtType: DAODistrict.Type { return DAODistrict.self }

    open class func createActivity() -> DAOActivity { activityType.init() }
    open class func createActivity(from object: DAOActivity) -> DAOActivity { activityType.init(from: object) }
    open class func createActivity(from data: DNSDataDictionary) -> DAOActivity { activityType.init(from: data) }

    open class func createDistrict() -> DAODistrict { districtType.init() }
    open class func createDistrict(from object: DAODistrict) -> DAODistrict { districtType.init(from: object) }
    open class func createDistrict(from data: DNSDataDictionary) -> DAODistrict { districtType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case activities, centerNum, code, district, name
    }

    open var activities: [DAOActivity] = []
    public var centerNum: Int16 = 0
    public var code = ""
    public var district = DAOCenter.createDistrict()
    public var name = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(centerNum: Int16, code: String, name: DNSString) {
        self.centerNum = centerNum
        self.code = code
        self.name = name
        super.init(id: code)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOCenter) {
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
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOCenter {
        _ = super.dao(from: data)
        var activities: [DAOActivity] = []
        let activitiesData: [DNSDataDictionary] = (data[field(.activities)] as? [DNSDataDictionary]) ?? []
        activitiesData.forEach { (activityData) in
            activities.append(Self.createActivity(from: activityData))
        }
        self.activities = activities
        self.centerNum = Int16(self.int(from: data[field(.centerNum)] as Any?) ?? Int(self.centerNum))
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        let districtData = data[field(.district)] as? DNSDataDictionary ?? [:]
        self.district = Self.createDistrict(from: districtData)
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.activities): self.activities.map { $0.asDictionary },
            field(.centerNum): self.centerNum,
            field(.code): self.code,
            field(.district): self.district.asDictionary,
            field(.name): self.name,
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
