//
//  DNSDataTranslation+daoUser.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoUser<K>(from container: KeyedDecodingContainer<K>,
                    forKey key: KeyedDecodingContainer<K>.Key) -> DAOUser? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOUser.self, forKey: key) } catch { }
        return nil
    }
    func daoUserArray<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> [DAOUser] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOUser].self, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoUser(from any: Any?) -> DAOUser? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoUser(from: any as? DNSDataDictionary)
        }
        return self.daoUser(from: any as? DAOUser)
    }
    func daoUser(from data: DNSDataDictionary?) -> DAOUser? {
        guard let data else { return nil }
        return DAOUser(from: data)
    }
    func daoUser(from daoUser: DAOUser?) -> DAOUser? {
        guard let daoUser else { return nil }
        return daoUser
    }
}
