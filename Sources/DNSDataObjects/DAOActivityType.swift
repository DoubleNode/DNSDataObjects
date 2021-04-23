//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOActivityType: DAOBaseObject {
    public var code: String
    public var name: String
    
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
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
    }

    override public init() {
        self.code = ""
        self.name = ""
        super.init()
    }
    override public init(id: String) {
        self.code = ""
        self.name = ""
        super.init(id: id)
    }
    override public init(from dictionary: [String: Any?]) {
        self.code = ""
        self.name = ""
        super.init()
        _ = self.dao(from: dictionary)
    }
    public init(from object: DAOActivityType) {
        self.code = object.code
        self.name = object.name
        super.init(from: object)
    }
    public init(code: String, name: String) {
        self.code = code
        self.name = name
        super.init(id: code)
    }
    
    open func update(from object: DAOActivityType) {
        self.code = object.code
        self.name = object.name
        super.update(from: object)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOActivityType {
        self.code = self.string(from: dictionary["code"] as Any?) ?? self.code
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name
        _ = super.dao(from: dictionary)
        return self
    }
    override open func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "code": self.code,
            "name": self.name,
        ]) { (current, _) in current }
        return retval
    }
}
