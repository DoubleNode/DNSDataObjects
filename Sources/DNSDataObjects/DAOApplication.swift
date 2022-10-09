//
//  DAOApplication.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOApplication: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var appEventType: DAOAppEvent.Type { DAOAppEvent.self }
    open class var appEventArrayType: [DAOAppEvent].Type { [DAOAppEvent].self }

    open class func createAppEvent() -> DAOAppEvent { appEventType.init() }
    open class func createAppEvent(from object: DAOAppEvent) -> DAOAppEvent { appEventType.init(from: object) }
    open class func createAppEvent(from data: DNSDataDictionary) -> DAOAppEvent? { appEventType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case appEvents
    }

    open var appEvents: [DAOAppEvent] = []
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
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appEvents = self.daoAppEventArray(of: Self.appEventArrayType, from: container, forKey: .appEvents)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appEvents, forKey: .appEvents)
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
