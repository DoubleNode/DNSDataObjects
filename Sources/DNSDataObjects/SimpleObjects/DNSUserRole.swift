//
//  DNSUserRole.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

public enum DNSUserRole: Int, CaseIterable, Codable {
    case blocked = -1
    case endUser = 0
    case placeViewer = 6000
    case placeStaff = 7000
    case placeOperation = 8000
    case placeAdmin = 9000
    case districtViewer = 60000
    case districtStaff = 70000
    case districtOperation = 80000
    case districtAdmin = 90000
    case regionalViewer = 100000
    case regionalStaff = 200000
    case regionalOperation = 300000
    case regionalAdmin = 400000
    case supportViewer = 500000
    case supportStaff = 600000
    case supportOperation = 700000
    case supportAdmin = 800000
    case superUser = 900000

    public var isSuperUser: Bool { self.rawValue == DNSUserRole.superUser.rawValue }
    public func isAdmin(for scope: DNSScope = .place) -> Bool {
        switch scope {
        case .all: return self.rawValue >= DNSUserRole.supportViewer.rawValue
        case .region: return self.rawValue >= DNSUserRole.regionalViewer.rawValue
        case .district: return self.rawValue >= DNSUserRole.districtViewer.rawValue
        case .place: return self.rawValue >= DNSUserRole.placeViewer.rawValue
        }
    }
    public var code: String {
        switch self {
        case .superUser:  return "SuperUser"
        case .supportAdmin:  return "SupportAdmin"
        case .supportOperation:  return "SupportOperation"
        case .supportStaff:  return "SupportStaff"
        case .supportViewer:  return "SupportViewer"
        case .regionalAdmin:  return "RegionalAdmin"
        case .regionalOperation:  return "RegionalOperation"
        case .regionalStaff:  return "RegionalStaff"
        case .regionalViewer:  return "RegionalViewer"
        case .districtAdmin:  return "DistrictAdmin"
        case .districtOperation:  return "DistrictOperation"
        case .districtStaff:  return "DistrictStaff"
        case .districtViewer:  return "DistrictViewer"
        case .placeAdmin:  return "PlaceAdmin"
        case .placeOperation:  return "PlaceOperation"
        case .placeStaff:  return "PlaceStaff"
        case .placeViewer:  return "PlaceViewer"
        case .endUser:  return "EndUser"
        case .blocked:  return "Blocked"
        }
    }
    public static func userRole(from code: String) -> DNSUserRole {
        switch code {
        case "SuperUser":  return .superUser
        case "SupportAdmin":  return .supportAdmin
        case "SupportOperation":  return .supportOperation
        case "SupportStaff":  return .supportStaff
        case "SupportViewer":  return .supportViewer
        case "RegionalAdmin":  return .regionalAdmin
        case "RegionalOperation":  return .regionalOperation
        case "RegionalStaff":  return .regionalStaff
        case "RegionalViewer":  return .regionalViewer
        case "DistrictAdmin":  return .districtAdmin
        case "DistrictOperation":  return .districtOperation
        case "DistrictStaff":  return .districtStaff
        case "DistrictViewer":  return .districtViewer
        case "PlaceAdmin":  return .placeAdmin
        case "PlaceOperation":  return .placeOperation
        case "PlaceStaff":  return .placeStaff
        case "PlaceViewer":  return .placeViewer
        case "EndUser":  return .endUser
        case "Blocked":  return .blocked
        default: return .blocked
        }
    }
}
