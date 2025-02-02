//
//  CDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDSkillTableViewController: CDTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: .cardDetailSettingsDidChange, object: nil)
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }
    
    override func prepareRows(for card: Card) {
        
        let property: Property
        let settings = CDSettingsViewController.Setting.default
        if CDSettingsViewController.Setting.default.expressionStyle == .valueOnly {
            property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: false, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
        } else if CDSettingsViewController.Setting.default.expressionStyle == .valueInCombat {
            property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: true, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
        } else {
            property = .zero
        }
        
        rows.removeAll()
        
        if let patterns = card.patterns, patterns.count > 1 {
            card.patterns?.enumerated().forEach {
                rows.append(Row(type: CDPatternTableViewCell.self, data: .pattern($0.element, card, $0.offset + 1)))
            }
        } else {
            card.patterns?.enumerated().forEach {
                rows.append(Row(type: CDPatternTableViewCell.self, data: .pattern($0.element, card, nil)))
            }
        }
        
        
        // setup union burst
        
        if settings.skillStyle == .both {
            if let unionBurst = card.unionBurst {
                rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst, property, nil)))
            }
            if let unionBurstEvolution = card.unionBurstEvolution {
                rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(unionBurstEvolution, .unionBurstEvolution, property, nil)))
            }
        } else {
            if let unionBurstEvolution = card.unionBurstEvolution {
                rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(unionBurstEvolution, .unionBurstEvolution, property, nil)))
            } else if let unionBurst = card.unionBurst {
                rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst, property, nil)))
            }
        }
        
        // setup main skills
        if settings.skillStyle == .both {
            rows += zip(card.mainSkills, card.mainSkillEvolutions)
                .enumerated()
                .flatMap {
                    [
                        Row(type: CDSkillTableViewCell.self, data: .skill($0.element.0, .main, property, $0.offset + 1)),
                        Row(type: CDSkillTableViewCell.self, data: .skill($0.element.1, .mainEvolution, property, $0.offset + 1))
                    ]
                }
            
            if card.mainSkills.count > card.mainSkillEvolutions.count {
                
                rows += card.mainSkills[card.mainSkillEvolutions.count..<card.mainSkills.count]
                    .enumerated()
                    .map {
                        return Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .main, property, card.mainSkillEvolutions.count + $0.offset + 1))
                }
            }
        } else {
            rows.append(contentsOf:
                zip(card.mainSkillEvolutions, card.mainSkills)
                    .enumerated()
                    .map {
                        return Row(type: CDSkillTableViewCell.self, data: .skill($0.element.0, .mainEvolution, property, $0.offset + 1))
                }
            )
            
            if card.mainSkills.count > card.mainSkillEvolutions.count {
                
                rows += card.mainSkills[card.mainSkillEvolutions.count..<card.mainSkills.count]
                    .enumerated()
                    .map {
                        return Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .main, property, card.mainSkillEvolutions.count + $0.offset + 1))
                }
            }
        }
        
        // setup sp skills
        rows += card.spSkills.enumerated().map {
            return Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .sp, property, $0.offset + 1))
        }
        
        // setup ex skills
        if settings.skillStyle == .both {
            rows += zip(card.exSkills, card.exSkillEvolutions)
                .enumerated()
                .flatMap {
                    [
                        Row(type: CDSkillTableViewCell.self, data: .skill($0.element.0, .ex, property, nil)),
                        Row(type: CDSkillTableViewCell.self, data: .skill($0.element.1, .exEvolution, property, nil))
                    ]
            }
            
            if card.exSkills.count > card.exSkillEvolutions.count {
                
                rows += card.exSkills[card.exSkillEvolutions.count..<card.exSkills.count]
                    .enumerated()
                    .map {
                        return Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .ex, property, nil))
                }
            }
        } else {
            rows.append(contentsOf:
                zip(card.exSkillEvolutions, card.exSkills)
                    .enumerated()
                    .map {
                        return Row(type: CDSkillTableViewCell.self, data: .skill($0.element.0, .exEvolution, property, nil))
                }
            )
            
            if card.exSkills.count > card.exSkillEvolutions.count {
                
                rows += card.mainSkills[card.exSkillEvolutions.count..<card.exSkills.count]
                    .enumerated()
                    .map {
                        return Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .ex, property, nil))
                }
            }
        }
        
        // insert minions
        let newRows: [Row] = rows.flatMap { row -> [Row] in
            guard case .skill(let skill, _, _, _) = row.data else {
                return [row]
            }
            let actions = skill.actions
            let minions = actions
                .compactMap { $0.parameter as? SummonAction }
                .compactMap { $0.minion }
                .reduce(into: [Minion]()) { results, minion in
                    if !results.contains(where: { $0.base.unitId == minion.base.unitId }) {
                        results.append(minion)
                    }
            }
            let rows = minions.map { Row(type: CDMinionTableViewCell.self, data: .minion($0)) }
            
            return [row] + rows
        }
        
        self.rows = newRows
    }
    
}
