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
    open class var systemStateType: DAOSystemState.Type { DAOSystemState.self }
    open class var systemStateArrayType: [DAOSystemState].Type { [DAOSystemState].self }
    open class var systemType: DAOSystem.Type { DAOSystem.self }

    open class func createSystemState() -> DAOSystemState { systemStateType.init() }
    open class func createSystemState(from object: DAOSystemState) -> DAOSystemState { systemStateType.init(from: object) }
    open class func createSystemState(from data: DNSDataDictionary) -> DAOSystemState? { systemStateType.init(from: data) }

    open class func createSystem() -> DAOSystem { systemType.init() }
    open class func createSystem(from object: DAOSystem) -> DAOSystem { systemType.init(from: object) }
    open class func createSystem(from data: DNSDataDictionary) -> DAOSystem? { systemType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case currentState, historyState, name, system
    }

    open var currentState: DAOSystemState
    open var name = DNSString()
    open var system: DAOSystem
    open var historyState: [DAOSystemState] = []

    // MARK: - Initializers -
    required public init() {
        currentState = Self.createSystemState()
        system = Self.createSystem()
        super.init()
    }
    required public init(id: String) {
        currentState = Self.createSystemState()
        system = Self.createSystem()
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOSystemEndPoint) {
        currentState = Self.createSystemState()
        system = Self.createSystem()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystemEndPoint) {
        super.update(from: object)
        self.name = object.name
        // swiftlint:disable force_cast
        self.historyState = object.historyState.map { $0.copy() as! DAOSystemState }
        self.currentState = object.currentState.copy() as! DAOSystemState
        self.system = object.system.copy() as! DAOSystem
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        currentState = Self.createSystemState()
        system = Self.createSystem()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOSystemEndPoint {
        _ = super.dao(from: data)
        let currentStateData = self.dictionary(from: data[field(.currentState)] as Any?)
        self.currentState = Self.createSystemState(from: currentStateData) ?? self.currentState
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        let systemData = self.dictionary(from: data[field(.system)] as Any?)
        self.system = Self.createSystem(from: systemData) ?? self.system
        let historyStateData = self.dataarray(from: data[field(.historyState)] as Any?)
        self.historyState = historyStateData.compactMap { Self.createSystemState(from: $0) }
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
        currentState = Self.createSystemState()
        system = Self.createSystem()
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentState = self.daoSystemState(of: Self.systemStateType, from: container, forKey: .currentState) ?? currentState
        name = self.dnsstring(from: container, forKey: .name) ?? name
        system = self.daoSystem(of: Self.systemType, from: container, forKey: .system) ?? system
        historyState = self.daoSystemStateArray(of: Self.systemStateArrayType, from: container, forKey: .historyState)
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
        return super.isDiffFrom(rhs) ||
            lhs.currentState != rhs.currentState ||
            lhs.name != rhs.name ||
            lhs.system != rhs.system ||
            lhs.historyState != rhs.historyState
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOSystemEndPoint, rhs: DAOSystemEndPoint) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOSystemEndPoint, rhs: DAOSystemEndPoint) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
