//
//  DNSDataTranslation+daoActivityType.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoActivityType<K>(of objectType: DAOActivityType.Type,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityType? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoActivityTypeArray<K>(of arrayType: [DAOActivityType].Type,
                                 from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityType] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoActivityType(from any: Any?) -> DAOActivityType? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoActivityType(from: any as? DNSDataDictionary)
        }
        return self.daoActivityType(from: any as? DAOActivityType)
    }
    func daoActivityType(from data: DNSDataDictionary?) -> DAOActivityType? {
        guard let data else { return nil }
        return DAOActivityType(from: data)
    }
    func daoActivityType(from daoActivityType: DAOActivityType?) -> DAOActivityType? {
        guard let daoActivityType else { return nil }
        return daoActivityType
    }
}
