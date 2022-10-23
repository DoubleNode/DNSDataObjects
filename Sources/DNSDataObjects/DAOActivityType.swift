//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOActivityType: PTCLCFGBaseObject {
    var activityTypeType: DAOActivityType.Type { get }
    func activityTypeArray<K>(from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityType] where K: CodingKey
}

public protocol PTCLCFGActivityTypeObject: PTCLCFGBaseObject {
}
public class CFGActivityTypeObject: PTCLCFGActivityTypeObject {
}
open class DAOActivityType: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGActivityTypeObject
    public static var config: Config = CFGActivityTypeObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case code, name
    }

    open var code = ""
    open var name = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(code: String, name: DNSString) {
        self.code = code
        self.name = name
        super.init(id: code)
    }
    
    // MARK: - DAO copy methods -
    required public init(from object: DAOActivityType) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOActivityType) {
        super.update(from: object)
        self.code = object.code
        self.name = object.name
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOActivityType {
        _ = super.dao(from: data)
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        self.name = self.dnsstring(from: data[field(.name)] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.code): self.code,
            field(.name): self.name.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = self.string(from: container, forKey: .code) ?? code
        name = self.dnsstring(from: container, forKey: .name) ?? name
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOActivityType(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOActivityType else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.code != rhs.code ||
            lhs.name != rhs.name
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOActivityType, rhs: DAOActivityType) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOActivityType, rhs: DAOActivityType) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
