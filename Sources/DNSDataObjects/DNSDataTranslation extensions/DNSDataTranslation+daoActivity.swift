//
//  DNSDataTranslation+daoActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoActivity<K>(of objectType: DAOActivity.Type,
                        from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivity? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoActivityArray<K>(of arrayType: [DAOActivity].Type,
                             from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivity] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoActivity(from any: Any?) -> DAOActivity? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoActivity(from: any as? DNSDataDictionary)
        }
        return self.daoActivity(from: any as? DAOActivity)
    }
    func daoActivity(from data: DNSDataDictionary?) -> DAOActivity? {
        guard let data else { return nil }
        return DAOActivity(from: data)
    }
    func daoActivity(from daoActivity: DAOActivity?) -> DAOActivity? {
        guard let daoActivity else { return nil }
        return daoActivity
    }
}
