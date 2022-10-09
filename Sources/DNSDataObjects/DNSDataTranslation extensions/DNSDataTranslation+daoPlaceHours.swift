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
    func daoPlaceHours<K>(of objectType: DAOPlaceHours.Type,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlaceHours? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoPlaceHoursArray<K>(of arrayType: [DAOPlaceHours].Type,
                               from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceHours] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
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
