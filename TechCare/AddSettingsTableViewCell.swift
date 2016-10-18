//
//  AddSettingsTableViewCell.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/17.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit

class AddSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var careItemName: UILabel!
    @IBOutlet weak var operationTimeTextField: UITextField!
    @IBOutlet weak var sendNotification: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
