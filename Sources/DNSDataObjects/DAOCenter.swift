//
//  DAOCenter.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import Foundation

open class DAOCenter: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var activityType: DAOActivity.Type { return DAOActivity.self }
    open class var alertType: DAOAlert.Type { return DAOAlert.self }
    open class var districtType: DAODistrict.Type { return DAODistrict.self }
    open class var hoursType: DAOCenterHours.Type { return DAOCenterHours.self }
    open class var statusType: DAOCenterStatus.Type { return DAOCenterStatus.self }

    open class func createActivity() -> DAOActivity { activityType.init() }
    open class func createActivity(from object: DAOActivity) -> DAOActivity { activityType.init(from: object) }
    open class func createActivity(from data: DNSDataDictionary) -> DAOActivity { activityType.init(from: data) }

    open class func createAlert() -> DAOAlert { alertType.init() }
    open class func createAlert(from object: DAOAlert) -> DAOAlert { alertType.init(from: object) }
    open class func createAlert(from data: DNSDataDictionary) -> DAOAlert { alertType.init(from: data) }

    open class func createDistrict() -> DAODistrict { districtType.init() }
    open class func createDistrict(from object: DAODistrict) -> DAODistrict { districtType.init(from: object) }
    open class func createDistrict(from data: DNSDataDictionary) -> DAODistrict { districtType.init(from: data) }

    open class func createHours() -> DAOCenterHours { hoursType.init() }
    open class func createHours(from object: DAOCenterHours) -> DAOCenterHours { hoursType.init(from: object) }
    open class func createHours(from data: DNSDataDictionary) -> DAOCenterHours { hoursType.init(from: data) }

    open class func createStatus() -> DAOCenterStatus { statusType.init() }
    open class func createStatus(from object: DAOCenterStatus) -> DAOCenterStatus { statusType.init(from: object) }
    open class func createStatus(from data: DNSDataDictionary) -> DAOCenterStatus { statusType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case activities, address, alerts, code, district
        case geohash, geopoint, hours, name, phone, statuses, timeZone
    }

    open var activities: [DAOActivity] = []
    public var address = ""
    public var alerts: [DAOAlert] = []
    public var code = ""
    public var district = DAOCenter.createDistrict()
    public var geohash = ""
    public var geopoint: CLLocation?
    public var hours = DAOCenter.createHours()
    public var name = DNSString()
    public var phone = ""
    public var statuses: [DAOCenterStatus] = [] {
        didSet {
            self.statuses.filter { $0.id.isEmpty }
                .forEach {
                    $0.id = "\(code):\($0.status.rawValue):\(Int($0.startTime.timeIntervalSince1970))"
                }
        }
    }
    public var timeZone: TimeZone = TimeZone.current

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(code: String, name: DNSString) {
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
        self.address = object.address
        self.alerts = object.alerts
        self.code = object.code
        self.district = object.district
        self.geohash = object.geohash
        self.geopoint = object.geopoint
        self.hours = object.hours
        self.name = object.name
        self.phone = object.phone
        self.statuses = object.statuses
        self.timeZone = object.timeZone
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
        self.address = self.string(from: data[field(.address)] as Any?) ?? self.address
        var alerts: [DAOAlert] = []
        let alertsData: [DNSDataDictionary] = (data[field(.alerts)] as? [DNSDataDictionary]) ?? []
        alertsData.forEach { (alertData) in
            alerts.append(Self.createAlert(from: alertData))
        }
        self.alerts = alerts
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        let districtData = data[field(.district)] as? DNSDataDictionary ?? [:]
        self.district = Self.createDistrict(from: districtData)
        self.geohash = self.string(from: data[field(.geohash)] as Any?) ?? self.geohash
        self.geopoint = self.location(from: data[field(.geopoint)] as Any?) ?? self.geopoint
        let hoursData = data[field(.hours)] as? DNSDataDictionary ?? [:]
        self.hours = Self.createHours(from: hoursData)
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        self.phone = self.string(from: data[field(.phone)] as Any?) ?? self.phone
        var statuses: [DAOCenterStatus] = []
        let statusesData: [DNSDataDictionary] = (data[field(.statuses)] as? [DNSDataDictionary]) ?? []
        statusesData.forEach { (statusData) in
            statuses.append(Self.createStatus(from: statusData))
        }
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
            field(.district): self.district.asDictionary,
            field(.geohash): self.geohash,
            field(.geopoint): self.geopoint?.asDictionary,
            field(.hours): self.hours.asDictionary,
            field(.name): self.name,
            field(.phone): self.phone,
            field(.statuses): self.statuses.map { $0.asDictionary },
            field(.timeZone): self.timeZone.identifier,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activities = try container.decode([DAOActivity].self, forKey: .activities)
        address = try container.decode(String.self, forKey: .address)
        alerts = try container.decode([DAOAlert].self, forKey: .alerts)
        code = try container.decode(String.self, forKey: .code)
        district = try container.decode(DAODistrict.self, forKey: .district)
        geohash = try container.decode(String.self, forKey: .geohash)
        let geopointData = try container.decode([String: Double].self, forKey: .geopoint)
        geopoint = CLLocation(from: geopointData)
        hours = try container.decode(DAOCenterHours.self, forKey: .hours)
        name = try container.decode(DNSString.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        statuses = try container.decode([DAOCenterStatus].self, forKey: .statuses)
        timeZone = try container.decode(TimeZone.self, forKey: .timeZone)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activities, forKey: .activities)
        try container.encode(address, forKey: .address)
        try container.encode(alerts, forKey: .alerts)
        try container.encode(code, forKey: .code)
        try container.encode(district, forKey: .district)
        try container.encode(geohash, forKey: .geohash)
        try container.encode(geopoint?.asDictionary as? [String: Double], forKey: .geopoint)
        try container.encode(hours, forKey: .hours)
        try container.encode(name, forKey: .name)
        try container.encode(phone, forKey: .phone)
        try container.encode(statuses, forKey: .statuses)
        try container.encode(timeZone, forKey: .timeZone)
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
            || lhs.address != rhs.address
            || lhs.alerts != rhs.alerts
            || lhs.code != rhs.code
            || lhs.district != rhs.district
            || lhs.geohash != rhs.geohash
            || lhs.geopoint != rhs.geopoint
            || lhs.hours != rhs.hours
            || lhs.name != rhs.name
            || lhs.phone != rhs.phone
            || lhs.statuses != rhs.statuses
            || lhs.timeZone != rhs.timeZone
    }
}

extension DAOCenter {
    public var status: DNSStatus {
        return self.statusNow().status
    }
    public var statusMessage: DNSString {
        return self.statusNow().message
    }

    public func isStatusOpen(for date: Date = Date()) -> Bool {
        guard !self.statuses.isEmpty else { return true }
        return status(for: date)?.isOpen ?? true
    }
    public func statusMessage(for date: Date = Date()) -> DNSString {
        return self.status(for: date)?.message ?? DNSString(with: "")
    }
    public func status(for date: Date = Date()) -> DAOCenterStatus? {
        let status = self.statuses
            .filter { date.isSameDate(as: $0.startTime) ||
                date.isSameDate(as: $0.endTime) ||
                ($0.startTime < date && $0.endTime > date)
            }
            .sorted { $0.startTime >= $1.startTime }
            .sorted { $0.scope.rawValue < $1.scope.rawValue }
            .first
        return status
    }

    public func isStatusOpenNow() -> Bool {
        return statusNow().isOpen
    }
    public func statusNow() -> DAOCenterStatus {
        let date = Date()
        let status = statuses
            .filter { ($0.startTime < date && $0.endTime > date) }
            .sorted { $0.startTime >= $1.startTime }
            .sorted { $0.scope.rawValue < $1.scope.rawValue }
            .first
        guard let status else {
            return DAOCenterStatus(status: DNSStatus.open)
        }
        return status
    }
}
