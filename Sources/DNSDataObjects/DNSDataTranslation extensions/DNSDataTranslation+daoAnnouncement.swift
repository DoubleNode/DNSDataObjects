//
//  DNSDataTranslation+daoAnnouncement.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoAnnouncement<K>(with configuration: PTCLCFGDAOAnnouncement,
                            from container: KeyedDecodingContainer<K>,
                            forKey key: KeyedDecodingContainer<K>.Key) -> DAOAnnouncement? where K: CodingKey {
        return configuration.announcement(from: container, forKey: key)
    }
    func daoAnnouncementArray<K>(with configuration: PTCLCFGDAOAnnouncement,
                                 from container: KeyedDecodingContainer<K>,
                                 forKey key: KeyedDecodingContainer<K>.Key) -> [DAOAnnouncement] where K: CodingKey {
        return configuration.announcementArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoAnnouncement(from any: Any?) -> DAOAnnouncement? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoAnnouncement(from: any as? DNSDataDictionary)
        }
        return self.daoAnnouncement(from: any as? DAOAnnouncement)
    }
    func daoAnnouncement(from data: DNSDataDictionary?) -> DAOAnnouncement? {
        guard let data else { return nil }
        return DAOAnnouncement(from: data)
    }
    func daoAnnouncement(from daoAnnouncement: DAOAnnouncement?) -> DAOAnnouncement? {
        guard let daoAnnouncement else { return nil }
        return daoAnnouncement
    }
}
