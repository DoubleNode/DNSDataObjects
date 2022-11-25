//
//  DAOAnnouncement.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOAnnouncement: PTCLCFGBaseObject {
    var announcementType: DAOAnnouncement.Type { get }
    func announcement<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAnnouncement? where K: CodingKey
    func announcementArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAnnouncement] where K: CodingKey
}

public protocol PTCLCFGAnnouncementObject: PTCLCFGBaseObject {
}
public class CFGAnnouncementObject: PTCLCFGAnnouncementObject {
}
open class DAOAnnouncement: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAnnouncementObject
    public static var config: Config = CFGAnnouncementObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case body, distribution, endTime, startTime, title
    }

    open var body = DNSString()
    open var distribution = DNSVisibility.everyone
    open var endTime = Date().nextMonth
    open var startTime = Date()
    open var title = DNSString()
    
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOAnnouncement) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAnnouncement) {
        super.update(from: object)
        self.distribution = object.distribution
        self.endTime = object.endTime
        self.startTime = object.startTime
        // swiftlint:disable force_cast
        self.body = object.body.copy() as! DNSString
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAnnouncement {
        _ = super.dao(from: data)
        self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
        let distributionData = self.string(from: data[field(.distribution)] as Any?) ?? self.distribution.rawValue
        self.distribution = DNSVisibility(rawValue: distributionData) ?? .everyone
        self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.startTime.nextMonth
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.body): self.body.asDictionary,
            field(.distribution): self.distribution.rawValue,
            field(.endTime): self.endTime,
            field(.startTime): self.startTime,
            field(.title): self.title.asDictionary,
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
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = self.dnsstring(from: container, forKey: .body) ?? body
        startTime = self.time(from: container, forKey: .startTime) ?? startTime
        title = self.dnsstring(from: container, forKey: .title) ?? title
        endTime = self.time(from: container, forKey: .endTime) ?? startTime.nextMonth

        distribution = try container.decodeIfPresent(Swift.type(of: distribution), forKey: .distribution) ?? distribution
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(distribution, forKey: .distribution)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAnnouncement(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAnnouncement else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.body != rhs.body ||
            lhs.distribution != rhs.distribution ||
            lhs.endTime != rhs.endTime ||
            lhs.startTime != rhs.startTime ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAnnouncement, rhs: DAOAnnouncement) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAnnouncement, rhs: DAOAnnouncement) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
