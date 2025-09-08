//
//  DNSDataTranslation+daoPricingItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPricingItem<K>(with configuration: PTCLCFGDAOPricingItem,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingItem? where K: CodingKey {
        return configuration.pricingItem(from: container, forKey: key)
    }
    func daoPricingItemArray<K>(with configuration: PTCLCFGDAOPricingItem,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingItem] where K: CodingKey {
        return configuration.pricingItemArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPricingItem(from any: Any?) -> DAOPricingItem? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPricingItem(from: any as? DNSDataDictionary)
        }
        return self.daoPricingItem(from: any as? DAOPricingItem)
    }
    func daoPricingItem(from data: DNSDataDictionary?) -> DAOPricingItem? {
        guard let data else { return nil }
        return DAOPricingItem(from: data)
    }
    func daoPricingItem(from daoPricingItem: DAOPricingItem?) -> DAOPricingItem? {
        guard let daoPricingItem else { return nil }
        return daoPricingItem
    }
}
