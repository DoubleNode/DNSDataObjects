//
//  DNSDataTranslation+daoSection.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoSection<K>(with configuration: PTCLCFGDAOSection,
                       from container: KeyedDecodingContainer<K>,
                       forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey {
        return configuration.section(from: container, forKey: key)
    }
    func daoSectionChild<K>(with configuration: PTCLCFGDAOSectionSection,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey {
        return configuration.sectionChild(from: container, forKey: key)
    }
    func daoSectionParent<K>(with configuration: PTCLCFGDAOSectionSection,
                             from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOSection? where K: CodingKey {
        return configuration.sectionParent(from: container, forKey: key)
    }
    func daoSectionArray<K>(with configuration: PTCLCFGDAOSection,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey {
        return configuration.sectionArray(from: container, forKey: key)
    }
    func daoSectionChildArray<K>(with configuration: PTCLCFGDAOSectionSection,
                                 from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey {
        return configuration.sectionChildArray(from: container, forKey: key)
    }
    func daoSectionParentArray<K>(with configuration: PTCLCFGDAOSectionSection,
                                  from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSection] where K: CodingKey {
        return configuration.sectionParentArray(from: container, forKey: key)
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
