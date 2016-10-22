//
//  CareItemModel.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/18.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import Foundation

class CareItemModel {
    var requesterId: String?
    var requesterName: String?
    var itemId: String?
    var itemName: String?
    var eventId: String?
    var operationTime: String?
    var sendNotification: Bool = false
    var completeTime: String?
    var note: String?
    
    var systolic: String = "null"
    var diastolic: String = "null"
    var heartRate: String = "null"
    var bloodSugar: String = "null"
 
    init(){}
    
    init(itemId: String, itemName: String) {
        self.itemId = itemId
        self.itemName = itemName
    }
    
    init(requesterId: String,requesterName: String,itemId: String,itemName: String,eventId: String,operationTime: String,sendNotification: Bool,completeTime: String,note: String) {
        self.requesterId = requesterId
        self.requesterName = requesterName
        self.itemId = itemId
        self.itemName = itemName
        self.eventId = eventId
        self.operationTime = operationTime
        self.sendNotification = sendNotification
        self.completeTime = completeTime
        self.note = note
    }
}






