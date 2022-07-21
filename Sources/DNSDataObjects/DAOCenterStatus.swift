//
//  DAOCenterStatus.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

open class DAOCenterStatus: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case endTime, message, scope, startTime, status
    }

    public var endTime = Date()
    public var message: DNSString = DNSString(with: "")
    public var scope: DNSAlertScope = .center
    public var startTime = Date()
    public var status: DNSCenterStatus = .open

    public var color: UIColor { utilityColor() }
    public var isOpen: Bool { utilityIsOpen() }
    
    // MARK: - Initializers -
    override public init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOCenterStatus) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOCenterStatus) {
        super.update(from: object)
        self.endTime = object.endTime
        self.message = object.message
        self.scope = object.scope
        self.startTime = object.startTime
        self.status = object.status
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOCenterStatus {
        _ = super.dao(from: dictionary)
        self.endTime = self.time(from: dictionary[CodingKeys.endTime.rawValue] as Any?) ?? self.endTime
        self.message = self.dnsstring(from: dictionary[CodingKeys.message.rawValue] as Any?) ?? self.message
        let scopeData = self.string(from: dictionary[CodingKeys.scope.rawValue] as Any?) ?? self.scope.rawValue
        self.scope = DNSAlertScope(rawValue: scopeData) ?? .center
        self.startTime = self.time(from: dictionary[CodingKeys.startTime.rawValue] as Any?) ?? self.startTime
        let statusData = self.string(from: dictionary[CodingKeys.status.rawValue] as Any?) ?? self.status.rawValue
        self.status = DNSCenterStatus(rawValue: statusData) ?? .open
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.endTime.rawValue: self.endTime,
            CodingKeys.message.rawValue: self.message.asDictionary,
            CodingKeys.scope.rawValue: self.scope.rawValue,
            CodingKeys.startTime.rawValue: self.startTime,
            CodingKeys.status.rawValue: self.status.rawValue,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endTime = try container.decode(Date.self, forKey: .endTime)
        message = try container.decode(DNSString.self, forKey: .message)
        scope = DNSAlertScope(rawValue: try container.decode(String.self, forKey: .scope)) ?? .center
        startTime = try container.decode(Date.self, forKey: .startTime)
        status = DNSCenterStatus(rawValue: try container.decode(String.self, forKey: .status)) ?? .open
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(message, forKey: .message)
        try container.encode(scope.rawValue, forKey: .scope)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(status.rawValue, forKey: .status)
    }

    // NSCopying protocol methods
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOCenterStatus(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOCenterStatus else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.endTime != rhs.endTime
            || lhs.message != rhs.message
            || lhs.scope != rhs.scope
            || lhs.startTime != rhs.startTime
            || lhs.status != rhs.status
    }

    // MARK: - Utility methods -
    open func utilityColor() -> UIColor {
        return UIColor.blue
    }
    open func utilityIsOpen() -> Bool {
        return [.open, .grandOpening, .holiday].contains(self.status)
    }
}
