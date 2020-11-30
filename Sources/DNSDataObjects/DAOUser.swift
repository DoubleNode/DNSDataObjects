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

    private enum CodingKeys: String, CodingKey {
        case email, firstName, lastName, phone, dob, cards, favoritedActivities, myCenter
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        phone = try container.decode(String.self, forKey: .phone)
        dob = try container.decode(Date.self, forKey: .dob)
        cards = try container.decode([DAOCard].self, forKey: .cards)
        favoritedActivities = try container.decode([DAOActivity].self, forKey: .favoritedActivities)
        myCenter = try container.decode(DAOCenter.self, forKey: .myCenter)

        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }

    public override init() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.phone = ""
        self.dob = nil

        super.init()
    }

    public init(id: String, email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = ""
        self.dob = nil

        super.init(id: id)
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

    open override func dictionary() -> [String: Any?] {
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
