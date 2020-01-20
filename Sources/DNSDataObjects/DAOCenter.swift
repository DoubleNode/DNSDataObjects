//
//  DAOCenter.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

open class DAOCenter: DAOBaseObject {
    public var centerNum: Int16
    public var code: String
    public var name: String
    open var activities: [DAOActivity]
    open var beacons: [DAOBeacon]

    public override init() {
        self.centerNum = 0
        self.code = ""
        self.name = ""

        self.activities = []
        self.beacons = []

        super.init()
    }

    public init(centerNum: Int16, code: String, name: String) {
        self.centerNum = centerNum
        self.code = code
        self.name = name

        self.activities = []
        self.beacons = []

        super.init(id: code)
    }
    
    public init(from object: DAOCenter) {
        self.centerNum = object.centerNum
        self.code = object.code
        self.name = object.name

        self.activities = object.activities
        self.beacons = object.beacons

        super.init(from: object)
    }

    public override init(from dictionary: Dictionary<String, Any?>) {
        self.centerNum = 0
        self.code = ""
        self.name = ""

        self.activities = []
        self.beacons = []

        super.init()

        _ = self.dao(from: dictionary)
    }

    public func update(from object: DAOCenter) {
        self.centerNum = object.centerNum
        self.code = object.code
        self.name = object.name

        self.activities = object.activities
        self.beacons = object.beacons

        super.update(from: object)
    }

    public override func dao(from dictionary: Dictionary<String, Any?>) -> DAOCenter {
        self.centerNum = dictionary["id"] as? Int16 ?? self.centerNum
        self.code = dictionary["code"] as? String ?? self.code
        self.name = dictionary["name"] as? String ?? self.name

        var activities: Array<DAOActivity> = []
        let activitiesData: Array<Dictionary<String, Any?>> = (dictionary["activities"] as? Array<Dictionary<String, Any?>>) ?? []
        activitiesData.forEach { (activityData) in
            activities.append(DAOActivity(from: activityData))
        }
        self.activities = activities
        
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
