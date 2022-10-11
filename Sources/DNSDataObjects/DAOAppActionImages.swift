//
//  DAOAppActionImages.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOAppActionImages: PTCLCFGBaseObject {
    var appActionImagesType: DAOAppActionImages.Type { get }
    func appActionImagesArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionImages] where K: CodingKey
}

public protocol PTCLCFGAppActionImagesObject: PTCLCFGBaseObject {
}
public class CFGAppActionImagesObject: PTCLCFGAppActionImagesObject {
}
open class DAOAppActionImages: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAppActionImagesObject
    public static var config: Config = CFGAppActionImagesObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case topUrl = "top"
    }

    open var topUrl = DNSURL()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppActionImages) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppActionImages) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.topUrl = object.topUrl.copy() as! DNSURL
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppActionImages {
        _ = super.dao(from: data)
        self.topUrl = self.dnsurl(from: data[field(.topUrl)] as Any?) ?? self.topUrl
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.topUrl): self.topUrl,
        ]) { (current, _) in current }
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder, configuration: PTCLCFGBaseObject) throws {
        fatalError("init(from:configuration:) has not been implemented")
    }
    required public init(from decoder: Decoder, configuration: Config) throws {
        try super.init(from: decoder, configuration: configuration)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        topUrl = self.dnsurl(from: container, forKey: .topUrl) ?? topUrl
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topUrl, forKey: .topUrl)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppActionImages(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppActionImages else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.topUrl != rhs.topUrl
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAppActionImages, rhs: DAOAppActionImages) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAppActionImages, rhs: DAOAppActionImages) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
