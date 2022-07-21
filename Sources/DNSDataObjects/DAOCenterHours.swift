//
//  DAOCenterHours.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOCenterHours: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case events, holidays
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    public var events: [DAOCenterEvent] = []
    public var holidays: [DAOCenterHoliday] = []

    public var monday = DNSDayHours()
    public var tuesday = DNSDayHours()
    public var wednesday = DNSDayHours()
    public var thursday = DNSDayHours()
    public var friday = DNSDayHours()
    public var saturday = DNSDayHours()
    public var sunday = DNSDayHours()

    public var today: DNSDayHours {
        switch Date().dnsDayOfWeek {
        case .unknown: return self.sunday
        case .sunday: return self.sunday
        case .monday: return self.monday
        case .tuesday: return self.tuesday
        case .wednesday: return self.wednesday
        case .thursday: return self.thursday
        case .friday: return self.friday
        case .saturday: return self.saturday
        }
    }
    public var todayOpen: Date? {
        return self.today.open(on: Date())
    }
    public var todayClose: Date? {
        return self.today.close(on: Date())
    }

    // MARK: - Initializers -
    override public required init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOCenterHours) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOCenterHours) {
        super.update(from: object)
        self.events = object.events
        self.holidays = object.holidays
        // swiftlint:disable force_cast
        self.monday = object.monday.copy() as! DNSDayHours
        self.tuesday = object.tuesday.copy() as! DNSDayHours
        self.wednesday = object.wednesday.copy() as! DNSDayHours
        self.thursday = object.thursday.copy() as! DNSDayHours
        self.friday = object.friday.copy() as! DNSDayHours
        self.saturday = object.saturday.copy() as! DNSDayHours
        self.sunday = object.sunday.copy() as! DNSDayHours
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOCenterHours {
        _ = super.dao(from: dictionary)
        let eventsData: [[String: Any?]] = dictionary[CodingKeys.events.rawValue] as? [[String: Any?]] ?? []
        self.events = eventsData.map { DAOCenterEvent(from: $0) }
        let holidaysData: [[String: Any?]] = dictionary[CodingKeys.holidays.rawValue] as? [[String: Any?]] ?? []
        self.holidays = holidaysData.map { DAOCenterHoliday(from: $0) }
        let mondayData: [String: Any?] = dictionary[CodingKeys.monday.rawValue] as? [String: Any?] ?? [:]
        self.monday = DNSDayHours(from: mondayData)
        let tuesdayData: [String: Any?] = dictionary[CodingKeys.tuesday.rawValue] as? [String: Any?] ?? [:]
        self.tuesday = DNSDayHours(from: tuesdayData)
        let wednesdayData: [String: Any?] = dictionary[CodingKeys.wednesday.rawValue] as? [String: Any?] ?? [:]
        self.wednesday = DNSDayHours(from: wednesdayData)
        let thursdayData: [String: Any?] = dictionary[CodingKeys.thursday.rawValue] as? [String: Any?] ?? [:]
        self.thursday = DNSDayHours(from: thursdayData)
        let fridayData: [String: Any?] = dictionary[CodingKeys.friday.rawValue] as? [String: Any?] ?? [:]
        self.friday = DNSDayHours(from: fridayData)
        let saturdayData: [String: Any?] = dictionary[CodingKeys.saturday.rawValue] as? [String: Any?] ?? [:]
        self.saturday = DNSDayHours(from: saturdayData)
        let sundayData: [String: Any?] = dictionary[CodingKeys.sunday.rawValue] as? [String: Any?] ?? [:]
        self.sunday = DNSDayHours(from: sundayData)
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.events.rawValue: self.events.map { $0.asDictionary },
            CodingKeys.holidays.rawValue: self.holidays.map { $0.asDictionary },
            CodingKeys.monday.rawValue: self.monday.asDictionary,
            CodingKeys.tuesday.rawValue: self.tuesday.asDictionary,
            CodingKeys.wednesday.rawValue: self.wednesday.asDictionary,
            CodingKeys.thursday.rawValue: self.thursday.asDictionary,
            CodingKeys.friday.rawValue: self.friday.asDictionary,
            CodingKeys.saturday.rawValue: self.saturday.asDictionary,
            CodingKeys.sunday.rawValue: self.sunday.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        events = try container.decode([DAOCenterEvent].self, forKey: .events)
        holidays = try container.decode([DAOCenterHoliday].self, forKey: .holidays)
        monday = try container.decode(DNSDayHours.self, forKey: .monday)
        tuesday = try container.decode(DNSDayHours.self, forKey: .tuesday)
        wednesday = try container.decode(DNSDayHours.self, forKey: .wednesday)
        thursday = try container.decode(DNSDayHours.self, forKey: .thursday)
        friday = try container.decode(DNSDayHours.self, forKey: .friday)
        saturday = try container.decode(DNSDayHours.self, forKey: .saturday)
        sunday = try container.decode(DNSDayHours.self, forKey: .sunday)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(events, forKey: .events)
        try container.encode(holidays, forKey: .holidays)
        try container.encode(monday, forKey: .monday)
        try container.encode(tuesday, forKey: .tuesday)
        try container.encode(wednesday, forKey: .wednesday)
        try container.encode(thursday, forKey: .thursday)
        try container.encode(friday, forKey: .friday)
        try container.encode(saturday, forKey: .saturday)
        try container.encode(sunday, forKey: .sunday)
    }

    // NSCopying protocol methods
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOCenterHours(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOCenterHours else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.events != rhs.events
            || lhs.holidays != rhs.holidays
            || lhs.monday != rhs.monday
            || lhs.tuesday != rhs.tuesday
            || lhs.wednesday != rhs.wednesday
            || lhs.thursday != rhs.thursday
            || lhs.friday != rhs.friday
            || lhs.saturday != rhs.saturday
            || lhs.sunday != rhs.sunday
    }
}
