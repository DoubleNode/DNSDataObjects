//
//  DAOUser.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

open class DAOUser: DAOBaseObject {
    public var email: String
    public var firstName: String
    public var lastName: String
    public var cards: [DAOCard] = []

    public override init() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""

        super.init()
    }

    public init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName

        super.init(id: email)
    }
    
    public init(from object: DAOUser) {
        self.email = object.email
        self.firstName = object.firstName
        self.lastName = object.lastName
        self.cards = object.cards

        super.init(from: object)
    }

    public override init(from dictionary: Dictionary<String, Any?>) {
        self.email = ""
        self.firstName = ""
        self.lastName = ""

        super.init()

        _ = self.dao(from: dictionary)
    }

    open func update(from object: DAOUser) {
        self.email = object.email
        self.firstName = object.firstName
        self.lastName = object.lastName
        self.cards = object.cards

        super.update(from: object)
    }

    open override func dao(from dictionary: [String: Any?]) -> DAOUser {
        self.email = dictionary["email"] as? String ?? self.email
        self.firstName = dictionary["firstName"] as? String ?? self.firstName
        self.lastName = dictionary["lastName"] as? String ?? self.lastName
        
        let cards = dictionary["cards"] as? [[String: Any?]] ?? []
        self.cards = cards.map { DAOCard(from: $0) }

        _ = super.dao(from: dictionary)
        
        return self
    }
}
