//
//  DAOBaseObject.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOBaseObject {
}

public protocol PTCLCFGBaseObject: PTCLCFGDAOBaseObject {
}
open class DAOBaseObject: DNSDataTranslation, Codable, CodableWithConfiguration, NSCopying {
    public typealias Config = PTCLCFGBaseObject

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case id, meta
    }

    open var id: String = ""
    open var meta: DNSMetadata = DNSMetadata()

    // MARK: - Initializers -
    override required public init() {
        super.init()
        self.id = self.meta.uid.uuidString
    }
    required public init(id: String) {
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
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DAOBaseObject {
        self.id = self.string(from: data[field(.id)] as Any?) ?? self.id
        let metaData = self.dictionary(from: data[field(.meta)] as Any?)
        self.meta = DNSMetadata(from: metaData)
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.id): self.id,
            field(.meta): self.meta.asDictionary,
        ]
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder, configuration: Config) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = self.string(from: container, forKey: .id) ?? id
        meta = try container.decodeIfPresent(Swift.type(of: meta), forKey: .meta) ?? meta
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
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
        return lhs.id != rhs.id ||
            lhs.meta != rhs.meta
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOBaseObject, rhs: DAOBaseObject) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOBaseObject, rhs: DAOBaseObject) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
