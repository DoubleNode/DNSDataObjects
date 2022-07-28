//
//  DAOSystemEndPoint.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOSystemEndPoint: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var stateType: DAOSystemState.Type { return DAOSystemState.self }
    open class var systemType: DAOSystem.Type { return DAOSystem.self }

    open class func createState() -> DAOSystemState { stateType.init() }
    open class func createState(from object: DAOSystemState) -> DAOSystemState { stateType.init(from: object) }
    open class func createState(from data: DNSDataDictionary) -> DAOSystemState { stateType.init(from: data) }

    open class func createSystem() -> DAOSystem { systemType.init() }
    open class func createSystem(from object: DAOSystem) -> DAOSystem { systemType.init(from: object) }
    open class func createSystem(from data: DNSDataDictionary) -> DAOSystem { systemType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case currentState, historyState, name, system
    }

    open var currentState = DAOSystemEndPoint.createState()
    open var name = DNSString()
    open var system = DAOSystemEndPoint.createSystem()
    open var historyState: [DAOSystemState] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOSystemEndPoint) {
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
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOSystemEndPoint {
        _ = super.dao(from: data)
        let currentStateData = self.dictionary(from: data[field(.currentState)] as Any?)
        self.currentState = Self.createState(from: currentStateData)
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        let systemData = self.dictionary(from: data[field(.system)] as Any?)
        self.system = Self.createSystem(from: systemData)
        let historyStateData = self.array(from: data[field(.historyState)] as Any?)
        self.historyState = historyStateData.map { Self.createState(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.currentState): self.currentState.asDictionary,
            field(.name): self.name.asDictionary,
            field(.system): self.system.asDictionary,
            field(.historyState): self.historyState,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentState = try container.decode(Self.stateType.self, forKey: .currentState)
        name = try container.decode(DNSString.self, forKey: .name)
        system = try container.decode(Self.systemType.self, forKey: .system)
        historyState = try container.decode([DAOSystemState].self, forKey: .historyState)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.currentState != rhs.currentState
            || lhs.name != rhs.name
            || lhs.system != rhs.system
            || lhs.historyState != rhs.historyState
    }
}
