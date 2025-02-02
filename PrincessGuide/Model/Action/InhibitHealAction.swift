//
//  InhibitHealAction.swift
//  PrincessGuide
//
//  Created by zzk on 2019/6/30.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit

class InhibitHealAction: ActionParameter {

    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("When %@ receive healing, deal [%@ * healing amount] damage instead, last for [%@]s or unlimited time if triggered by field.", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause(),
            actionValue1.description,
            buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
        )
    }
}
