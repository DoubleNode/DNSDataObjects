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

public protocol PTCLCFGDAOPlace: PTCLCFGBaseObject {
    var placeType: DAOPlace.Type { get }
    func placeArray<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey
}

public protocol PTCLCFGPlaceObject: PTCLCFGDAOActivity, PTCLCFGDAOAlert, PTCLCFGDAOPlaceHours,
                                    PTCLCFGDAOPlaceStatus, PTCLCFGDAOSection {
}
public class CFGPlaceObject: PTCLCFGPlaceObject {
    public var activityType: DAOActivity.Type = DAOActivity.self
    public var alertType: DAOAlert.Type = DAOAlert.self
    public var placeHoursType: DAOPlaceHours.Type = DAOPlaceHours.self
    public var placeStatusType: DAOPlaceStatus.Type = DAOPlaceStatus.self
    public var sectionType: DAOSection.Type = DAOSection.self

    open func activityArray<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivity] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOActivity].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
    open func alertArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAlert] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAlert].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
    open func placeHoursArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceHours] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlaceHours].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
    open func placeStatusArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceStatus] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlaceStatus].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
    open func sectionArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOSection].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOPlace: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPlaceObject
    public static var config: Config = CFGPlaceObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createActivity() -> DAOActivity { config.activityType.init() }
    open class func createActivity(from object: DAOActivity) -> DAOActivity { config.activityType.init(from: object) }
    open class func createActivity(from data: DNSDataDictionary) -> DAOActivity? { config.activityType.init(from: data) }

    open class func createAlert() -> DAOAlert { config.alertType.init() }
    open class func createAlert(from object: DAOAlert) -> DAOAlert { config.alertType.init(from: object) }
    open class func createAlert(from data: DNSDataDictionary) -> DAOAlert? { config.alertType.init(from: data) }

    open class func createPlaceHours() -> DAOPlaceHours { config.placeHoursType.init() }
    open class func createPlaceHours(from object: DAOPlaceHours) -> DAOPlaceHours { config.placeHoursType.init(from: object) }
    open class func createPlaceHours(from data: DNSDataDictionary) -> DAOPlaceHours? { config.placeHoursType.init(from: data) }

    open class func createPlaceStatus() -> DAOPlaceStatus { config.placeStatusType.init() }
    open class func createPlaceStatus(from object: DAOPlaceStatus) -> DAOPlaceStatus { config.placeStatusType.init(from: object) }
    open class func createPlaceStatus(from data: DNSDataDictionary) -> DAOPlaceStatus? { config.placeStatusType.init(from: data) }

    open class func createSection() -> DAOSection { config.sectionType.init() }
    open class func createSection(from object: DAOSection) -> DAOSection { config.sectionType.init(from: object) }
    open class func createSection(from data: DNSDataDictionary) -> DAOSection? { config.sectionType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case activities, address, alerts, code, geohashes, geopoint
        case hours, name, phone, section, statuses, timeZone
    }

    open var address = ""
    open var code = ""
    open var geohashes: [String] = []
    open var geopoint: CLLocation?
    open var name = DNSString()
    open var phone = ""
    @CodableConfiguration(from: DAOPlace.self) open var activities: [DAOActivity] = []
    @CodableConfiguration(from: DAOPlace.self) open var alerts: [DAOAlert] = []
    @CodableConfiguration(from: DAOPlace.self) open var hours: DAOPlaceHours = DAOPlaceHours()
    @CodableConfiguration(from: DAOPlace.self) open var section: DAOSection? = nil
    @CodableConfiguration(from: DAOPlace.self) open var statuses: [DAOPlaceStatus] = [] {
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
        fatalError("init(from:) has not been implemented")
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder)
    }
    private func commonInit(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        activities = self.daoActivityArray(with: Self.config, from: container, forKey: .activities)
        address = self.string(from: container, forKey: .address) ?? address
        alerts = self.daoAlertArray(with: Self.config, from: container, forKey: .alerts)
        code = self.string(from: container, forKey: .code) ?? code
        hours = self.daoPlaceHours(with: Self.config, from: container, forKey: .hours) ?? hours
        name = self.dnsstring(from: container, forKey: .name) ?? name
        phone = self.string(from: container, forKey: .phone) ?? phone
        section = self.daoSection(with: Self.config, from: container, forKey: .section) ?? section
        statuses = self.daoPlaceStatusArray(with: Self.config, from: container, forKey: .statuses)
        timeZone = self.timeZone(from: container, forKey: .timeZone) ?? timeZone

        geohashes = try container.decodeIfPresent(Swift.type(of: geohashes), forKey: .geohashes) ?? geohashes
        let geopointData = try container.decodeIfPresent([String: Double].self, forKey: .geopoint) ?? [:]
        geopoint = CLLocation(from: geopointData)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activities, forKey: .activities, configuration: configuration)
        try container.encode(address, forKey: .address)
        try container.encode(alerts, forKey: .alerts, configuration: configuration)
        try container.encode(code, forKey: .code)
        try container.encode(geohashes, forKey: .geohashes)
        try container.encode(geopoint?.asDictionary as? [String: Double], forKey: .geopoint)
        try container.encode(hours, forKey: .hours, configuration: configuration)
        try container.encode(name, forKey: .name)
        try container.encode(phone, forKey: .phone)
        try container.encode(section, forKey: .section, configuration: configuration)
        try container.encode(statuses, forKey: .statuses, configuration: configuration)
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
