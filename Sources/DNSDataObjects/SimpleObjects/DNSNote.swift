//
//  DNSNote.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DNSNote: DNSDataTranslation, Codable {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case body, distribution, priority
    }
    
    public var body = DNSString()
    public var distribution = DNSVisibility.everyone
    public var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }

    // MARK: - Initializers -
    required override public init() {
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DNSNote) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSNote) {
        self.distribution = object.distribution
        self.priority = object.priority
        // swiftlint:disable force_cast
        self.body = object.body.copy() as! DNSString
        // swiftlint:enable force_cast
    }
    
    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DNSNote {
        self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
        let distributionData = self.string(from: data[field(.distribution)] as Any?) ?? self.distribution.rawValue
        self.distribution = DNSVisibility(rawValue: distributionData) ?? .everyone
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.body): self.body.asDictionary,
            field(.distribution): self.distribution.rawValue,
            field(.priority): self.priority,
        ]
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = self.dnsstring(from: container, forKey: .body) ?? body
        distribution = try container.decodeIfPresent(Swift.type(of: distribution), forKey: .distribution) ?? distribution
        priority = self.int(from: container, forKey: .priority) ?? priority
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(distribution, forKey: .distribution)
        try container.encode(priority, forKey: .priority)
    }
    
    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSNote(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSNote else { return true }
        let lhs = self
        return lhs.body != rhs.body ||
            lhs.distribution != rhs.distribution ||
            lhs.priority != rhs.priority
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSNote, rhs: DNSNote) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DNSNote, rhs: DNSNote) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
