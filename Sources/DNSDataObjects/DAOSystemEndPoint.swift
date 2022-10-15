//
//  DAOSystemEndPoint.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOSystemEndPoint: PTCLCFGBaseObject {
    var systemEndPointType: DAOSystemEndPoint.Type { get }
    func systemEndPointArray<K>(from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystemEndPoint] where K: CodingKey
}

public protocol PTCLCFGSystemEndPointObject: PTCLCFGDAOSystem, PTCLCFGDAOSystemState {
}
public class CFGSystemEndPointObject: PTCLCFGSystemEndPointObject {
    public var systemType: DAOSystem.Type = DAOSystem.self
    public var systemStateType: DAOSystemState.Type = DAOSystemState.self

    open func systemArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystem] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOSystem].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
    open func systemStateArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystemState] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOSystemState].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOSystemEndPoint: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGSystemEndPointObject
    public static var config: Config = CFGSystemEndPointObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createSystemState() -> DAOSystemState { config.systemStateType.init() }
    open class func createSystemState(from object: DAOSystemState) -> DAOSystemState { config.systemStateType.init(from: object) }
    open class func createSystemState(from data: DNSDataDictionary) -> DAOSystemState? { config.systemStateType.init(from: data) }

    open class func createSystem() -> DAOSystem { config.systemType.init() }
    open class func createSystem(from object: DAOSystem) -> DAOSystem { config.systemType.init(from: object) }
    open class func createSystem(from data: DNSDataDictionary) -> DAOSystem? { config.systemType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case currentState, historyState, name, system
    }

    open var name = DNSString()
    @CodableConfiguration(from: DAOSystemEndPoint.self) open var currentState: DAOSystemState = DAOSystemState()
    @CodableConfiguration(from: DAOSystemEndPoint.self) open var system: DAOSystem = DAOSystem()
    @CodableConfiguration(from: DAOSystemEndPoint.self) open var historyState: [DAOSystemState] = []

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
        fatalError("init(from:) has not been implemented")
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        fatalError("init(from:configuration:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        currentState = Self.createSystemState()
        system = Self.createSystem()
        try super.init(from: decoder, configuration: configuration)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentState = self.daoSystemState(with: configuration, from: container, forKey: .currentState) ?? currentState
        name = self.dnsstring(from: container, forKey: .name) ?? name
        system = self.daoSystem(with: configuration, from: container, forKey: .system) ?? system
        historyState = self.daoSystemStateArray(with: configuration, from: container, forKey: .historyState)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentState, forKey: .currentState, configuration: configuration)
        try container.encode(name, forKey: .name)
        try container.encode(system, forKey: .system, configuration: configuration)
        try container.encode(historyState, forKey: .historyState, configuration: configuration)
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
