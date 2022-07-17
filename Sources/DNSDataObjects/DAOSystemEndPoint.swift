//
//  DAOSystemEndPoint.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOSystemEndPoint: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case currentState, historyState, name, system
    }

    public var currentState = DAOSystemState()
    public var name: String = ""
    public var system = DAOSystem()
    public var historyState: [DAOSystemState] = []

    // MARK: - Initializers -
    override public init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOSystemEndPoint) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystemEndPoint) {
        super.update(from: object)
        self.currentState = object.currentState
        self.name = object.name
        self.system = object.system
        self.historyState = object.historyState
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOSystemEndPoint {
        _ = super.dao(from: dictionary)
        let currentStateData = dictionary[CodingKeys.currentState.rawValue] as? [String: Any?] ?? [:]
        self.currentState = DAOSystemState(from: currentStateData)
        self.name = self.string(from: dictionary[CodingKeys.name.rawValue] as Any?) ?? self.name
        let systemData = dictionary[CodingKeys.system.rawValue] as? [String: Any?] ?? [:]
        self.system = DAOSystem(from: systemData)
        let historyStateData = dictionary[CodingKeys.historyState.rawValue] as? [[String: Any?]] ?? []
        self.historyState = historyStateData.map { DAOSystemState(from: $0) }
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.currentState.rawValue: self.currentState.asDictionary,
            CodingKeys.name.rawValue: self.name,
            CodingKeys.system.rawValue: self.system.asDictionary,
            CodingKeys.historyState.rawValue: self.historyState,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentState = try container.decode(DAOSystemState.self, forKey: .currentState)
        name = try container.decode(String.self, forKey: .name)
        system = try container.decode(DAOSystem.self, forKey: .system)
        historyState = try container.decode([DAOSystemState].self, forKey: .historyState)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentState, forKey: .currentState)
        try container.encode(name, forKey: .name)
        try container.encode(system, forKey: .system)
        try container.encode(historyState, forKey: .historyState)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOSystemEndPoint(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOSystemEndPoint else { return true }
        let lhs = self
        return lhs.currentState != rhs.currentState
            || lhs.name != rhs.name
            || lhs.system != rhs.system
            || lhs.historyState != rhs.historyState
    }
}
