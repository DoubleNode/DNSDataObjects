//
//  DAOFaq.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOFaq: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var sectionType: DAOFaqSection.Type { return DAOFaqSection.self }

    open class func createSection() -> DAOFaqSection { sectionType.init() }
    open class func createSection(from object: DAOFaqSection) -> DAOFaqSection { sectionType.init(from: object) }
    open class func createSection(from data: DNSDataDictionary) -> DAOFaqSection { sectionType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case section, question, answer
    }

    open var section = DAOFaq.createSection()
    open var question = DNSString()
    open var answer = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
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
    required public init(from object: DAOFaq) {
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
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOFaq {
        _ = super.dao(from: data)
        let sectionData = self.datadictionary(from: data[field(.section)] as Any?) ?? [:]
        self.section = Self.createSection(from: sectionData)
        self.question = self.dnsstring(from: data[field(.question)] as Any?) ?? self.question
        self.answer = self.dnsstring(from: data[field(.answer)] as Any?) ?? self.answer
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.section): self.section.asDictionary,
            field(.question): self.question.asDictionary,
            field(.answer): self.answer.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        section = try container.decode(Self.sectionType.self, forKey: .section)
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
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.section != rhs.section
            || lhs.question != rhs.question
            || lhs.answer != rhs.answer
    }
}
