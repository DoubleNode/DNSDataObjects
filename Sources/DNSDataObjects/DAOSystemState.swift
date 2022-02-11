//
//  DAOSystemState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOSystemState: DAOBaseObject {
    public enum State: String {
        case none
        case green
        case red
        case yellow
    }
    public var state: DAOSystemState.State = .green

    private enum CodingKeys: String, CodingKey {
        case state
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawState = try container.decode(String.self, forKey: .state)
        state = DAOSystemState.State(rawValue: rawState) ?? .green
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(state.rawValue, forKey: .state)
    }

    override public init() {
        super.init()
    }
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    public init(from object: DAOSystemState) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystemState) {
        super.update(from: object)
        self.state = object.state
    }

    override open func dao(from dictionary: [String: Any?]) -> DAOSystemState {
        let rawState = self.string(from: dictionary["state"] as Any?) ?? self.state.rawValue
        self.state = DAOSystemState.State(rawValue: rawState) ?? self.state
        _ = super.dao(from: dictionary)
        return self
    }
    override open func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "state": self.state.rawValue,
        ]) { (current, _) in current }
        return retval
    }
}
