//
//  RecentTableViewCell.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-18.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}
