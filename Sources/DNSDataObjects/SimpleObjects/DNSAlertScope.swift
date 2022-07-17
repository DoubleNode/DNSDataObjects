//
//  DNSAlertScope.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public enum DNSAlertScope: String, CaseIterable, Codable {
    case all
    case center
    case district
    case region
}
