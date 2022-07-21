//
//  DNSSystemStateNumbers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public class DNSSystemStateNumbers: DNSDataTranslation, Codable {
    public enum CodingKeys: String, CodingKey {
        case android, iOS, total
    }

    public var android: Double = 0.0
    public var iOS: Double = 0.0
    public var total: Double = 0.0

    // MARK: - Initializers -
    override public init() {
    }

    // MARK: - DAO copy methods -
    public init(from object: DNSSystemStateNumbers) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DNSSystemStateNumbers) {
        self.android = object.android
        self.iOS = object.iOS
        self.total = object.total
    }

    // MARK: - DAO translation methods -
    public init(from dictionary: [String: Any?]) {
        super.init()
        _ = self.dao(from: dictionary)
    }
    open func dao(from dictionary: [String: Any?]) -> DNSSystemStateNumbers {
        self.android = self.double(from: dictionary[CodingKeys.android.rawValue] as Any?) ?? self.android
        self.iOS = self.double(from: dictionary[CodingKeys.iOS.rawValue] as Any?) ?? self.iOS
        self.total = self.double(from: dictionary[CodingKeys.total.rawValue] as Any?) ?? self.total
        return self
    }
    open var asDictionary: [String: Any?] {
        let retval: [String: Any?] = [
            CodingKeys.android.rawValue: self.android,
            CodingKeys.iOS.rawValue: self.iOS,
            CodingKeys.total.rawValue: self.total,
        ]
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        android = try container.decode(Double.self, forKey: .android)
        iOS = try container.decode(Double.self, forKey: .iOS)
        total = try container.decode(Double.self, forKey: .total)
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(android, forKey: .android)
        try container.encode(iOS, forKey: .iOS)
        try container.encode(total, forKey: .total)
    }

    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DNSSystemStateNumbers(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DNSSystemStateNumbers else { return true }
        let lhs = self
        return lhs.android != rhs.android
            || lhs.iOS != rhs.iOS
            || lhs.total != rhs.total
    }
}
