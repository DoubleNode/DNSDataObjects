//
//  DNSDataTranslation+daoPlace.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPlace<K>(of objectType: DAOPlace.Type,
                     from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOPlace? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoPlaceArray<K>(of arrayType: [DAOPlace].Type,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPlace] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPlace(from any: Any?) -> DAOPlace? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPlace(from: any as? DNSDataDictionary)
        }
        return self.daoPlace(from: any as? DAOPlace)
    }
    func daoPlace(from data: DNSDataDictionary?) -> DAOPlace? {
        guard let data else { return nil }
        return DAOPlace(from: data)
    }
    func daoPlace(from daoPlace: DAOPlace?) -> DAOPlace? {
        guard let daoPlace else { return nil }
        return daoPlace
    }
}
