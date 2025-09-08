//
//  DNSDataTranslation+daoProduct.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoProduct<K>(with configuration: PTCLCFGDAOProduct,
                       from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOProduct? where K: CodingKey {
        return configuration.product(from: container, forKey: key)
    }
    func daoProductArray<K>(with configuration: PTCLCFGDAOProduct,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOProduct] where K: CodingKey {
        return configuration.productArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoProduct(from any: Any?) -> DAOProduct? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoProduct(from: any as? DNSDataDictionary)
        }
        return self.daoProduct(from: any as? DAOProduct)
    }
    func daoProduct(from data: DNSDataDictionary?) -> DAOProduct? {
        guard let data else { return nil }
        return DAOProduct(from: data)
    }
    func daoProduct(from daoProduct: DAOProduct?) -> DAOProduct? {
        guard let daoProduct else { return nil }
        return daoProduct
    }
}
