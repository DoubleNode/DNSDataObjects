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
    case center
    case district
    case region
    case all
}
