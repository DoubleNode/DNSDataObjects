//
//  DNSUserRole.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

public enum DNSUserRole: Int, CaseIterable, Codable {
    case superUser = 0
    case supportAdmin = 1000
    case supportOperation = 1250
    case supportStaff = 1500
    case supportViewer = 1750
    case regionalAdmin = 2000
    case regionalOperation = 2250
    case regionalStaff = 2500
    case regionalViewer = 2750
    case districtAdmin = 3000
    case districtOperation = 3250
    case districtStaff = 3500
    case districtViewer = 3750
    case centerAdmin = 4000
    case centerOperation = 4250
    case centerStaff = 4500
    case centerViewer = 4750
    case user = 9000
    case blocked = 10000
}
