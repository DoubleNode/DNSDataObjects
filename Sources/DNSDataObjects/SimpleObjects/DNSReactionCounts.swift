//
//  DNSReactionCounts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DNSReactionCounts: DNSDataTranslation, Codable {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case angered, cared, favorited, humored, liked, loved, saddened, wowed
    }
    
    public var angered: UInt = 0
    public var cared: UInt = 0
    public var favorited: UInt = 0
    public var humored: UInt = 0
    public var liked: UInt = 0
    public var loved: UInt = 0
    public var saddened: UInt = 0
    public var wowed: UInt = 0

    // MARK: - Initializers -
    required override public init() {
        super.init()
    }
    
    // MARK: - DAO copy methods -
    public init(from object: DNSReactionCounts) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSReactionCounts) {
        self.angered = object.angered
        self.cared = object.cared
        self.favorited = object.favorited
        self.humored = object.humored
        self.liked = object.liked
        self.loved = object.loved
        self.saddened = object.saddened
        self.wowed = object.wowed
    }
    
    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DNSReactionCounts {
        self.angered = self.uint(from: data[field(.angered)] as Any?) ?? self.angered
        self.cared = self.uint(from: data[field(.cared)] as Any?) ?? self.cared
        self.favorited = self.uint(from: data[field(.favorited)] as Any?) ?? self.favorited
        self.humored = self.uint(from: data[field(.humored)] as Any?) ?? self.humored
        self.liked = self.uint(from: data[field(.liked)] as Any?) ?? self.liked
        self.loved = self.uint(from: data[field(.loved)] as Any?) ?? self.loved
        self.saddened = self.uint(from: data[field(.saddened)] as Any?) ?? self.saddened
        self.wowed = self.uint(from: data[field(.wowed)] as Any?) ?? self.wowed
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.angered): self.angered,
            field(.cared): self.cared,
            field(.favorited): self.favorited,
            field(.humored): self.humored,
            field(.liked): self.liked,
            field(.loved): self.loved,
            field(.saddened): self.saddened,
            field(.wowed): self.wowed,
        ]
        return retval
    }
    
    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        angered = self.uint(from: container, forKey: .angered) ?? angered
        cared = self.uint(from: container, forKey: .cared) ?? cared
        favorited = self.uint(from: container, forKey: .favorited) ?? favorited
        humored = self.uint(from: container, forKey: .humored) ?? humored
        liked = self.uint(from: container, forKey: .liked) ?? liked
        loved = self.uint(from: container, forKey: .loved) ?? loved
        saddened = self.uint(from: container, forKey: .saddened) ?? saddened
        wowed = self.uint(from: container, forKey: .wowed) ?? wowed
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(angered, forKey: .angered)
        try container.encode(cared, forKey: .cared)
        try container.encode(favorited, forKey: .favorited)
        try container.encode(humored, forKey: .humored)
        try container.encode(liked, forKey: .liked)
        try container.encode(loved, forKey: .loved)
        try container.encode(saddened, forKey: .saddened)
        try container.encode(wowed, forKey: .wowed)
    }
    
    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSReactionCounts(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSReactionCounts else { return true }
        let lhs = self
        return lhs.angered != rhs.angered ||
            lhs.cared != rhs.cared ||
            lhs.favorited != rhs.favorited ||
            lhs.humored != rhs.humored ||
            lhs.liked != rhs.liked ||
            lhs.loved != rhs.loved ||
            lhs.saddened != rhs.saddened ||
            lhs.wowed != rhs.wowed
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DNSReactionCounts, rhs: DNSReactionCounts) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DNSReactionCounts, rhs: DNSReactionCounts) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
