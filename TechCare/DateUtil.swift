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
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "X"
        }
    }
    
}