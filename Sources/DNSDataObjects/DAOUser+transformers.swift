//
//  DAOUser+transformers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation
import KeyedCodable

extension DAOUser {
    public enum AccountArrayTransformer: Transformer {
        public typealias Destination = [DAOAccount]
        public typealias Object = [DAOAccount]

        public static func transform(from decodable: [DAOAccount]) -> Any? {
            decodable.compactMap { DAOUser.createAccount(from: $0) }
        }
        public static func transform(object: [DAOAccount]) throws -> [DAOAccount]? {
            object as Destination
        }
    }
    public enum ActivityTypeArrayTransformer: Transformer {
        public typealias Destination = [DAOActivityType]
        public typealias Object = [DAOActivityType]

        public static func transform(from decodable: [DAOActivityType]) -> Any? {
            decodable.compactMap { DAOUser.createActivityType(from: $0) }
        }
        public static func transform(object: [DAOActivityType]) throws -> [DAOActivityType]? {
            object as Destination
        }
    }
    public enum CardArrayTransformer: Transformer {
        public typealias Destination = [DAOCard]
        public typealias Object = [DAOCard]

        public static func transform(from decodable: [DAOCard]) -> Any? {
            decodable.compactMap { DAOUser.createCard(from: $0) }
        }
        public static func transform(object: [DAOCard]) throws -> [DAOCard]? {
            object as Destination
        }
    }
    public enum PlaceTransformer: Transformer {
        public typealias Destination = DAOPlace?
        public typealias Object = DAOPlace?

        public static func transform(from decodable: DAOPlace?) -> Any? {
            guard let decodable else { return nil }
            return DAOUser.createPlace(from: decodable)
        }
        public static func transform(object: DAOPlace?) throws -> DAOPlace?? {
            object as Destination
        }
    }
}
