//
//  Sequence+hasDiffElementsFrom.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation
import KeyedCodable

public extension Sequence where Element: DNSAnalyticsNumbers {
    var count: Int { return reduce(0) { acc, row in acc + 1 } }

    func hasDiffElementsFrom(_ rhs: [DNSAnalyticsNumbers]) -> Bool {
        guard self.count == rhs.count else { return true }
        var anyNonMatches = false
        self.forEach { lhsElement in
            let foundMatch = rhs.reduce(false) { $0 || !lhsElement.isDiffFrom($1) }
            if !foundMatch {
                anyNonMatches = true
            }
        }
        return anyNonMatches
    }
}
public extension Sequence where Element: DAOBaseObject {
    var count: Int { return reduce(0) { acc, row in acc + 1 } }

    func hasDiffElementsFrom(_ rhs: [DAOBaseObject]) -> Bool {
        guard self.count == rhs.count else { return true }
        var anyNonMatches = false
        self.forEach { lhsElement in
            let foundMatch = rhs.reduce(false) { $0 || !lhsElement.isDiffFrom($1) }
            if !foundMatch {
                anyNonMatches = true
            }
        }
        return anyNonMatches
    }
}
public extension Sequence where Element: DNSNote {
    var count: Int { return reduce(0) { acc, row in acc + 1 } }

    func hasDiffElementsFrom(_ rhs: [DNSNote]) -> Bool {
        guard self.count == rhs.count else { return true }
        var anyNonMatches = false
        self.forEach { lhsElement in
            let foundMatch = rhs.reduce(false) { $0 || !lhsElement.isDiffFrom($1) }
            if !foundMatch {
                anyNonMatches = true
            }
        }
        return anyNonMatches
    }
}
public extension Sequence where Element: DNSPrice {
    var count: Int { return reduce(0) { acc, row in acc + 1 } }

    func hasDiffElementsFrom(_ rhs: [DNSPrice]) -> Bool {
        guard self.count == rhs.count else { return true }
        var anyNonMatches = false
        self.forEach { lhsElement in
            let foundMatch = rhs.reduce(false) { $0 || !lhsElement.isDiffFrom($1) }
            if !foundMatch {
                anyNonMatches = true
            }
        }
        return anyNonMatches
    }
}
