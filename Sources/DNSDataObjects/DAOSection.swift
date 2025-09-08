//
//  DAOSection.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

public protocol PTCLCFGDAOSection: PTCLCFGBaseObject {
    var sectionType: DAOSection.Type { get }
    func section<K>(from container: KeyedDecodingContainer<K>,
                    forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey
    func sectionArray<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey
}
public protocol PTCLCFGDAOSectionSection: PTCLCFGBaseObject {
    var sectionChildType: DAOSection.Type { get }
    var sectionParentType: DAOSection.Type { get }
    func sectionChild<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey
    func sectionParent<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey
    func sectionChildArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey
    func sectionParentArray<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey
}

public protocol PTCLCFGSectionObject: PTCLCFGDAOPlace, PTCLCFGDAOSectionSection {
}
public class CFGSectionObject: PTCLCFGSectionObject {
    public var placeType: DAOPlace.Type = DAOPlace.self
    public var sectionChildType: DAOSection.Type = DAOSection.self
    public var sectionParentType: DAOSection.Type = DAOSection.self

    open func place<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlace? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOPlace.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func sectionChild<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOSection.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func sectionParent<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOSection.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }

    open func placeArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOPlace].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func sectionChildArray<K>(from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOSection].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func sectionParentArray<K>(from container: KeyedDecodingContainer<K>,
                                    forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOSection].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOSection: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGSectionObject
    public static var config: Config = CFGSectionObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createPlace() -> DAOPlace { config.placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { config.placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { config.placeType.init(from: data) }

    open class func createSectionChild() -> DAOSection { config.sectionChildType.init() }
    open class func createSectionChild(from object: DAOSection) -> DAOSection { config.sectionChildType.init(from: object) }
    open class func createSectionChild(from data: DNSDataDictionary) -> DAOSection? { config.sectionChildType.init(from: data) }

    open class func createSectionParent() -> DAOSection { config.sectionParentType.init() }
    open class func createSectionParent(from object: DAOSection) -> DAOSection { config.sectionParentType.init(from: object) }
    open class func createSectionParent(from data: DNSDataDictionary) -> DAOSection? { config.sectionParentType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case children, name, parent, places, pricingTierId
    }

    open var name = DNSString()
    open var pricingTierId = ""
    @CodableConfiguration(from: DAOSection.self) open var children: [DAOSection] = []
    @CodableConfiguration(from: DAOSection.self) open var parent: DAOSection? = nil
    @CodableConfiguration(from: DAOSection.self) open var places: [DAOPlace] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOSection) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSection) {
        super.update(from: object)
        self.name = object.name
        self.parent = object.parent?.copy() as? DAOSection
        self.pricingTierId = object.pricingTierId
        // swiftlint:disable force_cast
        self.children = object.children.map { $0.copy() as! DAOSection }
        self.name = object.name.copy() as! DNSString
        self.places = object.places.map { $0.copy() as! DAOPlace }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOSection {
        _ = super.dao(from: data)
        let childrenData = self.dataarray(from: data[field(.children)] as Any?)
        self.children = childrenData.compactMap { Self.createSectionChild(from: $0) }
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        let parentData = self.dictionary(from: data[field(.parent)] as Any?)
        self.parent = Self.createSectionParent(from: parentData)
        let placesData = self.dataarray(from: data[field(.places)] as Any?)
        self.places = placesData.compactMap { Self.createPlace(from: $0) }
        self.pricingTierId = self.string(from: data[field(.pricingTierId)] as Any?) ?? self.pricingTierId
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.children): self.children.map { $0.asDictionary },
            field(.name): self.name.asDictionary,
            field(.parent): self.parent?.asDictionary ?? .empty,
            field(.places): self.places.map { $0.asDictionary },
            field(.pricingTierId): self.pricingTierId,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        try commonInit(from: decoder, configuration: Self.config)
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
        name = self.dnsstring(from: container, forKey: .name) ?? name
        children = self.daoSectionChildArray(with: configuration, from: container, forKey: .children)
        parent = self.daoSectionParent(with: configuration, from: container, forKey: .parent) ?? parent
        places = self.daoPlaceArray(with: configuration, from: container, forKey: .places)
        pricingTierId = self.string(from: container, forKey: .pricingTierId) ?? pricingTierId
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(children, forKey: .children, configuration: configuration)
        try container.encode(name, forKey: .name)
        try container.encode(parent, forKey: .parent, configuration: configuration)
        try container.encode(places, forKey: .places, configuration: configuration)
        try container.encode(pricingTierId, forKey: .pricingTierId)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOSection(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOSection else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.parent?.isDiffFrom(rhs.parent) ?? (lhs.parent != rhs.parent)) ||
            lhs.children.hasDiffElementsFrom(rhs.children) ||
            lhs.places.hasDiffElementsFrom(rhs.places) ||
            lhs.name != rhs.name ||
            lhs.pricingTierId != rhs.pricingTierId
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOSection, rhs: DAOSection) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOSection, rhs: DAOSection) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
