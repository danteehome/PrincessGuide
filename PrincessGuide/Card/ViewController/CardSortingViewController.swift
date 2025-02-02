//
//  CardSortingViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/30.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt
import SwiftyJSON

extension Notification.Name {
    
    static let cardSortingSettingsDidChange = Notification.Name("card_sorting_settings_did_change")
    
}

class CardSortingViewController: FormViewController {

    struct Setting: Codable, Equatable {
        
        enum GroupingMethod: String, Codable, CustomStringConvertible, CaseIterable {
            case guild
            case position
            case attackType
            case uniqueEquipNumber
            case race
            case cv
            case none
            
            var description: String {
                switch self {
                case .guild:
                    return NSLocalizedString("Guild", comment: "")
                case .position:
                    return NSLocalizedString("Position", comment: "")
                case .attackType:
                    return NSLocalizedString("Attack Type", comment: "")
                case .uniqueEquipNumber:
                    return NSLocalizedString("Number of Unique Equipments", comment: "")
                case .race:
                    return NSLocalizedString("Race", comment: "")
                case .cv:
                    return NSLocalizedString("CV", comment: "")
                default:
                    return NSLocalizedString("None", comment: "")
                }
            }
        }
        
        enum SortingMethod: String, Codable, CustomStringConvertible {
            case atk
            case def
            case dodge
            case energyRecoveryRate
            case energyReduceRate
            case hp
            case hpRecoveryRate
            case lifeSteal
            case magicCritical
            case magicDef
            case magicStr
            case physicalCritical
            case waveEnergyRecovery
            case waveHpRecovery
            case accuracy
            
            case rarity
            case effectivePhysicalHP
            case effectiveMagicalHP
            case combatEffectiveness
            case swingTime
            case attackRange
            
            case id
            
            case name
            
            case height
            case weight
            case age
            
            case birthday
            
            var description: String {
                switch self {
                case .atk, .def, .dodge, .energyRecoveryRate, .energyReduceRate, .hp, .hpRecoveryRate,
                     .lifeSteal, .magicCritical, .magicDef, .magicStr, .physicalCritical, .waveEnergyRecovery, .waveHpRecovery, .accuracy:
                    return PropertyKey(rawValue: rawValue)!.description
                case .rarity:
                    return NSLocalizedString("Rarity", comment: "")
                case .effectivePhysicalHP:
                    return NSLocalizedString("Effective Physical HP", comment: "")
                case .effectiveMagicalHP:
                    return NSLocalizedString("Effective Magical HP", comment: "")
                case .swingTime:
                    return NSLocalizedString("Swing Time", comment: "")
                case .attackRange:
                    return NSLocalizedString("Attack Range", comment: "")
                case .id:
                    return NSLocalizedString("Internal ID", comment: "")
                case .name:
                    return NSLocalizedString("Chara Name", comment: "")
                case .age:
                    return Card.Profile.ItemKey.age.description
                case .height:
                    return Card.Profile.ItemKey.height.description
                case .weight:
                    return Card.Profile.ItemKey.weight.description
                case .combatEffectiveness:
                    return NSLocalizedString("Combat Effectiveness", comment: "")
                case .birthday:
                    return NSLocalizedString("Birthday", comment: "")
                }
                
            }
            
            static let allLabels = [SortingMethod.atk, .def, .dodge, .energyRecoveryRate, .energyReduceRate, .hp, .hpRecoveryRate, .lifeSteal, .magicCritical, .magicDef, .magicStr, .physicalCritical, .waveEnergyRecovery, .waveHpRecovery, .accuracy, .rarity, .effectiveMagicalHP, .effectivePhysicalHP, .combatEffectiveness, .swingTime, .attackRange, .id, .name, .age, .birthday, .height, .weight]
            
        }
        
        enum IconStyle: String, Codable, CustomStringConvertible {
            case `default`
            case r3
            case r1
            
            var description: String {
                switch self {
                case .default:
                    return NSLocalizedString("default", comment: "icon style")
                case .r3:
                    return NSLocalizedString("always 3★", comment: "icon style")
                case .r1:
                    return NSLocalizedString("always 1★", comment: "")
                }
            }
            
            static let allLabels = [IconStyle.default, .r3, .r1]
        }
        
        var isAscending: Bool = true
        
        var sortingMethod: SortingMethod = .name
        
        var groupingMethod: GroupingMethod = .none
        
        var addsEx: Bool = true
        
        var equipsUniqueEquipment: Bool = true
        
        var iconStyle: IconStyle = .default
        
        func save() {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            try? encoder.encode(self).write(to: Setting.url)
            NotificationCenter.default.post(name: .cardSortingSettingsDidChange, object: nil)
        }
        
        static func load() -> Setting? {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            return try? decoder.decode(Setting.self, from: data)
        }
        
        static let url = try! FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("unit_sorting_settings.json")
        
        static var `default` = Setting.load() ?? Setting() {
            didSet {
                Setting.default.save()
            }
        }
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleNavigationRightItem(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleNavigationLeftItem(_:)))
        tableView.backgroundView = backgroundImageView
        tableView.cellLayoutMarginsFollowReadableWidth = true
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            let navigationBar = themeable.navigationController?.navigationBar
            navigationBar?.tintColor = theme.color.tint
            navigationBar?.barStyle = theme.barStyle
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.tableView.backgroundColor = theme.color.background
            themeable.view.tintColor = theme.color.tint
        }
        
        func cellUpdate<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            EurekaAppearance.cellUpdate(cell: cell, row: row)
        }
        
        func cellSetup<T: RowType, U>(cell: T.Cell, row: T) where T.Cell.Value == U {
            EurekaAppearance.cellSetup(cell: cell, row: row)
        }
        
        func onCellSelection<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>) {
            EurekaAppearance.onCellSelection(cell: cell, row: row)
        }
        
        func onExpandInlineRow<T>(cell: PickerInlineCell<T>, row: PickerInlineRow<T>, pickerRow: PickerRow<T>) {
            EurekaAppearance.onExpandInlineRow(cell: cell, row: row, pickerRow: pickerRow)
        }
        
        form.inlineRowHideOptions = InlineRowHideOptions.AnotherInlineRowIsShown.union(.FirstResponderChanges)
        
        form
            +++ Section(NSLocalizedString("Grouping", comment: ""))
            <<< PickerInlineRow<String>("grouping_method") { (row : PickerInlineRow<String>) -> Void in
                row.title = NSLocalizedString("Group by", comment: "")
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.flatMap { Setting.GroupingMethod(rawValue: $0)?.description }
                }
                row.options = Setting.GroupingMethod.allCases.map { $0.rawValue }
                row.value = Setting.default.groupingMethod.rawValue
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
        
            +++ Section(NSLocalizedString("Sorting", comment: ""))
            
            <<< SegmentedRow<Bool>("is_ascending"){
                $0.title = NSLocalizedString("Order", comment: "")
                $0.displayValueFor = { (rowValue: Bool?) in
                    if let rowValue = rowValue, rowValue {
                        return NSLocalizedString("Ascending", comment: "")
                    } else {
                        return NSLocalizedString("Descending", comment: "")
                    }
                }
                $0.options = [true, false]
                $0.value = Setting.default.isAscending
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
            
            <<< PickerInlineRow<String>("sorting_method") { (row : PickerInlineRow<String>) -> Void in
                row.title = NSLocalizedString("Sort by", comment: "")
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.flatMap { Setting.SortingMethod(rawValue: $0)?.description }
                }
                row.options = Setting.SortingMethod.allLabels.map { $0.rawValue }
                row.value = Setting.default.sortingMethod.rawValue
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
            
            <<< SwitchRow("adds_ex") { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Adds Ex Bonus", comment: "")
                
                row.value = Setting.default.addsEx
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
            
            <<< SwitchRow("equips_unique_equipment") { (row : SwitchRow) -> Void in
                row.title = NSLocalizedString("Unique Equipment", comment: "")
                
                row.value = Setting.default.equipsUniqueEquipment
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
        
            +++ Section(NSLocalizedString("Misc", comment: ""))
            
            <<< PickerInlineRow<String>("icon_style") { (row : PickerInlineRow<String>) -> Void in
                row.title = NSLocalizedString("Icon Style", comment: "")
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.flatMap { Setting.IconStyle(rawValue: $0)?.description }
                }
                row.options = Setting.IconStyle.allLabels.map { $0.rawValue }
                row.value = Setting.default.iconStyle.rawValue
                
                }.cellSetup(cellSetup(cell:row:))
                .cellUpdate(cellUpdate(cell:row:))
                .onCellSelection(onCellSelection(cell:row:))
                .onExpandInlineRow(onExpandInlineRow(cell:row:pickerRow:))
        
            +++ Section()
            
            <<< ButtonRow("reset") { (row) in
                row.title = NSLocalizedString("Reset", comment: "")
                }
                .cellSetup(cellSetup(cell:row:))
                .onCellSelection { [unowned self] (cell, row) in
                    let encoder = JSONEncoder()
                    encoder.keyEncodingStrategy = .convertToSnakeCase
                    let data = try! encoder.encode(Setting())
                    let json = try! JSON(data: data)
                    self.form.setValues(json.dictionaryObject ?? [:])
                    self.tableView.reloadData()
        }
    }
    
    @objc private func handleNavigationRightItem(_ item: UIBarButtonItem) {
        let json = JSON(form.values())
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let setting = try? decoder.decode(Setting.self, from: json.rawData()) {
            Setting.default = setting
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleNavigationLeftItem(_ item: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
