//
//  DNSDataTranslation+daoAccount.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAccount<K>(with configuration: PTCLCFGDAOAccount,
                       from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOAccount? where K: CodingKey {
        return configuration.account(from: container, forKey: key)
    }
    func daoAccountArray<K>(with configuration: PTCLCFGDAOAccount,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAccount] where K: CodingKey {
        return configuration.accountArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAccount(from any: Any?) -> DAOAccount? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAccount(from: any as? DNSDataDictionary)
        }
        return self.daoAccount(from: any as? DAOAccount)
    }
    func daoAccount(from data: DNSDataDictionary?) -> DAOAccount? {
        guard let data else { return nil }
        return DAOAccount(from: data)
    }
    func daoAccount(from daoAccount: DAOAccount?) -> DAOAccount? {
        guard let daoAccount else { return nil }
        return daoAccount
    }
}
