//
//  DNSDataTranslation+daoSystemState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoSystemState<K>(of objectType: DAOSystemState.Type,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOSystemState? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoSystemStateArray<K>(of arrayType: [DAOSystemState].Type,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystemState] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoSystemState(from any: Any?) -> DAOSystemState? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoSystemState(from: any as? DNSDataDictionary)
        }
        return self.daoSystemState(from: any as? DAOSystemState)
    }
    func daoSystemState(from data: DNSDataDictionary?) -> DAOSystemState? {
        guard let data else { return nil }
        return DAOSystemState(from: data)
    }
    func daoSystemState(from daoSystemState: DAOSystemState?) -> DAOSystemState? {
        guard let daoSystemState else { return nil }
        return daoSystemState
    }
}
