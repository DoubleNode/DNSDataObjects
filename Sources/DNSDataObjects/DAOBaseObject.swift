//
//  DAOBaseObject.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataContracts
import Foundation

public protocol PTCLCFGDAOBaseObject {
}

public protocol PTCLCFGBaseObject: PTCLCFGDAOBaseObject {
}
open class DAOBaseObject: DNSDataTranslation, DAOBaseObjectProtocol, Codable, CodableWithConfiguration, NSCopying {
    public typealias Config = PTCLCFGBaseObject

    // MARK: - Properties -
    private func field(_ from: CodingKeys) -> String { return from.rawValue }
    public enum CodingKeys: String, CodingKey {
        case analyticsData, id, meta
    }

    // Internal concrete storage
    private var _analyticsData: [DAOAnalyticsData] = []
    private var _meta: DNSMetadata = DNSMetadata()
    
    // Protocol interface
    public var analyticsData: [any DAOAnalyticsDataProtocol] {
        get { _analyticsData }
        set { _analyticsData = newValue.compactMap { $0 as? DAOAnalyticsData } }
    }
    public var meta: any DAOMetadataProtocol {
        get { _meta }
        set { _meta = (newValue as? DNSMetadata) ?? DNSMetadata() }
    }
    
    open var id: String = ""

    // MARK: - Initializers -
    override required public init() {
        super.init()
        self.id = self._meta.uid.uuidString
    }
    required public init(id: String) {
        super.init()
        self.id = id
        // Always sync the meta UID with the provided ID for consistency
        // If the ID is a valid UUID, use it; otherwise generate a new one but keep the ID as-is
        if let uuid = UUID(uuidString: id) {
            self._meta.uid = uuid
        } else {
            // Keep the generated UUID but maintain the custom ID
            // This allows non-UUID IDs while keeping metadata consistent
        }
    }

    // MARK: - DAO copy methods -
    public init(from object: DAOBaseObject) {
        super.init()
        self.update(from: object)
    }
    open func update(from object: DAOBaseObject) {
        self.id = object.id  // Copy the exact ID from source
        self._meta = object._meta.copy() as! DNSMetadata
        // swiftlint:disable force_cast
        self._analyticsData = object._analyticsData.map { $0.copy() as! DAOAnalyticsData }
        // swiftlint:enable force_cast
    }

    // MARK: - DAO translation methods -
    required public init?(from data: DNSDataDictionary) {
        guard !data.isEmpty else { return nil }
        super.init()
        _ = self.dao(from: data)
    }
    open func dao(from data: DNSDataDictionary) -> DAOBaseObject {
        let analyticsDataData = self.dataarray(from: data[field(.analyticsData)] as Any?)
        self._analyticsData = analyticsDataData.compactMap { DAOAnalyticsData(from: $0) }
        self.id = self.string(from: data[field(.id)] as Any?) ?? self.id
        let metaData = self.dictionary(from: data[field(.meta)] as Any?)
        self._meta = DNSMetadata(from: metaData)
        return self
    }
    open var asDictionary: DNSDataDictionary {
        let retval: DNSDataDictionary = [
            field(.analyticsData): self._analyticsData.map { $0.asDictionary },
            field(.id): self.id,
            field(.meta): self._meta.asDictionary,
        ]
        return retval
    }

    // MARK: - Codable protocol methods -
    required public init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _analyticsData = try container.decodeIfPresent([DAOAnalyticsData].self, forKey: .analyticsData) ?? []
        id = self.string(from: container, forKey: .id) ?? id
        _meta = try container.decodeIfPresent(DNSMetadata.self, forKey: .meta) ?? DNSMetadata()
    }
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_analyticsData, forKey: .analyticsData)
        try container.encode(id, forKey: .id)
        try container.encode(_meta, forKey: .meta)
    }

    // MARK: - CodableWithConfiguration protocol methods -
    required public init(from decoder: Decoder, configuration: Config) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _analyticsData = try container.decodeIfPresent([DAOAnalyticsData].self, forKey: .analyticsData) ?? []
        id = self.string(from: container, forKey: .id) ?? id
        _meta = try container.decodeIfPresent(DNSMetadata.self, forKey: .meta) ?? DNSMetadata()
    }
    open func encode(to encoder: Encoder, configuration: Config) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_analyticsData, forKey: .analyticsData)
        try container.encode(id, forKey: .id)
        try container.encode(_meta, forKey: .meta)
    }

    // MARK: - NSCopying protocol methods -
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = DAOBaseObject(from: self)
        return copy
    }
    open func isDiffFrom(_ rhs: Any?) -> Bool {
        guard let rhs = rhs as? DAOBaseObject else { return true }
        let lhs = self
        // Compare everything except the meta UID (since ID is the primary identifier)
        let metaDiff = lhs._meta.created != rhs._meta.created ||
                      lhs._meta.synced != rhs._meta.synced ||
                      lhs._meta.updated != rhs._meta.updated ||
                      lhs._meta.status != rhs._meta.status ||
                      lhs._meta.createdBy != rhs._meta.createdBy ||
                      lhs._meta.updatedBy != rhs._meta.updatedBy ||
                      lhs._meta.reactionCounts != rhs._meta.reactionCounts ||
                      lhs._meta.views != rhs._meta.views
        
        return lhs._analyticsData.hasDiffElementsFrom(rhs._analyticsData) ||
            lhs.id != rhs.id ||
            metaDiff
    }

    // MARK: - Equatable protocol methods -
    static public func !=(lhs: DAOBaseObject, rhs: DAOBaseObject) -> Bool {
        lhs.isDiffFrom(rhs)
    }
    static public func ==(lhs: DAOBaseObject, rhs: DAOBaseObject) -> Bool {
        !lhs.isDiffFrom(rhs)
    }
}
