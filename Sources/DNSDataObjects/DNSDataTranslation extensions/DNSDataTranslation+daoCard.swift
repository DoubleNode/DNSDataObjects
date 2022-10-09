//
//  DNSDataTranslation+daoCard.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoCard<K>(from container: KeyedDecodingContainer<K>,
                    forKey key: KeyedDecodingContainer<K>.Key) -> DAOCard? where K: CodingKey {
        do { return try container.decodeIfPresent(DAOCard.self, forKey: key) } catch { }
        return nil
    }
    func daoCardArray<K>(from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> [DAOCard] where K: CodingKey {
        do { return try container.decodeIfPresent([DAOCard].self, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoCard(from any: Any?) -> DAOCard? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoCard(from: any as? DNSDataDictionary)
        }
        return self.daoCard(from: any as? DAOCard)
    }
    func daoCard(from data: DNSDataDictionary?) -> DAOCard? {
        guard let data else { return nil }
        return DAOCard(from: data)
    }
    func daoCard(from daoCard: DAOCard?) -> DAOCard? {
        guard let daoCard else { return nil }
        return daoCard
    }
}
