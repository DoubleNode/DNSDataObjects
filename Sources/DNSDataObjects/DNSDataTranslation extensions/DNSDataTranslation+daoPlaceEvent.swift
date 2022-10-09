//
//  DNSDataTranslation+daoPlaceEvent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPlaceEvent<K>(of objectType: DAOPlaceEvent.Type,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlaceEvent? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoPlaceEventArray<K>(of arrayType: [DAOPlaceEvent].Type,
                               from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlaceEvent] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPlaceEvent(from any: Any?) -> DAOPlaceEvent? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPlaceEvent(from: any as? DNSDataDictionary)
        }
        return self.daoPlaceEvent(from: any as? DAOPlaceEvent)
    }
    func daoPlaceEvent(from data: DNSDataDictionary?) -> DAOPlaceEvent? {
        guard let data else { return nil }
        return DAOPlaceEvent(from: data)
    }
    func daoPlaceEvent(from daoPlaceEvent: DAOPlaceEvent?) -> DAOPlaceEvent? {
        guard let daoPlaceEvent else { return nil }
        return daoPlaceEvent
    }
}
