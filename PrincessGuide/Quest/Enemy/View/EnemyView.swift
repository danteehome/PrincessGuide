//
//  EnemyView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class EnemyView: UIView {
    
    let enemyIcon = IconImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(enemyIcon)
        enemyIcon.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(64)
        }
    }
    
    func configure(for enemy: Enemy) {
        if enemy.unit.visualChangeFlag == 1 {
            enemyIcon.shadowUnitID = enemy.unit.prefabId
        } else {
            enemyIcon.unitID = enemy.unit.prefabId
        }
        if enemy.isBossPart {
            enemyIcon.layer.borderColor = UIColor.red.cgColor
            enemyIcon.layer.borderWidth = 2
            enemyIcon.layer.cornerRadius = 6
            enemyIcon.layer.masksToBounds = true
            ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                themeable.enemyIcon.layer.borderColor = theme.color.highlightedText.cgColor
            }
        } else {
            enemyIcon.layer.borderWidth = 0
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
