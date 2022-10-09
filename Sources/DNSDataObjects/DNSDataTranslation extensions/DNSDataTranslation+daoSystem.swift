//
//  DNSDataTranslation+daoSystem.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoSystem<K>(of objectType: DAOSystem.Type,
                      from container: KeyedDecodingContainer<K>,
                      forKey key: KeyedDecodingContainer<K>.Key) -> DAOSystem? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoSystemArray<K>(of arrayType: [DAOSystem].Type,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystem] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoSystem(from any: Any?) -> DAOSystem? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoSystem(from: any as? DNSDataDictionary)
        }
        return self.daoSystem(from: any as? DAOSystem)
    }
    func daoSystem(from data: DNSDataDictionary?) -> DAOSystem? {
        guard let data else { return nil }
        return DAOSystem(from: data)
    }
    func daoSystem(from daoSystem: DAOSystem?) -> DAOSystem? {
        guard let daoSystem else { return nil }
        return daoSystem
    }
}
