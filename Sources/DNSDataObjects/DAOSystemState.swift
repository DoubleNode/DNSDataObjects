//
//  DAOSystemState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOSystemState: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case state
    }
    
    public var state: DNSSystemState = .green
    
    override public init() {
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DAOSystemState) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOSystemState) {
        super.update(from: object)
        self.state = object.state
    }
    
    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOSystemState {
        _ = super.dao(from: dictionary)
        let rawState = self.string(from: dictionary["state"] as Any?) ?? self.state.rawValue
        self.state = DNSSystemState(rawValue: rawState) ?? self.state
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            "state": self.state.rawValue,
        ]) { (current, _) in current }
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawState = try container.decode(String.self, forKey: .state)
        state = DNSSystemState(rawValue: rawState) ?? .green
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(state.rawValue, forKey: .state)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOSystemState(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOSystemState else { return true }
        let lhs = self
        return lhs.state != rhs.state
    }
}
