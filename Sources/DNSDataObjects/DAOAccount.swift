//
//  DAOAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

open class DAOAccount: DAOBaseObject {
    public var name: String
    public var user: DAOUser?
    public var cards: [DAOCard] = []

    public override init() {
        self.name = ""
        self.user = nil

        super.init()
    }

    public init(name: String = "", user: DAOUser? = nil) {
        self.name = name
        self.user = user

        super.init()
    }
    
    public init(from object: DAOAccount) {
        self.name = object.name
        self.user = object.user
        self.cards = object.cards

        super.init(from: object)
    }

    public override init(from dictionary: Dictionary<String, Any?>) {
        self.name = ""
        self.user = nil
        
        super.init()

        _ = self.dao(from: dictionary)
    }

    public func update(from object: DAOAccount) {
        self.name = object.name
        self.user = object.user
        self.cards = object.cards

        super.update(from: object)
    }

    public override func dao(from dictionary: Dictionary<String, Any?>) -> DAOAccount {
        self.name = dictionary["name"] as? String ?? self.name
        self.user = DAOUser(from: dictionary["user"] as! Dictionary<String, Any?>)

        let cards = dictionary["cards"] as? [[String: Any?]] ?? []
        self.cards = cards.map { DAOCard(from: $0) }

        _ = super.dao(from: dictionary)
        
        return self
    }
}
