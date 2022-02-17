//
//  DAOSystemEndPoint.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOSystemEndPoint: DAOBaseObject {
    public var name: String = ""
    public var currentState: DAOSystemState?

    public var historyState: [DAOSystemState] = []

    private enum CodingKeys: String, CodingKey {
        case name, currentState, historyState
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        currentState = try container.decode(DAOSystemState.self, forKey: .currentState)
        historyState = try container.decode([DAOSystemState].self, forKey: .historyState)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(currentState, forKey: .currentState)
        try container.encode(historyState, forKey: .historyState)
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
        self.name = object.name
        self.currentState = object.currentState
        self.historyState = object.historyState
    }

    override open func dao(from dictionary: [String: Any?]) -> DAOSystemEndPoint {
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name
        let currentStateData = dictionary["currentState"] as? [String: Any?] ?? [:]
        self.currentState = DAOSystemState(from: currentStateData)
        let historyStateData = dictionary["historyState"] as? [[String: Any?]] ?? []
        self.historyState = historyStateData.map { DAOSystemState(from: $0) }
        _ = super.dao(from: dictionary)
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
