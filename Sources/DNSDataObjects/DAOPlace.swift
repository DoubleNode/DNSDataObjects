//
//  DAOPlace.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import Foundation

open class DAOPlace: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var activityType: DAOActivity.Type { DAOActivity.self }
    open class var activityArrayType: [DAOActivity].Type { [DAOActivity].self }
    open class var alertType: DAOAlert.Type { DAOAlert.self }
    open class var alertArrayType: [DAOAlert].Type { [DAOAlert].self }
    open class var placeHoursType: DAOPlaceHours.Type { DAOPlaceHours.self }
    open class var placeStatusType: DAOPlaceStatus.Type { DAOPlaceStatus.self }
    open class var placeStatusArrayType: [DAOPlaceStatus].Type { [DAOPlaceStatus].self }
    open class var sectionType: DAOSection.Type { DAOSection.self }

    open class func createActivity() -> DAOActivity { activityType.init() }
    open class func createActivity(from object: DAOActivity) -> DAOActivity { activityType.init(from: object) }
    open class func createActivity(from data: DNSDataDictionary) -> DAOActivity? { activityType.init(from: data) }

    open class func createAlert() -> DAOAlert { alertType.init() }
    open class func createAlert(from object: DAOAlert) -> DAOAlert { alertType.init(from: object) }
    open class func createAlert(from data: DNSDataDictionary) -> DAOAlert? { alertType.init(from: data) }

    open class func createPlaceHours() -> DAOPlaceHours { placeHoursType.init() }
    open class func createPlaceHours(from object: DAOPlaceHours) -> DAOPlaceHours { placeHoursType.init(from: object) }
    open class func createPlaceHours(from data: DNSDataDictionary) -> DAOPlaceHours? { placeHoursType.init(from: data) }

    open class func createPlaceStatus() -> DAOPlaceStatus { placeStatusType.init() }
    open class func createPlaceStatus(from object: DAOPlaceStatus) -> DAOPlaceStatus { placeStatusType.init(from: object) }
    open class func createPlaceStatus(from data: DNSDataDictionary) -> DAOPlaceStatus? { placeStatusType.init(from: data) }

    open class func createSection() -> DAOSection { sectionType.init() }
    open class func createSection(from object: DAOSection) -> DAOSection { sectionType.init(from: object) }
    open class func createSection(from data: DNSDataDictionary) -> DAOSection? { sectionType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case activities, address, alerts, code, geohashes, geopoint
        case hours, name, phone, section, statuses, timeZone
    }

    open var activities: [DAOActivity] = []
    open var address = ""
    open var alerts: [DAOAlert] = []
    open var code = ""
    open var geohashes: [String] = []
    open var geopoint: CLLocation?
    open var hours: DAOPlaceHours
    open var name = DNSString()
    open var phone = ""
    open var section: DAOSection?
    open var statuses: [DAOPlaceStatus] = [] {
        didSet {
            self.statuses.filter { $0.id.isEmpty }
                .forEach {
                    $0.id = "\(code):\($0.status.rawValue):\(Int($0.startTime.timeIntervalSince1970))"
                }
        }
    }
    open var timeZone: TimeZone = TimeZone.current
    // MARK: - Initializers -
    required public init() {
        hours = Self.createPlaceHours()
        super.init()
    }
    required public init(id: String) {
        hours = Self.createPlaceHours()
        super.init(id: id)
    }
    public init(code: String, name: DNSString) {
        hours = Self.createPlaceHours()
        self.code = code
        self.name = name
        super.init(id: code)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOPlace) {
        hours = Self.createPlaceHours()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPlace) {
        super.update(from: object)
        self.address = object.address
        self.code = object.code
        self.geohashes = object.geohashes
        self.geopoint = object.geopoint
        self.name = object.name
        self.phone = object.phone
        self.section = object.section?.copy() as? DAOSection
        self.timeZone = object.timeZone
        // swiftlint:disable force_cast
        self.activities = object.activities.map { $0.copy() as! DAOActivity }
        self.alerts = object.alerts.map { $0.copy() as! DAOAlert }
        self.statuses = object.statuses.map { $0.copy() as! DAOPlaceStatus }
        self.hours = object.hours.copy() as! DAOPlaceHours
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        hours = Self.createPlaceHours()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPlace {
        _ = super.dao(from: data)
        let activitiesData = self.dataarray(from: data[field(.activities)] as Any?)
        self.activities = activitiesData.compactMap { Self.createActivity(from: $0) }
        self.address = self.string(from: data[field(.address)] as Any?) ?? self.address
        let alertsData = self.dataarray(from: data[field(.alerts)] as Any?)
        self.alerts = alertsData.compactMap { Self.createAlert(from: $0) }
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        let geohashesData = self.array(from: data[field(.geohashes)] as Any?)
        self.geohashes = geohashesData.compactMap { self.string(from: $0 as Any?) }
        let hoursData = self.dictionary(from: data[field(.hours)] as Any?)
        self.hours = Self.createPlaceHours(from: hoursData) ?? self.hours
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        self.phone = self.string(from: data[field(.phone)] as Any?) ?? self.phone
        let sectionData = self.dictionary(from: data[field(.section)] as Any?)
        self.section = Self.createSection(from: sectionData) ?? self.section
        let statusesData = self.dataarray(from: data[field(.statuses)] as Any?)
        self.statuses = statusesData.compactMap { Self.createPlaceStatus(from: $0) }
        self.timeZone = self.timeZone(from: data[field(.timeZone)] as Any?) ?? self.timeZone
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.activities): self.activities.map { $0.asDictionary },
            field(.address): self.address,
            field(.alerts): self.alerts.map { $0.asDictionary },
            field(.code): self.code,
            field(.geohashes): self.geohashes.map { $0 },
            field(.geopoint): self.geopoint?.asDictionary,
            field(.hours): self.hours.asDictionary,
            field(.name): self.name,
            field(.phone): self.phone,
            field(.section): self.section?.asDictionary ?? .empty,
            field(.statuses): self.statuses.map { $0.asDictionary },
            field(.timeZone): self.timeZone.identifier,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        hours = Self.createPlaceHours()
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activities = self.daoActivityArray(of: Self.activityArrayType, from: container, forKey: .activities)
        address = self.string(from: container, forKey: .address) ?? address
        alerts = self.daoAlertArray(of: Self.alertArrayType, from: container, forKey: .alerts)
        code = self.string(from: container, forKey: .code) ?? code
        hours = self.daoPlaceHours(of: Self.placeHoursType, from: container, forKey: .hours) ?? hours
        name = self.dnsstring(from: container, forKey: .name) ?? name
        phone = self.string(from: container, forKey: .phone) ?? phone
        section = self.daoSection(of: Self.sectionType, from: container, forKey: .section) ?? section
        statuses = self.daoPlaceStatusArray(of: Self.placeStatusArrayType, from: container, forKey: .statuses)
        timeZone = self.timeZone(from: container, forKey: .timeZone) ?? timeZone

        geohashes = try container.decodeIfPresent(Swift.type(of: geohashes), forKey: .geohashes) ?? geohashes
        let geopointData = try container.decodeIfPresent([String: Double].self, forKey: .geopoint) ?? [:]
        geopoint = CLLocation(from: geopointData)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activities, forKey: .activities)
        try container.encode(address, forKey: .address)
        try container.encode(alerts, forKey: .alerts)
        try container.encode(code, forKey: .code)
        try container.encode(geohashes, forKey: .geohashes)
        try container.encode(geopoint?.asDictionary as? [String: Double], forKey: .geopoint)
        try container.encode(hours, forKey: .hours)
        try container.encode(name, forKey: .name)
        try container.encode(phone, forKey: .phone)
        try container.encode(section, forKey: .section)
        try container.encode(statuses, forKey: .statuses)
        try container.encode(timeZone, forKey: .timeZone)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPlace(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPlace else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.activities != rhs.activities ||
            lhs.address != rhs.address ||
            lhs.alerts != rhs.alerts ||
            lhs.code != rhs.code ||
            lhs.geohashes != rhs.geohashes ||
            lhs.geopoint != rhs.geopoint ||
            lhs.hours != rhs.hours ||
            lhs.name != rhs.name ||
            lhs.phone != rhs.phone ||
            lhs.section != rhs.section ||
            lhs.statuses != rhs.statuses ||
            lhs.timeZone != rhs.timeZone
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPlace, rhs: DAOPlace) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPlace, rhs: DAOPlace) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
