//
//  DAOSystemEndPoint+currentState.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataTypes
import Foundation

extension DAOSystemEndPoint {
    public var failureCodes: [String: DNSAnalyticsNumbers] {
        self.currentState.failureCodes
    }
    public var failureRate: DNSAnalyticsNumbers {
        self.currentState.failureRate
    }
    public var totalPoints: DNSAnalyticsNumbers {
        self.currentState.totalPoints
    }
    public var state: DNSSystemState {
        self.currentState.state
    }
    public var stateOverride: DNSSystemState {
        self.currentState.stateOverride
    }
}
