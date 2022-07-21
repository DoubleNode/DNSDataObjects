//
//  DNSCenterStatus.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

public enum DNSCenterStatus: String, CaseIterable, Codable {
    case badWeather
    case closed
    case comingSoon
    case grandOpening
    case hidden
    case holiday
    case open
    case tempClosed
}
