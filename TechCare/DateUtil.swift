//
//  DateUtil.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/21.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import Foundation

class DateUtil {
    
    //轉換星期幾為中文
    static func convertWeekdayToTC(weekday: Int) -> String {
        switch weekday {
        case 1:
            return "日"
        case 2:
            return "一"
        case 3:
            return "二"
        case 4:
            return "三"
        case 5:
            return "四"
        case 6:
            return "五"
        case 7:
            return "六"
        default:
            return "X"
        }
    }
    
}