//
//  DNSDataTranslation+daoSystemEndPoint.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoSystemEndPoint<K>(of objectType: DAOSystemEndPoint.Type,
                              from container: KeyedDecodingContainer<K>,
                              forKey key: KeyedDecodingContainer<K>.Key) -> DAOSystemEndPoint? where K: CodingKey {
        do { return try container.decodeIfPresent(objectType, forKey: key) } catch { }
        return nil
    }
    func daoSystemEndPointArray<K>(of arrayType: [DAOSystemEndPoint].Type,
                                   from container: KeyedDecodingContainer<K>,
                                   forKey key: KeyedDecodingContainer<K>.Key) -> [DAOSystemEndPoint] where K: CodingKey {
        do { return try container.decodeIfPresent(arrayType, forKey: key) ?? [] } catch { }
        return []
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoSystemEndPoint(from any: Any?) -> DAOSystemEndPoint? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoSystemEndPoint(from: any as? DNSDataDictionary)
        }
        return self.daoSystemEndPoint(from: any as? DAOSystemEndPoint)
    }
    func daoSystemEndPoint(from data: DNSDataDictionary?) -> DAOSystemEndPoint? {
        guard let data else { return nil }
        return DAOSystemEndPoint(from: data)
    }
    func daoSystemEndPoint(from daoSystemEndPoint: DAOSystemEndPoint?) -> DAOSystemEndPoint? {
        guard let daoSystemEndPoint else { return nil }
        return daoSystemEndPoint
    }
}
