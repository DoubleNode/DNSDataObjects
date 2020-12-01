//
//  DAOBaseObject.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOBaseObject: DNSDataTranslation, Codable {
    public struct Metadata: Codable {
        var uuid: UUID = UUID()

        var created: Date = Date()
        var synced: Date?
        var updated: Date = Date()

        var status: String?
        var createdBy: String?
        var updatedBy: String?
    }

    public var id: String
    public var meta: Metadata = Metadata()

    private enum CodingKeys: String, CodingKey {
        case id, meta
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        meta = try container.decode(Metadata.self, forKey: .meta)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(meta, forKey: .meta)
    }

    public override init() {
        self.id = ""
        super.init()

        self.id = self.meta.uuid.uuidString
    }

    public init(id: String) {
        self.id = ""
        super.init()

        self.id = id
    }

    public init(from dictionary: Dictionary<String, Any?>) {
        self.id = ""
        super.init()

        _ = self.dao(from: dictionary)
    }

    public init(from object: DAOBaseObject) {
        self.id = ""
        super.init()

        self.update(from: object)
    }

    open func update(from object: DAOBaseObject) {
        self.id = object.id
        self.meta = object.meta
    }

    open func dao(from dictionary: [String: Any?]) -> DAOBaseObject {
        self.id = self.string(from: dictionary["id"] as Any?) ?? self.id
        self.meta.updated = Date()
        return self
    }

    open func dictionary() -> [String: Any?] {
        let retval = [
            "id": self.id,
        ]
        
        return retval
    }

    // MARK: - Equatable protocol methods -

    static func == (lhs: DAOBaseObject, rhs: DAOBaseObject) -> Bool {
        return lhs.id == rhs.id
    }
}
