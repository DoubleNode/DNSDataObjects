//
//  DNSDataTranslation+daoSection.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoSection<K>(of objectType: DAOSection.Type,
                       from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoSectionArray<K>(of arrayType: [DAOSection].Type,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoSection(from any: Any?) -> DAOSection? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoSection(from: any as? DNSDataDictionary)
        }
        return self.daoSection(from: any as? DAOSection)
    }
    func daoSection(from data: DNSDataDictionary?) -> DAOSection? {
        guard let data else { return nil }
        return DAOSection(from: data)
    }
    func daoSection(from daoSection: DAOSection?) -> DAOSection? {
        guard let daoSection else { return nil }
        return daoSection
    }
}
