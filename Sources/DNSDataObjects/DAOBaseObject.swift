//
//  DAOBaseObject.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOBaseObject: DNSDataTranslation {
    public struct Metadata {
        var uuid: UUID = UUID()

        var created: Date = Date()
        var synced: Date?
        var updated: Date = Date()

        var status: String?
        var createdBy: Any?
        var updatedBy: Any?
    }

    public var id: String
    public var meta: Metadata = Metadata()

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

    open func dao(from dictionary: Dictionary<String, Any?>) -> DAOBaseObject {
        self.id = dictionary["id"] as? String ?? self.id
        self.meta.updated = Date()
        return self
    }
}
