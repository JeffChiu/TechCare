//
//  RequesterModel.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/20.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import Foundation

class RequesterModel {
    var id: String?
    var name: String?
    var photoUrl: String?
    var info: String?
    var isSet: Bool?
    
    init(id: String, name: String, photoUrl: String, info: String, isSet: Bool){
        self.id = id
        self.name = name
        self.photoUrl = photoUrl
        self.info = info
        self.isSet = isSet
    }
}