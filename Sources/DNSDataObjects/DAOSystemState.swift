//
//  DAOSystemState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOSystemState: PTCLCFGBaseObject {
    var systemStateType: DAOSystemState.Type { get }
    func systemStateArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystemState] where K: CodingKey
}

public protocol PTCLCFGSystemStateObject: PTCLCFGBaseObject {
}
public class CFGSystemStateObject: PTCLCFGSystemStateObject {
}
open class DAOSystemState: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGSystemStateObject
    public static var config: Config = CFGSystemStateObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case failureCodes, failureRate, state, stateOverride, totalPoints
    }
    
    open var failureCodes: [String: DNSSystemStateNumbers] = [:]
    open var failureRate = DNSSystemStateNumbers()
    open var state: DNSSystemState = .green
    open var stateOverride: DNSSystemState = .none
    open var totalPoints = DNSSystemStateNumbers()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOSystemState) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystemState) {
        super.update(from: object)
        self.failureCodes = object.failureCodes
        self.failureRate = object.failureRate
        self.state = object.state
        self.stateOverride = object.stateOverride
        self.totalPoints = object.totalPoints
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOSystemState {
        _ = super.dao(from: data)
        let failureCodesData: [String: DNSDataDictionary] = data[field(.failureCodes)] as? [String: DNSDataDictionary] ?? [:]
        self.failureCodes = [:]
        failureCodesData.forEach { key, value in
            self.failureCodes[key] = DNSSystemStateNumbers(from: value)
        }
        let failureRateData = self.dictionary(from: data[field(.failureRate)] as Any?)
        self.failureRate = DNSSystemStateNumbers(from: failureRateData)
        let rawState = self.string(from: data[field(.state)] as Any?) ?? self.state.rawValue
        self.state = DNSSystemState(rawValue: rawState) ?? self.state
        let rawStateOverride = self.string(from: data[field(.stateOverride)] as Any?) ?? self.state.rawValue
        self.stateOverride = DNSSystemState(rawValue: rawStateOverride) ?? self.stateOverride
        let totalPointsData = self.dictionary(from: data[field(.totalPoints)] as Any?)
        self.totalPoints = DNSSystemStateNumbers(from: totalPointsData)
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var failureCodesData: [String: DNSDataDictionary] = [:]
        self.failureCodes.forEach { key, value in
            failureCodesData[key] = value.asDictionary
        }
        var retval = super.asDictionary
        retval.merge([
            field(.failureCodes): failureCodesData,
            field(.failureRate): self.failureRate.asDictionary,
            field(.state): self.state.rawValue,
            field(.stateOverride): self.stateOverride.rawValue,
            field(.totalPoints): self.totalPoints.asDictionary,
        ]) { (current, _) in current }
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        fatalError("init(from:configuration:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        failureCodes = try container.decodeIfPresent(Swift.type(of: failureCodes), forKey: .failureCodes) ?? failureCodes
        failureRate = try container.decodeIfPresent(Swift.type(of: failureRate), forKey: .failureRate) ?? failureRate
        state = try container.decodeIfPresent(Swift.type(of: state), forKey: .state) ?? state
        stateOverride = try container.decodeIfPresent(Swift.type(of: stateOverride), forKey: .stateOverride) ?? stateOverride
        totalPoints = try container.decodeIfPresent(Swift.type(of: totalPoints), forKey: .totalPoints) ?? totalPoints
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(failureCodes, forKey: .failureCodes)
        try container.encode(failureRate, forKey: .failureRate)
        try container.encode(state.rawValue, forKey: .state)
        try container.encode(stateOverride.rawValue, forKey: .stateOverride)
        try container.encode(totalPoints, forKey: .totalPoints)
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
        return super.isDiffFrom(rhs) ||
            lhs.failureCodes != rhs.failureCodes ||
            lhs.failureRate != rhs.failureRate ||
            lhs.state != rhs.state ||
            lhs.stateOverride != rhs.stateOverride ||
            lhs.totalPoints != rhs.totalPoints
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOSystemState, rhs: DAOSystemState) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOSystemState, rhs: DAOSystemState) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
