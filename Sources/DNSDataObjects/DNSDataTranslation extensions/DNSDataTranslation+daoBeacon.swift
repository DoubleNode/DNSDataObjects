//
//  DNSDataTranslation+daoBeacon.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoBeacon<K>(with configuration: PTCLCFGDAOBeacon,
                      from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOBeacon? where K: CodingKey {
        return configuration.beacon(from: container, forKey: key)
    }
    func daoBeaconArray<K>(with configuration: PTCLCFGDAOBeacon,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOBeacon] where K: CodingKey {
        return configuration.beaconArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoBeacon(from any: Any?) -> DAOBeacon? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoBeacon(from: any as? DNSDataDictionary)
        }
        return self.daoBeacon(from: any as? DAOBeacon)
    }
    func daoBeacon(from data: DNSDataDictionary?) -> DAOBeacon? {
        guard let data else { return nil }
        return DAOBeacon(from: data)
    }
    func daoBeacon(from daoBeacon: DAOBeacon?) -> DAOBeacon? {
        guard let daoBeacon else { return nil }
        return daoBeacon
    }
}
