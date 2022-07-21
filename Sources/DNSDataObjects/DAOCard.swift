//
//  DAOCard.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAOCard: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case cardNumber, nickname, pinNumber
    }

    public var cardNumber: String = ""
    public var nickname: String = ""
    public var pinNumber: String = ""

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    override public init(id: String) {
        super.init(id: id)
    }
    public init(cardNumber: String, nickname: String, pinNumber: String) {
        self.cardNumber = cardNumber
        self.nickname = nickname
        self.pinNumber = pinNumber
        super.init(id: cardNumber)
    }

    // MARK: - DAO copy methods -
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

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOCard {
        _ = super.dao(from: dictionary)
        self.cardNumber = self.string(from: dictionary[CodingKeys.cardNumber.rawValue] as Any?) ?? self.cardNumber
        self.nickname = self.string(from: dictionary[CodingKeys.nickname.rawValue] as Any?) ?? self.nickname
        self.pinNumber = self.string(from: dictionary[CodingKeys.pinNumber.rawValue] as Any?) ?? self.pinNumber
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.cardNumber.rawValue: self.cardNumber,
            CodingKeys.nickname.rawValue: self.nickname,
            CodingKeys.pinNumber.rawValue: self.pinNumber,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cardNumber = try container.decode(String.self, forKey: .cardNumber)
        nickname = try container.decode(String.self, forKey: .nickname)
        pinNumber = try container.decode(String.self, forKey: .pinNumber)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(pinNumber, forKey: .pinNumber)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOCard(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOCard else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.cardNumber != rhs.cardNumber
            || lhs.nickname != rhs.nickname
            || lhs.pinNumber != rhs.pinNumber
    }
}
