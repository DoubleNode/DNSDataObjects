//
//  DAOActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOActivityType: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case code, name
    }

    public var code: String = ""
    public var name: String = ""

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    override public init(id: String) {
        super.init(id: id)
    }
    public init(code: String, name: String) {
        self.code = code
        self.name = name
        super.init(id: code)
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DAOActivityType) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOActivityType) {
        super.update(from: object)
        self.code = object.code
        self.name = object.name
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOActivityType {
        _ = super.dao(from: dictionary)
        self.code = self.string(from: dictionary[CodingKeys.code.rawValue] as Any?) ?? self.code
        self.name = self.string(from: dictionary[CodingKeys.name.rawValue] as Any?) ?? self.name
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.code.rawValue: self.code,
            CodingKeys.name.rawValue: self.name,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
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
        return lhs.code != rhs.code
            || lhs.name != rhs.name
    }
}
