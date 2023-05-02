//
//  DNSDataTranslation+daoAppActionThemes.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAppActionThemes<K>(with configuration: PTCLCFGDAOAppActionThemes,
                               from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionThemes? where K: CodingKey {
        return configuration.appActionThemes(from: container, forKey: key)
    }
    func daoAppActionThemesArray<K>(with configuration: PTCLCFGDAOAppActionThemes,
                                    from container: KeyedDecodingContainer<K>,
                                    forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionThemes] where K: CodingKey {
        return configuration.appActionThemesArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAppActionThemes(from any: Any?) -> DAOAppActionThemes? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAppActionThemes(from: any as? DNSDataDictionary)
        }
        return self.daoAppActionThemes(from: any as? DAOAppActionThemes)
    }
    func daoAppActionThemes(from data: DNSDataDictionary?) -> DAOAppActionThemes? {
        guard let data else { return nil }
        return DAOAppActionThemes(from: data)
    }
    func daoAppActionThemes(from daoAppActionThemes: DAOAppActionThemes?) -> DAOAppActionThemes? {
        guard let daoAppActionThemes else { return nil }
        return daoAppActionThemes
    }
}
