//
//  DNSDataTranslation+daoPlaceHours.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPlaceHours<K>(with configuration: PTCLCFGDAOPlaceHours,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlaceHours? where K: CodingKey {
        do { return try container.decodeIfPresent(configuration.placeHoursType, forKey: key,
                                                  configuration: configuration) } catch { }
        return nil
    }
    func daoPlaceHoursArray<K>(with configuration: PTCLCFGDAOPlaceHours,
                               from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceHours] where K: CodingKey {
        return configuration.placeHoursArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPlaceHours(from any: Any?) -> DAOPlaceHours? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPlaceHours(from: any as? DNSDataDictionary)
        }
        return self.daoPlaceHours(from: any as? DAOPlaceHours)
    }
    func daoPlaceHours(from data: DNSDataDictionary?) -> DAOPlaceHours? {
        guard let data else { return nil }
        return DAOPlaceHours(from: data)
    }
    func daoPlaceHours(from daoPlaceHours: DAOPlaceHours?) -> DAOPlaceHours? {
        guard let daoPlaceHours else { return nil }
        return daoPlaceHours
    }
}
