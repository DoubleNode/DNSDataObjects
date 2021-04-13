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
    public var favoritedActivityTypes: [DAOActivityType] = []
    open var myCenter: DAOCenter?

    private enum CodingKeys: String, CodingKey {
        case email, firstName, lastName, phone, dob, cards, favoritedActivityTypes, myCenter
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phone = try container.decode(String.self, forKey: .phone)
        dob = try container.decode(Date.self, forKey: .dob)
        cards = try container.decode([DAOCard].self, forKey: .cards)
        favoritedActivityTypes = try container.decode([DAOActivityType].self, forKey: .favoritedActivityTypes)
        myCenter = try container.decode(DAOCenter.self, forKey: .myCenter)

        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phone, forKey: .phone)
        try container.encode(dob, forKey: .dob)
        try container.encode(cards, forKey: .cards)
        try container.encode(favoritedActivityTypes, forKey: .favoritedActivityTypes)
        try container.encode(myCenter, forKey: .myCenter)
    }

    override public init() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.phone = ""
        self.dob = nil
        super.init()
    }
    override public init(id: String) {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.phone = ""
        self.dob = nil
        super.init(id: id)
    }
    override public init(from dictionary: Dictionary<String, Any?>) {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.phone = ""
        self.dob = nil
        super.init()
        _ = self.dao(from: dictionary)
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
    public init(id: String, email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = ""
        self.dob = nil
        super.init(id: id)
    }

    open func update(from object: DAOUser) {
        self.email = object.email
        self.firstName = object.firstName
        self.lastName = object.lastName
        self.phone = object.phone
        self.dob = object.dob
        self.cards = object.cards
        self.favoritedActivityTypes = object.favoritedActivityTypes
        self.myCenter = object.myCenter
        super.update(from: object)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOUser {
        self.email = self.string(from: dictionary["email"]  as Any?) ?? self.email
        self.firstName = self.string(from: dictionary["firstName"] as Any?) ?? self.firstName
        self.lastName = self.string(from: dictionary["lastName"] as Any?) ?? self.lastName
        self.phone = self.string(from: dictionary["phone"] as Any?) ?? self.phone
        self.dob = self.date(from: dictionary["dateOfBirth"] as Any?) ?? self.dob

        let cards = dictionary["cards"] as? [[String: Any?]] ?? []
        self.cards = cards.map { DAOCard(from: $0) }

        _ = super.dao(from: dictionary)
        return self
    }
    override open func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "email": self.email,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "phone": self.phone,
            "dateOfBirth": self.dob?.dnsDate() ?? "",
        ]) { (current, _) in current }
        return retval
    }
}
