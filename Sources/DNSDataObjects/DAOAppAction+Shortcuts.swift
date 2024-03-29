//
//  DAOAppAction+Shortcuts.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSBaseTheme
import DNSCore
import Foundation

public extension DAOAppAction {
    // MARK: - Themes Properties -
    var cancelButtonTheme: DNSThemeButtonStyle { get { themes.cancelButton } set { themes.cancelButton = newValue } }
    var okayButtonTheme: DNSThemeButtonStyle { get { themes.okayButton } set { themes.okayButton = newValue } }
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
