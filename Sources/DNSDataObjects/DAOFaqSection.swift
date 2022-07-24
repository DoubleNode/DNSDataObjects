//
//  DAOFaqSection.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOFaqSection: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var faqType: DAOFaq.Type { return DAOFaq.self }

    open class func createFaq() -> DAOFaq { faqType.init() }
    open class func createFaq(from object: DAOFaq) -> DAOFaq { faqType.init(from: object) }
    open class func createFaq(from data: DNSDataDictionary) -> DAOFaq { faqType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case code, faqs, icon, title
    }

    open var code = ""
    open var faqs: [DAOFaq] = []
    open var icon = ""
    open var title = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(code: String, title: DNSString, icon: String) {
        self.code = code
        self.icon = icon
        self.title = title
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOFaqSection) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOFaqSection) {
        super.update(from: object)
        self.code = object.code
        self.faqs = object.faqs
        self.icon = object.icon
        self.title = object.title
    }

    // MARK: - DAO translation methods -
    required public init(from data: DNSDataDictionary) {
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOFaqSection {
        _ = super.dao(from: data)
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        let faqsData = data[field(.faqs)] as? [DNSDataDictionary] ?? []
        self.faqs = faqsData.map { Self.createFaq(from: $0) }
        self.icon = self.string(from: data[field(.icon)] as Any?) ?? self.icon
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.code): self.code,
            field(.faqs): self.faqs.map { $0.asDictionary },
            field(.icon): self.icon,
            field(.title): self.title.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        faqs = try container.decode([DAOFaq].self, forKey: .faqs)
        icon = try container.decode(String.self, forKey: .icon)
        title = try container.decode(DNSString.self, forKey: .title)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(faqs, forKey: .faqs)
        try container.encode(icon, forKey: .icon)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOFaqSection(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOFaqSection else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return lhs.code != rhs.code
            || lhs.faqs != rhs.faqs
            || lhs.icon != rhs.icon
            || lhs.title != rhs.title
    }
}
