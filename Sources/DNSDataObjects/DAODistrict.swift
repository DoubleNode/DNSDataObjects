//
//  DAODistrict.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

open class DAODistrict: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var placeType: DAOPlace.Type { return DAOPlace.self }
    open class var regionType: DAORegion.Type { return DAORegion.self }

    open class func createPlace() -> DAOPlace { placeType.init() }
    open class func createPlace(from object: DAOPlace) -> DAOPlace { placeType.init(from: object) }
    open class func createPlace(from data: DNSDataDictionary) -> DAOPlace { placeType.init(from: data) }

    open class func createRegion() -> DAORegion { regionType.init() }
    open class func createRegion(from object: DAORegion) -> DAORegion { regionType.init(from: object) }
    open class func createRegion(from data: DNSDataDictionary) -> DAORegion { regionType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case centers, name, region
    }

    open var centers: [DAOPlace] = []
    open var name = DNSString()
    open var region: DAORegion

    // MARK: - Initializers -
    required public init() {
        region = Self.createRegion()
        super.init()
    }
    required public init(id: String) {
        region = Self.createRegion()
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAODistrict) {
        region = Self.createRegion()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAODistrict) {
        super.update(from: object)
        self.name = object.name
        // swiftlint:disable force_cast
        self.centers = object.centers.map { $0.copy() as! DAOPlace }
        self.region = object.region.copy() as! DAORegion
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        region = Self.createRegion()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAODistrict {
        _ = super.dao(from: data)
        let centersData = self.dataarray(from: data[field(.centers)] as Any?)
        self.centers = centersData.map { Self.createPlace(from: $0) }
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        let regionData = self.dictionary(from: data[field(.region)] as Any?)
        self.region = Self.createRegion(from: regionData)
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.centers): self.centers.map { $0.asDictionary },
            field(.name): self.name.asDictionary,
            field(.region): self.region.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        region = Self.createRegion()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        centers = try container.decode([DAOPlace].self, forKey: .centers)
        name = try container.decode(DNSString.self, forKey: .name)
        region = try container.decode(Self.regionType.self, forKey: .region)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(centers, forKey: .centers)
        try container.encode(name, forKey: .name)
        try container.encode(region, forKey: .region)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAODistrict(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAODistrict else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.centers != rhs.centers ||
            lhs.name != rhs.name ||
            lhs.region != rhs.region
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAODistrict, rhs: DAODistrict) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAODistrict, rhs: DAODistrict) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
