//
//  DNSDataTranslation+daoSystem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoSystem<K>(with configuration: PTCLCFGDAOSystem,
                      from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOSystem? where K: CodingKey {
        return configuration.system(from: container, forKey: key)
    }
    func daoSystemArray<K>(with configuration: PTCLCFGDAOSystem,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystem] where K: CodingKey {
        return configuration.systemArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoSystem(from any: Any?) -> DAOSystem? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoSystem(from: any as? DNSDataDictionary)
        }
        return self.daoSystem(from: any as? DAOSystem)
    }
    func daoSystem(from data: DNSDataDictionary?) -> DAOSystem? {
        guard let data else { return nil }
        return DAOSystem(from: data)
    }
    func daoSystem(from daoSystem: DAOSystem?) -> DAOSystem? {
        guard let daoSystem else { return nil }
        return daoSystem
    }
}
