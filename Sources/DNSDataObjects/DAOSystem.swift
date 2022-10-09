//
//  DAOSystem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOSystem: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var systemEndPointType: DAOSystemEndPoint.Type { DAOSystemEndPoint.self }
    open class var systemEndPointArrayType: [DAOSystemEndPoint].Type { [DAOSystemEndPoint].self }
    open class var systemStateType: DAOSystemState.Type { DAOSystemState.self }
    open class var systemStateArrayType: [DAOSystemState].Type { [DAOSystemState].self }

    open class func createSystemEndPoint() -> DAOSystemEndPoint { systemEndPointType.init() }
    open class func createSystemEndPoint(from object: DAOSystemEndPoint) -> DAOSystemEndPoint { systemEndPointType.init(from: object) }
    open class func createSystemEndPoint(from data: DNSDataDictionary) -> DAOSystemEndPoint? { systemEndPointType.init(from: data) }

    open class func createSystemState() -> DAOSystemState { systemStateType.init() }
    open class func createSystemState(from object: DAOSystemState) -> DAOSystemState { systemStateType.init(from: object) }
    open class func createSystemState(from data: DNSDataDictionary) -> DAOSystemState? { systemStateType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case currentState, endPoints, historyState, message, name
    }

    open var currentState: DAOSystemState
    open var endPoints: [DAOSystemEndPoint] = []
    open var historyState: [DAOSystemState] = []
    open var message = DNSString()
    open var name = DNSString()

    // MARK: - Initializers -
    required public init() {
        currentState = Self.createSystemState()
        super.init()
    }
    required public init(id: String) {
        currentState = Self.createSystemState()
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOSystem) {
        currentState = Self.createSystemState()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystem) {
        super.update(from: object)
        self.message = object.message
        self.name = object.name
        // swiftlint:disable force_cast
        self.endPoints = object.endPoints.map { $0.copy() as! DAOSystemEndPoint }
        self.historyState = object.historyState.map { $0.copy() as! DAOSystemState }
        self.currentState = object.currentState.copy() as! DAOSystemState
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        currentState = Self.createSystemState()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOSystem {
        _ = super.dao(from: data)
        let currentStateData = self.dictionary(from: data[field(.currentState)] as Any?)
        self.currentState = Self.createSystemState(from: currentStateData) ?? self.currentState
        let endPointsData = self.dataarray(from: data[field(.endPoints)] as Any?)
        self.endPoints = endPointsData.compactMap { Self.createSystemEndPoint(from: $0) }
        let historyStateData = self.dataarray(from: data[field(.historyState)] as Any?)
        self.historyState = historyStateData.compactMap { Self.createSystemState(from: $0) }
        self.message = self.dnsstring(from: data[field(.message)] as Any?) ?? self.message
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.currentState): self.currentState.asDictionary,
            field(.endPoints): self.endPoints.map { $0.asDictionary },
            field(.historyState): self.historyState.map { $0.asDictionary },
            field(.message): self.message,
            field(.name): self.name,
        ]) { (current, _) in current }
        return retval
    }
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        currentState = Self.createSystemState()
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentState = self.daoSystemState(of: Self.systemStateType, from: container, forKey: .currentState) ?? currentState
        endPoints = self.daoSystemEndPointArray(of: Self.systemEndPointArrayType, from: container, forKey: .endPoints)
        historyState = self.daoSystemStateArray(of: Self.systemStateArrayType, from: container, forKey: .historyState)
        message = self.dnsstring(from: container, forKey: .message) ?? message
        name = self.dnsstring(from: container, forKey: .name) ?? name
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentState, forKey: .currentState)
        try container.encode(endPoints, forKey: .endPoints)
        try container.encode(historyState, forKey: .historyState)
        try container.encode(message, forKey: .message)
        try container.encode(name, forKey: .name)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOSystem(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOSystem else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.currentState != rhs.currentState ||
            lhs.endPoints != rhs.endPoints ||
            lhs.historyState != rhs.historyState ||
            lhs.message != rhs.message ||
            lhs.name != rhs.name
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOSystem, rhs: DAOSystem) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOSystem, rhs: DAOSystem) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
