//
//  Sequence+hasDiffElementsFrom.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation
import KeyedCodable

extension Sequence where Element: DAOBaseObject {
    func hasDiffElementsFrom(_ rhs: [DAOBaseObject]) -> Bool {
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
