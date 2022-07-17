//
//  DAORegion.swift
//  Main Event App
//
//  Created by Darren.Ehlers on 1/9/20.
//  Copyright © 2020 Main Event Entertainment LP. All rights reserved.
//

import DNSCore
import UIKit

public class DAORegion: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case districts, name
    }

    public var districts: [DAODistrict] = []
    public var name = DNSString()

    // MARK: - Initializers -
    override public init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAORegion) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAORegion) {
        super.update(from: object)
        self.districts = object.districts
        self.name = object.name
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAORegion {
        _ = super.dao(from: dictionary)
        let districtsData: [[String: Any?]] = dictionary[CodingKeys.districts.rawValue] as? [[String: Any?]] ?? []
        self.districts = districtsData.map { DAODistrict(from: $0) }
        self.name = self.dnsstring(from: dictionary[CodingKeys.name.rawValue] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.districts.rawValue: self.districts.map { $0.asDictionary },
            CodingKeys.name.rawValue: self.name.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        districts = try container.decode([DAODistrict].self, forKey: .districts)
        name = try container.decode(DNSString.self, forKey: .name)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(districts, forKey: .districts)
        try container.encode(name, forKey: .name)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAORegion(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAORegion else { return true }
        let lhs = self
        return lhs.districts != rhs.districts
            || lhs.name != rhs.name
    }
}
