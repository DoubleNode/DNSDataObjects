//
//  DNSDataTranslation+daoOrder.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoOrder<K>(with configuration: PTCLCFGDAOOrder,
                     from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOOrder? where K: CodingKey {
        return configuration.order(from: container, forKey: key)
    }
    func daoOrderArray<K>(with configuration: PTCLCFGDAOOrder,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOOrder] where K: CodingKey {
        return configuration.orderArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoOrder(from any: Any?) -> DAOOrder? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoOrder(from: any as? DNSDataDictionary)
        }
        return self.daoOrder(from: any as? DAOOrder)
    }
    func daoOrder(from data: DNSDataDictionary?) -> DAOOrder? {
        guard let data else { return nil }
        return DAOOrder(from: data)
    }
    func daoOrder(from daoOrder: DAOOrder?) -> DAOOrder? {
        guard let daoOrder else { return nil }
        return daoOrder
    }
}
