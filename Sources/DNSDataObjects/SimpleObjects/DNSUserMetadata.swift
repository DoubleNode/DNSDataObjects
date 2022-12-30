//
//  DNSUserMetadata.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DNSUserMetadata: DNSDataTranslation, Codable {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case userId, created, liked, updated, viewed
    }
    
    public var userId = ""
    
    public var created = false
    public var liked = false
    public var updated = false
    public var viewed = false
    
    // MARK: - Initializers -
    required override public init() {
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DNSUserMetadata) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSUserMetadata) {
        self.userId = object.userId
        self.created = object.created
        self.liked = object.liked
        self.updated = object.updated
        self.viewed = object.viewed
    }
    
    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DNSUserMetadata {
        self.userId = self.string(from: data[field(.userId)] as Any?) ?? self.userId
        self.created = self.bool(from: data[field(.created)] as Any?) ?? self.created
        self.liked = self.bool(from: data[field(.liked)] as Any?) ?? self.liked
        self.updated = self.bool(from: data[field(.updated)] as Any?) ?? self.updated
        self.viewed = self.bool(from: data[field(.viewed)] as Any?) ?? self.viewed
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.userId): self.userId,
            field(.created): self.created,
            field(.liked): self.liked,
            field(.updated): self.updated,
            field(.viewed): self.viewed,
        ]
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = self.string(from: container, forKey: .userId) ?? userId
        created = self.bool(from: container, forKey: .created) ?? created
        liked = self.bool(from: container, forKey: .liked) ?? liked
        updated = self.bool(from: container, forKey: .updated) ?? updated
        viewed = self.bool(from: container, forKey: .viewed) ?? viewed
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(created, forKey: .created)
        try container.encode(liked, forKey: .liked)
        try container.encode(updated, forKey: .updated)
        try container.encode(viewed, forKey: .viewed)
    }
    
    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSUserMetadata(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSUserMetadata else { return true }
        let lhs = self
        return lhs.userId != rhs.userId ||
            lhs.created != rhs.created ||
            lhs.liked != rhs.liked ||
            lhs.updated != rhs.updated ||
            lhs.viewed != rhs.viewed
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSUserMetadata, rhs: DNSUserMetadata) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DNSUserMetadata, rhs: DNSUserMetadata) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
