//
//  DAOCard.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOCard: DAOBaseObject {
    public var cardNumber: String = ""
    public var nickname: String = ""
    public var pinNumber: String = ""

    private enum CodingKeys: String, CodingKey {
        case cardNumber, nickname, pinNumber
    }
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cardNumber = try container.decode(String.self, forKey: .cardNumber)
        nickname = try container.decode(String.self, forKey: .nickname)
        pinNumber = try container.decode(String.self, forKey: .pinNumber)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(pinNumber, forKey: .pinNumber)
    }

    override public init() {
        self.cardNumber = ""
        self.nickname = ""
        self.pinNumber = ""
        super.init()
    }
    override public init(id: String) {
        self.cardNumber = ""
        self.nickname = ""
        self.pinNumber = ""
        super.init(id: id)
    }
    
    override public init(from dictionary: [String: Any?]) {
        self.cardNumber = ""
        self.nickname = ""
        self.pinNumber = ""
        super.init()
        _ = self.dao(from: dictionary)
    }
    public init(from object: DAOCard) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOCard) {
        super.update(from: object)
        self.cardNumber = object.cardNumber
        self.nickname = object.nickname
        self.pinNumber = object.pinNumber
    }

    public init(cardNumber: String, nickname: String, pinNumber: String) {
        self.cardNumber = cardNumber
        self.nickname = nickname
        self.pinNumber = pinNumber
        
        super.init(id: cardNumber)
    }

    override open func dao(from dictionary: [String: Any?]) -> DAOCard {
        _ = super.dao(from: dictionary)
        self.cardNumber =
            self.string(from: dictionary["cardNumber"] as Any?) ?? self.cardNumber
        self.nickname =
            self.string(from: dictionary["nickname"] as Any?) ?? self.nickname
        self.pinNumber =
            self.string(from: dictionary["pinNumber"] as Any?) ?? self.pinNumber
        return self
    }

    override open func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "cardNumber": self.cardNumber,
            "nickname": self.nickname,
            "pinNumber": self.pinNumber,
        ]) { (current, _) in current }
        return retval
    }
}
