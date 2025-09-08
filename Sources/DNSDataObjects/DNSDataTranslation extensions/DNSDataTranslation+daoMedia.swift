//
//  DNSDataTranslation+daoMedia.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoMedia<K>(with configuration: PTCLCFGDAOMedia,
                     from container: KeyedDecodingContainer<K>,
                     forKey key: KeyedDecodingContainer<K>.Key) -> DAOMedia? where K: CodingKey {
        return configuration.media(from: container, forKey: key)
    }
    func daoMediaArray<K>(with configuration: PTCLCFGDAOMedia,
                          from container: KeyedDecodingContainer<K>,
                          forKey key: KeyedDecodingContainer<K>.Key) -> [DAOMedia] where K: CodingKey {
        return configuration.mediaArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoMedia(from any: Any?) -> DAOMedia? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoMedia(from: any as? DNSDataDictionary)
        }
        return self.daoMedia(from: any as? DAOMedia)
    }
    func daoMedia(from data: DNSDataDictionary?) -> DAOMedia? {
        guard let data else { return nil }
        return DAOMedia(from: data)
    }
    func daoMedia(from daoMedia: DAOMedia?) -> DAOMedia? {
        guard let daoMedia else { return nil }
        return daoMedia
    }
}
