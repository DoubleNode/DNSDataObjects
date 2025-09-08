//
//  DNSDataTranslation+daoEvent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoEvent<K>(with configuration: PTCLCFGDAOEvent,
                     from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOEvent? where K: CodingKey {
        return configuration.event(from: container, forKey: key)
    }
    func daoEventArray<K>(with configuration: PTCLCFGDAOEvent,
                        from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> [DAOEvent] where K: CodingKey {
        return configuration.eventArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoEvent(from any: Any?) -> DAOEvent? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoEvent(from: any as? DNSDataDictionary)
        }
        return self.daoEvent(from: any as? DAOEvent)
    }
    func daoEvent(from data: DNSDataDictionary?) -> DAOEvent? {
        guard let data else { return nil }
        return DAOEvent(from: data)
    }
    func daoEvent(from daoEvent: DAOEvent?) -> DAOEvent? {
        guard let daoEvent else { return nil }
        return daoEvent
    }
}
