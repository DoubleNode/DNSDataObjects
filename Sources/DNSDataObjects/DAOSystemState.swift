//
//  DAOSystemState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOSystemState: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case failureCodes, failureRate, totalPoints, state, stateOverride
    }
    
    public var failureCodes: [String: DNSSystemStateNumbers] = [:]
    public var failureRate = DNSSystemStateNumbers()
    public var totalPoints = DNSSystemStateNumbers()
    public var state: DNSSystemState = .green
    public var stateOverride: DNSSystemState = .none

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DAOSystemState) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystemState) {
        super.update(from: object)
        self.failureCodes = object.failureCodes
        self.failureRate = object.failureRate
        self.totalPoints = object.totalPoints
        self.state = object.state
        self.stateOverride = object.stateOverride
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOSystemState {
        _ = super.dao(from: dictionary)
        let failureCodesData: [String: [String: Any?]] = dictionary[CodingKeys.failureCodes.rawValue] as? [String: [String: Any?]] ?? [:]
        self.failureCodes = [:]
        failureCodesData.forEach { key, value in
            self.failureCodes[key] = DNSSystemStateNumbers(from: value)
        }
        let failureRateData: [String: Any?] = dictionary[CodingKeys.failureRate.rawValue] as? [String: Any?] ?? [:]
        self.failureRate = DNSSystemStateNumbers(from: failureRateData)
        let totalPointsData: [String: Any?] = dictionary[CodingKeys.totalPoints.rawValue] as? [String: Any?] ?? [:]
        self.totalPoints = DNSSystemStateNumbers(from: totalPointsData)
        let rawState = self.string(from: dictionary[CodingKeys.state.rawValue] as Any?) ?? self.state.rawValue
        self.state = DNSSystemState(rawValue: rawState) ?? self.state
        let rawStateOverride = self.string(from: dictionary[CodingKeys.stateOverride.rawValue] as Any?) ?? self.state.rawValue
        self.stateOverride = DNSSystemState(rawValue: rawStateOverride) ?? self.stateOverride
        return self
    }
    override open var asDictionary: [String: Any?] {
        var failureCodesData: [String: [String: Any?]] = [:]
        self.failureCodes.forEach { key, value in
            failureCodesData[key] = value.asDictionary
        }
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.failureCodes.rawValue: failureCodesData,
            CodingKeys.failureRate.rawValue: self.failureRate.asDictionary,
            CodingKeys.totalPoints.rawValue: self.totalPoints.asDictionary,
            CodingKeys.state.rawValue: self.state.rawValue,
            CodingKeys.stateOverride.rawValue: self.stateOverride.rawValue,
        ]) { (current, _) in current }
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        failureCodes = try container.decode([String: DNSSystemStateNumbers].self, forKey: .failureCodes)
        failureRate = try container.decode(DNSSystemStateNumbers.self, forKey: .failureRate)
        totalPoints = try container.decode(DNSSystemStateNumbers.self, forKey: .totalPoints)
        let rawState = try container.decode(String.self, forKey: .state)
        state = DNSSystemState(rawValue: rawState) ?? .green
        let rawStateOverride = try container.decode(String.self, forKey: .stateOverride)
        stateOverride = DNSSystemState(rawValue: rawStateOverride) ?? .none
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(failureCodes, forKey: .failureCodes)
        try container.encode(failureRate, forKey: .failureRate)
        try container.encode(totalPoints, forKey: .totalPoints)
        try container.encode(state.rawValue, forKey: .state)
        try container.encode(stateOverride.rawValue, forKey: .stateOverride)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOSystemState(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOSystemState else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.failureCodes != rhs.failureCodes
            || lhs.failureRate != rhs.failureRate
            || lhs.totalPoints != rhs.totalPoints
            || lhs.state != rhs.state
            || lhs.stateOverride != rhs.stateOverride
    }
}
