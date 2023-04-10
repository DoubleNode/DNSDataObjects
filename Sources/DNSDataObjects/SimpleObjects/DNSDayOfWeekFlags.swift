//
//  DNSDayOfWeekFlags.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DNSDayOfWeekFlags: DNSDataTranslation, Codable, NSCopying {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    }
    
    open var sunday: Bool = true
    open var monday: Bool = true
    open var tuesday: Bool = true
    open var wednesday: Bool = true
    open var thursday: Bool = true
    open var friday: Bool = true
    open var saturday: Bool = true
    
    // MARK: - Initializers -
    required override public init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DNSDayOfWeekFlags) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSDayOfWeekFlags) {
        self.sunday = object.sunday
        self.monday = object.monday
        self.tuesday = object.tuesday
        self.wednesday = object.wednesday
        self.thursday = object.thursday
        self.friday = object.friday
        self.saturday = object.saturday
    }
    
    // MARK: - DAO translation methods -
    public init(from data: DNSDataDictionary) {
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DNSDayOfWeekFlags {
        self.sunday = self.bool(from: data[field(.sunday)] as Any?) ?? self.sunday
        self.monday = self.bool(from: data[field(.monday)] as Any?) ?? self.monday
        self.tuesday = self.bool(from: data[field(.tuesday)] as Any?) ?? self.tuesday
        self.wednesday = self.bool(from: data[field(.wednesday)] as Any?) ?? self.wednesday
        self.thursday = self.bool(from: data[field(.thursday)] as Any?) ?? self.thursday
        self.friday = self.bool(from: data[field(.friday)] as Any?) ?? self.friday
        self.saturday = self.bool(from: data[field(.saturday)] as Any?) ?? self.saturday
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.sunday): self.sunday,
            field(.monday): self.monday,
            field(.tuesday): self.tuesday,
            field(.wednesday): self.wednesday,
            field(.thursday): self.thursday,
            field(.friday): self.friday,
            field(.saturday): self.saturday,
        ]
        return retval
    }
    
    // NSCopying protocol methods
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSDayOfWeekFlags()
        copy.sunday = sunday
        copy.monday = monday
        copy.tuesday = tuesday
        copy.wednesday = wednesday
        copy.thursday = thursday
        copy.friday = friday
        copy.saturday = saturday
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSDayOfWeekFlags else { return true }
        let lhs = self
        return lhs.sunday != rhs.sunday ||
            lhs.monday != rhs.monday ||
            lhs.tuesday != rhs.tuesday ||
            lhs.wednesday != rhs.wednesday ||
            lhs.thursday != rhs.thursday ||
            lhs.friday != rhs.friday ||
            lhs.saturday != rhs.saturday
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSDayOfWeekFlags, rhs: DNSDayOfWeekFlags) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DNSDayOfWeekFlags, rhs: DNSDayOfWeekFlags) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
