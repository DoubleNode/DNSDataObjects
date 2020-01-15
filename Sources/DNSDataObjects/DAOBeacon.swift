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

    required public init() {
    }
}
