//
//  DAOPricingTier.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOPricingTier: PTCLCFGBaseObject {
    var pricingTierType: DAOPricingTier.Type { get }
    func pricingTier<K>(from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingTier? where K: CodingKey
    func pricingTierArray<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingTier] where K: CodingKey
}

public protocol PTCLCFGPricingTierObject: PTCLCFGDAOPricingSeason, PTCLCFGDAOPricingTier {
}
public class CFGPricingTierObject: PTCLCFGPricingTierObject {
    public var pricingSeasonType: DAOPricingSeason.Type = DAOPricingSeason.self
    open func pricingSeason<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingSeason? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPricingSeason.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func pricingSeasonArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingSeason] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPricingSeason].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

    public var pricingTierType: DAOPricingTier.Type = DAOPricingTier.self
    open func pricingTier<K>(from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingTier? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPricingTier.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func pricingTierArray<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingTier] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPricingTier].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOPricingTier: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPricingTierObject
    public static var config: Config = CFGPricingTierObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createPricingSeason() -> DAOPricingSeason { config.pricingSeasonType.init() }
    open class func createPricingSeason(from object: DAOPricingSeason) -> DAOPricingSeason { config.pricingSeasonType.init(from: object) }
    open class func createPricingSeason(from data: DNSDataDictionary) -> DAOPricingSeason? { config.pricingSeasonType.init(from: data) }

    open class func createPricingTier() -> DAOPricingTier { config.pricingTierType.init() }
    open class func createPricingTier(from object: DAOPricingTier) -> DAOPricingTier { config.pricingTierType.init(from: object) }
    open class func createPricingTier(from data: DNSDataDictionary) -> DAOPricingTier? { config.pricingTierType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case dataStrings, priority, seasons, title
    }

    open var dataStrings: [String: DNSString] = [:]
    open var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }
    open var seasons: [DAOPricingSeason] = []
    open var title = ""

    open var price: DNSPrice? { price() }
    open func price(for time: Date = Date()) -> DNSPrice? {
        seasons
            .filter { $0.isActive }
            .sorted { $0.priority > $1.priority }
            .compactMap { $0.price(for: time) }
            .first
    }
    open func season(for seasonId: String) -> DAOPricingSeason? {
        let season = seasons
            .filter { $0.id == seasonId }
            .sorted { $0.priority > $1.priority }
            .first ?? seasons.first
        return season
    }

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(title: String) {
        self.title = title
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOPricingTier) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOPricingTier) {
        super.update(from: object)
        self.priority = object.priority
        self.title = object.title
        // swiftlint:disable force_cast
        self.dataStrings = [:]
        object.dataStrings.forEach { self.dataStrings[$0] = ($1.copy() as! DNSString) }
        self.seasons = object.seasons.map { $0.copy() as! DAOPricingSeason }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOPricingTier {
        _ = super.dao(from: data)
        self.dataStrings = self.dictionary(from: data[field(.dataStrings)] as Any?) as? [String: DNSString] ?? self.dataStrings
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        let seasonsData = self.dataarray(from: data[field(.seasons)] as Any?)
        self.seasons = seasonsData.compactMap { Self.createPricingSeason(from: $0) }
        self.title = self.string(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.dataStrings): self.dataStrings,
            field(.priority): self.priority,
            field(.seasons): self.seasons.map { $0.asDictionary },
            field(.title): self.title,
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
        dataStrings = try container.decodeIfPresent([String: DNSString].self, forKey: .dataStrings) ?? [:]
        priority = self.int(from: container, forKey: .priority) ?? priority
        seasons = self.daoPricingSeasonArray(with: configuration, from: container, forKey: .seasons)
        title = self.string(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dataStrings, forKey: .dataStrings)
        try container.encode(priority, forKey: .priority)
        try container.encode(seasons, forKey: .seasons, configuration: configuration)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPricingTier(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPricingTier else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.seasons.hasDiffElementsFrom(rhs.seasons) ||
            lhs.dataStrings != rhs.dataStrings ||
            lhs.priority != rhs.priority ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPricingTier, rhs: DAOPricingTier) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPricingTier, rhs: DAOPricingTier) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
