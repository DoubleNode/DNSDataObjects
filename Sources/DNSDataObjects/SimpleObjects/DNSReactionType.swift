//
//  DNSReactionType.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

public enum DNSReactionType: String, CaseIterable, Codable {
    case unknown = ""
    case angered
    case cared
    case humored
    case liked
    case loved
    case saddened
    case wowed
}
