//
//  DNSMetadata.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DNSMetadata: DNSDataTranslation, Codable {
    public enum CodingKeys: String, CodingKey {
        case uuid, created, synced, updated, status, createdBy, updatedBy
        case genericValues
    }

    public var uuid: UUID = UUID()

    public var created = Date()
    public var synced: Date?
    public var updated = Date()

    public var status = ""
    public var createdBy = ""
    public var updatedBy = ""
    
    public var genericValues: [String: Any?] = [:]

    // MARK: - Initializers -
    override public init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DNSMetadata) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSMetadata) {
        self.uuid = object.uuid
        self.created = object.created
        self.synced = object.synced
        self.updated = object.updated
        self.status = object.status
        self.createdBy = object.createdBy
        self.updatedBy = object.updatedBy
        self.genericValues = object.genericValues
    }

    // MARK: - DAO translation methods -
    public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    open func dao(from dictionary: [String: Any?]) -> DNSMetadata {
        let uuidData = self.string(from: dictionary[CodingKeys.uuid.rawValue] as Any?) ?? self.uuid.uuidString
        self.uuid = UUID(uuidString: uuidData) ?? self.uuid
        self.created = self.time(from: dictionary[CodingKeys.created.rawValue] as Any?) ?? self.created
        self.synced = self.time(from: dictionary[CodingKeys.synced.rawValue] as Any?) ?? self.synced
        self.updated = self.time(from: dictionary[CodingKeys.updated.rawValue] as Any?) ?? self.updated
        self.status = self.string(from: dictionary[CodingKeys.status.rawValue] as Any?) ?? self.status
        self.createdBy = self.string(from: dictionary[CodingKeys.createdBy.rawValue] as Any?) ?? self.createdBy
        self.updatedBy = self.string(from: dictionary[CodingKeys.updatedBy.rawValue] as Any?) ?? self.updatedBy
        let genericData = dictionary[CodingKeys.genericValues.rawValue] as? [String: Any?] ?? [:]
        self.genericValues = genericData
        return self
    }
    open var asDictionary: [String: Any?] {
        let retval: [String: Any?] = [
            CodingKeys.uuid.rawValue: self.uuid,
            CodingKeys.created.rawValue: self.created,
            CodingKeys.synced.rawValue: self.synced,
            CodingKeys.updated.rawValue: self.updated,
            CodingKeys.status.rawValue: self.status,
            CodingKeys.createdBy.rawValue: self.createdBy,
            CodingKeys.updatedBy.rawValue: self.updatedBy,
            CodingKeys.genericValues.rawValue: self.genericValues,
        ]
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = UUID(uuidString: try container.decode(String.self, forKey: .uuid)) ?? UUID()
        created = try container.decode(Date.self, forKey: .created)
        synced = try container.decode(Date?.self, forKey: .synced)
        updated = try container.decode(Date.self, forKey: .updated)
        status = try container.decode(String.self, forKey: .status)
        createdBy = try container.decode(String.self, forKey: .createdBy)
        updatedBy = try container.decode(String.self, forKey: .updatedBy)
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid.uuidString, forKey: .uuid)
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
        return lhs.uuid != rhs.uuid
            || lhs.created != rhs.created
            || lhs.synced != rhs.synced
            || lhs.updated != rhs.updated
            || lhs.status != rhs.status
            || lhs.createdBy != rhs.createdBy
            || lhs.updatedBy != rhs.updatedBy
    }
}
