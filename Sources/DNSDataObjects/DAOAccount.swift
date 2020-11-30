//
//  DAOAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOAccount: DAOBaseObject {
    public var name: String
    public var user: DAOUser?
    public var cards: [DAOCard] = []

    private enum CodingKeys: String, CodingKey {
        case name, user, cards
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        user = try container.decode(DAOUser.self, forKey: .user)
        cards = try container.decode([DAOCard].self, forKey: .cards)

        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }

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

    open func update(from object: DAOAccount) {
        self.name = object.name
        self.user = object.user
        self.cards = object.cards

        super.update(from: object)
    }

    open override func dao(from dictionary: [String: Any?]) -> DAOAccount {
        self.name = self.string(from: dictionary["name"] as Any?) ?? self.name
        self.user = DAOUser(from: dictionary["user"] as? [String: Any?] ?? [:])

        let cards = dictionary["cards"] as? [[String: Any?]] ?? []
        self.cards = cards.map { DAOCard(from: $0) }

        _ = super.dao(from: dictionary)
        
        return self
    }

    open override func dictionary() -> [String: Any?] {
        var retval = super.dictionary()
        retval.merge([
            "name": self.name,
            "user": self.user?.dictionary(),
            "cards": self.cards.map { $0.dictionary() },
        ]) { (current, _) in current }
        return retval
    }
}
