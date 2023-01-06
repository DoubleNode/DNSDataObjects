//
//  DNSDataTranslation+daoPricingTier.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPricingTier<K>(with configuration: PTCLCFGDAOPricingTier,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingTier? where K: CodingKey {
        return configuration.pricingTier(from: container, forKey: key)
    }
    func daoPricingTierArray<K>(with configuration: PTCLCFGDAOPricingTier,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingTier] where K: CodingKey {
        return configuration.pricingTierArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPricingTier(from any: Any?) -> DAOPricingTier? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPricingTier(from: any as? DNSDataDictionary)
        }
        return self.daoPricingTier(from: any as? DAOPricingTier)
    }
    func daoPricingTier(from data: DNSDataDictionary?) -> DAOPricingTier? {
        guard let data else { return nil }
        return DAOPricingTier(from: data)
    }
    func daoPricingTier(from daoPricingTier: DAOPricingTier?) -> DAOPricingTier? {
        guard let daoPricingTier else { return nil }
        return daoPricingTier
    }
}
