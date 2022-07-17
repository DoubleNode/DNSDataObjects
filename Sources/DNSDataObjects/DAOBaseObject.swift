//
//  DAOBaseObject.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOBaseObject: DNSDataTranslation, Codable, NSCopying {
    public enum CodingKeys: String, CodingKey {
        case id, metaUUID, metaCreated, metaSynced, metaUpdated
        case metaStatus, metaCreatedBy, metaUpdatedBy
    }

    public struct Metadata: Codable {
        public var uuid: UUID = UUID()

        public var created = Date()
        public var synced: Date?
        public var updated = Date()

        public var status = ""
        public var createdBy = ""
        public var updatedBy = ""
    }

    public var id: String = ""
    public var meta: Metadata = Metadata()

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
        self.id = self.string(from: dictionary["id"] as Any?) ?? self.id
        self.meta.updated = Date()
        return self
    }
    open var asDictionary: [String: Any?] {
        let retval: [String: Any?] = [
            "id": self.id,
            "meta": [
                "uuid": self.meta.uuid,
                "created": self.meta.created,
                "synced": self.meta.synced as Any,
                "updated": self.meta.updated,
                "status": self.meta.status,
                "createdBy": self.meta.createdBy,
                "updatedBy": self.meta.updatedBy,
            ],
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
        meta.uuid = UUID(uuidString: try container.decode(String.self, forKey: .metaUUID)) ?? UUID()
        meta.created = try container.decode(Date.self, forKey: .metaCreated)
        meta.synced = try container.decode(Date?.self, forKey: .metaSynced)
        meta.updated = try container.decode(Date.self, forKey: .metaUpdated)

        meta.status = try container.decode(String.self, forKey: .metaStatus)
        meta.createdBy = try container.decode(String.self, forKey: .metaCreatedBy)
        meta.updatedBy = try container.decode(String.self, forKey: .metaUpdatedBy)
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(meta.uuid.uuidString, forKey: .metaUUID)
        try container.encode(meta.created, forKey: .metaCreated)
        try container.encode(meta.synced, forKey: .metaSynced)
        try container.encode(meta.updated, forKey: .metaUpdated)

        try container.encode(meta.status, forKey: .metaStatus)
        try container.encode(meta.createdBy, forKey: .metaCreatedBy)
        try container.encode(meta.updatedBy, forKey: .metaUpdatedBy)
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
            || lhs.meta.uuid != rhs.meta.uuid
            || lhs.meta.created != rhs.meta.created
            || lhs.meta.synced != rhs.meta.synced
            || lhs.meta.updated != rhs.meta.updated
            || lhs.meta.status != rhs.meta.status
            || lhs.meta.createdBy != rhs.meta.createdBy
            || lhs.meta.updatedBy != rhs.meta.updatedBy
    }
}
