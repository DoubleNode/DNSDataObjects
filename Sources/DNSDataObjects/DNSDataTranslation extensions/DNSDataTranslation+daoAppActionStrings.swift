//
//  DNSDataTranslation+daoAppActionStrings.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAppActionStrings<K>(with configuration: PTCLCFGDAOAppActionStrings,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionStrings? where K: CodingKey {
        return configuration.appActionStrings(from: container, forKey: key)
    }
    func daoAppActionStringsArray<K>(with configuration: PTCLCFGDAOAppActionStrings,
                                     from container: KeyedDecodingContainer<K>,
                                     forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionStrings] where K: CodingKey {
        return configuration.appActionStringsArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAppActionStrings(from any: Any?) -> DAOAppActionStrings? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAppActionStrings(from: any as? DNSDataDictionary)
        }
        return self.daoAppActionStrings(from: any as? DAOAppActionStrings)
    }
    func daoAppActionStrings(from data: DNSDataDictionary?) -> DAOAppActionStrings? {
        guard let data else { return nil }
        return DAOAppActionStrings(from: data)
    }
    func daoAppActionStrings(from daoAppActionStrings: DAOAppActionStrings?) -> DAOAppActionStrings? {
        guard let daoAppActionStrings else { return nil }
        return daoAppActionStrings
    }
}
