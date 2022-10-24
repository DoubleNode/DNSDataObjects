//
//  DNSDataTranslation+daoPlaceHoliday.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPlaceHoliday<K>(with configuration: PTCLCFGDAOPlaceHoliday,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlaceHoliday? where K: CodingKey {
        return configuration.placeHoliday(from: container, forKey: key)
    }
    func daoPlaceHolidayArray<K>(with configuration: PTCLCFGDAOPlaceHoliday,
                                 from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceHoliday] where K: CodingKey {
        return configuration.placeHolidayArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPlaceHoliday(from any: Any?) -> DAOPlaceHoliday? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPlaceHoliday(from: any as? DNSDataDictionary)
        }
        return self.daoPlaceHoliday(from: any as? DAOPlaceHoliday)
    }
    func daoPlaceHoliday(from data: DNSDataDictionary?) -> DAOPlaceHoliday? {
        guard let data else { return nil }
        return DAOPlaceHoliday(from: data)
    }
    func daoPlaceHoliday(from daoPlaceHoliday: DAOPlaceHoliday?) -> DAOPlaceHoliday? {
        guard let daoPlaceHoliday else { return nil }
        return daoPlaceHoliday
    }
}
