//
//  DNSDataObjectsCodeLocation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError

public extension DNSCodeLocation {
    typealias dataObjects = DNSDataObjectsCodeLocation
}
open class DNSDataObjectsCodeLocation: DNSCodeLocation {
    override open class var domainPreface: String { "com.doublenode.dataObjects." }
}
