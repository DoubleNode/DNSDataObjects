//
//  DNSOrderState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import UIKit

public enum DNSOrderState: String, CaseIterable, Codable {
    case cancelled
    case completed
    case created
    case fraudulent
    case pending
    case processing
    case refunded
    case unknown
}
