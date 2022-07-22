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
    open class func createEndPoint(from data: DNSDataDictionary) -> DAOSystemEndPoint { endPointType.init(from: data) }

    open class func createState() -> DAOSystemState { stateType.init() }
    open class func createState(from object: DAOSystemState) -> DAOSystemState { stateType.init(from: object) }
    open class func createState(from data: DNSDataDictionary) -> DAOSystemState { stateType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case message, name, currentState, endPoints, historyState
    }

    public var message = DNSString()
    public var name = DNSString()
    public var currentState = DAOSystem.createState()
    public var endPoints: [DAOSystemEndPoint] = []
    public var historyState: [DAOSystemState] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOSystem) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystem) {
        super.update(from: object)
        self.message = object.message
        self.name = object.name
        self.currentState = object.currentState
        self.endPoints = object.endPoints
        self.historyState = object.historyState
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOSystem {
        _ = super.dao(from: data)
        self.message = self.dnsstring(from: data[field(.message)] as Any?) ?? self.message
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        let currentStateData = data[field(.currentState)] as? DNSDataDictionary ?? [:]
        self.currentState = Self.createState(from: currentStateData)
        let endPointsData = data[field(.endPoints)] as? [DNSDataDictionary] ?? []
        self.endPoints = endPointsData.map { Self.createEndPoint(from: $0) }
        let historyStateData = data[field(.historyState)] as? [DNSDataDictionary] ?? []
        self.historyState = historyStateData.map { Self.createState(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.message): self.message,
            field(.name): self.name,
            field(.currentState): self.currentState.asDictionary,
            field(.endPoints): self.endPoints.map { $0.asDictionary },
            field(.historyState): self.historyState.map { $0.asDictionary },
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(DNSString.self, forKey: .message)
        name = try container.decode(DNSString.self, forKey: .name)
        currentState = try container.decode(DAOSystemState.self, forKey: .currentState)
        endPoints = try container.decode([DAOSystemEndPoint].self, forKey: .endPoints)
        historyState = try container.decode([DAOSystemState].self, forKey: .historyState)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(name, forKey: .name)
        try container.encode(currentState, forKey: .currentState)
        try container.encode(endPoints, forKey: .endPoints)
        try container.encode(historyState, forKey: .historyState)
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
        return lhs.message != rhs.message
            || lhs.name != rhs.name
            || lhs.currentState != rhs.currentState
            || lhs.endPoints != rhs.endPoints
            || lhs.historyState != rhs.historyState
    }
}
