//
//  DAOCard.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOCard: DAOBaseObject {
    public var nickname: String
    public var cardNumber: String
    public var pinNumber: String
    
    public override init() {
        self.nickname = ""
        self.cardNumber = ""
        self.pinNumber = ""

        super.init()
    }

    public init(nickname: String, cardNumber: String, pinNumber: String) {
        self.nickname = nickname
        self.cardNumber = cardNumber
        self.pinNumber = pinNumber

        super.init(id: cardNumber)
    }
    
    public init(from object: DAOCard) {
        self.nickname = object.nickname
        self.cardNumber = object.cardNumber
        self.pinNumber = object.pinNumber

        super.init(from: object)
    }

    public override init(from dictionary: Dictionary<String, Any?>) {
        self.nickname = ""
        self.cardNumber = ""
        self.pinNumber = ""

        super.init()

        _ = self.dao(from: dictionary)
    }

    open func update(from object: DAOCard) {
        self.nickname = object.nickname
        self.cardNumber = object.cardNumber
        self.pinNumber = object.pinNumber

        super.update(from: object)
    }

    open override func dao(from dictionary: [String: Any?]) -> DAOCard {
        self.nickname = self.string(from: dictionary["nickname"] ?? self.nickname)!
        self.cardNumber = self.string(from: dictionary["cardNumber"] ?? self.cardNumber)!
        self.pinNumber = self.string(from: dictionary["pinNumber"] ?? self.pinNumber)!

        _ = super.dao(from: dictionary)
        
        return self
    }

    open override func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "nickname": self.nickname,
            "cardNumber": self.cardNumber,
            "pinNumber": self.pinNumber,
        ]) { (current, _) in current }
        return retval
    }
}
