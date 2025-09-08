//
//  DNSDataTranslation+daoApplication.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoApplication<K>(with configuration: PTCLCFGDAOApplication,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOApplication? where K: CodingKey {
        return configuration.application(from: container, forKey: key)
    }
    func daoApplicationArray<K>(with configuration: PTCLCFGDAOApplication,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOApplication] where K: CodingKey {
        return configuration.applicationArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoApplication(from any: Any?) -> DAOApplication? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoApplication(from: any as? DNSDataDictionary)
        }
        return self.daoApplication(from: any as? DAOApplication)
    }
    func daoApplication(from data: DNSDataDictionary?) -> DAOApplication? {
        guard let data else { return nil }
        return DAOApplication(from: data)
    }
    func daoApplication(from daoApplication: DAOApplication?) -> DAOApplication? {
        guard let daoApplication else { return nil }
        return daoApplication
    }
}
