//
//  DNSDataTranslation+daoNotification.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoNotification<K>(with configuration: PTCLCFGDAONotification,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAONotification? where K: CodingKey {
        return configuration.notification(from: container, forKey: key)
    }
    func daoNotificationArray<K>(with configuration: PTCLCFGDAONotification,
                                 from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAONotification] where K: CodingKey {
        return configuration.notificationArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoNotification(from any: Any?) -> DAONotification? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoNotification(from: any as? DNSDataDictionary)
        }
        return self.daoNotification(from: any as? DAONotification)
    }
    func daoNotification(from data: DNSDataDictionary?) -> DAONotification? {
        guard let data else { return nil }
        return DAONotification(from: data)
    }
    func daoNotification(from daoNotification: DAONotification?) -> DAONotification? {
        guard let daoNotification else { return nil }
        return daoNotification
    }
}
