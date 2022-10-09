//
//  DNSDataTranslation+daoActivityBlackout.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoActivityBlackout<K>(of objectType: DAOActivityBlackout.Type,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> DAOActivityBlackout? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoActivityBlackoutArray<K>(of arrayType: [DAOActivityBlackout].Type,
                                     from container: KeyedDecodingContainer<K>,
                                     forKey key: KeyedDecodingContainer<K>.Key) -> [DAOActivityBlackout] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoActivityBlackout(from any: Any?) -> DAOActivityBlackout? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoActivityBlackout(from: any as? DNSDataDictionary)
        }
        return self.daoActivityBlackout(from: any as? DAOActivityBlackout)
    }
    func daoActivityBlackout(from data: DNSDataDictionary?) -> DAOActivityBlackout? {
        guard let data else { return nil }
        return DAOActivityBlackout(from: data)
    }
    func daoActivityBlackout(from daoActivityBlackout: DAOActivityBlackout?) -> DAOActivityBlackout? {
        guard let daoActivityBlackout else { return nil }
        return daoActivityBlackout
    }
}
