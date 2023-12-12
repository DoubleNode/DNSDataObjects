//
//  DAODocument.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAODocument: PTCLCFGBaseObject {
    var documentType: DAODocument.Type { get }
    func document<K>(from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAODocument? where K: CodingKey
    func documentArray<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAODocument] where K: CodingKey
}

public protocol PTCLCFGDocumentObject: PTCLCFGBaseObject {
}
public class CFGDocumentObject: PTCLCFGDocumentObject {
}
open class DAODocument: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGDocumentObject
    public static var config: Config = CFGDocumentObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case priority, title, url
    }

    open var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }
    open var title = DNSString()
    open var url = DNSURL()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(title: DNSString,
                url: DNSURL) {
        self.title = title
        self.url = url
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAODocument) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAODocument) {
        super.update(from: object)
        self.priority = object.priority
        self.title = object.title
        self.url = object.url
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAODocument {
        _ = super.dao(from: data)
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        self.url = self.dnsurl(from: data[field(.url)] as Any?) ?? self.url
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.priority): self.priority,
            field(.title): self.title.asDictionary,
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
        priority = self.int(from: container, forKey: .priority) ?? priority
        title = self.dnsstring(from: container, forKey: .title) ?? title
        url = self.dnsurl(from: container, forKey: .url) ?? url
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(priority, forKey: .priority)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAODocument(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAODocument else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.priority != rhs.priority ||
            lhs.title != rhs.title ||
            lhs.url != rhs.url
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAODocument, rhs: DAODocument) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAODocument, rhs: DAODocument) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
