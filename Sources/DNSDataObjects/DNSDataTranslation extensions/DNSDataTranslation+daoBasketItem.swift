//
//  DNSDataTranslation+daoBasketItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoBasketItem<K>(of objectType: DAOBasketItem.Type,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOBasketItem? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoBasketItemArray<K>(of arrayType: [DAOBasketItem].Type,
                               from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOBasketItem] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoBasketItem(from any: Any?) -> DAOBasketItem? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoBasketItem(from: any as? DNSDataDictionary)
        }
        return self.daoBasketItem(from: any as? DAOBasketItem)
    }
    func daoBasketItem(from data: DNSDataDictionary?) -> DAOBasketItem? {
        guard let data else { return nil }
        return DAOBasketItem(from: data)
    }
    func daoBasketItem(from daoBasketItem: DAOBasketItem?) -> DAOBasketItem? {
        guard let daoBasketItem else { return nil }
        return daoBasketItem
    }
}
