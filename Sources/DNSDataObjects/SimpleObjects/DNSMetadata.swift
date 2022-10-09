//
//  DNSMetadata.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DNSMetadata: DNSDataTranslation, Codable {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case uid, created, synced, updated, status, createdBy, updatedBy
        case genericValues
    }
    
    public var uid: UUID = UUID()
    
    public var created = Date()
    public var synced: Date?
    public var updated = Date()
    
    public var status = ""
    public var createdBy = ""
    public var updatedBy = ""
    
    public var genericValues: DNSDataDictionary = [:]
    
    // MARK: - Initializers -
    required override public init() {
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DNSMetadata) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSMetadata) {
        self.uid = object.uid
        self.created = object.created
        self.synced = object.synced
        self.updated = object.updated
        self.status = object.status
        self.createdBy = object.createdBy
        self.updatedBy = object.updatedBy
        self.genericValues = object.genericValues
    }
    
    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DNSMetadata {
        self.uid = self.uuid(from: data[field(.uid)] as Any?) ?? self.uid
        self.created = self.time(from: data[field(.created)] as Any?) ?? self.created
        self.synced = self.time(from: data[field(.synced)] as Any?) ?? self.synced
        self.updated = self.time(from: data[field(.updated)] as Any?) ?? self.updated
        self.status = self.string(from: data[field(.status)] as Any?) ?? self.status
        self.createdBy = self.string(from: data[field(.createdBy)] as Any?) ?? self.createdBy
        self.updatedBy = self.string(from: data[field(.updatedBy)] as Any?) ?? self.updatedBy
        self.genericValues = self.dictionary(from: data[field(.genericValues)] as Any?)
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.uid): self.uid,
            field(.created): self.created,
            field(.synced): self.synced,
            field(.updated): self.updated,
            field(.status): self.status,
            field(.createdBy): self.createdBy,
            field(.updatedBy): self.updatedBy,
            field(.genericValues): self.genericValues,
        ]
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = self.uuid(from: container, forKey: .uid) ?? uid
        created = self.date(from: container, forKey: .created) ?? created
        synced = self.date(from: container, forKey: .synced) ?? synced
        updated = self.date(from: container, forKey: .updated) ?? updated
        status = self.string(from: container, forKey: .status) ?? status
        createdBy = self.string(from: container, forKey: .createdBy) ?? createdBy
        updatedBy = self.string(from: container, forKey: .updatedBy) ?? updatedBy
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(created, forKey: .created)
        try container.encode(synced, forKey: .synced)
        try container.encode(updated, forKey: .updated)
        try container.encode(status, forKey: .status)
        try container.encode(createdBy, forKey: .createdBy)
        try container.encode(updatedBy, forKey: .updatedBy)
    }
    
    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSMetadata(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSMetadata else { return true }
        let lhs = self
        return lhs.uid != rhs.uid ||
            lhs.created != rhs.created ||
            lhs.synced != rhs.synced ||
            lhs.updated != rhs.updated ||
            lhs.status != rhs.status ||
            lhs.createdBy != rhs.createdBy ||
            lhs.updatedBy != rhs.updatedBy
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSMetadata, rhs: DNSMetadata) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DNSMetadata, rhs: DNSMetadata) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
