//
//  DAONotification.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

open class DAONotification: DAOBaseObject {
    public enum NotificationType: String, CaseIterable, Codable {
        case unknown
        case alert
        case deepLink
        case deepLinkAuto
        public static func notificationType(for typeString: String) -> NotificationType {
            guard let retval = (DAONotification.NotificationType.allCases.first { typeString == $0.rawValue }) else {
                return .unknown
            }
            return retval
        }
    }
    
    var body = ""
    var deepLink: URL?
    var title = ""
    var type: DAONotification.NotificationType
    
    // TODO: Implement all CodingKeys
    private enum CodingKeys: String, CodingKey {
        case body, deepLink, title, type
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decode(String.self, forKey: .body)
        deepLink = try container.decode(URL.self, forKey: .deepLink)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(DAONotification.NotificationType.self, forKey: .type)
        
        // Get superDecoder for superclass and call super.init(from:) with it
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    public override init(from dictionary: [String: Any?]) {
        self.type = .unknown
        super.init()
        _ = self.dao(from: dictionary)
    }
    public init(type: DAONotification.NotificationType) {
        self.type = type
        super.init()
    }
    
    open override func dao(from dictionary: [String: Any?]) -> DAOBaseObject {
        self.body = self.string(from: dictionary["body"] as Any?) ?? ""
        self.deepLink = self.url(from: self.localized(dictionary["deepLink"] as Any?))
        self.title = self.string(from: dictionary["title"] as Any?) ?? ""
        self.type = NotificationType.notificationType(for: self.string(from: dictionary["type"] as Any?) ?? "")
        
        _ = super.dao(from: dictionary)
        
        return self
    }
}
