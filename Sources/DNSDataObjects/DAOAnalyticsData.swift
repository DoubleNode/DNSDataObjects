//
//  DAOAnalyticsData.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOAnalyticsData: PTCLCFGBaseObject {
    var analyticsDataType: DAOAnalyticsData.Type { get }
    func analyticsData<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOAnalyticsData? where K: CodingKey
    func analyticsDataArray<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAnalyticsData] where K: CodingKey
}

public protocol PTCLCFGAnalyticsDataObject: PTCLCFGBaseObject {
}
public class CFGAnalyticsDataObject: PTCLCFGAnalyticsDataObject {
}
open class DAOAnalyticsData: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAnalyticsDataObject
    public static var config: Config = CFGAnalyticsDataObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case data, subtitle, title
    }

    var data: [DNSAnalyticsNumbers] = []
    var subtitle = DNSString()
    var title = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAnalyticsData) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAnalyticsData) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.data = object.data.map { $0.copy() as! DNSAnalyticsNumbers }
        self.subtitle = object.subtitle.copy() as! DNSString
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAnalyticsData {
        _ = super.dao(from: data)
        let dataData = self.dataarray(from: data[field(.data)] as Any?)
        self.data = dataData.compactMap { DNSAnalyticsNumbers(from: $0) }
        self.subtitle = self.dnsstring(from: data[field(.subtitle)] as Any?) ?? self.subtitle
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.data): self.data.map { $0.asDictionary },
            field(.subtitle): self.subtitle.asDictionary,
            field(.title): self.title.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(Swift.type(of: data), forKey: .data) ?? data
        subtitle = self.dnsstring(from: container, forKey: .subtitle) ?? subtitle
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAnalyticsData(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAnalyticsData else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.data.hasDiffElementsFrom(rhs.data) ||
            lhs.subtitle != rhs.subtitle ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAnalyticsData, rhs: DAOAnalyticsData) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAnalyticsData, rhs: DAOAnalyticsData) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
