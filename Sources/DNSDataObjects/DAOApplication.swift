//
//  DAOApplication.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOApplication: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case appEvents
    }

    open var appEvents: [DAOAppEvent] = []
    open var activeAppEvent: DAOAppEvent? {
        self.utilityActiveAppEvent()
    }

    // MARK: - Initializers -
    public override init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOApplication) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOApplication) {
        super.update(from: object)
        self.appEvents = object.appEvents
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOApplication {
        _ = super.dao(from: dictionary)
        let appEvents = dictionary[CodingKeys.appEvents.rawValue] as? [[String: Any?]] ?? []
        self.appEvents = appEvents.map { DAOAppEvent(from: $0) }
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.appEvents.rawValue: self.appEvents.map { $0.asDictionary },
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
