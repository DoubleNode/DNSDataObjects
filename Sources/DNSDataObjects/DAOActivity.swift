//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.

//

import Foundation

open class DAOActivity: DAOBaseObject {
    public var code: String
    public var name: String
    open var beacons: [DAOBeacon]
    
    public override init() {
        self.code = ""
        self.name = ""
        self.beacons = []

        super.init()
    }

    public init(code: String, name: String) {
        self.code = code
        self.name = name
        self.beacons = []

        super.init(id: code)
    }
    
    public init(from object: DAOActivity) {
        self.code = object.code
        self.name = object.name
        self.beacons = object.beacons

        super.init(from: object)
    }

    public override init(from dictionary: Dictionary<String, Any?>) {
        self.code = ""
        self.name = ""
        self.beacons = []
        
        super.init()

        _ = self.dao(from: dictionary)
    }

    open func update(from object: DAOActivity) {
        self.code = object.code
        self.name = object.name

        self.beacons = object.beacons

        super.update(from: object)
    }

    open override func dao(from dictionary: Dictionary<String, Any?>) -> DAOActivity {
        self.code = dictionary["code"] as? String ?? self.code
        self.name = dictionary["name"] as? String ?? self.name

        var beacons: Array<DAOBeacon> = []
        let beaconsData: Array<Dictionary<String, Any?>> = (dictionary["beacons"] as? Array<Dictionary<String, Any?>>) ?? []
        beaconsData.forEach { (beaconData) in
            beacons.append(DAOBeacon(from: beaconData))
        }
        self.beacons = beacons

        _ = super.dao(from: dictionary)
        
        return self
    }
}
