//
//  DNSDataTranslation+daoTransaction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoTransaction<K>(with configuration: PTCLCFGDAOTransaction,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOTransaction? where K: CodingKey {
        return configuration.transaction(from: container, forKey: key)
    }
    func daoTransactionArray<K>(with configuration: PTCLCFGDAOTransaction,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOTransaction] where K: CodingKey {
        return configuration.transactionArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoTransaction(from any: Any?) -> DAOTransaction? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoTransaction(from: any as? DNSDataDictionary)
        }
        return self.daoTransaction(from: any as? DAOTransaction)
    }
    func daoTransaction(from data: DNSDataDictionary?) -> DAOTransaction? {
        guard let data else { return nil }
        return DAOTransaction(from: data)
    }
    func daoTransaction(from daoTransaction: DAOTransaction?) -> DAOTransaction? {
        guard let daoTransaction else { return nil }
        return daoTransaction
    }
}
