//
//  DAOPromotion.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

public protocol PTCLCFGDAOPromotion: PTCLCFGBaseObject {
    var promotionType: DAOPromotion.Type { get }
    func promotion<K>(from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOPromotion? where K: CodingKey
    func promotionArray<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPromotion] where K: CodingKey
}

public protocol PTCLCFGPromotionObject: PTCLCFGDAOAppAction, PTCLCFGDAOMedia {
}
public class CFGPromotionObject: PTCLCFGPromotionObject {
    public var appActionType: DAOAppAction.Type = DAOAppAction.self
    open func appAction<K>(from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppAction? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOAppAction.self, forKey: key, configuration: self) ?? nil } catch { }
        return nil
    }
    open func appActionArray<K>(from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppAction] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOAppAction].self, forKey: key, configuration: self) ?? [] } catch { }
        return []
    }

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
open class DAOPromotion: DAOBaseObject, DecodingConfigurationProviding, EncodingConfigurationProviding {
    public typealias Config = PTCLCFGPromotionObject
    public static var config: Config = CFGPromotionObject()

    public static var decodingConfiguration: DAOBaseObject.Config { Self.config }
    public static var encodingConfiguration: DAOBaseObject.Config { Self.config }

    // MARK: - Class Factory methods -
    open class func createAppAction() -> DAOAppAction { config.appActionType.init() }
    open class func createAppAction(from object: DAOAppAction) -> DAOAppAction { config.appActionType.init(from: object) }
    open class func createAppAction(from data: DNSDataDictionary) -> DAOAppAction? { config.appActionType.init(from: data) }

    open class func createMedia() -> DAOMedia { config.mediaType.init() }
    open class func createMedia(from object: DAOMedia) -> DAOMedia { config.mediaType.init(from: object) }
    open class func createMedia(from data: DNSDataDictionary) -> DAOMedia? { config.mediaType.init(from: data) }
    
    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case action, body, disclaimer, displayDayOfWeek, enabled, endTime, mediaItems,
             placement, priority, startTime, subtitle, title
    }

    public enum C {
        public static let defaultEndTime = Date(timeIntervalSinceReferenceDate: Date.Seconds.deltaOneYear * 30.0)
        public static let defaultStartTime = Date(timeIntervalSinceReferenceDate: 0.0)
    }

    open var body = DNSString()
    open var disclaimer = DNSString()
    open var displayDayOfWeek = DNSDayOfWeekFlags()
    open var enabled: Bool = true
    open var endTime: Date = C.defaultEndTime
    open var placement = ""
    open var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }
    open var startTime: Date = C.defaultStartTime
    open var subtitle = DNSString()
    open var title = DNSString()
    @CodableConfiguration(from: DAOAppAction.self) open var action: DAOAppAction? = nil
    @CodableConfiguration(from: DAOPromotion.self) open var mediaItems: [DAOMedia] = []

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }

    // MARK: - DAO copy methods -
   required public init(from object: DAOPromotion) {
       super.init(from: object)
       self.update(from: object)
   }
   open func update(from object: DAOPromotion) {
       super.update(from: object)
       self.enabled = object.enabled
       self.endTime = object.endTime
       self.placement = object.placement
       self.priority = object.priority
       self.startTime = object.startTime
       // swiftlint:disable force_cast
       self.action = object.action?.copy() as? DAOAppAction
       self.body = object.body.copy() as! DNSString
       self.disclaimer = object.disclaimer.copy() as! DNSString
       self.displayDayOfWeek = object.displayDayOfWeek.copy() as! DNSDayOfWeekFlags
       self.mediaItems = object.mediaItems.map { $0.copy() as! DAOMedia }
       self.subtitle = object.subtitle.copy() as! DNSString
       self.title = object.title.copy() as! DNSString
       // swiftlint:enable force_cast
   }

    // MARK: - DAO translation methods -
   required public init?(from data: DNSDataDictionary) {
       guard !data.isEmpty else { return nil }
       super.init(from: data)
   }
   override open func dao(from data: DNSDataDictionary) -> DAOPromotion {
       _ = super.dao(from: data)
       let actionData = data[field(.action)] as? DNSDataDictionary ?? [:]
       self.action = Self.createAppAction(from: actionData)
       self.body = self.dnsstring(from: data[field(.body)] as Any?) ?? self.body
       self.disclaimer = self.dnsstring(from: data[field(.disclaimer)] as Any?) ?? self.disclaimer
       let displayDayOfWeekData = data[field(.displayDayOfWeek)] as? DNSDataDictionary ?? [:]
       self.displayDayOfWeek = DNSDayOfWeekFlags(from: displayDayOfWeekData)
       self.enabled = self.bool(from: data[field(.enabled)] as Any?) ?? self.enabled
       self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.endTime
       let mediaItemsData = self.dataarray(from: data[field(.mediaItems)] as Any?)
       self.mediaItems = mediaItemsData.compactMap { Self.createMedia(from: $0) }
       self.placement = self.string(from: data[field(.placement)] as Any?) ?? self.placement
       self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
       self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
       self.subtitle = self.dnsstring(from: data[field(.subtitle)] as Any?) ?? self.subtitle
       self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
       return self
   }
   override open var asDictionary: DNSDataDictionary {
       var retval = super.asDictionary
       retval.merge([
           field(.action): self.action?.asDictionary,
           field(.body): self.body.asDictionary,
           field(.disclaimer): self.disclaimer.asDictionary,
           field(.displayDayOfWeek): self.displayDayOfWeek.asDictionary,
           field(.enabled): self.enabled,
           field(.endTime): self.endTime.dnsDateTime(as: .shortMilitary),
           field(.mediaItems): self.mediaItems.map { $0.asDictionary },
           field(.placement): self.placement,
           field(.priority): self.priority,
           field(.startTime): self.startTime.dnsDateTime(as: .shortMilitary),
           field(.subtitle): self.subtitle.asDictionary,
           field(.title): self.title.asDictionary,
       ]) { (current, _) in current }
       return retval
   }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        try commonInit(from: decoder, configuration: Self.config)
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
        action = self.daoAppAction(with: configuration, from: container, forKey: .action) ?? action
        body = self.dnsstring(from: container, forKey: .body) ?? body
        disclaimer = self.dnsstring(from: container, forKey: .disclaimer) ?? disclaimer
        displayDayOfWeek = try container.decodeIfPresent(DNSDayOfWeekFlags.self, forKey: .displayDayOfWeek) ?? DNSDayOfWeekFlags()
        enabled = self.bool(from: container, forKey: .enabled) ?? enabled
        endTime = self.time(from: container, forKey: .endTime) ?? endTime
        mediaItems = self.daoMediaArray(with: configuration, from: container, forKey: .mediaItems)
        placement = self.string(from: container, forKey: .placement) ?? placement
        priority = self.int(from: container, forKey: .priority) ?? priority
        startTime = self.time(from: container, forKey: .startTime) ?? startTime
        subtitle = self.dnsstring(from: container, forKey: .subtitle) ?? subtitle
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    override open func encode(to encoder: Encoder, configuration: DAOBaseObject.Config) throws {
        try self.encode(to: encoder, configuration: Self.config)
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(action, forKey: .action, configuration: configuration)
        try container.encode(body, forKey: .body)
        try container.encode(disclaimer, forKey: .disclaimer)
        try container.encode(displayDayOfWeek, forKey: .displayDayOfWeek)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(mediaItems, forKey: .mediaItems, configuration: configuration)
        try container.encode(placement, forKey: .placement)
        try container.encode(priority, forKey: .priority)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOPromotion(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOPromotion else { return true }
        guard self !== rhs else { return false }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            (lhs.action?.isDiffFrom(rhs.action) ?? (lhs.action != rhs.action)) ||
            lhs.mediaItems.hasDiffElementsFrom(rhs.mediaItems) ||
            lhs.body != rhs.body ||
            lhs.disclaimer != rhs.disclaimer ||
            lhs.displayDayOfWeek != rhs.displayDayOfWeek ||
            lhs.enabled != rhs.enabled ||
            lhs.endTime != rhs.endTime ||
            lhs.placement != rhs.placement ||
            lhs.priority != rhs.priority ||
            lhs.startTime != rhs.startTime ||
            lhs.subtitle != rhs.subtitle ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOPromotion, rhs: DAOPromotion) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOPromotion, rhs: DAOPromotion) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
