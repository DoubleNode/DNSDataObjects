//
//  DAOSystemEndPoint.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOSystemEndPoint: DAOBaseObject {
    public var currentState: DAOSystemState?
    public var name: String = ""
    public var system: DAOSystem?

    public var historyState: [DAOSystemState] = []

    private enum CodingKeys: String, CodingKey {
        case currentState, historyState, name, system
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentState = try container.decode(DAOSystemState.self, forKey: .currentState)
        historyState = try container.decode([DAOSystemState].self, forKey: .historyState)
        name = try container.decode(String.self, forKey: .name)
        system = try container.decode(DAOSystem.self, forKey: .system)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentState, forKey: .currentState)
        try container.encode(historyState, forKey: .historyState)
        try container.encode(name, forKey: .name)
        try container.encode(system, forKey: .system)
    }

    override public init() {
        super.init()
    }
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    public init(from object: DAOSystemEndPoint) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystemEndPoint) {
        super.update(from: object)
        self.currentState = object.currentState
        self.historyState = object.historyState
        self.name = object.name
        self.system = object.system
    }

    override open func dao(from dictionary: [String: Any?]) -> DAOSystemEndPoint {
        _ = super.dao(from: dictionary)
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name
        let currentStateData = dictionary["currentState"] as? [String: Any?] ?? [:]
        self.currentState = DAOSystemState(from: currentStateData)
        let historyStateData = dictionary["historyState"] as? [[String: Any?]] ?? []
        self.historyState = historyStateData.map { DAOSystemState(from: $0) }
        return self
    }

    override open func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "name": self.name,
            "currentState": self.currentState?.dictionary() ?? [:],
            "historyState": self.historyState,
        ]) { (current, _) in current }
        return retval
    }
}
