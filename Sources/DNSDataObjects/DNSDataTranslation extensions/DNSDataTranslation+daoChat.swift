//
//  DNSDataTranslation+daoChat.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoChat<K>(with configuration: PTCLCFGDAOChat,
                    from container: KeyedDecodingContainer<K>,
                    forKey key: KeyedDecodingContainer<K>.Key) -> DAOChat? where K: CodingKey {
        return configuration.chat(from: container, forKey: key)
    }
    func daoChatArray<K>(with configuration: PTCLCFGDAOChat,
                         from container: KeyedDecodingContainer<K>,
                         forKey key: KeyedDecodingContainer<K>.Key) -> [DAOChat] where K: CodingKey {
        return configuration.chatArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoChat(from any: Any?) -> DAOChat? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoChat(from: any as? DNSDataDictionary)
        }
        return self.daoChat(from: any as? DAOChat)
    }
    func daoChat(from data: DNSDataDictionary?) -> DAOChat? {
        guard let data else { return nil }
        return DAOChat(from: data)
    }
    func daoChat(from daoChat: DAOChat?) -> DAOChat? {
        guard let daoChat else { return nil }
        return daoChat
    }
}
