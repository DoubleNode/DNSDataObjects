//
//  DNSDataTranslation+daoPromotion.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoPromotion<K>(with configuration: PTCLCFGDAOPromotion,
                         from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> DAOPromotion? where K: CodingKey {
        return configuration.promotion(from: container, forKey: key)
    }
    func daoPromotionArray<K>(with configuration: PTCLCFGDAOPromotion,
                              from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> [DAOPromotion] where K: CodingKey {
        return configuration.promotionArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoPromotion(from any: Any?) -> DAOPromotion? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoPromotion(from: any as? DNSDataDictionary)
        }
        return self.daoPromotion(from: any as? DAOPromotion)
    }
    func daoPromotion(from data: DNSDataDictionary?) -> DAOPromotion? {
        guard let data else { return nil }
        return DAOPromotion(from: data)
    }
    func daoPromotion(from daoPromotion: DAOPromotion?) -> DAOPromotion? {
        guard let daoPromotion else { return nil }
        return daoPromotion
    }
}
