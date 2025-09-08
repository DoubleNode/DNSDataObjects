//
//  DNSDataTranslation+daoAppActionImages.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAppActionImages<K>(with configuration: PTCLCFGDAOAppActionImages,
                               from container: KeyedDecodingContainer<K>,
                               forKey key: KeyedDecodingContainer<K>.Key) -> DAOAppActionImages? where K: CodingKey {
        return configuration.appActionImages(from: container, forKey: key)
    }
    func daoAppActionImagesArray<K>(with configuration: PTCLCFGDAOAppActionImages,
                                    from container: KeyedDecodingContainer<K>,
                                    forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAppActionImages] where K: CodingKey {
        return configuration.appActionImagesArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAppActionImages(from any: Any?) -> DAOAppActionImages? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAppActionImages(from: any as? DNSDataDictionary)
        }
        return self.daoAppActionImages(from: any as? DAOAppActionImages)
    }
    func daoAppActionImages(from data: DNSDataDictionary?) -> DAOAppActionImages? {
        guard let data else { return nil }
        return DAOAppActionImages(from: data)
    }
    func daoAppActionImages(from daoAppActionImages: DAOAppActionImages?) -> DAOAppActionImages? {
        guard let daoAppActionImages else { return nil }
        return daoAppActionImages
    }
}
