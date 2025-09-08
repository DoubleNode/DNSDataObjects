//
//  DAOPlace+Status.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import CoreLocation
import DNSCore
import DNSDataTypes
import Foundation

extension DAOPlace {
    public var status: DNSStatus {
        return self.statusNow().status
    }
    public var statusMessage: DNSString {
        return self.statusNow().message
    }

    public func isStatusOpen(for date: Date = Date()) -> Bool {
        guard !self.statuses.isEmpty else { return true }
        return status(for: date)?.isOpen ?? true
    }
    public func statusMessage(for date: Date = Date()) -> DNSString {
        return self.status(for: date)?.message ?? DNSString(with: "")
    }
    public func status(for date: Date = Date()) -> DAOPlaceStatus? {
        let status = self.statuses
            .filter { date.isSameDate(as: $0.startTime) ||
                date.isSameDate(as: $0.endTime) ||
                ($0.startTime < date && $0.endTime > date)
            }
            .sorted { $0.startTime >= $1.startTime }
            .sorted { $0.scope.rawValue < $1.scope.rawValue }
            .first
        return status
    }

    public func isStatusOpenNow() -> Bool {
        return statusNow().isOpen
    }
    public func statusNow() -> DAOPlaceStatus {
        let date = Date()
        let status = statuses
            .filter { ($0.startTime < date && $0.endTime > date) }
            .sorted { $0.startTime >= $1.startTime }
            .sorted { $0.scope.rawValue < $1.scope.rawValue }
            .first
        guard let status else {
            let retval = Self.createPlaceStatus()
            retval.status = .open
            return retval
        }
        return status
    }
}
