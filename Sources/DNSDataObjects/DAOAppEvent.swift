//
//  DAOAppEvent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public protocol PTCLCFGDAOAppEvent: PTCLCFGBaseObject {
    var appEventType: DAOAppEvent.Type { get }
    func appEventArray<K>(from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppEvent] where K: CodingKey
}

public protocol PTCLCFGAppEventObject: PTCLCFGBaseObject {
}
public class CFGAppEventObject: PTCLCFGAppEventObject {
}
open class DAOAppEvent: DAOBaseObject {
    public typealias Config = PTCLCFGAppEventObject
    public static var config: Config = CFGAppEventObject()

    public enum C {
        public static let defaultEndTime = Date(timeIntervalSinceReferenceDate: Date.Seconds.deltaOneYear * 30.0)
        public static let defaultStartTime = Date(timeIntervalSinceReferenceDate: 0.0)
    }

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case endTime, priority, startTime, title
    }

    open var endTime = C.defaultEndTime
    open var priority: Int = DNSPriority.normal {
        didSet {
            if priority > DNSPriority.highest {
                priority = DNSPriority.highest
            } else if priority < DNSPriority.none {
                priority = DNSPriority.none
            }
        }
    }
    open var startTime = C.defaultStartTime
    open var title = DNSString()

    // MARK: - Initializers -
    required public init() {
        super.init()
    }
    required public init(id: String) {
        super.init(id: id)
    }
    public init(title: DNSString = DNSString(),
                startTime: Date = C.defaultStartTime,
                endTime: Date = C.defaultEndTime) {
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }

    // MARK: - DAO copy methods -
    required public init(from object: DAOAppEvent) {
        super.init(from: object)
        self.update(from: object)
    }
    open func update(from object: DAOAppEvent) {
        super.update(from: object)
        self.endTime = object.endTime
        self.priority = object.priority
        self.startTime = object.startTime
        self.title = object.title
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init(from: data)
    }
    override open func dao(from data: DNSDataDictionary) -> DAOAppEvent {
        _ = super.dao(from: data)
        self.endTime = self.time(from: data[field(.endTime)] as Any?) ?? self.endTime
        self.priority = self.int(from: data[field(.priority)] as Any?) ?? self.priority
        self.startTime = self.time(from: data[field(.startTime)] as Any?) ?? self.startTime
        self.title = self.dnsstring(from: data[field(.title)] as Any?) ?? self.title
        return self
    }
    override open var asDictionary: DNSDataDictionary {
        var retval = super.asDictionary
        retval.merge([
            field(.endTime): self.endTime,
            field(.priority): self.priority,
            field(.startTime): self.startTime,
            field(.title): self.title.asDictionary,
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
        endTime = self.date(from: container, forKey: .endTime) ?? endTime
        priority = self.int(from: container, forKey: .priority) ?? priority
        startTime = self.date(from: container, forKey: .startTime) ?? startTime
        title = self.dnsstring(from: container, forKey: .title) ?? title
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        try super.encode(to: encoder, configuration: configuration)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(priority, forKey: .priority)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(title, forKey: .title)
    }

    // MARK: - NSCopying protocol methods -
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOAppEvent(from: self)
        return copy
    }
    override open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOAppEvent else { return true }
        guard !super.isDiffFrom(rhs) else { return true }
        let lhs = self
        return super.isDiffFrom(rhs) ||
            lhs.endTime != rhs.endTime ||
            lhs.priority != rhs.priority ||
            lhs.startTime != rhs.startTime ||
            lhs.title != rhs.title
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOAppEvent, rhs: DAOAppEvent) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOAppEvent, rhs: DAOAppEvent) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
