//
//  DNSStatus.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

public enum DNSStatus: String, CaseIterable, Codable {
    case badWeather
    case closed
    case comingSoon
    case grandOpening
    case hidden
    case holiday
    case maintenance
    case open
    case privateEvent
    case tempClosed
    case training
}
