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
    open class var endPointType: DAOSystemEndPoint.Type { return DAOSystemEndPoint.self }
    open class var stateType: DAOSystemState.Type { return DAOSystemState.self }

    open class func createEndPoint() -> DAOSystemEndPoint { endPointType.init() }
    open class func createEndPoint(from object: DAOSystemEndPoint) -> DAOSystemEndPoint { endPointType.init(from: object) }
    open class func createEndPoint(from data: DNSDataDictionary) -> DAOSystemEndPoint? { endPointType.init(from: data) }

    open class func createState() -> DAOSystemState { stateType.init() }
    open class func createState(from object: DAOSystemState) -> DAOSystemState { stateType.init(from: object) }
    open class func createState(from data: DNSDataDictionary) -> DAOSystemState? { stateType.init(from: data) }

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
        currentState = Self.createState()
        super.init()
    }
    required public init(id: String) {
        currentState = Self.createState()
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOSystem) {
        currentState = Self.createState()
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
        currentState = Self.createState()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOSystem {
        _ = super.dao(from: data)
        let currentStateData = self.dictionary(from: data[field(.currentState)] as Any?)
        self.currentState = Self.createState(from: currentStateData) ?? self.currentState
        let endPointsData = self.dataarray(from: data[field(.endPoints)] as Any?)
        self.endPoints = endPointsData.compactMap { Self.createEndPoint(from: $0) }
        let historyStateData = self.dataarray(from: data[field(.historyState)] as Any?)
        self.historyState = historyStateData.compactMap { Self.createState(from: $0) }
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
        currentState = Self.createState()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentState = try container.decodeIfPresent(Self.stateType.self, forKey: .currentState) ?? currentState
        endPoints = try container.decodeIfPresent([DAOSystemEndPoint].self, forKey: .endPoints) ?? endPoints
        historyState = try container.decodeIfPresent([DAOSystemState].self, forKey: .historyState) ?? historyState
        message = try container.decodeIfPresent(DNSString.self, forKey: .message) ?? message
        name = try container.decodeIfPresent(DNSString.self, forKey: .name) ?? name
        try super.init(from: decoder)
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
