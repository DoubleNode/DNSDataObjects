//
//  DNSDataTranslation+daoFaqSection.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoFaqSection<K>(with configuration: PTCLCFGDAOFaqSection,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> DAOFaqSection? where K: CodingKey {
        do { return try container.decodeIfPresent(configuration.faqSectionType, forKey: key,
                                                  configuration: configuration) } catch { }
        return nil
    }
    func daoFaqSectionArray<K>(with configuration: PTCLCFGDAOFaqSection,
                               from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> [DAOFaqSection] where K: CodingKey {
        return configuration.faqSectionArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoFaqSection(from any: Any?) -> DAOFaqSection? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoFaqSection(from: any as? DNSDataDictionary)
        }
        return self.daoFaqSection(from: any as? DAOFaqSection)
    }
    func daoFaqSection(from data: DNSDataDictionary?) -> DAOFaqSection? {
        guard let data else { return nil }
        return DAOFaqSection(from: data)
    }
    func daoFaqSection(from daoFaqSection: DAOFaqSection?) -> DAOFaqSection? {
        guard let daoFaqSection else { return nil }
        return daoFaqSection
    }
}
