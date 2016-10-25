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
    
    //轉換時間顯示格式 09:00 -> 0900
    static func operationTimeFormat(inputDate: String) -> String {
        var returnVal: String = inputDate
        if inputDate.characters.count == 5 {
            let range: Range<String.Index> = inputDate.rangeOfString(":")!
            returnVal.removeRange(range)
        }
        return returnVal
    }
    
    //轉換時間顯示格式 0900 -> 09:00
    static func operationTimeFormat2(inputDate: String) -> String {
        var returnVal: String = inputDate
        if inputDate != "" {
            if inputDate.characters.count == 4 {
                returnVal = inputDate.substring(0, 2) + ":" + inputDate.substring(2, 4)
            }
        }
        return returnVal
    }
}

extension String {
    func substring(s: Int, _ e: Int? = nil) -> String {
        let start = s >= 0 ? self.startIndex : self.endIndex
        let startIndex = start.advancedBy(s)
        
        var end: String.Index
        var endIndex: String.Index
        if(e == nil){
            end = self.endIndex
            endIndex = self.endIndex
        } else {
            end = e >= 0 ? self.startIndex : self.endIndex
            endIndex = end.advancedBy(e!)
        }
        
        let range = Range<String.Index>(startIndex..<endIndex)
        return self.substringWithRange(range)
        
    }
}