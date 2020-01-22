//
//  DAOBeacon.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
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

        super.init(from: object)
    }
    
    public override init(from dictionary: Dictionary<String, Any?>) {
        self.code = ""

        super.init()

        _ = self.dao(from: dictionary)
    }

    public func update(from object: DAOBeacon) {
        self.code = object.code
        self.range = object.range
        self.accuracy = object.accuracy
        self.data = object.data

        super.update(from: object)
    }

    public override func dao(from dictionary: Dictionary<String, Any?>) -> DAOBeacon {
        self.code = dictionary["code"] as? String ?? self.code
        self.range = dictionary["range"] as? String ?? self.range
        self.accuracy = dictionary["accuracy"] as? CLLocationAccuracy ?? self.accuracy

        _ = super.dao(from: dictionary)
        
        return self
    }
}
