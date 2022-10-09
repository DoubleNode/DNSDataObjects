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
    func daoOrder<K>(of objectType: DAOOrder.Type,
                     from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOOrder? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoOrderArray<K>(of arrayType: [DAOOrder].Type,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOOrder] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
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
