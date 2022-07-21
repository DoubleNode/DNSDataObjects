//
//  DNSDayOfWeekFlags.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DNSDayOfWeekFlags: Codable, Hashable, NSCopying {
    public var sunday: Bool = true
    public var monday: Bool = true
    public var tuesday: Bool = true
    public var wednesday: Bool = true
    public var thursday: Bool = true
    public var friday: Bool = true
    public var saturday: Bool = true
    
    public init() { }
    
    // Equatable protocol methods
    static public func ==(lhs: DNSDayOfWeekFlags, rhs: DNSDayOfWeekFlags) -> Bool {
        return lhs.sunday == rhs.sunday &&
        lhs.monday == rhs.monday &&
        lhs.tuesday == rhs.tuesday &&
        lhs.wednesday == rhs.wednesday &&
        lhs.thursday == rhs.thursday &&
        lhs.friday == rhs.friday &&
        lhs.saturday == rhs.saturday
    }
    
    // Hashable protocol methods
    open func hash(into hasher: inout Hasher) {
        hasher.combine(sunday)
        hasher.combine(monday)
        hasher.combine(tuesday)
        hasher.combine(wednesday)
        hasher.combine(thursday)
        hasher.combine(friday)
        hasher.combine(saturday)
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
}
