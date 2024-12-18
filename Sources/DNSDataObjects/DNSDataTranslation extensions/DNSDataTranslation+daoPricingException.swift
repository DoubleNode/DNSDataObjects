//
//  DNSDataTranslation+daoPricingException.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPricingException<K>(with configuration: PTCLCFGDAOPricingException,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> DAOPricingException? where K: CodingKey {
        return configuration.pricingException(from: container, forKey: key)
    }
    func daoPricingExceptionArray<K>(with configuration: PTCLCFGDAOPricingException,
                                     from container: KeyedDecodingContainer<K>,
                                     forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPricingException] where K: CodingKey {
        return configuration.pricingExceptionArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPricingException(from any: Any?) -> DAOPricingException? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPricingException(from: any as? DNSDataDictionary)
        }
        return self.daoPricingException(from: any as? DAOPricingException)
    }
    func daoPricingException(from data: DNSDataDictionary?) -> DAOPricingException? {
        guard let data else { return nil }
        return DAOPricingException(from: data)
    }
    func daoPricingException(from daoPricingException: DAOPricingException?) -> DAOPricingException? {
        guard let daoPricingException else { return nil }
        return daoPricingException
    }
}
