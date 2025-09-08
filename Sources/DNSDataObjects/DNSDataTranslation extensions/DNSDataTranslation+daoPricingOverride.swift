//
//  DNSDataTranslation+DAOPricingOverride.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func DAOPricingOverride<K>(with configuration: PTCLCFGDAOPricingOverride,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingOverride? where K: CodingKey {
        return configuration.pricingOverride(from: container, forKey: key)
    }
    func DAOPricingOverrideArray<K>(with configuration: PTCLCFGDAOPricingOverride,
                                     from container: KeyedDecodingContainer<K>,
                                     forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingOverride] where K: CodingKey {
        return configuration.pricingOverrideArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func DAOPricingOverride(from any: Any?) -> DAOPricingOverride? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.DAOPricingOverride(from: any as? DNSDataDictionary)
        }
        return self.DAOPricingOverride(from: any as? DAOPricingOverride)
    }
    func DAOPricingOverride(from data: DNSDataDictionary?) -> DAOPricingOverride? {
        guard let data else { return nil }
        return DAOPricingOverride(from: data)
    }
    func DAOPricingOverride(from DAOPricingOverride: DAOPricingOverride?) -> DAOPricingOverride? {
        guard let DAOPricingOverride else { return nil }
        return DAOPricingOverride
    }
}
