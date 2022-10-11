//
//  DNSDataTranslation+daoAppEvent.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAppEvent<K>(with configuration: PTCLCFGDAOAppEvent,
                        from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppEvent? where K: CodingKey {
        do { return try container.decodeIfPresent(configuration.appEventType, forKey: key,
                                                  configuration: configuration) } catch { }
        return nil
    }
    func daoAppEventArray<K>(with configuration: PTCLCFGDAOAppEvent,
                             from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppEvent] where K: CodingKey {
        return configuration.appEventArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAppEvent(from any: Any?) -> DAOAppEvent? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAppEvent(from: any as? DNSDataDictionary)
        }
        return self.daoAppEvent(from: any as? DAOAppEvent)
    }
    func daoAppEvent(from data: DNSDataDictionary?) -> DAOAppEvent? {
        guard let data else { return nil }
        return DAOAppEvent(from: data)
    }
    func daoAppEvent(from daoAppEvent: DAOAppEvent?) -> DAOAppEvent? {
        guard let daoAppEvent else { return nil }
        return daoAppEvent
    }
}
