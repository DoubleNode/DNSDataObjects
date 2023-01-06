//
//  DNSPrice.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DNSPrice: DNSDataTranslation, Codable {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endTime, price, priority, startTime
    }
    
    public var endTime = Date.zeroTime
    public var price: Float = 0
    public var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }
    public var startTime = Date.zeroTime

    public var isActive: Bool { isActive() }
    public func isActive(for time: Date = Date()) -> Bool {
        guard startTime != Date.zeroTime && endTime != Date.zeroTime else { return true }
        guard startTime != Date.zeroTime else { return time.timeOfDay() < endTime }
        guard endTime != Date.zeroTime else { return time.timeOfDay() > startTime }
        return time.timeOfDay() > startTime && time.timeOfDay() < endTime
    }

    // MARK: - Initializers -
    required override public init() {
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DNSPrice) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSPrice) {
        self.endTime = object.endTime
        self.price = object.price
        self.priority = object.priority
        self.startTime = object.startTime
    }
    
    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DNSPrice {
        self.endTime = self.timeOfDay(from: data[field(.endTime)] as Any?) ?? self.endTime
        self.price = self.float(from: data[field(.price)] as Any?) ?? self.price
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        self.startTime = self.timeOfDay(from: data[field(.startTime)] as Any?) ?? self.startTime
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.endTime): self.endTime,
            field(.price): self.price,
            field(.priority): self.priority,
            field(.startTime): self.startTime,
        ]
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endTime = self.timeOfDay(from: container, forKey: .endTime) ?? endTime
        price = self.float(from: container, forKey: .price) ?? price
        priority = self.int(from: container, forKey: .priority) ?? priority
        startTime = self.timeOfDay(from: container, forKey: .startTime) ?? startTime
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(price, forKey: .price)
        try container.encode(priority, forKey: .priority)
        try container.encode(startTime, forKey: .startTime)
    }
    
    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSPrice(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSPrice else { return true }
        let lhs = self
        return lhs.endTime != rhs.endTime ||
            lhs.price != rhs.price ||
            lhs.priority != rhs.priority ||
            lhs.startTime != rhs.startTime
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSPrice, rhs: DNSPrice) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DNSPrice, rhs: DNSPrice) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
