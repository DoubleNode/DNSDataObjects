//
//  DAOActivityBlackout.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOActivityBlackout: DAOBaseObject {
    public var endTime: Date?
    public var message: DNSString = DNSString()
    public var startTime: Date?
    
    // TODO: Implement all CodingKeys
    private enum CodingKeys: String, CodingKey {
        case endTime, message, startTime
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        endTime = try container.decode(Date.self, forKey: .endTime)
        message = try container.decode(DNSString.self, forKey: .message)
        startTime = try container.decode(Date.self, forKey: .startTime)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        if endTime != nil { try container.encode(endTime, forKey: .endTime) }
        try container.encode(message, forKey: .message)
        if startTime != nil { try container.encode(endTime, forKey: .startTime) }
    }

    public override init() {
        super.init()
    }
}
