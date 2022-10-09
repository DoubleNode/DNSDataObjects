//
//  DAOChangeRequest.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOChangeRequest: DAOBaseObject {
    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOChangeRequest) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOChangeRequest) {
        super.update(from: object)
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOChangeRequest {
        _ = super.dao(from: data)
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
//        var container = encoder.container(keyedBy: CodingKeys.self)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOChangeRequest(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOChangeRequest else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
//        let lhs = self
        return super.isDiffFrom(rhs)
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOChangeRequest, rhs: DAOChangeRequest) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOChangeRequest, rhs: DAOChangeRequest) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
