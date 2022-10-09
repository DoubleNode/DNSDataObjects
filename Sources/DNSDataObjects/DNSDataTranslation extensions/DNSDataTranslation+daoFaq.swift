//
//  DNSDataTranslation+daoFaq.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoFaq<K>(of objectType: DAOFaq.Type,
                   from container: KeyedDecodingContainer<K>,
                   forKey key: KeyedDecodingContainer<K>.Key) -> DAOFaq? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoFaqArray<K>(of arrayType: [DAOFaq].Type,
                        from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> [DAOFaq] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoFaq(from any: Any?) -> DAOFaq? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoFaq(from: any as? DNSDataDictionary)
        }
        return self.daoFaq(from: any as? DAOFaq)
    }
    func daoFaq(from data: DNSDataDictionary?) -> DAOFaq? {
        guard let data else { return nil }
        return DAOFaq(from: data)
    }
    func daoFaq(from daoFaq: DAOFaq?) -> DAOFaq? {
        guard let daoFaq else { return nil }
        return daoFaq
    }
}
