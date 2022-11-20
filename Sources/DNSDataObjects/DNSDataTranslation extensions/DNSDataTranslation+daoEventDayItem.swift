//
//  DNSDataTranslation+daoEventDayItem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoEventDayItem<K>(with configuration: PTCLCFGDAOEventDayItem,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOEventDayItem? where K: CodingKey {
        return configuration.eventDayItem(from: container, forKey: key)
    }
    func daoEventDayItemArray<K>(with configuration: PTCLCFGDAOEventDayItem,
                                 from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEventDayItem] where K: CodingKey {
        return configuration.eventDayItemArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoEventDayItem(from any: Any?) -> DAOEventDayItem? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoEventDayItem(from: any as? DNSDataDictionary)
        }
        return self.daoEventDayItem(from: any as? DAOEventDayItem)
    }
    func daoEventDayItem(from data: DNSDataDictionary?) -> DAOEventDayItem? {
        guard let data else { return nil }
        return DAOEventDayItem(from: data)
    }
    func daoEventDayItem(from daoEventDayItem: DAOEventDayItem?) -> DAOEventDayItem? {
        guard let daoEventDayItem else { return nil }
        return daoEventDayItem
    }
}
