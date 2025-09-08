//
//  DNSDataTranslation+daoActivity.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoActivity<K>(with configuration: PTCLCFGDAOActivity,
                        from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivity? where K: CodingKey {
        return configuration.activity(from: container, forKey: key)
    }
    func daoActivityArray<K>(with configuration: PTCLCFGDAOActivity,
                             from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivity] where K: CodingKey {
        return configuration.activityArray(from: container, forKey: key)
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
