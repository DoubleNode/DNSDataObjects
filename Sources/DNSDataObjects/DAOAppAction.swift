//
//  DAOAppAction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAppAction: DAOBaseObject, NSCopying {
    public enum ActionType: String, CaseIterable, Codable {
        case popup
    }

    public var actionType: ActionType = .popup
    public var body: DNSString = DNSString()
    public var cancelLabel: DNSString = DNSString()
    public var deepLink: URL?
    public var disclaimer: DNSString = DNSString()
    public var imageUrl: DNSURL = DNSURL()
    public var okayLabel: DNSString = DNSString()
    public var subTitle: DNSString = DNSString()
    public var title: DNSString = DNSString()

    // TODO: Finish adding Coding Keys
    public enum CodingKeys: String, CodingKey {
        case actionType, body, cancelLabel, deepLink, disclaimer,
             imageUrl, okayLabel, subTitle, title
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        actionType = try container.decode(ActionType.self, forKey: .actionType)
        body = try container.decode(DNSString.self, forKey: .body)
        cancelLabel = try container.decode(DNSString.self, forKey: .cancelLabel)
        deepLink = try container.decode(URL.self, forKey: .deepLink)
        disclaimer = try container.decode(DNSString.self, forKey: .disclaimer)
        imageUrl = try container.decode(DNSURL.self, forKey: .imageUrl)
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
        try container.encode(actionType, forKey: .actionType)
        try container.encode(body, forKey: .body)
        try container.encode(cancelLabel, forKey: .cancelLabel)
        try container.encode(deepLink, forKey: .deepLink)
        try container.encode(disclaimer, forKey: .disclaimer)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(okayLabel, forKey: .okayLabel)
        try container.encode(subTitle, forKey: .subTitle)
        try container.encode(title, forKey: .title)
    }

    override public init() {
        super.init()
    }
    public init(from object: DAOAppAction) {
        super.init(from: object)
        self.update(from: object)
    }
    override public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }

    open func update(from object: DAOAppAction) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.actionType = object.actionType
        self.body = object.body.copy() as! DNSString
        self.cancelLabel = object.cancelLabel.copy() as! DNSString
        self.deepLink = object.deepLink
        self.disclaimer = object.disclaimer.copy() as! DNSString
        self.imageUrl = object.imageUrl.copy() as! DNSURL
        self.okayLabel = object.okayLabel.copy() as! DNSString
        self.subTitle = object.subTitle.copy() as! DNSString
        self.title = object.title.copy() as! DNSString
        // swiftlint:enable force_cast
    }

    // NSCopying protocol methods
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppAction(from: self)
        return copy
    }
    override open func dao(from dictionary: [String: Any?]) -> DAOAppAction {
        _ = super.dao(from: dictionary)
        self.deepLink = self.url(from: dictionary["deepLink"] as Any?) ?? self.deepLink
        let typeString = self.string(from: dictionary["type"] as Any?) ?? "popup"
        self.actionType = ActionType(rawValue: typeString) ?? .popup

        var stringsData = dictionary["strings"] as? [String: Any] ?? [:]
        if stringsData.isEmpty {
            stringsData = dictionary as [String : Any]
        }
        self.body = self.dnsstring(from: stringsData["description"] as Any?) ?? self.body
        self.cancelLabel = self.dnsstring(from: stringsData["cancelLabel"] as Any?) ?? self.cancelLabel
        self.disclaimer = self.dnsstring(from: stringsData["disclaimer"] as Any?) ?? self.disclaimer
        self.okayLabel = self.dnsstring(from: stringsData["okayLabel"] as Any?) ?? self.okayLabel
        self.subTitle = self.dnsstring(from: stringsData["subtitle"] as Any?) ?? self.subTitle
        self.title = self.dnsstring(from: stringsData["title"] as Any?) ?? self.title

        let imagesData = dictionary["images"] as? [String: Any] ?? [:]
        self.imageUrl = self.dnsurl(from: imagesData["top"]) ?? self.imageUrl
        return self
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppAction else { return true }
        let lhs = self
        return lhs.actionType != rhs.actionType
            || lhs.body != rhs.body
            || lhs.cancelLabel != rhs.cancelLabel
            || lhs.deepLink != rhs.deepLink
            || lhs.disclaimer != rhs.disclaimer
            || lhs.imageUrl != rhs.imageUrl
            || lhs.okayLabel != rhs.okayLabel
            || lhs.subTitle != rhs.subTitle
            || lhs.title != rhs.title
    }
}
