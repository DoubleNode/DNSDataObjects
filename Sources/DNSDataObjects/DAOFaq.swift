//
//  DAOFaq.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOFaq: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case section, question, answer
    }

    public var section = DAOFaqSection()
    public var question = DNSString()
    public var answer = DNSString()

    // MARK: - Initializers -
    override public init() {
        super.init()
    }
    public init(section: DAOFaqSection,
                question: DNSString,
                answer: DNSString) {
        self.section = section
        self.question = question
        self.answer = answer
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOFaq) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOFaq) {
        super.update(from: object)
        self.section = object.section
        self.question = object.question
        self.answer = object.answer
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOFaq {
        _ = super.dao(from: dictionary)
        let sectionData = dictionary[CodingKeys.section.rawValue] as? [String: Any?] ?? [:]
        self.section = DAOFaqSection(from: sectionData)
        self.question = self.dnsstring(from: dictionary[CodingKeys.question.rawValue] as Any?) ?? self.question
        self.answer = self.dnsstring(from: dictionary[CodingKeys.answer.rawValue] as Any?) ?? self.answer
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.section.rawValue: self.section.asDictionary,
            CodingKeys.question.rawValue: self.question.asDictionary,
            CodingKeys.answer.rawValue: self.answer.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        section = try container.decode(DAOFaqSection.self, forKey: .section)
        question = try container.decode(DNSString.self, forKey: .question)
        answer = try container.decode(DNSString.self, forKey: .answer)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(section, forKey: .section)
        try container.encode(question, forKey: .question)
        try container.encode(answer, forKey: .answer)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOFaq(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOFaq else { return true }
        let lhs = self
        return lhs.section != rhs.section
            || lhs.question != rhs.question
            || lhs.answer != rhs.answer
    }
}
