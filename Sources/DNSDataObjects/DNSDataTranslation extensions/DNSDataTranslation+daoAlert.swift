//
//  DNSDataTranslation+daoAlert.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAlert<K>(with configuration: PTCLCFGDAOAlert,
                     from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOAlert? where K: CodingKey {
        return configuration.alert(from: container, forKey: key)
    }
    func daoAlertArray<K>(with configuration: PTCLCFGDAOAlert,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAlert] where K: CodingKey {
        return configuration.alertArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAlert(from any: Any?) -> DAOAlert? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAlert(from: any as? DNSDataDictionary)
        }
        return self.daoAlert(from: any as? DAOAlert)
    }
    func daoAlert(from data: DNSDataDictionary?) -> DAOAlert? {
        guard let data else { return nil }
        return DAOAlert(from: data)
    }
    func daoAlert(from daoAlert: DAOAlert?) -> DAOAlert? {
        guard let daoAlert else { return nil }
        return daoAlert
    }
}
