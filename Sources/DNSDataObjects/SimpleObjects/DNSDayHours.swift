//
//  DNSDayHours.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DNSDayHours: Codable, Hashable, NSCopying {
    public var open: DNSTimeOfDay?
    public var close: DNSTimeOfDay?

    open var openTime: Date { open() ?? Date() }
    open var closeTime: Date { close() ?? Date() }

    open var isClosedToday: Bool {
        (open == nil) && (close == nil)
    }
    open var isOpenToday: Bool {
        !isClosedToday
    }
    open var isClosed: Bool {
        Date() < openTime || Date() > closeTime
    }
    open var isOpen: Bool {
        !isClosed
    }

    open func open(on date: Date = Date()) -> Date? {
        guard let open = self.open else { return nil }
        let date = date
        return open.time(on: date)
    }
    open func close(on date: Date = Date()) -> Date? {
        guard let open = self.open else { return nil }
        guard let close = self.close else { return nil }
        let date = open.value <= close.value ? Date() : Date().nextDay
        return close.time(on: date)
    }

    public init() { }
    public init(open: DNSTimeOfDay?,
                close: DNSTimeOfDay?) {
        self.open = open
        self.close = close
    }
    public init(from object: DNSDayHours) {
        self.update(from: object)
    }
    open func update(from object: DNSDayHours) {
        self.open = object.open
        self.close = object.close
    }

    // Hashable protocol methods
    open func hash(into hasher: inout Hasher) {
        hasher.combine(open)
        hasher.combine(close)
    }

    // NSCopying protocol methods
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSDayHours(from: self)
        return copy
    }

    open func timeAsString(forceMinutes: Bool = false) -> String {
        var retval = ""
        if open == nil && close == nil {
            return Localizations.closedEntireDay
        }
        if let open {
            retval += open.timeAsString(forceMinutes: forceMinutes)
            retval += Localizations.thru
        } else {
            retval = Localizations.midnight + Localizations.thru
        }
        if let close {
            retval += close.timeAsString(forceMinutes: forceMinutes)
        } else {
            retval += Localizations.midnight
        }
        return retval
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSDayHours, rhs: DNSDayHours) -> Bool {
        !(lhs == rhs)
    }
    static public func ==(lhs: DNSDayHours, rhs: DNSDayHours) -> Bool {
        lhs.open == rhs.open && lhs.close == rhs.close
    }

    // MARK: - Localizations -
    public enum Localizations {
        static let closedEntireDay = NSLocalizedString("DataObjectsDayHoursClosedEntireDay", comment: "DataObjectsDayHoursClosedEntireDay")  // "Closed entire day"
        static let midnight = NSLocalizedString("DataObjectsDayHoursMidnight", comment: "DataObjectsDayHoursMidnight")  // "Midnight"
        static let thru = NSLocalizedString("DataObjectsDayHoursThru", comment: "DataObjectsDayHoursThru")  // " - "
    }
}
