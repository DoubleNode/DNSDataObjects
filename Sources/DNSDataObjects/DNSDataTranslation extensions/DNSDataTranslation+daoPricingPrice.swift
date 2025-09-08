//
//  DNSDataTranslation+daoPricingPrice.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPricingPrice<K>(with configuration: PTCLCFGDAOPricingPrice,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingPrice? where K: CodingKey {
        return configuration.pricingPrice(from: container, forKey: key)
    }
    func daoPricingPriceArray<K>(with configuration: PTCLCFGDAOPricingPrice,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingPrice] where K: CodingKey {
        return configuration.pricingPriceArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPricingPrice(from any: Any?) -> DAOPricingPrice? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPricingPrice(from: any as? DNSDataDictionary)
        }
        return self.daoPricingPrice(from: any as? DAOPricingPrice)
    }
    func daoPricingPrice(from data: DNSDataDictionary?) -> DAOPricingPrice? {
        guard let data else { return nil }
        return DAOPricingPrice(from: data)
    }
    func daoPricingPrice(from daoPricingPrice: DAOPricingPrice?) -> DAOPricingPrice? {
        guard let daoPricingPrice else { return nil }
        return daoPricingPrice
    }
}
