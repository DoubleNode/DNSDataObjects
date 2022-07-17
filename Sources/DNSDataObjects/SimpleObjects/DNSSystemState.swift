//
//  DNSSystemState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

public enum DNSSystemState: String, CaseIterable, Codable {
    case none
    case green
    case orange
    case red
    case yellow
}
