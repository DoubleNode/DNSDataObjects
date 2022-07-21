//
//  DAOBaseObject.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOBaseObject: DNSDataTranslation, Codable, NSCopying {
    public enum CodingKeys: String, CodingKey {
        case id, meta
    }

    public var id: String = ""
    public var meta: DNSMetadata = DNSMetadata()

    // MARK: - Initializers -
    public override init() {
        super.init()
        self.id = self.meta.uuid.uuidString
    }
    public init(id: String) {
        super.init()
        self.id = id
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOBaseObject) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DAOBaseObject) {
        self.id = object.id
        self.meta = object.meta
    }

    // MARK: - DAO translation methods -
    public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    open func dao(from dictionary: [String: Any?]) -> DAOBaseObject {
        self.id = self.string(from: dictionary[CodingKeys.id.rawValue] as Any?) ?? self.id
        let metaData: [String: Any?] = dictionary[CodingKeys.meta.rawValue] as? [String: Any?] ?? [:]
        self.meta = DNSMetadata(from: metaData)
        return self
    }
    open var asDictionary: [String: Any?] {
        let retval: [String: Any?] = [
            CodingKeys.id.rawValue: self.id,
            CodingKeys.meta.rawValue: self.meta.asDictionary,
        ]
        return retval
    }

    // MARK: - Equatable protocol methods -
    static func == (lhs: DAOBaseObject, rhs: DAOBaseObject) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        meta = try container.decode(DNSMetadata.self, forKey: .meta)
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(meta, forKey: .meta)
    }

    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOBaseObject(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOBaseObject else { return true }
        let lhs = self
        return lhs.id != rhs.id
            || lhs.meta != rhs.meta
    }
}
