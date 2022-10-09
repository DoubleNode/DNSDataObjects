//
//  DAOPlaceHours.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOPlaceHours: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var placeEventType: DAOPlaceEvent.Type { DAOPlaceEvent.self }
    open class var placeEventArrayType: [DAOPlaceEvent].Type { [DAOPlaceEvent].self }
    open class var placeHolidayType: DAOPlaceHoliday.Type { DAOPlaceHoliday.self }
    open class var placeHolidayArrayType: [DAOPlaceHoliday].Type { [DAOPlaceHoliday].self }

    open class func createPlaceEvent() -> DAOPlaceEvent { placeEventType.init() }
    open class func createPlaceEvent(from object: DAOPlaceEvent) -> DAOPlaceEvent { placeEventType.init(from: object) }
    open class func createPlaceEvent(from data: DNSDataDictionary) -> DAOPlaceEvent? { placeEventType.init(from: data) }

    open class func createPlaceHoliday() -> DAOPlaceHoliday { placeHolidayType.init() }
    open class func createPlaceHoliday(from object: DAOPlaceHoliday) -> DAOPlaceHoliday { placeHolidayType.init(from: object) }
    open class func createPlaceHoliday(from data: DNSDataDictionary) -> DAOPlaceHoliday? { placeHolidayType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case events, holidays
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    open var events: [DAOPlaceEvent] = []
    open var holidays: [DAOPlaceHoliday] = []

    open var monday = DNSDailyHours()
    open var tuesday = DNSDailyHours()
    open var wednesday = DNSDailyHours()
    open var thursday = DNSDailyHours()
    open var friday = DNSDailyHours()
    open var saturday = DNSDailyHours()
    open var sunday = DNSDailyHours()

    public var today: DNSDailyHours {
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
    required public init(from object: DAOPlaceHours) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPlaceHours) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.events = object.events.map { $0.copy() as! DAOPlaceEvent }
        self.holidays = object.holidays.map { $0.copy() as! DAOPlaceHoliday }
        self.monday = object.monday.copy() as! DNSDailyHours
        self.tuesday = object.tuesday.copy() as! DNSDailyHours
        self.wednesday = object.wednesday.copy() as! DNSDailyHours
        self.thursday = object.thursday.copy() as! DNSDailyHours
        self.friday = object.friday.copy() as! DNSDailyHours
        self.saturday = object.saturday.copy() as! DNSDailyHours
        self.sunday = object.sunday.copy() as! DNSDailyHours
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPlaceHours {
        _ = super.dao(from: data)
        let eventsData = self.dataarray(from: data[field(.events)] as Any?)
        self.events = eventsData.compactMap { Self.createPlaceEvent(from: $0) }
        let holidaysData = self.dataarray(from: data[field(.holidays)] as Any?)
        self.holidays = holidaysData.compactMap { Self.createPlaceHoliday(from: $0) }
        let mondayData = self.dictionary(from: data[field(.monday)] as Any?)
        self.monday = DNSDailyHours(from: mondayData)
        let tuesdayData = self.dictionary(from: data[field(.tuesday)] as Any?)
        self.tuesday = DNSDailyHours(from: tuesdayData)
        let wednesdayData = self.dictionary(from: data[field(.wednesday)] as Any?)
        self.wednesday = DNSDailyHours(from: wednesdayData)
        let thursdayData = self.dictionary(from: data[field(.thursday)] as Any?)
        self.thursday = DNSDailyHours(from: thursdayData)
        let fridayData = self.dictionary(from: data[field(.friday)] as Any?)
        self.friday = DNSDailyHours(from: fridayData)
        let saturdayData = self.dictionary(from: data[field(.saturday)] as Any?)
        self.saturday = DNSDailyHours(from: saturdayData)
        let sundayData = self.dictionary(from: data[field(.sunday)] as Any?)
        self.sunday = DNSDailyHours(from: sundayData)
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
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        events = self.daoPlaceEventArray(of: Self.placeEventArrayType, from: container, forKey: .events)
        holidays = self.daoPlaceHolidayArray(of: Self.placeHolidayArrayType, from: container, forKey: .holidays)
        monday = try container.decodeIfPresent(Swift.type(of: monday), forKey: .monday) ?? monday
        tuesday = try container.decodeIfPresent(Swift.type(of: tuesday), forKey: .tuesday) ?? tuesday
        wednesday = try container.decodeIfPresent(Swift.type(of: wednesday), forKey: .wednesday) ?? wednesday
        thursday = try container.decodeIfPresent(Swift.type(of: thursday), forKey: .thursday) ?? thursday
        friday = try container.decodeIfPresent(Swift.type(of: friday), forKey: .friday) ?? friday
        saturday = try container.decodeIfPresent(Swift.type(of: saturday), forKey: .saturday) ?? saturday
        sunday = try container.decodeIfPresent(Swift.type(of: sunday), forKey: .sunday) ?? sunday
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
        let copy = DAOPlaceHours(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPlaceHours else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.events != rhs.events ||
            lhs.holidays != rhs.holidays ||
            lhs.monday != rhs.monday ||
            lhs.tuesday != rhs.tuesday ||
            lhs.wednesday != rhs.wednesday ||
            lhs.thursday != rhs.thursday ||
            lhs.friday != rhs.friday ||
            lhs.saturday != rhs.saturday ||
            lhs.sunday != rhs.sunday
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPlaceHours, rhs: DAOPlaceHours) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPlaceHours, rhs: DAOPlaceHours) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
