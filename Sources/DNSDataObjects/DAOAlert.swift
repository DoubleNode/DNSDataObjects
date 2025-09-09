//
//  DAOAlert.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

public protocol PTCLCFGDAOAlert: PTCLCFGBaseObject {
    var alertType: DAOAlert.Type { get }
    func alert<K>(from container: KeyedDecodingContainer<K>,
                  forKey key: KeyedDecodingContainer<K>.Key) -> DAOAlert? where K: CodingKey
    func alertArray<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAlert] where K: CodingKey
}

public protocol PTCLCFGAlertObject: PTCLCFGDAOAlert {
}
public class CFGAlertObject: PTCLCFGAlertObject {
    public var alertType: DAOAlert.Type = DAOAlert.self
    open func alert<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOAlert? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAlert.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func alertArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAlert] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAlert].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOAlert: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAlertObject
    public static var config: Config = CFGAlertObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    public enum C {
        public static let defaultEndTime = Date(timeIntervalSinceReferenceDate: Date.Seconds.deltaOneYear * 30.0)
        public static let defaultStartTime = Date(timeIntervalSinceReferenceDate: 0.0)
    }

    // MARK: - Class Factory methods -
    open class func createAlert() -> DAOAlert { config.alertType.init() }
    open class func createAlert(from object: DAOAlert) -> DAOAlert { config.alertType.init(from: object) }
    open class func createAlert(from data: DNSDataDictionary) -> DAOAlert? { config.alertType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endTime, imageUrl, name, priority, scope
        case startTime, status, tagLine, title
    }

    open var endTime = C.defaultEndTime
    open var imageUrl = DNSURL()
    open var name = ""
    open var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }
    open var scope: DNSScope = .all
    open var startTime = C.defaultStartTime
    open var status: DNSStatus = .tempClosed
    open var tagLine = DNSString()
    open var title = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(status: DNSStatus,
                title: DNSString,
                tagLine: DNSString,
                startTime: Date = C.defaultStartTime,
                endTime: Date = C.defaultEndTime) {
        self.status = status
        self.title = title
        self.tagLine = tagLine
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAlert) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAlert) {
        super.update(from: object)
        self.endTime = object.endTime
        self.name = object.name
        self.priority = object.priority
        self.scope = object.scope
        self.startTime = object.startTime
        self.status = object.status
        // swiftlint:disable force_cast
        self.imageUrl = object.imageUrl.copy() as! DNSURL
        self.tagLine = object.tagLine.copy() as! DNSString
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAlert {
        _ = super.dao(from: data)
        self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.endTime
        self.imageUrl = self.dnsurl(from: data[field(.imageUrl)] as Any?) ?? self.imageUrl
        self.name = self.string(from: data[field(.name)] as Any?) ?? self.name
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        let scopeData = self.int(from: data[field(.scope)] as Any?) ?? self.scope.rawValue
        self.scope = DNSScope(rawValue: scopeData) ?? .all
        self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
        let statusData = self.string(from: data[field(.status)] as Any?) ?? self.status.rawValue
        self.status = DNSStatus(rawValue: statusData) ?? .open
        self.tagLine = self.dnsstring(from: data[field(.tagLine)] as Any?) ?? self.tagLine
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.endTime): self.endTime,
            field(.imageUrl): self.imageUrl.asDictionary,
            field(.name): self.name,
            field(.priority): self.priority,
            field(.scope): self.scope.rawValue,
            field(.startTime): self.startTime,
            field(.status): self.status.rawValue,
            field(.tagLine): self.tagLine.asDictionary,
            field(.title): self.title.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        try commonInit(from: decoder, configuration: Self.config)
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endTime = self.date(from: container, forKey: .endTime) ?? endTime
        imageUrl = self.dnsurl(from: container, forKey: .imageUrl) ?? imageUrl
        name = self.string(from: container, forKey: .name) ?? name
        priority = self.int(from: container, forKey: .priority) ?? priority
        startTime = self.date(from: container, forKey: .startTime) ?? startTime
        tagLine = self.dnsstring(from: container, forKey: .tagLine) ?? tagLine
        title = self.dnsstring(from: container, forKey: .title) ?? title

        scope = try container.decodeIfPresent(Swift.type(of: scope), forKey: .scope) ?? scope
        status = try container.decodeIfPresent(Swift.type(of: status), forKey: .status) ?? status
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(name, forKey: .name)
        try container.encode(priority, forKey: .priority)
        try container.encode(scope, forKey: .scope)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(tagLine, forKey: .tagLine)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAlert(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAlert else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.endTime != rhs.endTime ||
            lhs.imageUrl != rhs.imageUrl ||
            lhs.name != rhs.name ||
            lhs.priority != rhs.priority ||
            lhs.scope != rhs.scope ||
            lhs.startTime != rhs.startTime ||
            lhs.status != rhs.status ||
            lhs.tagLine != rhs.tagLine ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAlert, rhs: DAOAlert) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAlert, rhs: DAOAlert) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
