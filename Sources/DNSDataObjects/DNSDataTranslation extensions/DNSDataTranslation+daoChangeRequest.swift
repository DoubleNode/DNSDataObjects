//
//  DNSDataTranslation+daoChangeRequest.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoChangeRequest<K>(with configuration: PTCLCFGDAOChangeRequest,
                             from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> DAOChangeRequest? where K: CodingKey {
        return configuration.changeRequest(from: container, forKey: key)
    }
    func daoChangeRequestArray<K>(with configuration: PTCLCFGDAOChangeRequest,
                                  from container: KeyedDecodingContainer<K>,
                                  forKey key: KeyedDecodingContainer<K>.Key) -> [DAOChangeRequest] where K: CodingKey {
        return configuration.changeRequestArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoChangeRequest(from any: Any?) -> DAOChangeRequest? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoChangeRequest(from: any as? DNSDataDictionary)
        }
        return self.daoChangeRequest(from: any as? DAOChangeRequest)
    }
    func daoChangeRequest(from data: DNSDataDictionary?) -> DAOChangeRequest? {
        guard let data else { return nil }
        return DAOChangeRequest(from: data)
    }
    func daoChangeRequest(from daoChangeRequest: DAOChangeRequest?) -> DAOChangeRequest? {
        guard let daoChangeRequest else { return nil }
        return daoChangeRequest
    }
}
