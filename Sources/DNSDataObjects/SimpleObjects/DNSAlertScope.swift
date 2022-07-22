//
//  DNSAlertScope.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public enum DNSAlertScope: Int, CaseIterable, Codable {
    case place = 1000
    case district = 3000
    case region = 5000
    case all = 10000
}
