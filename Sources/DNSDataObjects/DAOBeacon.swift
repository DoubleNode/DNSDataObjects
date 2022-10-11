//
//  DAOBeacon.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import Foundation

public protocol PTCLCFGDAOBeacon: PTCLCFGBaseObject {
    var beaconType: DAOBeacon.Type { get }
    func beaconArray<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> [DAOBeacon] where K: CodingKey
}

public protocol PTCLCFGBeaconObject: PTCLCFGBaseObject {
}
public class CFGBeaconObject: PTCLCFGBeaconObject {
}
open class DAOBeacon: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGBeaconObject
    public static var config: Config = CFGBeaconObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case accuracy, code, data, distance, major, minor, name, range, rssi
    }

    open var accuracy: CLLocationAccuracy = 0 {
        didSet {
            if accuracy < 0 {
                accuracy = 50
            }
        }
    }
    open var code = ""
    open var data: CLBeacon?
    open var distance = DNSBeaconDistance.unknown
    open var major: Int = 0
    open var minor: Int = 0
    open var name = DNSString()
    open var range: String?
    open var rssi: Int?

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOBeacon) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOBeacon) {
        super.update(from: object)
        self.accuracy = object.accuracy
        self.code = object.code
        self.data = object.data
        self.distance = object.distance
        self.major = object.major
        self.minor = object.minor
        self.name = object.name
        self.range = object.range
        self.rssi = object.rssi
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOBeacon {
        _ = super.dao(from: data)
        self.accuracy = self.double(from: data[field(.accuracy)] as Any?) ?? self.accuracy
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
//        self.data = self.string(from: data[field(.data)] as Any?) ?? self.data
        let distanceData = self.string(from: data[field(.distance)] as Any?) ?? ""
        self.distance = DNSBeaconDistance(rawValue: distanceData) ?? self.distance
        self.major = self.int(from: data[field(.major)] as Any?) ?? self.major
        self.minor = self.int(from: data[field(.minor)] as Any?) ?? self.minor
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        self.range = self.string(from: data[field(.range)] as Any?) ?? self.range
        self.rssi = self.int(from: data[field(.rssi)] as Any?) ?? self.rssi
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.accuracy): self.accuracy,
            field(.code): self.code,
//            field(.data): self.data,
            field(.distance): self.distance.rawValue,
            field(.major): self.major,
            field(.minor): self.minor,
            field(.name): self.name.asDictionary,
            field(.range): self.range,
            field(.rssi): self.rssi,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder, configuration: PTCLCFGBaseObject) throws {
        fatalError("init(from:configuration:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = self.string(from: container, forKey: .code) ?? code
        major = self.int(from: container, forKey: .major) ?? major
        minor = self.int(from: container, forKey: .minor) ?? minor
        name = self.dnsstring(from: container, forKey: .name) ?? name
        range = self.string(from: container, forKey: .range) ?? range
        rssi = self.int(from: container, forKey: .rssi) ?? rssi

        accuracy = try container.decodeIfPresent(Swift.type(of: accuracy), forKey: .accuracy) ?? accuracy
//        data = try container.decodeIfPresent(CLBeacon.self, forKey: .data)
        distance = try container.decodeIfPresent(Swift.type(of: distance), forKey: .distance) ?? distance
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accuracy, forKey: .accuracy)
        try container.encode(code, forKey: .code)
//        try container.encode(data, forKey: .data)
        try container.encode(distance, forKey: .distance)
        try container.encode(major, forKey: .major)
        try container.encode(minor, forKey: .minor)
        try container.encode(name, forKey: .name)
        try container.encode(range, forKey: .range)
        try container.encode(rssi, forKey: .rssi)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOBeacon(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOBeacon else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.accuracy != rhs.accuracy ||
            lhs.code != rhs.code ||
            lhs.data != rhs.data ||
            lhs.distance != rhs.distance ||
            lhs.major != rhs.major ||
            lhs.minor != rhs.minor ||
            lhs.name != rhs.name ||
            lhs.range != rhs.range ||
            lhs.rssi != rhs.rssi
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOBeacon, rhs: DAOBeacon) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOBeacon, rhs: DAOBeacon) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
