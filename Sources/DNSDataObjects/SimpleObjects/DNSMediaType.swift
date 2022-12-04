//
//  DNSMediaType.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public enum DNSMediaType: String, CaseIterable, Codable {
    case unknown
    case animatedImage
    case pdfDocument
    case staticImage
    case text
    case video
}
