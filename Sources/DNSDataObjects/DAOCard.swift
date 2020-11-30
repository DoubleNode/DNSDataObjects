//
//  DAOCard.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOCard: DAOBaseObject {
    public var cardNumber: String
    public var nickname: String
    public var pinNumber: String

    private enum CodingKeys: String, CodingKey {
        case nickname, cardNumber, pinNumber
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cardNumber = try container.decode(String.self, forKey: .cardNumber)
        nickname = try container.decode(String.self, forKey: .nickname)
        pinNumber = try container.decode(String.self, forKey: .pinNumber)

        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }

    required public init() {
        self.cardNumber = ""
        self.nickname = ""
        self.pinNumber = ""

        super.init()
    }

    required public init(cardNumber: String, nickname: String, pinNumber: String) {
        self.cardNumber = cardNumber
        self.nickname = nickname
        self.pinNumber = pinNumber

        super.init(id: cardNumber)
    }
    
    required public init(from object: DAOCard) {
        self.cardNumber = object.cardNumber
        self.nickname = object.nickname
        self.pinNumber = object.pinNumber

        super.init(from: object)
    }

    required public init(id: String) {
        self.cardNumber = ""
        self.nickname = ""
        self.pinNumber = ""
        
        super.init(id: id)
    }
    
    public override init(from dictionary: Dictionary<String, Any?>) {
        self.cardNumber = ""
        self.nickname = ""
        self.pinNumber = ""

        super.init()

        _ = self.dao(from: dictionary)
    }
    
    open func update(from object: DAOCard) {
        self.cardNumber = object.cardNumber
        self.nickname = object.nickname
        self.pinNumber = object.pinNumber

        super.update(from: object)
    }

    open override func dao(from dictionary: [String: Any?]) -> DAOCard {
        self.cardNumber =
            self.string(from: dictionary["cardNumber"] as Any?) ?? self.cardNumber
        self.nickname =
            self.string(from: dictionary["nickname"] as Any?) ?? self.nickname
        self.pinNumber =
            self.string(from: dictionary["pinNumber"] as Any?) ?? self.pinNumber

        _ = super.dao(from: dictionary)
        
        return self
    }

    open override func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "cardNumber": self.cardNumber,
            "nickname": self.nickname,
            "pinNumber": self.pinNumber,
        ]) { (current, _) in current }
        return retval
    }
}
