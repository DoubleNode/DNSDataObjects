//
//  DNSUserReaction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DNSUserReaction: DNSDataTranslation, Codable {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case userId, created, reaction, reactionOn, updated, viewed, viewedOn
    }
    
    public var userId = ""
    public var created = false
    public var reaction: DNSReactionType?
    public var reactionOn: Date?
    public var updated = false
    public var viewed = false
    public var viewedOn: Date?

    // MARK: - Initializers -
    required override public init() {
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DNSUserReaction) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSUserReaction) {
        self.userId = object.userId
        self.created = object.created
        self.reaction = object.reaction
        self.reactionOn = object.reactionOn
        self.updated = object.updated
        self.viewed = object.viewed
        self.viewedOn = object.viewedOn
    }
    
    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DNSUserReaction {
        self.userId = self.string(from: data[field(.userId)] as Any?) ?? self.userId
        self.created = self.bool(from: data[field(.created)] as Any?) ?? self.created
        let reactionData = self.string(from: data[field(.reaction)] as Any?) ?? ""
        self.reaction = DNSReactionType(rawValue: reactionData) ?? .unknown
        self.reactionOn = self.time(from: data[field(.reactionOn)] as Any?) ?? self.reactionOn
        self.updated = self.bool(from: data[field(.updated)] as Any?) ?? self.updated
        self.viewed = self.bool(from: data[field(.viewed)] as Any?) ?? self.viewed
        self.viewedOn = self.time(from: data[field(.viewedOn)] as Any?) ?? self.viewedOn
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.userId): self.userId,
            field(.created): self.created,
            field(.reaction): self.reaction?.rawValue,
            field(.reactionOn): self.reactionOn,
            field(.updated): self.updated,
            field(.viewed): self.viewed,
            field(.viewedOn): self.viewedOn,
        ]
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = self.string(from: container, forKey: .userId) ?? userId
        created = self.bool(from: container, forKey: .created) ?? created
        reaction = try container.decodeIfPresent(Swift.type(of: reaction), forKey: .reaction) ?? reaction
        reactionOn = self.time(from: container, forKey: .reactionOn) ?? reactionOn
        updated = self.bool(from: container, forKey: .updated) ?? updated
        viewed = self.bool(from: container, forKey: .viewed) ?? viewed
        viewedOn = self.time(from: container, forKey: .viewedOn) ?? viewedOn
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(created, forKey: .created)
        try container.encode(reaction, forKey: .reaction)
        try container.encode(reactionOn, forKey: .reactionOn)
        try container.encode(updated, forKey: .updated)
        try container.encode(viewed, forKey: .viewed)
        try container.encode(viewedOn, forKey: .viewedOn)
    }
    
    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSUserReaction(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSUserReaction else { return true }
        let lhs = self
        return lhs.userId != rhs.userId ||
            lhs.created != rhs.created ||
            lhs.reaction != rhs.reaction ||
            lhs.reactionOn != rhs.reactionOn ||
            lhs.updated != rhs.updated ||
            lhs.viewed != rhs.viewed ||
            lhs.viewedOn != rhs.viewedOn
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSUserReaction, rhs: DNSUserReaction) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DNSUserReaction, rhs: DNSUserReaction) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
