//
//  DAOCard.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
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

    public func update(from object: DAOCard) {
        self.nickname = object.nickname
        self.cardNumber = object.cardNumber
        self.pinNumber = object.pinNumber

        super.update(from: object)
    }

    public override func dao(from dictionary: Dictionary<String, Any?>) -> DAOCard {
        self.nickname = dictionary["nickname"] as? String ?? self.nickname
        self.cardNumber = dictionary["cardNumber"] as? String ?? self.cardNumber
        self.pinNumber = dictionary["pinNumber"] as? String ?? self.pinNumber

        _ = super.dao(from: dictionary)
        
        return self
    }
}
