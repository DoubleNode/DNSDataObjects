//
//  DNSDataTranslation+daoAppAction.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAppAction<K>(with configuration: PTCLCFGDAOAppAction,
                         from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppAction? where K: CodingKey {
        return configuration.appAction(from: container, forKey: key)
    }
    func daoAppActionArray<K>(with configuration: PTCLCFGDAOAppAction,
                              from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppAction] where K: CodingKey {
        return configuration.appActionArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAppAction(from any: Any?) -> DAOAppAction? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAppAction(from: any as? DNSDataDictionary)
        }
        return self.daoAppAction(from: any as? DAOAppAction)
    }
    func daoAppAction(from data: DNSDataDictionary?) -> DAOAppAction? {
        guard let data else { return nil }
        return DAOAppAction(from: data)
    }
    func daoAppAction(from daoAppAction: DAOAppAction?) -> DAOAppAction? {
        guard let daoAppAction else { return nil }
        return daoAppAction
    }
}
