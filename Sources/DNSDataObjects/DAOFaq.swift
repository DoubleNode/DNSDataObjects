//
//  DAOFaq.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOFaq: PTCLCFGBaseObject {
    var faqType: DAOFaq.Type { get }
    func faq<K>(from container: KeyedDecodingContainer<K>,
                forKey key: KeyedDecodingContainer<K>.Key) -> DAOFaq? where K: CodingKey
    func faqArray<K>(from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> [DAOFaq] where K: CodingKey
}

public protocol PTCLCFGFaqObject: PTCLCFGDAOFaqSection {
}
public class CFGFaqObject: PTCLCFGFaqObject {
    public var faqSectionType: DAOFaqSection.Type = DAOFaqSection.self
    open func faqSection<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOFaqSection? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOFaqSection.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func faqSectionArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOFaqSection] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOFaqSection].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOFaq: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGFaqObject
    public static var config: Config = CFGFaqObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createSection() -> DAOFaqSection { config.faqSectionType.init() }
    open class func createSection(from object: DAOFaqSection) -> DAOFaqSection { config.faqSectionType.init(from: object) }
    open class func createSection(from data: DNSDataDictionary) -> DAOFaqSection? { config.faqSectionType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case section, question, answer
    }

    @CodableConfiguration(from: DAOFaq.self) open var section: DAOFaqSection = DAOFaqSection()
    open var question = DNSString()
    open var answer = DNSString()

    // MARK: - Initializers -
    required public init() {
        section = Self.createSection()
        super.init()
    }
    required public init(id: String) {
        section = Self.createSection()
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
        section = Self.createSection()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOFaq) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.section = object.section.copy() as! DAOFaqSection
        self.question = object.question.copy() as! DNSString
        self.answer = object.answer.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        section = Self.createSection()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOFaq {
        _ = super.dao(from: data)
        let sectionData = self.dictionary(from: data[field(.section)] as Any?)
        self.section = Self.createSection(from: sectionData) ?? self.section
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
        fatalError("init(from:) has not been implemented")
    }
    override open func encode(to encoder: Encoder) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: DAOBaseObject.Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: Self.config)
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        try self.commonInit(from: decoder, configuration: configuration)
    }
    private func commonInit(from decoder: Decoder, configuration: Config) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        question = self.dnsstring(from: container, forKey: .question) ?? question
        answer = self.dnsstring(from: container, forKey: .answer) ?? answer
        section = self.daoFaqSection(with: configuration, from: container, forKey: .section) ?? section
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(section, forKey: .section, configuration: configuration)
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
        return super.isDiffFrom(rhs) ||
            lhs.section != rhs.section ||
            lhs.question != rhs.question ||
            lhs.answer != rhs.answer
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOFaq, rhs: DAOFaq) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOFaq, rhs: DAOFaq) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
