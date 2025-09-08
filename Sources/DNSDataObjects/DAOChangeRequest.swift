//
//  DAOChangeRequest.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOChangeRequest: PTCLCFGBaseObject {
    var changeRequestType: DAOChangeRequest.Type { get }
    func changeRequest<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOChangeRequest? where K: CodingKey
    func changeRequestArray<K>(from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOChangeRequest] where K: CodingKey
}

public protocol PTCLCFGChangeRequestObject: PTCLCFGBaseObject {
}
public class CFGChangeRequestObject: PTCLCFGChangeRequestObject {
}
open class DAOChangeRequest: DAOBaseObject {
    public typealias Config = PTCLCFGChangeRequestObject
    private static var config: Config = CFGChangeRequestObject()

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
        super.init()
        try commonInit(from: decoder, configuration: Self.config)
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
//        var container = encoder.container(keyedBy: CodingKeys.self)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOChangeRequest(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOChangeRequest else { return true }
        guard self !== rhs else { return false }
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
