//
//  DNSDataTranslation+daoDocument.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoDocument<K>(with configuration: PTCLCFGDAODocument,
                        from container: KeyedDecodingContainer<K>,
                        forKey key: KeyedDecodingContainer<K>.Key) -> DAODocument? where K: CodingKey {
        return configuration.document(from: container, forKey: key)
    }
    func daoDocumentArray<K>(with configuration: PTCLCFGDAODocument,
                             from container: KeyedDecodingContainer<K>,
                             forKey key: KeyedDecodingContainer<K>.Key) -> [DAODocument] where K: CodingKey {
        return configuration.documentArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoDocument(from any: Any?) -> DAODocument? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoDocument(from: any as? DNSDataDictionary)
        }
        return self.daoDocument(from: any as? DAODocument)
    }
    func daoDocument(from data: DNSDataDictionary?) -> DAODocument? {
        guard let data else { return nil }
        return DAODocument(from: data)
    }
    func daoDocument(from daoDocument: DAODocument?) -> DAODocument? {
        guard let daoDocument else { return nil }
        return daoDocument
    }
}
