//
//  DAOAppAction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

open class DAOAppAction: DAOBaseObject {
    // MARK: - Class Factory methods -
    open class var imagesType: DAOAppActionImages.Type { return DAOAppActionImages.self }
    open class var stringsType: DAOAppActionStrings.Type { return DAOAppActionStrings.self }

    open class func createImages() -> DAOAppActionImages { imagesType.init() }
    open class func createImages(from object: DAOAppActionImages) -> DAOAppActionImages { imagesType.init(from: object) }
    open class func createImages(from data: DNSDataDictionary) -> DAOAppActionImages? { imagesType.init(from: data) }

    open class func createStrings() -> DAOAppActionStrings { stringsType.init() }
    open class func createStrings(from object: DAOAppActionStrings) -> DAOAppActionStrings { stringsType.init(from: object) }
    open class func createStrings(from data: DNSDataDictionary) -> DAOAppActionStrings? { stringsType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case actionType, deepLink
        case imagesSection = "images"
        case stringsSection = "strings"
    }

    open var actionType: DNSAppActionType = .popup
    open var deepLink: URL?
    open var images: DAOAppActionImages
    open var strings: DAOAppActionStrings

    // MARK: - Initializers -
    required public init() {
        images = Self.createImages()
        strings = Self.createStrings()
        super.init()
    }
    required public init(id: String) {
        images = Self.createImages()
        strings = Self.createStrings()
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppAction) {
        images = Self.createImages()
        strings = Self.createStrings()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppAction) {
        super.update(from: object)
        self.actionType = object.actionType
        self.deepLink = object.deepLink
        // swiftlint:disable force_cast
        self.images = object.images.copy() as! DAOAppActionImages
        self.strings = object.strings.copy() as! DAOAppActionStrings
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        images = Self.createImages()
        strings = Self.createStrings()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppAction {
        _ = super.dao(from: data)
        let typeString = self.string(from: data[field(.actionType)] as Any?) ?? ""
        self.actionType = DNSAppActionType(rawValue: typeString) ?? .popup
        self.deepLink = self.url(from: data[field(.deepLink)] as Any?) ?? self.deepLink
        // images section
        let imagesSection = self.dictionary(from: data[field(.imagesSection)] as Any?)
        self.images = Self.createImages(from: imagesSection) ?? self.images
        // strings section
        let stringsSection = self.dictionary(from: data[field(.stringsSection)] as Any?)
        self.strings = Self.createStrings(from: stringsSection) ?? self.strings
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.actionType): self.actionType,
            field(.deepLink): self.deepLink,
            field(.imagesSection): self.images.asDictionary,
            field(.stringsSection): self.strings.asDictionary,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        images = Self.createImages()
        strings = Self.createStrings()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        actionType = try container.decode(DNSAppActionType.self, forKey: .actionType)
        deepLink = try container.decode(URL.self, forKey: .deepLink)
        images = try container.decode(Self.imagesType.self, forKey: .imagesSection)
        strings = try container.decode(Self.stringsType.self, forKey: .stringsSection)
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(actionType, forKey: .actionType)
        try container.encode(deepLink, forKey: .deepLink)
        try container.encode(images, forKey: .imagesSection)
        try container.encode(strings, forKey: .stringsSection)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppAction(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppAction else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.actionType != rhs.actionType ||
            lhs.deepLink != rhs.deepLink ||
            lhs.images != rhs.images ||
            lhs.strings != rhs.strings
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAppAction, rhs: DAOAppAction) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAppAction, rhs: DAOAppAction) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
