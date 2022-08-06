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
    case placeAdmin = 4000
    case placeOperation = 4250
    case placeStaff = 4500
    case placeViewer = 4750
    case endUser = 9000
    case blocked = 10000

    public var isSuperUser: Bool { self.rawValue == DNSUserRole.superUser.rawValue }
    public func isAdmin(for scope: DNSScope = .place) -> Bool {
        switch scope {
        case .all: return self.rawValue <= DNSUserRole.supportViewer.rawValue
        case .region: return self.rawValue <= DNSUserRole.regionalViewer.rawValue
        case .district: return self.rawValue <= DNSUserRole.districtViewer.rawValue
        case .place: return self.rawValue <= DNSUserRole.placeViewer.rawValue
        }
    }
    public var code: String {
        switch self {
        case .superUser:  return "superUser"
        case .supportAdmin:  return "supportAdmin"
        case .supportOperation:  return "supportOperation"
        case .supportStaff:  return "supportStaff"
        case .supportViewer:  return "supportViewer"
        case .regionalAdmin:  return "regionalAdmin"
        case .regionalOperation:  return "regionalOperation"
        case .regionalStaff:  return "regionalStaff"
        case .regionalViewer:  return "regionalViewer"
        case .districtAdmin:  return "districtAdmin"
        case .districtOperation:  return "districtOperation"
        case .districtStaff:  return "districtStaff"
        case .districtViewer:  return "districtViewer"
        case .placeAdmin:  return "placeAdmin"
        case .placeOperation:  return "placeOperation"
        case .placeStaff:  return "placeStaff"
        case .placeViewer:  return "placeViewer"
        case .endUser:  return "endUser"
        case .blocked:  return "blocked"
        }
    }
    public static func userRole(from code: String) -> DNSUserRole {
        switch code {
        case "superUser":  return .superUser
        case "supportAdmin":  return .supportAdmin
        case "supportOperation":  return .supportOperation
        case "supportStaff":  return .supportStaff
        case "supportViewer":  return .supportViewer
        case "regionalAdmin":  return .regionalAdmin
        case "regionalOperation":  return .regionalOperation
        case "regionalStaff":  return .regionalStaff
        case "regionalViewer":  return .regionalViewer
        case "districtAdmin":  return .districtAdmin
        case "districtOperation":  return .districtOperation
        case "districtStaff":  return .districtStaff
        case "districtViewer":  return .districtViewer
        case "placeAdmin":  return .placeAdmin
        case "placeOperation":  return .placeOperation
        case "placeStaff":  return .placeStaff
        case "placeViewer":  return .placeViewer
        case "endUser":  return .endUser
        case "blocked":  return .blocked
        default: return .blocked
        }
    }
}
