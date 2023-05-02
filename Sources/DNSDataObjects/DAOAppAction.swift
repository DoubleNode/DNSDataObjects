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
    func appAction<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppAction? where K: CodingKey
    func appActionArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppAction] where K: CodingKey
}

public protocol PTCLCFGAppActionObject: PTCLCFGDAOAppActionColors, PTCLCFGDAOAppActionImages, PTCLCFGDAOAppActionStrings {
}
public class CFGAppActionObject: PTCLCFGAppActionObject {
    public var appActionColorsType: DAOAppActionColors.Type = DAOAppActionColors.self
    public var appActionImagesType: DAOAppActionImages.Type = DAOAppActionImages.self
    public var appActionStringsType: DAOAppActionStrings.Type = DAOAppActionStrings.self

    open func appActionColors<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionColors? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAppActionColors.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func appActionImages<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionImages? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAppActionImages.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func appActionStrings<K>(from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionStrings? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAppActionStrings.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }

    open func appActionColorsArray<K>(from container: KeyedDecodingContainer<K>,
                                      forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionColors] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAppActionColors].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func appActionImagesArray<K>(from container: KeyedDecodingContainer<K>,
                                      forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionImages] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAppActionImages].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
    open func appActionStringsArray<K>(from container: KeyedDecodingContainer<K>,
                                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionStrings] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAppActionStrings].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOAppAction: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAppActionObject
    public static var config: Config = CFGAppActionObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAppActionColors() -> DAOAppActionColors { config.appActionColorsType.init() }
    open class func createAppActionColors(from object: DAOAppActionColors) -> DAOAppActionColors { config.appActionColorsType.init(from: object) }
    open class func createAppActionColors(from data: DNSDataDictionary) -> DAOAppActionColors? { config.appActionColorsType.init(from: data) }

    open class func createAppActionImages() -> DAOAppActionImages { config.appActionImagesType.init() }
    open class func createAppActionImages(from object: DAOAppActionImages) -> DAOAppActionImages { config.appActionImagesType.init(from: object) }
    open class func createAppActionImages(from data: DNSDataDictionary) -> DAOAppActionImages? { config.appActionImagesType.init(from: data) }

    open class func createAppActionStrings() -> DAOAppActionStrings { config.appActionStringsType.init() }
    open class func createAppActionStrings(from object: DAOAppActionStrings) -> DAOAppActionStrings { config.appActionStringsType.init(from: object) }
    open class func createAppActionStrings(from data: DNSDataDictionary) -> DAOAppActionStrings? { config.appActionStringsType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case actionType, colors, deepLink, images, strings
    }

    open var actionType: DNSAppActionType = .popup
    open var deepLink: URL?
    @CodableConfiguration(from: DAOAppAction.self) open var colors: DAOAppActionColors = DAOAppActionColors()
    @CodableConfiguration(from: DAOAppAction.self) open var images: DAOAppActionImages = DAOAppActionImages()
    @CodableConfiguration(from: DAOAppAction.self) open var strings: DAOAppActionStrings = DAOAppActionStrings()

    // MARK: - Initializers -
    required public init() {
        colors = Self.createAppActionColors()
        images = Self.createAppActionImages()
        strings = Self.createAppActionStrings()
        super.init()
    }
    required public init(id: String) {
        colors = Self.createAppActionColors()
        images = Self.createAppActionImages()
        strings = Self.createAppActionStrings()
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppAction) {
        colors = Self.createAppActionColors()
        images = Self.createAppActionImages()
        strings = Self.createAppActionStrings()
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppAction) {
        super.update(from: object)
        self.actionType = object.actionType
        self.deepLink = object.deepLink
        // swiftlint:disable force_cast
        self.colors = object.colors.copy() as! DAOAppActionColors
        self.images = object.images.copy() as! DAOAppActionImages
        self.strings = object.strings.copy() as! DAOAppActionStrings
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        colors = Self.createAppActionColors()
        images = Self.createAppActionImages()
        strings = Self.createAppActionStrings()
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppAction {
        _ = super.dao(from: data)
        let typeString = self.string(from: data[field(.actionType)] as Any?) ?? ""
        self.actionType = DNSAppActionType(rawValue: typeString) ?? .popup
        self.deepLink = self.url(from: data[field(.deepLink)] as Any?) ?? self.deepLink
        // colors section
        let colorsData = self.dictionary(from: data[field(.colors)] as Any?)
        self.colors = Self.createAppActionColors(from: colorsData) ?? self.colors
        // images section
        let imagesData = self.dictionary(from: data[field(.images)] as Any?)
        self.images = Self.createAppActionImages(from: imagesData) ?? self.images
        // strings section
        let stringsData = self.dictionary(from: data[field(.strings)] as Any?)
        self.strings = Self.createAppActionStrings(from: stringsData) ?? self.strings
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.actionType): self.actionType,
            field(.deepLink): self.deepLink,
            field(.colors): self.colors.asDictionary,
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
        colors = self.daoAppActionColors(with: configuration, from: container, forKey: .colors) ?? colors
        images = self.daoAppActionImages(with: configuration, from: container, forKey: .images) ?? images
        strings = self.daoAppActionStrings(with: configuration, from: container, forKey: .strings) ?? strings

    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(actionType, forKey: .actionType)
        try container.encode(deepLink, forKey: .deepLink)
        try container.encode(colors, forKey: .colors, configuration: configuration)
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
            lhs.colors != rhs.colors ||
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
