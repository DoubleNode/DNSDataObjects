//
//  DAOUser.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOUser: DAOBaseObject {
    public var email: String
    public var firstName: String
    public var lastName: String
    public var phone: String = ""
    public var dob: Date?
    public var cards: [DAOCard] = []
    public var favoritedActivities: [DAOActivity] = []
    public var myCenter: DAOCenter?

    public override init() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.phone = ""
        self.dob = nil

        super.init()
    }

    public init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = ""
        self.dob = nil

        super.init(id: email)
    }

    public init(from object: DAOUser) {
        self.email = object.email
        self.firstName = object.firstName
        self.lastName = object.lastName
        self.phone = object.phone
        self.dob = object.dob
        self.cards = object.cards

        super.init(from: object)
    }

    public override init(from dictionary: Dictionary<String, Any?>) {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.phone = ""
        self.dob = nil

        super.init()

        _ = self.dao(from: dictionary)
    }

    open func update(from object: DAOUser) {
        self.email = object.email
        self.firstName = object.firstName
        self.lastName = object.lastName
        self.phone = object.phone
        self.dob = object.dob
        self.cards = object.cards
        self.favoritedActivities = object.favoritedActivities
        self.myCenter = object.myCenter

        super.update(from: object)
    }

    open override func dao(from dictionary: [String: Any?]) -> DAOUser {
        self.email = self.string(from: dictionary["email"] ?? self.email)!
        self.firstName = self.string(from: dictionary["firstName"] ?? self.firstName)!
        self.lastName = self.string(from: dictionary["lastName"] ?? self.lastName)!
        self.phone = self.string(from: dictionary["phone"] ?? self.phone)!
        self.dob = self.date(from: dictionary["dateOfBirth"] ?? self.dob)

        let cards = dictionary["cards"] as? [[String: Any?]] ?? []
        self.cards = cards.map { DAOCard(from: $0) }

        _ = super.dao(from: dictionary)
        
        return self
    }
}
