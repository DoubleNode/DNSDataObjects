//
//  DAOPlaceHoliday.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOPlaceHoliday: PTCLCFGBaseObject {
    var placeHolidayType: DAOPlaceHoliday.Type { get }
    func placeHolidayArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceHoliday] where K: CodingKey
}

public protocol PTCLCFGPlaceHolidayObject: PTCLCFGBaseObject {
}
public class CFGPlaceHolidayObject: PTCLCFGPlaceHolidayObject {
}
open class DAOPlaceHoliday: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPlaceHolidayObject
    public static var config: Config = CFGPlaceHolidayObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case date, hours
    }

    open var date = Date.today
    open var hours = DNSDailyHours()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOPlaceHoliday) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPlaceHoliday) {
        super.update(from: object)
        self.date = object.date
        // swiftlint:disable force_cast
        self.hours = object.hours.copy() as! DNSDailyHours
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPlaceHoliday {
        _ = super.dao(from: data)
        self.date = self.time(from: data[field(.date)] as Any?) ?? self.date
        let hoursData = self.dictionary(from: data[field(.hours)] as Any?)
        self.hours = DNSDailyHours(from: hoursData)
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.date): self.date,
            field(.hours): self.hours.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        fatalError("init(from:configuration:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = self.date(from: container, forKey: .date) ?? date

        hours = try container.decodeIfPresent(Swift.type(of: hours), forKey: .hours) ?? hours
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(hours, forKey: .hours)
    }

    // NSCopying protocol methods
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPlaceHoliday(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPlaceHoliday else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.date != rhs.date ||
            lhs.hours != rhs.hours
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPlaceHoliday, rhs: DAOPlaceHoliday) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPlaceHoliday, rhs: DAOPlaceHoliday) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
