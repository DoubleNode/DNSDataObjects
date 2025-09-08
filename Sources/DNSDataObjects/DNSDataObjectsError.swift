//
//  DNSDataObjectsError.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias DataObjects = DNSDataObjectsError
}
public enum DNSDataObjectsError: DNSError {
    // Common Errors
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case notFound(field: String, value: String, _ codeLocation: DNSCodeLocation)
    case invalidParameters(parameters: [String], _ codeLocation: DNSCodeLocation)
    case lowerError(error: Error, _ codeLocation: DNSCodeLocation)
    // Domain-Specific Errors
    case typeMismatch(expectedType: String, actualType: String, _ codeLocation: DNSCodeLocation)
    case unexpectedNil(name: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "DATAOBJECTS"
    public enum Code: Int
    {
        // Common Errors
        case unknown = 1001
        case notImplemented = 1002
        case notFound = 1003
        case invalidParameters = 1004
        case lowerError = 1005
        // Domain-Specific Errors
        case typeMismatch = 2001
        case unexpectedNil = 2002
    }
    
    public var nsError: NSError! {
        switch self {
            // Common Errors
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        case .notFound(let field, let value, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["field"] = field
            userInfo["value"] = value
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notFound.rawValue,
                                userInfo: userInfo)
        case .invalidParameters(let parameters, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Parameters"] = parameters
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidParameters.rawValue,
                                userInfo: userInfo)
        case .lowerError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.lowerError.rawValue,
                                userInfo: userInfo)
            // Domain-Specific Errors
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
            // Common Errors
        case .unknown:
            return String(format: NSLocalizedString("DATAOBJECTS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("DATAOBJECTS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let field, let value, _):
            return String(format: NSLocalizedString("DATAOBJECTS-Not Found%@%@%@", comment: ""),
                          "\(field)", "\(value)",
                          "(\(Self.domain):\(Self.Code.notFound.rawValue))")
        case .invalidParameters(let parameters, _):
            let parametersString = parameters.reduce("") { $0 + ($0.isEmpty ? "" : ", ") + $1 }
            return String(format: NSLocalizedString("DATAOBJECTS-Invalid Parameters%@%@", comment: ""),
                          "\(parametersString)",
                          " (\(Self.domain):\(Self.Code.invalidParameters.rawValue))")
        case .lowerError(let error, _):
            return String(format: NSLocalizedString("DATAOBJECTS-Lower Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.lowerError.rawValue))")
            // Domain-Specific Errors
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
            // Common Errors
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .notFound(_, _, let codeLocation),
             .invalidParameters(_, let codeLocation),
             .lowerError(_, let codeLocation),
            // Domain-Specific Errors
             .typeMismatch(_, _, let codeLocation),
             .unexpectedNil(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}
