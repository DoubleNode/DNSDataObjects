//
//  DAOAppAction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAppAction: DAOBaseObject {
    public enum CodingKeys: String, CodingKey {
        case actionType, body, cancelLabel, deepLink, disclaimer,
             topImageUrl, okayLabel, subTitle, title
        case images, strings
    }

    public var actionType: DNSActionType = .popup
    public var body: DNSString = DNSString()
    public var cancelLabel: DNSString = DNSString()
    public var deepLink: URL?
    public var disclaimer: DNSString = DNSString()
    public var okayLabel: DNSString = DNSString()
    public var subTitle: DNSString = DNSString()
    public var title: DNSString = DNSString()
    public var topImageUrl: DNSURL = DNSURL()

    // MARK: - Initializers -
    override public init() {
        super.init()
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOAppAction) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppAction) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.actionType = object.actionType
        self.body = object.body.copy() as! DNSString
        self.cancelLabel = object.cancelLabel.copy() as! DNSString
        self.deepLink = object.deepLink
        self.disclaimer = object.disclaimer.copy() as! DNSString
        self.okayLabel = object.okayLabel.copy() as! DNSString
        self.subTitle = object.subTitle.copy() as! DNSString
        self.title = object.title.copy() as! DNSString
        self.topImageUrl = object.topImageUrl.copy() as! DNSURL
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOAppAction {
        _ = super.dao(from: dictionary)
        let typeString = self.string(from: dictionary[CodingKeys.actionType.rawValue] as Any?) ?? ""
        self.actionType = DNSActionType(rawValue: typeString) ?? .popup
        self.deepLink = self.url(from: dictionary[CodingKeys.deepLink.rawValue] as Any?) ?? self.deepLink

        var stringsData = dictionary[CodingKeys.strings.rawValue] as? [String: Any] ?? [:]
        if stringsData.isEmpty {
            stringsData = dictionary as [String : Any]
        }
        self.body = self.dnsstring(from: stringsData[CodingKeys.body.rawValue] as Any?) ?? self.body
        self.cancelLabel = self.dnsstring(from: stringsData[CodingKeys.cancelLabel.rawValue] as Any?) ?? self.cancelLabel
        self.disclaimer = self.dnsstring(from: stringsData[CodingKeys.disclaimer.rawValue] as Any?) ?? self.disclaimer
        self.okayLabel = self.dnsstring(from: stringsData[CodingKeys.okayLabel.rawValue] as Any?) ?? self.okayLabel
        self.subTitle = self.dnsstring(from: stringsData[CodingKeys.subTitle.rawValue] as Any?) ?? self.subTitle
        self.title = self.dnsstring(from: stringsData[CodingKeys.title.rawValue] as Any?) ?? self.title

        let imagesData = dictionary[CodingKeys.images.rawValue] as? [String: Any] ?? [:]
        self.topImageUrl = self.dnsurl(from: imagesData[CodingKeys.topImageUrl.rawValue]) ?? self.topImageUrl
        return self
    }
    override open var asDictionary: [String: Any?] {
        var retval = super.asDictionary
        retval.merge([
            CodingKeys.deepLink.rawValue: self.deepLink,
            CodingKeys.actionType.rawValue: self.actionType,
            CodingKeys.strings.rawValue: [
                CodingKeys.body.rawValue: self.body,
                CodingKeys.cancelLabel.rawValue: self.cancelLabel,
                CodingKeys.disclaimer.rawValue: self.disclaimer,
                CodingKeys.okayLabel.rawValue: self.okayLabel,
                CodingKeys.subTitle.rawValue: self.subTitle,
                CodingKeys.title.rawValue: self.title,
            ],
            CodingKeys.images.rawValue: [
                CodingKeys.topImageUrl.rawValue: self.topImageUrl,
            ],
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        actionType = try container.decode(DNSActionType.self, forKey: .actionType)
        body = try container.decode(DNSString.self, forKey: .body)
        cancelLabel = try container.decode(DNSString.self, forKey: .cancelLabel)
        deepLink = try container.decode(URL.self, forKey: .deepLink)
        disclaimer = try container.decode(DNSString.self, forKey: .disclaimer)
        okayLabel = try container.decode(DNSString.self, forKey: .okayLabel)
        subTitle = try container.decode(DNSString.self, forKey: .subTitle)
        title = try container.decode(DNSString.self, forKey: .title)
        topImageUrl = try container.decode(DNSURL.self, forKey: .topImageUrl)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(actionType, forKey: .actionType)
        try container.encode(body, forKey: .body)
        try container.encode(cancelLabel, forKey: .cancelLabel)
        try container.encode(deepLink, forKey: .deepLink)
        try container.encode(disclaimer, forKey: .disclaimer)
        try container.encode(okayLabel, forKey: .okayLabel)
        try container.encode(subTitle, forKey: .subTitle)
        try container.encode(title, forKey: .title)
        try container.encode(topImageUrl, forKey: .topImageUrl)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppAction(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppAction else { return true }
        let lhs = self
        return lhs.actionType != rhs.actionType
            || lhs.body != rhs.body
            || lhs.cancelLabel != rhs.cancelLabel
            || lhs.deepLink != rhs.deepLink
            || lhs.disclaimer != rhs.disclaimer
            || lhs.okayLabel != rhs.okayLabel
            || lhs.subTitle != rhs.subTitle
            || lhs.title != rhs.title
            || lhs.topImageUrl != rhs.topImageUrl
    }
}
