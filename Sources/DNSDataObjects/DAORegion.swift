//
//  DAORegion.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

public class DAORegion: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var districtType: DAODistrict.Type { return DAODistrict.self }

    open class func createDistrict() -> DAODistrict { districtType.init() }
    open class func createDistrict(from object: DAODistrict) -> DAODistrict { districtType.init(from: object) }
    open class func createDistrict(from data: DNSDataDictionary) -> DAODistrict { districtType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case districts, name
    }

    open var districts: [DAODistrict] = []
    open var name = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAORegion) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAORegion) {
        super.update(from: object)
        self.name = object.name
        // swiftlint:disable force_cast
        self.districts = object.districts.map { $0.copy() as! DAODistrict }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAORegion {
        _ = super.dao(from: data)
        let districtsData = self.array(from: data[field(.districts)] as Any?)
        self.districts = districtsData.map { Self.createDistrict(from: $0) }
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.districts): self.districts.map { $0.asDictionary },
            field(.name): self.name.asDictionary,
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.districts != rhs.districts
            || lhs.name != rhs.name
    }
}
