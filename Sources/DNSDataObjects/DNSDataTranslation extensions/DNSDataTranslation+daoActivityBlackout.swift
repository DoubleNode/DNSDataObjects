//
//  DNSDataTranslation+daoActivityBlackout.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoActivityBlackout<K>(with configuration: PTCLCFGDAOActivityBlackout,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityBlackout? where K: CodingKey {
        return configuration.activityBlackout(from: container, forKey: key)
    }
    func daoActivityBlackoutArray<K>(with configuration: PTCLCFGDAOActivityBlackout,
                                     from container: KeyedDecodingContainer<K>,
                                     forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityBlackout] where K: CodingKey {
        return configuration.activityBlackoutArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoActivityBlackout(from any: Any?) -> DAOActivityBlackout? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoActivityBlackout(from: any as? DNSDataDictionary)
        }
        return self.daoActivityBlackout(from: any as? DAOActivityBlackout)
    }
    func daoActivityBlackout(from data: DNSDataDictionary?) -> DAOActivityBlackout? {
        guard let data else { return nil }
        return DAOActivityBlackout(from: data)
    }
    func daoActivityBlackout(from daoActivityBlackout: DAOActivityBlackout?) -> DAOActivityBlackout? {
        guard let daoActivityBlackout else { return nil }
        return daoActivityBlackout
    }
}
