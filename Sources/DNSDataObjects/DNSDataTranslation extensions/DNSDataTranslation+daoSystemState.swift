//
//  DNSDataTranslation+daoSystemState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoSystemState<K>(with configuration: PTCLCFGDAOSystemState,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOSystemState? where K: CodingKey {
        return configuration.systemState(from: container, forKey: key)
    }
    func daoSystemStateArray<K>(with configuration: PTCLCFGDAOSystemState,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystemState] where K: CodingKey {
        return configuration.systemStateArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoSystemState(from any: Any?) -> DAOSystemState? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoSystemState(from: any as? DNSDataDictionary)
        }
        return self.daoSystemState(from: any as? DAOSystemState)
    }
    func daoSystemState(from data: DNSDataDictionary?) -> DAOSystemState? {
        guard let data else { return nil }
        return DAOSystemState(from: data)
    }
    func daoSystemState(from daoSystemState: DAOSystemState?) -> DAOSystemState? {
        guard let daoSystemState else { return nil }
        return daoSystemState
    }
}
