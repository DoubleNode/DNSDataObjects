//
//  DAOAccount+transformers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation
import KeyedCodable

extension DAOAccount {
    public enum CardArrayTransformer: Transformer {
        public typealias Destination = [DAOCard]
        public typealias Object = [DAOCard]

        public static func transform(from decodable: [DAOCard]) -> Any? {
            decodable.compactMap { DAOAccount.createCard(from: $0) }
        }
        public static func transform(object: [DAOCard]) throws -> [DAOCard]? {
            object as Destination
        }
    }
    public enum UserArrayTransformer: Transformer {
        public typealias Destination = [DAOUser]
        public typealias Object = [DAOUser]

        public static func transform(from decodable: [DAOUser]) -> Any? {
            decodable.compactMap { DAOAccount.createUser(from: $0) }
        }
        public static func transform(object: [DAOUser]) throws -> [DAOUser]? {
            object as Destination
        }
    }
}
