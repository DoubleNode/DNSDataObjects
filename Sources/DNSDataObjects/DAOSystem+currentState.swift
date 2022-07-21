//
//  DAOSystem+currentState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

extension DAOSystem {
    public var failureCodes: [String: DNSSystemStateNumbers] {
        self.currentState.failureCodes
    }
    public var failureRate: DNSSystemStateNumbers {
        self.currentState.failureRate
    }
    public var totalPoints: DNSSystemStateNumbers {
        self.currentState.totalPoints
    }
    public var state: DNSSystemState {
        self.currentState.state
    }
    public var stateOverride: DNSSystemState {
        self.currentState.stateOverride
    }
}
