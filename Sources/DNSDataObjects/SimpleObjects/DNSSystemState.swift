//
//  DNSSystemState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

public enum DNSSystemState: String, CaseIterable, Codable {
    case none
    case black
    case green
    case grey
    case orange
    case red
    case yellow
}
