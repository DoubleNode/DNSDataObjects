//
//  DAOObjectError.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import Foundation

public enum DAOObjectError: Error
{
    case typeMismatch(expectedType: String, actualType: String, domain: String, file: String, line: String, method: String)
    case unexpectedNil(name: String, domain: String, file: String, line: String, method: String)
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
        case .typeMismatch(let expectedType, let actualType, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "ExpectedType": expectedType, "ActualType": actualType,
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.typeMismatch.rawValue,
                                userInfo: userInfo)
        case .unexpectedNil(let name, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "Name": name, "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unexpectedNil.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
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
        case .typeMismatch(_, _, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .unexpectedNil(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        }
    }
}
