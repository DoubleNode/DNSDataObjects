//
//  DNSDataObjectsError.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias DataObjects = DNSDataObjectsError
}
public enum DNSDataObjectsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case typeMismatch(expectedType: String, actualType: String, _ codeLocation: DNSCodeLocation)
    case unexpectedNil(name: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "DATAOBJECTS"
    public enum Code: Int
    {
        case unknown = 1001
        case typeMismatch = 1002
        case unexpectedNil = 1003
    }
    
    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .typeMismatch(let expectedType, let actualType, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["ExpectedType"] = expectedType
            userInfo["ActualType"] = actualType
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.typeMismatch.rawValue,
                                userInfo: userInfo)
        case .unexpectedNil(let name, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Name"] = name
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unexpectedNil.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("DATAOBJECTS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .typeMismatch(let expectedType, let actualType, _):
            return String(format: NSLocalizedString("DATAOBJECTS-Type Mismatch Error%@%@%@", comment: ""),
                          "\(expectedType)",
                          "\(actualType)",
                          " (\(Self.domain):\(Self.Code.typeMismatch.rawValue))")
        case .unexpectedNil(let name, _):
            return String(format: NSLocalizedString("DATAOBJECTS-Unexpected Nil Error%@%@", comment: ""),
                          "\(name)",
                          " (\(Self.domain):\(Self.Code.unexpectedNil.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .typeMismatch(_, _, let codeLocation),
             .unexpectedNil(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}
