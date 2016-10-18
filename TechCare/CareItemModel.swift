//
//  CareItemModel.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/18.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import Foundation

class CareItemModel {
    var itemId: String?
    var itemName: String?
    var eventId: String?
    var operationTime: String?
    var sendNotification: Bool = false
    var completeTime: String?
 
    init(){}
    
    init(itemId: String, itemName: String) {
        self.itemId = itemId
        self.itemName = itemName
    }
}