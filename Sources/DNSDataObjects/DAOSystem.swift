//
//  DAOSystem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOSystem: PTCLCFGBaseObject {
    var systemType: DAOSystem.Type { get }
    func system<K>(from container: KeyedDecodingContainer<K>,
                   forKey key: KeyedDecodingContainer<K>.Key) -> DAOSystem? where K: CodingKey
    func systemArray<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystem] where K: CodingKey
}

public protocol PTCLCFGSystemObject: PTCLCFGDAOSystemEndPoint, PTCLCFGDAOSystemState {
}
public class CFGSystemObject: PTCLCFGSystemObject {
    public var systemEndPointType: DAOSystemEndPoint.Type = DAOSystemEndPoint.self
    public var systemStateType: DAOSystemState.Type = DAOSystemState.self

    open func systemEndPoint<K>(from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> DAOSystemEndPoint? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOSystemEndPoint.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func systemState<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOSystemState? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOSystemState.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }

    open func systemEndPointArray<K>(from container: KeyedDecodingContainer<K>,
                                     forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystemEndPoint] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOSystemEndPoint].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func systemStateArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystemState] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOSystemState].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOSystem: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGSystemObject
    public static var config: Config = CFGSystemObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createSystemEndPoint() -> DAOSystemEndPoint { config.systemEndPointType.init() }
    open class func createSystemEndPoint(from object: DAOSystemEndPoint) -> DAOSystemEndPoint { config.systemEndPointType.init(from: object) }
    open class func createSystemEndPoint(from data: DNSDataDictionary) -> DAOSystemEndPoint? { config.systemEndPointType.init(from: data) }

    open class func createSystemState() -> DAOSystemState { config.systemStateType.init() }
    open class func createSystemState(from object: DAOSystemState) -> DAOSystemState { config.systemStateType.init(from: object) }
    open class func createSystemState(from data: DNSDataDictionary) -> DAOSystemState? { config.systemStateType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case currentState, endPoints, historyState, message, name
    }

    open var message = DNSString()
    open var name = DNSString()
    @CodableConfiguration(from: DAOSystem.self) open var currentState: DAOSystemState = DAOSystemState()
    @CodableConfiguration(from: DAOSystem.self) open var endPoints: [DAOSystemEndPoint] = []
    @CodableConfiguration(from: DAOSystem.self) open var historyState: [DAOSystemState] = []

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
        self.currentState = object.currentState.copy() as! DAOSystemState
        self.endPoints = object.endPoints.map { $0.copy() as! DAOSystemEndPoint }
        self.historyState = object.historyState.map { $0.copy() as! DAOSystemState }
        self.message = object.message.copy() as! DNSString
        self.name = object.name.copy() as! DNSString
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
        try super.init(from: decoder)
        try commonInit(from: decoder, configuration: Self.config)
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentState = self.daoSystemState(with: configuration, from: container, forKey: .currentState) ?? currentState
        endPoints = self.daoSystemEndPointArray(with: configuration, from: container, forKey: .endPoints)
        historyState = self.daoSystemStateArray(with: configuration, from: container, forKey: .historyState)
        message = self.dnsstring(from: container, forKey: .message) ?? message
        name = self.dnsstring(from: container, forKey: .name) ?? name
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentState, forKey: .currentState, configuration: configuration)
        try container.encode(endPoints, forKey: .endPoints, configuration: configuration)
        try container.encode(historyState, forKey: .historyState, configuration: configuration)
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
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.endPoints.hasDiffElementsFrom(rhs.endPoints) ||
            lhs.historyState.hasDiffElementsFrom(rhs.historyState) ||
            lhs.currentState != rhs.currentState ||
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
