//
//  DAOAppAction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOAppAction: PTCLCFGBaseObject {
    var appActionType: DAOAppAction.Type { get }
    func appActionArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppAction] where K: CodingKey
}

public protocol PTCLCFGAppActionObject: PTCLCFGDAOAppActionImages, PTCLCFGDAOAppActionStrings {
}
public class CFGAppActionObject: PTCLCFGAppActionObject {
    public var appActionImagesType: DAOAppActionImages.Type = DAOAppActionImages.self
    public var appActionStringsType: DAOAppActionStrings.Type = DAOAppActionStrings.self

    open func appActionImagesArray<K>(from container: KeyedDecodingContainer<K>,
                                      forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionImages] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAppActionImages].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
    open func appActionStringsArray<K>(from container: KeyedDecodingContainer<K>,
                                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionStrings] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAppActionStrings].self, forKey: key,
                                                  configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOAppAction: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAppActionObject
    public static var config: Config = CFGAppActionObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createImages() -> DAOAppActionImages { config.appActionImagesType.init() }
    open class func createImages(from object: DAOAppActionImages) -> DAOAppActionImages { config.appActionImagesType.init(from: object) }
    open class func createImages(from data: DNSDataDictionary) -> DAOAppActionImages? { config.appActionImagesType.init(from: data) }

    open class func createStrings() -> DAOAppActionStrings { config.appActionStringsType.init() }
    open class func createStrings(from object: DAOAppActionStrings) -> DAOAppActionStrings { config.appActionStringsType.init(from: object) }
    open class func createStrings(from data: DNSDataDictionary) -> DAOAppActionStrings? { config.appActionStringsType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case actionType, deepLink, images, strings
    }

    open var actionType: DNSAppActionType = .popup
    open var deepLink: URL?
    @CodableConfiguration(from: DAOAppAction.self) open var images: DAOAppActionImages = DAOAppActionImages()
    @CodableConfiguration(from: DAOAppAction.self) open var strings: DAOAppActionStrings = DAOAppActionStrings()

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
        let imagesData = self.dictionary(from: data[field(.images)] as Any?)
        self.images = Self.createImages(from: imagesData) ?? self.images
        // strings section
        let stringsData = self.dictionary(from: data[field(.strings)] as Any?)
        self.strings = Self.createStrings(from: stringsData) ?? self.strings
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.actionType): self.actionType,
            field(.deepLink): self.deepLink,
            field(.images): self.images.asDictionary,
            field(.strings): self.strings.asDictionary,
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
        actionType = try container.decodeIfPresent(Swift.type(of: actionType), forKey: .actionType) ?? actionType
        deepLink = self.url(from: container, forKey: .deepLink) ?? deepLink
        images = self.daoAppActionImages(with: configuration, from: container, forKey: .images) ?? images
        strings = self.daoAppActionStrings(with: configuration, from: container, forKey: .strings) ?? strings

    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(actionType, forKey: .actionType)
        try container.encode(deepLink, forKey: .deepLink)
        try container.encode(images, forKey: .images, configuration: configuration)
        try container.encode(strings, forKey: .strings, configuration: configuration)
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
