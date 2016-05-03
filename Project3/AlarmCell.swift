//
//  AlarmCell.swift
//  Project3
//
//  Created by Michael Boom on 4/30/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell {
    
    @IBOutlet weak var hourLabel:UILabel!
    @IBOutlet weak var minuteLabel:UILabel!
    
    @IBOutlet weak var sunLabel:UILabel!
    @IBOutlet weak var monLabel:UILabel!
    @IBOutlet weak var tueLabel:UILabel!
    @IBOutlet weak var wedLabel:UILabel!
    @IBOutlet weak var thuLabel:UILabel!
    @IBOutlet weak var friLabel:UILabel!
    @IBOutlet weak var satLabel:UILabel!
    
    @IBOutlet weak var activatedButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
