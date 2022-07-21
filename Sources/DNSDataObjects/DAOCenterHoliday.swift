//
//  DAOCenterHoliday.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOCenterHoliday: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case date, hours
    }

    public var date = Date.today
    public var hours = DNSDayHours()

    // MARK: - Initializers -
    override public init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOCenterHoliday) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOCenterHoliday) {
        super.update(from: object)
        self.date = object.date
        // swiftlint:disable force_cast
        self.hours = object.hours.copy() as! DNSDayHours
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOCenterHoliday {
        _ = super.dao(from: dictionary)
        self.date = self.time(from: dictionary[CodingKeys.date.rawValue] as Any?) ?? self.date
        let hoursData: [String: Any?] = dictionary[CodingKeys.hours.rawValue] as? [String: Any?] ?? [:]
        self.hours = DNSDayHours(from: hoursData)
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.date.rawValue: self.date,
            CodingKeys.hours.rawValue: self.hours.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        hours = try container.decode(DNSDayHours.self, forKey: .hours)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(hours, forKey: .hours)
    }

    // NSCopying protocol methods
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOCenterHoliday(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOCenterHoliday else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.date != rhs.date
            || lhs.hours != rhs.hours
    }
}
