//
//  DNSDataTranslation+daoPricingSeason.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPricingSeason<K>(with configuration: PTCLCFGDAOPricingSeason,
                             from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingSeason? where K: CodingKey {
        return configuration.pricingSeason(from: container, forKey: key)
    }
    func daoPricingSeasonArray<K>(with configuration: PTCLCFGDAOPricingSeason,
                                  from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingSeason] where K: CodingKey {
        return configuration.pricingSeasonArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPricingSeason(from any: Any?) -> DAOPricingSeason? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPricingSeason(from: any as? DNSDataDictionary)
        }
        return self.daoPricingSeason(from: any as? DAOPricingSeason)
    }
    func daoPricingSeason(from data: DNSDataDictionary?) -> DAOPricingSeason? {
        guard let data else { return nil }
        return DAOPricingSeason(from: data)
    }
    func daoPricingSeason(from daoPricingSeason: DAOPricingSeason?) -> DAOPricingSeason? {
        guard let daoPricingSeason else { return nil }
        return daoPricingSeason
    }
}
