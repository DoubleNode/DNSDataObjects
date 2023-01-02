//
//  DNSVisibility.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

public enum DNSVisibility: String, CaseIterable, Codable {
    case adultsOnly
    case everyone
    case staffCadets
    case staffOnly
}
