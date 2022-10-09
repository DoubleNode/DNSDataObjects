//
//  DAOAppActionStrings.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAppActionStrings: DAOBaseObject {
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case cancelLabel, disclaimer, okayLabel, subTitle, title
        case body = "description"
    }

    open var body = DNSString()
    open var cancelLabel = DNSString()
    open var disclaimer = DNSString()
    open var okayLabel = DNSString()
    open var subTitle = DNSString()
    open var title = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppActionStrings) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppActionStrings) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.body = object.body.copy() as! DNSString
        self.cancelLabel = object.cancelLabel.copy() as! DNSString
        self.disclaimer = object.disclaimer.copy() as! DNSString
        self.okayLabel = object.okayLabel.copy() as! DNSString
        self.subTitle = object.subTitle.copy() as! DNSString
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppActionStrings {
        _ = super.dao(from: data)
        self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
        self.cancelLabel = self.dnsstring(from: data[field(.cancelLabel)] as Any?) ?? self.cancelLabel
        self.disclaimer = self.dnsstring(from: data[field(.disclaimer)] as Any?) ?? self.disclaimer
        self.okayLabel = self.dnsstring(from: data[field(.okayLabel)] as Any?) ?? self.okayLabel
        self.subTitle = self.dnsstring(from: data[field(.subTitle)] as Any?) ?? self.subTitle
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.body): self.body.asDictionary,
            field(.cancelLabel): self.cancelLabel.asDictionary,
            field(.disclaimer): self.disclaimer.asDictionary,
            field(.okayLabel): self.okayLabel.asDictionary,
            field(.subTitle): self.subTitle.asDictionary,
            field(.title): self.title.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = self.dnsstring(from: container, forKey: .body) ?? body
        cancelLabel = self.dnsstring(from: container, forKey: .cancelLabel) ?? cancelLabel
        disclaimer = self.dnsstring(from: container, forKey: .disclaimer) ?? disclaimer
        okayLabel = self.dnsstring(from: container, forKey: .okayLabel) ?? okayLabel
        subTitle = self.dnsstring(from: container, forKey: .subTitle) ?? subTitle
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(body, forKey: .body)
        try container.encode(cancelLabel, forKey: .cancelLabel)
        try container.encode(disclaimer, forKey: .disclaimer)
        try container.encode(okayLabel, forKey: .okayLabel)
        try container.encode(subTitle, forKey: .subTitle)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppActionStrings(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppActionStrings else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.body != rhs.body ||
            lhs.cancelLabel != rhs.cancelLabel ||
            lhs.disclaimer != rhs.disclaimer ||
            lhs.okayLabel != rhs.okayLabel ||
            lhs.subTitle != rhs.subTitle ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAppActionStrings, rhs: DAOAppActionStrings) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAppActionStrings, rhs: DAOAppActionStrings) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
