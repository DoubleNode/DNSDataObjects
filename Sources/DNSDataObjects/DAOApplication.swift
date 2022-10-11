//
//  DAOApplication.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOApplication: PTCLCFGBaseObject {
    var applicationType: DAOApplication.Type { get }
    func applicationArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOApplication] where K: CodingKey
}

public protocol PTCLCFGApplicationObject: PTCLCFGDAOAppEvent {
}
public class CFGApplicationObject: PTCLCFGApplicationObject {
    public var appEventType: DAOAppEvent.Type = DAOAppEvent.self
    open func appEventArray<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppEvent] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAppEvent].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOApplication: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGApplicationObject
    public static var config: Config = CFGApplicationObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAppEvent() -> DAOAppEvent { config.appEventType.init() }
    open class func createAppEvent(from object: DAOAppEvent) -> DAOAppEvent { config.appEventType.init(from: object) }
    open class func createAppEvent(from data: DNSDataDictionary) -> DAOAppEvent? { config.appEventType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case appEvents
    }

    @CodableConfiguration(from: DAOApplication.self) open var appEvents: [DAOAppEvent] = []
    open var activeAppEvent: DAOAppEvent? {
        self.utilityActiveAppEvent()
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOApplication) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOApplication) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.appEvents = object.appEvents.map { $0.copy() as! DAOAppEvent }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOApplication {
        _ = super.dao(from: data)
        let appEventsData = self.dataarray(from: data[field(.appEvents)] as Any?)
        self.appEvents = appEventsData.compactMap { Self.createAppEvent(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.appEvents): self.appEvents.map { $0.asDictionary },
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
        appEvents = self.daoAppEventArray(with: configuration, from: container, forKey: .appEvents)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appEvents, forKey: .appEvents, configuration: configuration)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOApplication(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOApplication else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.appEvents != rhs.appEvents
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOApplication, rhs: DAOApplication) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOApplication, rhs: DAOApplication) -> Bool {
        !lhs.isDiffFrom(rhs)
    }

    // MARK: - Utility methods -
    open func utilityActiveAppEvent() -> DAOAppEvent? {
        let now = Date()
        return appEvents
            .filter { $0.startTime < now && $0.endTime > now }
            .first
    }
}
