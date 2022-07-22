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
    // MARK: - Class Factory methods -
    open class var eventType: DAOCenterEvent.Type { return DAOCenterEvent.self }
    open class var holidayType: DAOCenterHoliday.Type { return DAOCenterHoliday.self }

    open class func createEvent() -> DAOCenterEvent { eventType.init() }
    open class func createEvent(from object: DAOCenterEvent) -> DAOCenterEvent { eventType.init(from: object) }
    open class func createEvent(from data: DNSDataDictionary) -> DAOCenterEvent { eventType.init(from: data) }

    open class func createHoliday() -> DAOCenterHoliday { holidayType.init() }
    open class func createHoliday(from object: DAOCenterHoliday) -> DAOCenterHoliday { holidayType.init(from: object) }
    open class func createHoliday(from data: DNSDataDictionary) -> DAOCenterHoliday { holidayType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
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
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOCenterHours) {
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
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOCenterHours {
        _ = super.dao(from: data)
        let eventsData: [DNSDataDictionary] = data[field(.events)] as? [DNSDataDictionary] ?? []
        self.events = eventsData.map { Self.createEvent(from: $0) }
        let holidaysData: [DNSDataDictionary] = data[field(.holidays)] as? [DNSDataDictionary] ?? []
        self.holidays = holidaysData.map { Self.createHoliday(from: $0) }
        let mondayData: DNSDataDictionary = data[field(.monday)] as? DNSDataDictionary ?? [:]
        self.monday = DNSDayHours(from: mondayData)
        let tuesdayData: DNSDataDictionary = data[field(.tuesday)] as? DNSDataDictionary ?? [:]
        self.tuesday = DNSDayHours(from: tuesdayData)
        let wednesdayData: DNSDataDictionary = data[field(.wednesday)] as? DNSDataDictionary ?? [:]
        self.wednesday = DNSDayHours(from: wednesdayData)
        let thursdayData: DNSDataDictionary = data[field(.thursday)] as? DNSDataDictionary ?? [:]
        self.thursday = DNSDayHours(from: thursdayData)
        let fridayData: DNSDataDictionary = data[field(.friday)] as? DNSDataDictionary ?? [:]
        self.friday = DNSDayHours(from: fridayData)
        let saturdayData: DNSDataDictionary = data[field(.saturday)] as? DNSDataDictionary ?? [:]
        self.saturday = DNSDayHours(from: saturdayData)
        let sundayData: DNSDataDictionary = data[field(.sunday)] as? DNSDataDictionary ?? [:]
        self.sunday = DNSDayHours(from: sundayData)
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.events): self.events.map { $0.asDictionary },
            field(.holidays): self.holidays.map { $0.asDictionary },
            field(.monday): self.monday.asDictionary,
            field(.tuesday): self.tuesday.asDictionary,
            field(.wednesday): self.wednesday.asDictionary,
            field(.thursday): self.thursday.asDictionary,
            field(.friday): self.friday.asDictionary,
            field(.saturday): self.saturday.asDictionary,
            field(.sunday): self.sunday.asDictionary,
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
