//
//  DAOAppActionColors.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOAppActionColors: PTCLCFGBaseObject {
    var appActionColorsType: DAOAppActionColors.Type { get }
    func appActionColors<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionColors? where K: CodingKey
    func appActionColorsArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionColors] where K: CodingKey
}

public protocol PTCLCFGAppActionColorsObject: PTCLCFGBaseObject {
}
public class CFGAppActionColorsObject: PTCLCFGAppActionColorsObject {
}
open class DAOAppActionColors: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAppActionColorsObject
    public static var config: Config = CFGAppActionColorsObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case cancelButtonBackground, cancelButtonText
        case okButtonBackground, okButtonText
    }

    open var cancelButtonBackground: DNSUIColor?
    open var cancelButtonText: DNSUIColor?
    open var okButtonBackground: DNSUIColor?
    open var okButtonText: DNSUIColor?

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppActionColors) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppActionColors) {
        super.update(from: object)
        self.cancelButtonBackground = object.cancelButtonBackground?.copy() as? DNSUIColor
        self.cancelButtonText = object.cancelButtonText?.copy() as? DNSUIColor
        self.okButtonBackground = object.okButtonBackground?.copy() as? DNSUIColor
        self.okButtonText = object.okButtonText?.copy() as? DNSUIColor
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppActionColors {
        _ = super.dao(from: data)
        self.cancelButtonBackground = self.dnscolor(from: data[field(.cancelButtonBackground)] as Any?) ?? self.cancelButtonBackground
        self.cancelButtonText = self.dnscolor(from: data[field(.cancelButtonText)] as Any?) ?? self.cancelButtonText
        self.okButtonBackground = self.dnscolor(from: data[field(.okButtonBackground)] as Any?) ?? self.okButtonBackground
        self.okButtonText = self.dnscolor(from: data[field(.okButtonText)] as Any?) ?? self.okButtonText
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        if let cancelButtonBackground = self.cancelButtonBackground {
            retval.merge([
                field(.cancelButtonBackground): cancelButtonBackground,
            ]) { (current, _) in current }
        }
        if let cancelButtonText = self.cancelButtonText {
            retval.merge([
                field(.cancelButtonText): cancelButtonText,
            ]) { (current, _) in current }
        }
        if let okButtonBackground = self.okButtonBackground {
            retval.merge([
                field(.okButtonBackground): okButtonBackground,
            ]) { (current, _) in current }
        }
        if let okButtonText = self.okButtonText {
            retval.merge([
                field(.okButtonText): okButtonText,
            ]) { (current, _) in current }
        }
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
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        topUrl = self.dnsurl(from: container, forKey: .topUrl) ?? topUrl
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cancelButtonBackground, forKey: .cancelButtonBackground)
        try container.encode(cancelButtonText, forKey: .cancelButtonText)
        try container.encode(okButtonBackground, forKey: .okButtonBackground)
        try container.encode(okButtonText, forKey: .okButtonText)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppActionColors(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppActionColors else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.cancelButtonBackground != rhs.cancelButtonBackground ||
            lhs.cancelButtonText != rhs.cancelButtonText ||
            lhs.okButtonBackground != rhs.okButtonBackground ||
            lhs.okButtonText != rhs.okButtonText
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAppActionColors, rhs: DAOAppActionColors) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAppActionColors, rhs: DAOAppActionColors) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
