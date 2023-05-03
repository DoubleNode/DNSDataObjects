//
//  DAOAppActionThemes.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSBaseTheme
import DNSCore
import Foundation

public protocol PTCLCFGDAOAppActionThemes: PTCLCFGBaseObject {
    var appActionThemesType: DAOAppActionThemes.Type { get }
    func appActionThemes<K>(from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionThemes? where K: CodingKey
    func appActionThemesArray<K>(from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionThemes] where K: CodingKey
}

public protocol PTCLCFGAppActionThemesObject: PTCLCFGBaseObject {
}
public class CFGAppActionThemesObject: PTCLCFGAppActionThemesObject {
}
open class DAOAppActionThemes: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGAppActionThemesObject
    public static var config: Config = CFGAppActionThemesObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    public static var defaultCancelButton = DNSThemeButtonStyle.default
    public static var defaultOkayButton = DNSThemeButtonStyle.default

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case cancelButton, okayButton
    }

    open var cancelButton = DAOAppActionThemes.defaultCancelButton
    open var okayButton = DAOAppActionThemes.defaultOkayButton

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppActionThemes) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppActionThemes) {
        super.update(from: object)
        // swiftlint:disable force_cast
        self.cancelButton = object.cancelButton.copy() as! DNSThemeButtonStyle
        self.okayButton = object.okayButton.copy() as! DNSThemeButtonStyle
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppActionThemes {
        _ = super.dao(from: data)
        self.cancelButton = self.dnsThemeButtonStyle(from: data[field(.cancelButton)] as Any?) ?? self.cancelButton
        self.okayButton = self.dnsThemeButtonStyle(from: data[field(.okayButton)] as Any?) ?? self.okayButton
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.cancelButton): cancelButton,
            field(.okayButton): okayButton,
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
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        topUrl = self.dnsurl(from: container, forKey: .topUrl) ?? topUrl
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(cancelButton, forKey: .cancelButton)
//        try container.encode(okayButton, forKey: .okayButton)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppActionThemes(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppActionThemes else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs)
            || lhs.cancelButton != rhs.cancelButton
            || lhs.okayButton != rhs.okayButton
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAppActionThemes, rhs: DAOAppActionThemes) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAppActionThemes, rhs: DAOAppActionThemes) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
