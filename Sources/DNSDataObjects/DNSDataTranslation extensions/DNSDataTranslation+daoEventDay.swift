//
//  DNSDataTranslation+daoEventDay.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoEventDay<K>(with configuration: PTCLCFGDAOEventDay,
                        from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDay? where K: CodingKey {
        return configuration.eventDay(from: container, forKey: key)
    }
    func daoEventDayArray<K>(with configuration: PTCLCFGDAOEventDay,
                             from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDay] where K: CodingKey {
        return configuration.eventDayArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoEventDay(from any: Any?) -> DAOEventDay? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoEventDay(from: any as? DNSDataDictionary)
        }
        return self.daoEventDay(from: any as? DAOEventDay)
    }
    func daoEventDay(from data: DNSDataDictionary?) -> DAOEventDay? {
        guard let data else { return nil }
        return DAOEventDay(from: data)
    }
    func daoEventDay(from daoEventDay: DAOEventDay?) -> DAOEventDay? {
        guard let daoEventDay else { return nil }
        return daoEventDay
    }
}
