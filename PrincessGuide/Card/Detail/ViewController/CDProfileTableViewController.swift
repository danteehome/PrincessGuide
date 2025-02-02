//
//  CDProfileTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDProfileTableViewController: CDTableViewController {
    
    override func prepareRows(for card: Card) {
        rows.removeAll()
        rows += [
            Row(type: CDBasicTableViewCell.self, data: .card(card)),
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("True Name", comment: ""), card.actualUnit?.unitName ?? NSLocalizedString("None", comment: ""), false)),
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Catch Copy", comment: ""), card.profile.catchCopy, false)),
            Row(type: CDProfileTableViewCell.self, data: .profileItems([
                card.profile.item(for: .height),
                card.profile.item(for: .weight)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profileItems([
                card.profile.item(for: .birthday),
                card.profile.item(for: .blood)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profileItems([
                card.profile.item(for: .race),
                card.profile.item(for: .age)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profileItems([
                card.profile.item(for: .guild)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profileItems([
                card.profile.item(for: .favorite)
            ])),
            Row(type: CDProfileTableViewCell.self, data: .profileItems([
                card.profile.item(for: .voice)
            ]))
        ]
        
        rows += card.comments.map { Row(type: CDCommentTableViewCell.self, data: .comment($0)) }
    }
    
}
