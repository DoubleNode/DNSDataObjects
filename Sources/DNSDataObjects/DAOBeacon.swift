//
//  DAOBeacon.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import Foundation

open class DAOBeacon: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case code, range, accuracy, rssi, data
    }

    public var code: String = ""
    public var range: String?
    public var accuracy: CLLocationAccuracy = 0 {
        didSet {
            if accuracy < 0 {
                accuracy = 50
            }
        }
    }
    public var rssi: Int?
    public var data: CLBeacon?

    override public init() {
        super.init()
    }
    override public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOBeacon) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOBeacon) {
        self.code = object.code
        self.range = object.range
        self.accuracy = object.accuracy
        self.data = object.data
        self.rssi = object.rssi
        super.update(from: object)
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOBeacon {
        _ = super.dao(from: dictionary)
        self.code = self.string(from: dictionary["code"] as Any?) ?? self.code
        self.range = self.string(from: dictionary["range"] as Any?) ?? self.range
        self.accuracy = self.double(from: dictionary["accuracy"] as Any?) ?? self.accuracy
        self.rssi = self.int(from: dictionary["rssi"] as Any?) ?? self.rssi
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            "code": self.code,
            "range": self.range,
            "accuracy": self.accuracy,
            "rssi": self.rssi,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        range = try container.decode(String?.self, forKey: .range)
        accuracy = try container.decode(CLLocationAccuracy.self, forKey: .accuracy)
        rssi = try container.decode(Int?.self, forKey: .rssi)
        // FIXME: data = try container.decode(CLBeacon.self, forKey: .data)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(range, forKey: .range)
        try container.encode(accuracy, forKey: .accuracy)
        try container.encode(rssi, forKey: .rssi)
        // FIXME: if data != nil { try container.encode(data, forKey: .data) }
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOBeacon(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOBeacon else { return true }
        let lhs = self
        return lhs.code != rhs.code
            || lhs.range != rhs.range
            || lhs.accuracy != rhs.accuracy
            || lhs.rssi != rhs.rssi
            || lhs.data != rhs.data
    }
}
