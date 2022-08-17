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
    open class var eventType: DAOAppEvent.Type { return DAOAppEvent.self }

    open class func createEvent() -> DAOAppEvent { eventType.init() }
    open class func createEvent(from object: DAOAppEvent) -> DAOAppEvent { eventType.init(from: object) }
    open class func createEvent(from data: DNSDataDictionary) -> DAOAppEvent { eventType.init(from: data) }

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
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOApplication {
        _ = super.dao(from: data)
        let appEventsData = self.array(from: data[field(.appEvents)] as Any?)
        self.appEvents = appEventsData.map { Self.createEvent(from: $0) }
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appEvents = try container.decode([DAOAppEvent].self, forKey: .appEvents)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
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
        return lhs.appEvents != rhs.appEvents
    }

    // MARK: - Utility methods -
    open func utilityActiveAppEvent() -> DAOAppEvent? {
        let now = Date()
        return appEvents
            .filter { $0.startTime < now && $0.endTime > now }
            .first
    }
}
