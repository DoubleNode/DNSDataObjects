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
    open var beacons: [DAOBeacon] = []
    
    private enum CodingKeys: String, CodingKey {
        case code, name /*, beacons*/
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)

        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }

    required public init() {
        self.code = ""
        self.name = ""
        self.beacons = []

        super.init()
    }

    required public init(code: String, name: String) {
        self.code = code
        self.name = name
        self.beacons = []

        super.init(id: code)
    }
    
    required public init(from object: DAOActivity) {
        self.code = object.code
        self.name = object.name
        self.beacons = object.beacons

        super.init(from: object)
    }

    required public init(id: String) {
        self.code = ""
        self.name = ""
        self.beacons = []

        super.init(id: id)
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

    open override func dao(from dictionary: [String: Any?]) -> DAOActivity {
        self.code = self.string(from: dictionary["code"] as Any?) ?? self.code
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name

        var beacons: [DAOBeacon] = []
        let beaconsData: [[String: Any?]] = (dictionary["beacons"] as? [[String: Any?]]) ?? []
        beaconsData.forEach { (beaconData) in
            beacons.append(DAOBeacon(from: beaconData))
        }
        self.beacons = beacons

        _ = super.dao(from: dictionary)
        
        return self
    }

    open override func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "code": self.code,
            "name": self.name,
            "beacons": self.beacons.map { $0.dictionary() },
        ]) { (current, _) in current }
        return retval
    }
}
