//
//  DNSDataTranslation+daoAppActionColors.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAppActionColors<K>(with configuration: PTCLCFGDAOAppActionColors,
                               from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionColors? where K: CodingKey {
        return configuration.appActionColors(from: container, forKey: key)
    }
    func daoAppActionColorsArray<K>(with configuration: PTCLCFGDAOAppActionColors,
                                    from container: KeyedDecodingContainer<K>,
                                    forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionColors] where K: CodingKey {
        return configuration.appActionColorsArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAppActionColors(from any: Any?) -> DAOAppActionColors? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAppActionColors(from: any as? DNSDataDictionary)
        }
        return self.daoAppActionColors(from: any as? DAOAppActionColors)
    }
    func daoAppActionColors(from data: DNSDataDictionary?) -> DAOAppActionColors? {
        guard let data else { return nil }
        return DAOAppActionColors(from: data)
    }
    func daoAppActionColors(from daoAppActionColors: DAOAppActionColors?) -> DAOAppActionColors? {
        guard let daoAppActionColors else { return nil }
        return daoAppActionColors
    }
}
