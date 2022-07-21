//
//  DAONotificationType.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

public enum DNSNotificationType: String, CaseIterable, Codable {
    case unknown
    case alert
    case deepLink
    case deepLinkAuto
}
