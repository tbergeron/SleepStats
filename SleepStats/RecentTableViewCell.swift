//
//  RecentTableViewCell.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-18.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var wokeUpLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}