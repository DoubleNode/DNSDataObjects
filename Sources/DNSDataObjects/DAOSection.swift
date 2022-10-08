//
//  DAOSection.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

open class DAOSection: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var placeType: DAOPlace.Type { return DAOPlace.self }
    open class var sectionType: DAOSection.Type { return DAOSection.self }

    open class func createPlace() -> DAOPlace { placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace? { placeType.init(from: data) }

    open class func createSection() -> DAOSection { sectionType.init() }
    open class func createSection(from object: DAOSection) -> DAOSection { sectionType.init(from: object) }
    open class func createSection(from data: DNSDataDictionary) -> DAOSection? { sectionType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case children, name, parent, places
    }

    open var children: [DAOSection] = []
    open var name = DNSString()
    open var parent: DAOSection?
    open var places: [DAOPlace] = []

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
        // swiftlint:disable force_cast
        self.children = object.children.map { $0.copy() as! DAOSection }
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
        self.children = childrenData.compactMap { Self.createSection(from: $0) }
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        let parentData = self.dictionary(from: data[field(.parent)] as Any?)
        self.parent = Self.createSection(from: parentData)
        let placesData = self.dataarray(from: data[field(.places)] as Any?)
        self.places = placesData.compactMap { Self.createPlace(from: $0) }
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.children): self.children.map { $0.asDictionary },
            field(.name): self.name.asDictionary,
            field(.parent): self.parent?.asDictionary ?? .empty,
            field(.places): self.places.map { $0.asDictionary },
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        children = try container.decodeIfPresent([DAOSection].self, forKey: .children) ?? children
        name = try container.decodeIfPresent(DNSString.self, forKey: .name) ?? name
        parent = try container.decodeIfPresent(Self.sectionType.self, forKey: .parent) ?? parent
        places = try container.decodeIfPresent([DAOPlace].self, forKey: .places) ?? places
        try super.init(from: decoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(children, forKey: .children)
        try container.encode(name, forKey: .name)
        try container.encode(parent, forKey: .parent)
        try container.encode(places, forKey: .places)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOSection(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOSection else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.children != rhs.children ||
            lhs.name != rhs.name ||
            lhs.parent != rhs.parent ||
            lhs.places != rhs.places
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOSection, rhs: DAOSection) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOSection, rhs: DAOSection) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
