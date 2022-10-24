//
//  DNSDataTranslation+daoPlaceStatus.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPlaceStatus<K>(with configuration: PTCLCFGDAOPlaceStatus,
                     from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlaceStatus? where K: CodingKey {
        return configuration.placeStatus(from: container, forKey: key)
    }
    func daoPlaceStatusArray<K>(with configuration: PTCLCFGDAOPlaceStatus,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceStatus] where K: CodingKey {
        return configuration.placeStatusArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPlaceStatus(from any: Any?) -> DAOPlaceStatus? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPlaceStatus(from: any as? DNSDataDictionary)
        }
        return self.daoPlaceStatus(from: any as? DAOPlaceStatus)
    }
    func daoPlaceStatus(from data: DNSDataDictionary?) -> DAOPlaceStatus? {
        guard let data else { return nil }
        return DAOPlaceStatus(from: data)
    }
    func daoPlaceStatus(from daoPlaceStatus: DAOPlaceStatus?) -> DAOPlaceStatus? {
        guard let daoPlaceStatus else { return nil }
        return daoPlaceStatus
    }
}
