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
        case body, cancelLabel, disclaimer, okayLabel, subTitle, title
    }

    public var body = DNSString()
    public var cancelLabel = DNSString()
    public var disclaimer = DNSString()
    public var okayLabel = DNSString()
    public var subTitle = DNSString()
    public var title = DNSString()

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
    required public init(from data: DNSDataDictionary) {
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
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decode(DNSString.self, forKey: .body)
        cancelLabel = try container.decode(DNSString.self, forKey: .cancelLabel)
        disclaimer = try container.decode(DNSString.self, forKey: .disclaimer)
        okayLabel = try container.decode(DNSString.self, forKey: .okayLabel)
        subTitle = try container.decode(DNSString.self, forKey: .subTitle)
        title = try container.decode(DNSString.self, forKey: .title)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
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
        return lhs.body != rhs.body
            || lhs.cancelLabel != rhs.cancelLabel
            || lhs.disclaimer != rhs.disclaimer
            || lhs.okayLabel != rhs.okayLabel
            || lhs.subTitle != rhs.subTitle
            || lhs.title != rhs.title
    }
}
