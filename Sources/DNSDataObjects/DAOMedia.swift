//
//  DAOMedia.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOMedia: PTCLCFGBaseObject {
    var mediaType: DAOMedia.Type { get }
    func media<K>(from container: KeyedDecodingContainer<K>,
                  forKey key: KeyedDecodingContainer<K>.Key) -> DAOMedia? where K: CodingKey
    func mediaArray<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> [DAOMedia] where K: CodingKey
}

public protocol PTCLCFGMediaObject: PTCLCFGDAOMedia {
}
public class CFGMediaObject: PTCLCFGMediaObject {
    public var mediaType: DAOMedia.Type = DAOMedia.self
    open func media<K>(from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOMedia? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOMedia.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func mediaArray<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOMedia] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOMedia].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }
}
open class DAOMedia: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGMediaObject
    public static var config: Config = CFGMediaObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createMedia() -> DAOMedia { config.mediaType.init() }
    open class func createMedia(from object: DAOMedia) -> DAOMedia { config.mediaType.init(from: object) }
    open class func createMedia(from data: DNSDataDictionary) -> DAOMedia? { config.mediaType.init(from: data) }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case path, preloadUrl, title, type, url
    }

    open var path = ""
    open var preloadUrl = DNSURL()
    open var title = DNSString()
    open var type: DNSMediaType = .unknown
    open var url = DNSURL()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(type: DNSMediaType) {
        self.type = type
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOMedia) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOMedia) {
        super.update(from: object)
        self.path = object.path
        self.type = object.type
        // swiftlint:disable force_cast
        self.preloadUrl = object.preloadUrl.copy() as! DNSURL
        self.title = object.title.copy() as! DNSString
        self.url = object.url.copy() as! DNSURL
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOMedia {
        _ = super.dao(from: data)
        let typeData = self.string(from: data[field(.type)] as Any?) ?? self.type.rawValue
        self.path = self.string(from: data[field(.path)] as Any?) ?? self.path
        self.preloadUrl = self.dnsurl(from: data[field(.preloadUrl)] as Any?) ?? self.preloadUrl
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        self.type = DNSMediaType(rawValue: typeData) ?? .unknown
        self.url = self.dnsurl(from: data[field(.url)] as Any?) ?? self.url
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.path): self.path,
            field(.preloadUrl): self.preloadUrl.asDictionary,
            field(.title): self.title.asDictionary,
            field(.type): self.type.rawValue,
            field(.url): self.url.asDictionary,
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
        path = try container.decodeIfPresent(Swift.type(of: path), forKey: .path) ?? path
        preloadUrl = self.dnsurl(from: container, forKey: .preloadUrl) ?? preloadUrl
        title = self.dnsstring(from: container, forKey: .title) ?? title
        url = self.dnsurl(from: container, forKey: .url) ?? url
        type = try container.decodeIfPresent(Swift.type(of: type), forKey: .type) ?? type
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(preloadUrl, forKey: .preloadUrl)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOMedia(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOMedia else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.path != rhs.path ||
            lhs.preloadUrl != rhs.preloadUrl ||
            lhs.title != rhs.title ||
            lhs.type != rhs.type ||
            lhs.url != rhs.url
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOMedia, rhs: DAOMedia) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOMedia, rhs: DAOMedia) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
