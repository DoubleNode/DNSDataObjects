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
    open class var faqType: DAOFaq.Type { DAOFaq.self }

    open class func createFaq() -> DAOFaq { faqType.init() }
    open class func createFaq(from object: DAOFaq) -> DAOFaq { faqType.init(from: object) }
    open class func createFaq(from data: DNSDataDictionary) -> DAOFaq? { faqType.init(from: data) }

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
        self.icon = object.icon
        self.title = object.title
        // swiftlint:disable force_cast
        self.faqs = object.faqs.map { $0.copy() as! DAOFaq }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOFaqSection {
        _ = super.dao(from: data)
        self.code = self.string(from: data[field(.code)] as Any?) ?? self.code
        let faqsData = self.dataarray(from: data[field(.faqs)] as Any?)
        self.faqs = faqsData.compactMap { Self.createFaq(from: $0) }
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
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = self.string(from: container, forKey: .code) ?? code
        icon = self.string(from: container, forKey: .icon) ?? icon
        title = self.dnsstring(from: container, forKey: .title) ?? title

        faqs = try container.decodeIfPresent(Swift.type(of: faqs), forKey: .faqs) ?? faqs
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
        return super.isDiffFrom(rhs) ||
            lhs.code != rhs.code ||
            lhs.faqs != rhs.faqs ||
            lhs.icon != rhs.icon ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOFaqSection, rhs: DAOFaqSection) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOFaqSection, rhs: DAOFaqSection) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
