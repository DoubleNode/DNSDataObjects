//
//  DNSDataTranslation+daoChatMessage.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DNSDataTranslation {
    func daoChatMessage<K>(with configuration: PTCLCFGDAOChatMessage,
                           from container: KeyedDecodingContainer<K>,
                           forKey key: KeyedDecodingContainer<K>.Key) -> DAOChatMessage? where K: CodingKey {
        return configuration.chatMessage(from: container, forKey: key)
    }
    func daoChatMessageArray<K>(with configuration: PTCLCFGDAOChatMessage,
                                from container: KeyedDecodingContainer<K>,
                                forKey key: KeyedDecodingContainer<K>.Key) -> [DAOChatMessage] where K: CodingKey {
        return configuration.chatMessageArray(from: container, forKey: key)
    }
    // swiftlint:disable:next cyclomatic_complexity
    func daoChatMessage(from any: Any?) -> DAOChatMessage? {
        guard let any else { return nil }
        if any is DNSDataDictionary {
            return self.daoChatMessage(from: any as? DNSDataDictionary)
        }
        return self.daoChatMessage(from: any as? DAOChatMessage)
    }
    func daoChatMessage(from data: DNSDataDictionary?) -> DAOChatMessage? {
        guard let data else { return nil }
        return DAOChatMessage(from: data)
    }
    func daoChatMessage(from daoChatMessage: DAOChatMessage?) -> DAOChatMessage? {
        guard let daoChatMessage else { return nil }
        return daoChatMessage
    }
}
