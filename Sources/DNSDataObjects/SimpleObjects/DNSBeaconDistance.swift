//
//  DNSBeaconDistance.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

public enum DNSBeaconDistance: String, CaseIterable, Codable {
    case unknown
    case distant
    case far
    case nearby
    case close
    case immediate

    public var code: String {
        switch self {
        case .unknown:  return "unk"
        case .distant:  return "dis"
        case .far:      return "far"
        case .nearby:   return "nea"
        case .close:    return "clo"
        // .immediate
        default:        return "imm"
        }
    }
    public var index: Int {
        switch self {
        case .unknown:  return 1
        case .distant:  return 2
        case .far:      return 3
        case .nearby:   return 4
        case .close:    return 5
        // .immediate
        default:        return 6
        }
    }
    public var signalLevel: Int8 {
        switch self {
        case .unknown:  return 5
        case .distant:  return 20
        case .far:      return 45
        case .nearby:   return 70
        case .close:    return 95
        // .immediate
        default:        return 100
        }
    }
}
