//
//  DAOSystem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOSystem: DAOBaseObject {
    public enum State: String {
        case none
        case green
        case red
        case yellow
    }
    public var message: String = ""
    public var name: String = ""
    public var state: DAOSystem.State = .green

    private enum CodingKeys: String, CodingKey {
        case message, name, state
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        name = try container.decode(String.self, forKey: .name)
        let rawState = try container.decode(String.self, forKey: .state)
        state = DAOSystem.State(rawValue: rawState) ?? .green
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(name, forKey: .name)
        try container.encode(state.rawValue, forKey: .state)
    }

    override public init() {
        super.init()
    }
    
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    public init(from object: DAOSystem) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystem) {
        super.update(from: object)
        self.message = object.message
        self.name = object.name
        self.state = object.state
    }

    override open func dao(from dictionary: [String: Any?]) -> DAOSystem {
        self.message = self.string(from: dictionary["message"] as Any?) ?? self.message
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name
        let rawState = self.string(from: dictionary["state"] as Any?) ?? self.state.rawValue
        self.state = DAOSystem.State(rawValue: rawState) ?? self.state
        _ = super.dao(from: dictionary)
        return self
    }

    override open func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "message": self.message,
            "name": self.name,
            "state": self.state.rawValue,
        ]) { (current, _) in current }
        return retval
    }
}
