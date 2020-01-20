//
//  DAOBaseObject.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
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

    public init(id: String? = nil) {
        self.id = ""
        super.init()

        self.id = id ?? self.meta.uuid.uuidString
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
