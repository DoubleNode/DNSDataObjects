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
    public var confidence: DNSSystemConfidence {
        self.currentState.confidence
    }
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
    public var stateAndroid: DNSSystemState {
        self.currentState.stateAndroid
    }
    public var stateIOS: DNSSystemState {
        self.currentState.stateIOS
    }
    public var stateOverride: DNSSystemState {
        self.currentState.stateOverride
    }
}
