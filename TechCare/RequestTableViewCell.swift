//
//  RequestTableViewCell.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/12.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    
    @IBOutlet weak var personalImageView: UIImageView!
    @IBOutlet weak var personalBackgroundImageView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
