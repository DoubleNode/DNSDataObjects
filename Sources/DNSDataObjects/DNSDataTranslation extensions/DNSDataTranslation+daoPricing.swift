//
//  DNSDataTranslation+daoPricing.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPricing<K>(with configuration: PTCLCFGDAOPricing,
                       from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricing? where K: CodingKey {
        return configuration.pricing(from: container, forKey: key)
    }
    func daoPricingArray<K>(with configuration: PTCLCFGDAOPricing,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricing] where K: CodingKey {
        return configuration.pricingArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPricing(from any: Any?) -> DAOPricing? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPricing(from: any as? DNSDataDictionary)
        }
        return self.daoPricing(from: any as? DAOPricing)
    }
    func daoPricing(from data: DNSDataDictionary?) -> DAOPricing? {
        guard let data else { return nil }
        return DAOPricing(from: data)
    }
    func daoPricing(from daoPricing: DAOPricing?) -> DAOPricing? {
        guard let daoPricing else { return nil }
        return daoPricing
    }
}
