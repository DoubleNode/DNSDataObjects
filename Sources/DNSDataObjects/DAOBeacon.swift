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

    private enum CodingKeys: String, CodingKey {
        case code, range, accuracy, rssi
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        range = try container.decode(String.self, forKey: .range)
        accuracy = try container.decode(CLLocationAccuracy.self, forKey: .accuracy)
        rssi = try container.decode(Int.self, forKey: .rssi)
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
    }

    override public init() {
        self.code = ""
        super.init()
    }
    override public init(id: String) {
        self.code = ""
        super.init(id: id)
    }
    override public init(from dictionary: Dictionary<String, Any?>) {
        self.code = ""
        super.init()
        _ = self.dao(from: dictionary)
    }
    
    public init(from object: DAOBeacon) {
        self.code = object.code
        self.range = object.range
        self.accuracy = object.accuracy
        self.data = object.data
        self.rssi = object.rssi
        super.init(from: object)
    }
    open func update(from object: DAOBeacon) {
        self.code = object.code
        self.range = object.range
        self.accuracy = object.accuracy
        self.data = object.data
        self.rssi = object.rssi
        super.update(from: object)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOBeacon {
        self.code = self.string(from: dictionary["code"] as Any?) ?? self.code
        self.range = self.string(from: dictionary["range"] as Any?) ?? self.range
        self.accuracy = self.double(from: dictionary["accuracy"] as Any?) ?? self.accuracy
        self.rssi = self.int(from: dictionary["rssi"] as Any?) ?? self.rssi
        _ = super.dao(from: dictionary)
        return self
    }
    override open func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "code": self.code,
            "range": self.range,
            "accuracy": self.accuracy,
            "rssi": self.rssi,
        ]) { (current, _) in current }
        return retval
    }
}
