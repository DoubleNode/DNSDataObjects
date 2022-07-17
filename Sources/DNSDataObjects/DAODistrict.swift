//
//  DAODistrict.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

open class DAODistrict: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case centers, name, region
    }

    public var centers: [DAOCenter] = []
    public var name = DNSString()
    public var region = DAORegion()

    // MARK: - Initializers -
    override public init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAODistrict) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAODistrict) {
        super.update(from: object)
        self.centers = object.centers
        self.name = object.name
        self.region = object.region
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAODistrict {
        _ = super.dao(from: dictionary)
        let centersData: [[String: Any?]] = dictionary[CodingKeys.centers.rawValue] as? [[String: Any?]] ?? []
        self.centers = centersData.map { DAOCenter(from: $0) }
        self.name = self.dnsstring(from: dictionary[CodingKeys.name.rawValue] as Any?) ?? self.name
        let regionData = dictionary[CodingKeys.region.rawValue] as? [String: Any?] ?? [:]
        self.region = DAORegion(from: regionData)
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.centers.rawValue: self.centers.map { $0.asDictionary },
            CodingKeys.name.rawValue: self.name.asDictionary,
            CodingKeys.region.rawValue: self.region.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        centers = try container.decode([DAOCenter].self, forKey: .centers)
        name = try container.decode(DNSString.self, forKey: .name)
        region = try container.decode(DAORegion.self, forKey: .region)
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
        let lhs = self
        return lhs.centers != rhs.centers
            || lhs.name != rhs.name
            || lhs.region != rhs.region
    }
}
