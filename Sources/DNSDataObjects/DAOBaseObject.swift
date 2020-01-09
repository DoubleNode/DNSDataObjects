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

    public required override init() {
        id = meta.uuid.uuidString

        super.init()
    }
}
