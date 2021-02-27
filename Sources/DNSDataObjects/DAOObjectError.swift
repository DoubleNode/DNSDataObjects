//
//  DAOObjectError.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public enum DAOObjectError: Error
{
    case typeMismatch(expectedType: String, actualType: String, _ codeLocation: DNSCodeLocation)
    case unexpectedNil(name: String, _ codeLocation: DNSCodeLocation)
}
extension DAOObjectError: DNSError {
    public static let domain = "DAOOBJECT"
    public enum Code: Int
    {
        case typeMismatch = 1001
        case unexpectedNil = 1002
    }
    
    public var nsError: NSError! {
        switch self {
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
        case .typeMismatch:
            return NSLocalizedString("DAOOBJECT-Type Mismatch Error", comment: "")
                + " (\(Self.domain):\(Self.Code.typeMismatch.rawValue))"
        case .unexpectedNil:
            return NSLocalizedString("DAOOBJECT-Unexpected Nil Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unexpectedNil.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .typeMismatch(_, _, let codeLocation),
             .unexpectedNil(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}
