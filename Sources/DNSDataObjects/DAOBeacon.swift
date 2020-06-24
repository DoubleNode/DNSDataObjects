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

    public override init() {
        self.code = ""
        
        super.init()
    }

    public init(from object: DAOBeacon) {
        self.code = object.code
        self.range = object.range
        self.accuracy = object.accuracy
        self.data = object.data
        self.rssi = object.rssi

        super.init(from: object)
    }
    
    public override init(from dictionary: Dictionary<String, Any?>) {
        self.code = ""

        super.init()

        _ = self.dao(from: dictionary)
    }

    open func update(from object: DAOBeacon) {
        self.code = object.code
        self.range = object.range
        self.accuracy = object.accuracy
        self.data = object.data
        self.rssi = object.rssi

        super.update(from: object)
    }

    open override func dao(from dictionary: Dictionary<String, Any?>) -> DAOBeacon {
        self.code = dictionary["code"] as? String ?? self.code
        self.range = dictionary["range"] as? String ?? self.range
        self.accuracy = dictionary["accuracy"] as? CLLocationAccuracy ?? self.accuracy
        self.rssi = dictionary["rssi"] as? Int ?? self.rssi

        _ = super.dao(from: dictionary)
        
        return self
    }
}
