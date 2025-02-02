//
//  CountDownAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/5/31.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class CountDownAction: ActionParameter {

    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Delay event: use %d after %@s.", comment: "")
        return String(format: format, actionDetail1 % 10, actionValue1.roundedString(roundingRule: nil))
    }
}
