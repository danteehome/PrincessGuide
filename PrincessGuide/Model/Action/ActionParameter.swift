//
//  ActionParameter.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/24.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class ActionParameter {
    
    class func type(of rawType: Int) -> ActionParameter.Type {
        switch rawType {
        case 1:
            return DamageAction.self
        case 2:
            return MoveAction.self
        case 3:
            return KnockAction.self
        case 4:
            return HealAction.self
        case 5:
            return CureAction.self
        case 6:
            return BarrierAction.self
        case 7:
            return ReflexiveAction.self
        case 8, 9, 12, 13:
            return AilmentAction.self
        case 10:
            return AuraAction.self
        case 11:
            return CharmAction.self
        case 14:
            return ModeChangeAction.self
        case 15:
            return SummonAction.self
        case 16:
            return ChangeEnergyAction.self
        case 17:
            return TriggerAction.self
        case 18:
            return DamageChargeAction.self
        case 19:
            return ChargeAction.self
        case 20:
            return DecoyAction.self
        case 21:
            return NoDamageAction.self
        case 22:
            return ChangePatterAction.self
        case 23:
            return IfForChildrenAction.self
        case 24:
            return RevivalAction.self
        case 25:
            return ContinuousAttackAction.self
        case 26:
            return AdditiveAction.self
        case 27:
            return MultipleAction.self
        case 28:
            return IfForAllAction.self
        case 29:
            return SearchAreaChangeAction.self
        case 30:
            return DestroyAction.self
        case 31:
            return ContinuousAttackNearbyAction.self
        case 32:
            return EnchantLifeStealAction.self
        case 33:
            return EnchantStrikeBackAction.self
        case 34:
            return AccumulativeDamageAction.self
        case 35:
            return SealAction.self
        case 36:
            return AttackFieldAction.self
        case 37:
            return HealFieldAction.self
        case 38:
            return ChangeParameterFieldAction.self
        case 39:
            return AbnormalStateFieldAction.self
        case 40:
            return ChangeSpeedFieldAction.self
        case 41:
            return UBChangeTimeAction.self
        case 42:
            return LoopTriggerAction.self
        case 43:
            return IfHasTargetAction.self
        case 44:
            return WaveStartIdleAction.self
        case 45:
            return SkillExecCountAction.self
        case 46:
            return RatioDamageAction.self
        case 47:
            return UpperLimitAttackAction.self
        case 48:
            return RegenerationAction.self
        case 49:
            return DispelAction.self
        case 50:
            return ChannelAction.self
        case 52:
            return ChangeBodyWidthAction.self
        case 53:
            return IFExistsFieldForAllAction.self
        case 54:
            return StealthAction.self
        case 55:
            return MovePartsAction.self
        case 56:
            return CountBlindAction.self
        case 57:
            return CountDownAction.self
        case 58:
            return StopFieldAction.self
        case 59:
            return InhibitHealAction.self
        case 90:
            return PassiveAction.self
        case 91:
            return PassiveInermittentAction.self
        default:
            return ActionParameter.self
        }
    }
    
//    var isHealingAction: Bool {
//        switch rawActionType {
//        case 4, 37, 48:
//            return true
//        default:
//            return false
//        }
//    }
   
    let targetParameter: TargetParameter
    let actionType: ActionType
   
    let rawActionType: Int
    let id: Int
    
    let actionValue1: Double
    let actionValue2: Double
    let actionValue3: Double
    let actionValue4: Double
    let actionValue5: Double
    let actionValue6: Double
    let actionValue7: Double
    
    lazy var rawActionValues = [
        self.actionValue1,
        self.actionValue2,
        self.actionValue3,
        self.actionValue4,
        self.actionValue5,
        self.actionValue6,
        self.actionValue7
    ]
    
    let actionDetail1: Int
    let actionDetail2: Int
    let actionDetail3: Int
        
    lazy var actionDetails = [
        self.actionDetail1,
        self.actionDetail2,
        self.actionDetail3
    ]
    
    required init(id: Int, targetAssignment: Int, targetNth: Int, actionType: Int, targetType: Int, targetRange: Int,
                  direction: Int, targetCount: Int, actionValue1: Double, actionValue2: Double, actionValue3: Double, actionValue4: Double, actionValue5: Double, actionValue6: Double, actionValue7: Double, actionDetail1: Int, actionDetail2: Int, actionDetail3: Int, dependActionID: Int) {
        self.targetParameter = TargetParameter(targetAssignment: targetAssignment, targetNth: targetNth, targetType: targetType, targetRange: targetRange, direction: direction, targetCount: targetCount, dependActionID: dependActionID)
        self.id = id
        self.rawActionType = actionType
        self.actionType = ActionType(rawValue: actionType) ?? .unknown
        self.actionValue1 = actionValue1
        self.actionValue2 = actionValue2
        self.actionValue3 = actionValue3
        self.actionValue4 = actionValue4
        self.actionValue5 = actionValue5
        self.actionValue6 = actionValue6
        self.actionValue7 = actionValue7
        self.actionDetail1 = actionDetail1
        self.actionDetail2 = actionDetail2
        self.actionDetail3 = actionDetail3
    }
    
    func localizedDetail(of level: Int,
                         property: Property = .zero,
                         style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Unknown effect %d to %@ with details [%@], values [%@].", comment: "")
        return String(
            format: format,
            rawActionType,
            targetParameter.buildTargetClause(),
            actionDetails
                .filter { $0 != 0 }
                .map(String.init)
                .joined(separator: ","),
            rawActionValues
                .filter { $0 != 0 }
                .map(String.init(_:))
                .joined(separator: ", ")
        )
    }
    
    var actionValues: [ActionValue] {
        return []
    }
    
    private func bracesIfNeeded(content: String) -> String {
        if content.contains("+") {
            return "(\(content))"
        } else {
            return content
        }
    }
    
    func buildExpression(of level: Int,
                         actionValues: [ActionValue]? = nil,
                         roundingRule: FloatingPointRoundingRule? = .towardZero,
                         style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle,
                         property: Property = .zero,
                         isHealing: Bool = false,
                         isSelfTPRestoring: Bool = false,
                         hasBracesIfNeeded: Bool = false) -> String {

        switch style {
        case .short:
            
            let expression = (actionValues ?? self.actionValues).map { value in
                var part = ""
                if let initialValue = Decimal(string: value.initial), let perLevelValue = Decimal(string: value.perLevel) {
                    let roundingRule = value.key == nil ? roundingRule : nil
                    switch (initialValue, perLevelValue) {
                    case (0, 0):
                        break
                    case (0, _):
                        part = "\((perLevelValue * Decimal(level)).roundedString(roundingRule: roundingRule))@\(level)"
                    case (_, 0):
                        part = initialValue.roundedString(roundingRule: roundingRule)
                    case (_, _):
                        part = "\((perLevelValue * Decimal(level) + initialValue).roundedString(roundingRule: roundingRule))@\(level)"
                    }
                    if let key = value.key {
                        switch (initialValue, perLevelValue) {
                        case (0, 0):
                            break
                        case (0, _), (_, 0):
                            part += " * \(key.description)"
                        case (_, _):
                            part = "\(part) * \(key.description)"
                        }
                    }
                }
                return part
            }
            .filter { $0 != "" }
            .joined(separator: " + ")
            
            if expression == "" {
                return "0"
            } else {
                return hasBracesIfNeeded ? bracesIfNeeded(content: expression) : expression
            }
        case .full:
            
            let expression = (actionValues ?? self.actionValues).map { value in
                var part = ""
                if let initialValue = Double(value.initial), let perLevelValue = Double(value.perLevel) {
                    switch (initialValue, perLevelValue) {
                    case (0, 0):
                        break
                    case (0, _):
                        part = "\(perLevelValue) * \(NSLocalizedString("SLv.", comment: ""))"
                    case (_, 0):
                        part = "\(initialValue)"
                    case (_, _):
                        part = "\(initialValue) + \(perLevelValue) * \(NSLocalizedString("SLv.", comment: ""))"
                    }
                    if let key = value.key {
                        switch (initialValue, perLevelValue) {
                        case (0, 0):
                            break
                        case (0, _), (_, 0):
                            part += " * \(key.description)"
                        case (_, _):
                            part = "(\(part)) * \(key.description)"
                        }
                    }
                }
                return part
            }
            .filter { $0 != "" }
            .joined(separator: " + ")
            
            if expression == "" {
                return "0"
            } else {
                return hasBracesIfNeeded ? bracesIfNeeded(content: expression) : expression
            }
            
        case .rawValueID:
            
            let expression = (actionValues ?? self.actionValues).map { value in
                var part = ""
                let format = NSLocalizedString("value %d", comment: "")
                let initialValue = String(format: format, value.startIndex)
                let perLevelValue = String(format: format, value.startIndex + 1)
                part = "\(initialValue) + \(perLevelValue) * \(NSLocalizedString("SLv.", comment: ""))"
                if let key = value.key {
                    part = "(\(part)) * \(key.description)"
                }
                return part
                }
                .filter { $0 != "" }
                .joined(separator: " + ")
            
            if expression == "" {
                return "0"
            } else {
                return hasBracesIfNeeded ? bracesIfNeeded(content: expression) : expression
            }
        case .valueOnly:
            
            var fixedValue: Decimal = 0.0
            
            for value in actionValues ?? self.actionValues {
                var part: Decimal = 0.0
                if let initialValue = Decimal(string: value.initial), let perLevelValue = Decimal(string: value.perLevel) {
                    part = initialValue + perLevelValue * Decimal(level)
                }
                if let key = value.key {
                    part = part * Decimal(property.item(for: key).value)
                }
                fixedValue += part
            }
            
            return fixedValue.roundedString(roundingRule: roundingRule)
            
        case .valueInCombat:
            
            var fixedValue: Decimal = 0.0
            
            for value in actionValues ?? self.actionValues {
                var part: Decimal = 0.0
                if let initialValue = Decimal(string: value.initial), let perLevelValue = Decimal(string: value.perLevel) {
                    part = initialValue + perLevelValue * Decimal(level)
                }
                if let key = value.key {
                    part = part * Decimal(property.item(for: key).value)
                }
                fixedValue += part
            }
            
            if isHealing {
                fixedValue *= (Decimal(property.hpRecoveryRate) / 100 + 1)
            }
            
            if isSelfTPRestoring {
                fixedValue *= (Decimal(property.energyRecoveryRate) / 100 + 1)
            }
            
            return fixedValue.roundedString(roundingRule: roundingRule)
        }
        
    }
    
}

struct ActionValue {
    let initial: String
    let perLevel: String
    let key: PropertyKey?
    let startIndex: Int
}

enum PercentModifier: CustomStringConvertible {
    case percent
    case number
    
    var description: String {
        switch self {
        case .percent:
            return "%"
        case .number:
            return ""
        }
    }
    
    init(_ value: Int) {
        switch value {
        case 2:
            self = .percent
        default:
            self = .number
        }
    }
}

enum ClassModifier: Int, CustomStringConvertible {
    case unknown = 0
    case physical
    case magical
    case inevitablePhysical
    
    var description: String {
        switch self {
        case .magical:
            return NSLocalizedString("magical", comment: "")
        case .physical:
            return NSLocalizedString("physical", comment: "")
        case .inevitablePhysical:
            return NSLocalizedString("inevitable physical", comment: "")
        case .unknown:
            return NSLocalizedString("unknown", comment: "")
        }
    }
    
}

enum CriticalModifier: Int, CustomStringConvertible {
    
    case normal = 0
    case critical
    
    var description: String {
        switch self {
        case .normal:
            return NSLocalizedString("", comment: "")
        case .critical:
            return NSLocalizedString("", comment: "")
        }
    }
}

enum ActionType: Int {
    case unknown = 0
    case damage
    case move
    case knock
    case heal
    case cure
    case `guard`
    case chooseArea
    case ailment
    case dot
    case aura = 10
    case charm
    case blind
    case silence
    case changeMode
    case summon
    case changeEnergy
    case trigger
    case charge
    case damageCharge
    case taunt = 20
    case invulnerable
    case changePattern
    case ifForChildren
    case revival
    case continuousAttack
    case additive
    case multiple
    case ifForAll
    case changeSearchArea
    case instantDeath = 30
    case continuousAttackNearby
    case enhanceLifeSteal
    case enhanceStrikeBack
    case accumulativeDamage
    case seal
    case attackField
    case healField
    case changeParameterField
    case dotField
    case ailmentField = 40
    case changeUBTime
    case loopTrigger
    case ifHasTarget
    case waveStartIdle
    case skillCount
    case gravity
    case upperLimitAttack
    case hot
    case dispel
    case channel = 50
    case division
    case changeWidth
    case ifExistsFieldForAll
    case stealth
    case moveParts
    case countBlind
    case countDown
    case ex = 90
    case exPlus
}
