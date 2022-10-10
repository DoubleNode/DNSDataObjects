//
//  DNSDataTranslation+daoBasket.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoBasket<K>(of objectType: DAOBasket.Type,
                      from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOBasket? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoBasketArray<K>(of arrayType: [DAOBasket].Type,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOBasket] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoBasket(from any: Any?) -> DAOBasket? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoBasket(from: any as? DNSDataDictionary)
        }
        return self.daoBasket(from: any as? DAOBasket)
    }
    func daoBasket(from data: DNSDataDictionary?) -> DAOBasket? {
        guard let data else { return nil }
        return DAOBasket(from: data)
    }
    func daoBasket(from daoBasket: DAOBasket?) -> DAOBasket? {
        guard let daoBasket else { return nil }
        return daoBasket
    }
}
