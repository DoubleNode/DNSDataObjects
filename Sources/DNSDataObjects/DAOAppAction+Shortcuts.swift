//
//  DAOAppAction+Shortcuts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public extension DAOAppAction {
    // MARK: - Colors Properties -
    var cancelButtonBackground: DNSUIColor? { get { colors.cancelButtonBackground } set { colors.cancelButtonBackground = newValue } }
    var cancelButtonText: DNSUIColor? { get { colors.cancelButtonText } set { colors.cancelButtonText = newValue } }
    var okButtonBackground: DNSUIColor? { get { colors.okButtonBackground } set { colors.okButtonBackground = newValue } }
    var okButtonText: DNSUIColor? { get { colors.okButtonText } set { colors.okButtonText = newValue } }
    // MARK: - Images Properties -
    var topImageUrl: DNSURL { get { images.topUrl } set { images.topUrl = newValue } }
    // MARK: - Strings Properties -
    var body: DNSString { get { strings.body } set { strings.body = newValue } }
    var cancelLabel: DNSString { get { strings.cancelLabel } set { strings.cancelLabel = newValue } }
    var disclaimer: DNSString { get { strings.disclaimer } set { strings.disclaimer = newValue } }
    var okayLabel: DNSString { get { strings.okayLabel } set { strings.okayLabel = newValue } }
    var subtitle: DNSString { get { strings.subtitle } set { strings.subtitle = newValue } }
    var title: DNSString { get { strings.title } set { strings.title = newValue } }
}
