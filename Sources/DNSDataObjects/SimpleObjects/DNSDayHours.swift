//
//  DNSDayHours.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DNSDayHours: DNSDataTranslation, Codable, NSCopying {
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case close, open
    }
    
    public var close: DNSTimeOfDay?
    public var open: DNSTimeOfDay?
    
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
    
    // MARK: - Initializers -
    required override public init() {
        super.init()
    }
    public init(open: DNSTimeOfDay?,
                close: DNSTimeOfDay?) {
        super.init()
        self.close = close
        self.open = open
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DNSDayHours) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSDayHours) {
        self.close = object.close
        self.open = object.open
    }
    
    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DNSDayHours {
        self.close = self.timeOfDay(from: data[field(.close)] as Any?) ?? self.close
        self.open = self.timeOfDay(from: data[field(.open)] as Any?) ?? self.open
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.close): self.close,
            field(.open): self.open,
        ]
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        close = try container.decode(DNSTimeOfDay.self, forKey: .close)
        open = try container.decode(DNSTimeOfDay.self, forKey: .open)
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(close, forKey: .close)
        try container.encode(open, forKey: .open)
    }
    
    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSDayHours(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSDayHours else { return true }
        let lhs = self
        return lhs.close != rhs.close
        || lhs.open != rhs.open
    }
}
extension DNSDayHours {
    public func open(on date: Date = Date()) -> Date? {
        guard let open = self.open else { return nil }
        let date = date
        return open.time(on: date)
    }
    public func close(on date: Date = Date()) -> Date? {
        guard let open = self.open else { return nil }
        guard let close = self.close else { return nil }
        let date = open.value <= close.value ? Date() : Date().nextDay
        return close.time(on: date)
    }
    
    public func timeAsString(forceMinutes: Bool = false) -> String {
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
//    static public func !=(lhs: DNSDayHours, rhs: DNSDayHours) -> Bool {
//        !(lhs == rhs)
//    }
//    static public func ==(lhs: DNSDayHours, rhs: DNSDayHours) -> Bool {
//        lhs.open == rhs.open && lhs.close == rhs.close
//    }

    // MARK: - Localizations -
    public enum Localizations {
        static let closedEntireDay = NSLocalizedString("DataObjectsDayHoursClosedEntireDay", comment: "DataObjectsDayHoursClosedEntireDay")  // "Closed entire day"
        static let midnight = NSLocalizedString("DataObjectsDayHoursMidnight", comment: "DataObjectsDayHoursMidnight")  // "Midnight"
        static let thru = NSLocalizedString("DataObjectsDayHoursThru", comment: "DataObjectsDayHoursThru")  // " - "
    }
}
