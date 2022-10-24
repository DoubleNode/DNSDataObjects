//
//  DNSDataTranslation+daoOrderItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoOrderItem<K>(with configuration: PTCLCFGDAOOrderItem,
                     from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOOrderItem? where K: CodingKey {
        return configuration.orderItem(from: container, forKey: key)
    }
    func daoOrderItemArray<K>(with configuration: PTCLCFGDAOOrderItem,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOOrderItem] where K: CodingKey {
        return configuration.orderItemArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoOrderItem(from any: Any?) -> DAOOrderItem? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoOrderItem(from: any as? DNSDataDictionary)
        }
        return self.daoOrderItem(from: any as? DAOOrderItem)
    }
    func daoOrderItem(from data: DNSDataDictionary?) -> DAOOrderItem? {
        guard let data else { return nil }
        return DAOOrderItem(from: data)
    }
    func daoOrderItem(from daoOrderItem: DAOOrderItem?) -> DAOOrderItem? {
        guard let daoOrderItem else { return nil }
        return daoOrderItem
    }
}
