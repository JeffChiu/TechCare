//
//  AddSettingsViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/6.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddSettingsViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var careItemTableView: UITableView!
    @IBOutlet weak var yearMonth: UILabel!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    
    var dateArray: [NSDate] = []
    var dateHighlightCurrentIndex: Int? //記錄目前是點選哪一個
    var dateFormatter = NSDateFormatter()
    var inputDate: NSDate?
    var inputRequesterName: String?
    var inputRequesterId: String?
    var inputIsSet:Bool?
    var careDate: String?
    var careItemDictionary: [Int:CareItemModel] = [:] //[itemId:CareItemModel物件]
    
    let dateBackgroundUIColor: UIColor = UIColor(red:0.27, green:0.80, blue:0.73, alpha:1.0) //tiffany green
    let calendar = NSCalendar.currentCalendar()
    
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 200))
    var currentTextField: UITextField?
    var currentTextFieldIndex: Int?
    let userDefault = NSUserDefaults.standardUserDefaults()
    
    func initSettingData() {
        self.careItemDictionary.removeAll()
        careItemDictionary[1] = CareItemModel(itemId: "1", itemName: "陪伴")
        careItemDictionary[2] = CareItemModel(itemId: "2", itemName: "情緒支持")
        careItemDictionary[3] = CareItemModel(itemId: "3", itemName: "盥洗")
        careItemDictionary[4] = CareItemModel(itemId: "4", itemName: "入浴")
        careItemDictionary[5] = CareItemModel(itemId: "5", itemName: "如廁")
        careItemDictionary[6] = CareItemModel(itemId: "6", itemName: "更衣")
        careItemDictionary[7] = CareItemModel(itemId: "7", itemName: "餵食")
        careItemDictionary[8] = CareItemModel(itemId: "8", itemName: "餵藥")
        careItemDictionary[9] = CareItemModel(itemId: "9", itemName: "肢體關節運動")
        careItemDictionary[10] = CareItemModel(itemId: "10", itemName: "翻身")
        careItemDictionary[11] = CareItemModel(itemId: "11", itemName: "拍背")
        careItemDictionary[12] = CareItemModel(itemId: "12", itemName: "洗衣")
        careItemDictionary[13] = CareItemModel(itemId: "13", itemName: "服務對象起居環境清潔")
        careItemDictionary[14] = CareItemModel(itemId: "14", itemName: "陪同或代理購物")
        careItemDictionary[15] = CareItemModel(itemId: "15", itemName: "備餐(購買)")
        careItemDictionary[16] = CareItemModel(itemId: "16", itemName: "備餐(煮食)")
        careItemDictionary[17] = CareItemModel(itemId: "17", itemName: "協助申請社會福利服務")
        careItemDictionary[18] = CareItemModel(itemId: "18", itemName: "代寫書信及聯絡親友")
        careItemDictionary[19] = CareItemModel(itemId: "19", itemName: "陪同就醫")
        careItemDictionary[20] = CareItemModel(itemId: "20", itemName: "代領藥品")
        careItemDictionary[21] = CareItemModel(itemId: "21", itemName: "量血壓/心跳")
        careItemDictionary[22] = CareItemModel(itemId: "22", itemName: "量血糖")
        careItemDictionary[23] = CareItemModel(itemId: "23", itemName: "陪同散步")
        careItemDictionary[24] = CareItemModel(itemId: "24", itemName: "閱讀書報")
        careItemDictionary[25] = CareItemModel(itemId: "25", itemName: "服藥：早餐飯前")
        careItemDictionary[26] = CareItemModel(itemId: "26", itemName: "服藥：早餐飯後")
        careItemDictionary[27] = CareItemModel(itemId: "27", itemName: "服藥：中餐飯前")
        careItemDictionary[28] = CareItemModel(itemId: "28", itemName: "服藥：中餐飯後")
        careItemDictionary[29] = CareItemModel(itemId: "29", itemName: "服藥：晚餐飯前")
        careItemDictionary[30] = CareItemModel(itemId: "30", itemName: "服藥：晚餐飯後")
        careItemDictionary[31] = CareItemModel(itemId: "31", itemName: "服藥：睡前")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Navigation Item UI
        let label: UILabel = UILabel.init(frame: TechCareDef.NAVIGATION_LABEL_RECT_SIZE)
        label.text = "\(inputRequesterName!)"
        label.textAlignment = .Center
        label.font = TechCareDef.NAVIGATION_LABEL_FONT_SIZE
        self.navigationItem.titleView = label
        self.navigationItem.title = "\(inputRequesterName!)"
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        careItemTableView.dataSource = self
        
        initSettingData()
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        var startDateTime = dateFormatter.dateFromString("2016-09-01")
//        startDateTime = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: startDateTime!, options: [])
        
        //將串入日期參數轉換格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        careDate = dateFormatter.stringFromDate(inputDate!)
        
        
        let components = NSDateComponents()
        components.year = 2016
        components.month = 9
        components.day = 1
        components.hour = 8
        components.minute = 0
        components.second = 0
        components.timeZone = NSTimeZone(abbreviation: "GMT+8")
        let startDateTime: NSDate = calendar.dateFromComponents(components)!
        
        
        
        //製造90天的日期
        for day in 1...90 {
            dateArray.append(calendar.dateByAddingUnit(.Day, value: day, toDate: startDateTime, options: [])!)
        }
        
        let layout = calendarCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (UIScreen.mainScreen().bounds.width - 8 * 8) / 7
        print("UIScreen.mainScreen().bounds.width = \(UIScreen.mainScreen().bounds.width) , width = \(width)")
        layout.itemSize = CGSize(width: width, height: 60)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
//        
    }

    
    
    override func viewDidAppear(animated: Bool) {
        
        var selectDate: NSDate?
        
        if let inputDate = inputDate {
            selectDate = inputDate
        } else {
            //設定現在系統時間的時分秒為00:00:00
            selectDate = calendar.dateBySettingHour(8, minute: 0, second: 0, ofDate: NSDate(), options: [])
        }
        
        //比對今日日期在陣列中是第幾個
        let index = dateArray.indexOf(selectDate!)
        
        //滾動到今天日期，並置於最左側
        let indexPath = NSIndexPath(forItem: index!, inSection: 0)
        self.calendarCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        
        dateHighlightCurrentIndex = indexPath.row

        yearMonth.text = "\(calendar.component(.Year, fromDate: selectDate!))年\(calendar.component(.Month, fromDate: selectDate!))月"
        
        //如果已經完成設定，則顯示已設定資料，並且disable save按鈕
        if inputIsSet == true {
            fetchItemList()
            self.saveBtn.enabled = false
        }
        
    }
    
    func openDatePicker(sender: UITextField) {
        
        datePicker.datePickerMode = .Time
        datePicker.minuteInterval = 30
        datePicker.date = NSDate()
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 50 ))
        let okButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.pickerDone))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(self.pickerCancel))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toolbar.items = [cancelButton, space, okButton]
        sender.inputAccessoryView = toolbar
        currentTextField = sender
        currentTextFieldIndex = sender.tag
        sender.inputView = datePicker
        
        self.datePickerWillShow()
    }
    
    
    //[steven解決]Date Picker出現時，將table view推高(關鍵：調整ContentInsets)
    func datePickerWillShow() {
        var contentInsets: UIEdgeInsets
        
        if UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.datePicker.bounds.height, 0.0)
        } else {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.datePicker.bounds.height, 0.0)
        }
        
        UIView.animateWithDuration(1) {
            self.careItemTableView.contentInset = contentInsets
            //self.careItemTableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    func datePickerWillHide() {
        UIView.animateWithDuration(1) {
            self.careItemTableView.contentInset = UIEdgeInsetsZero
            //self.careItemTableView.scrollIndicatorInsets = UIEdgeInsetsZero
        }
    }
    
    func pickerDone() {
        let df = NSDateFormatter()
        df.dateFormat = "HH:mm"
        careItemDictionary[currentTextFieldIndex!]?.operationTime = df.stringFromDate(pickerDefault(datePicker.date))
        
        self.careItemTableView.reloadData()
        currentTextField?.resignFirstResponder()
        
        self.datePickerWillHide()
    }
    
    func pickerCancel() {
        currentTextField?.resignFirstResponder()
        self.datePickerWillHide()
    }
    
    func changeSwitch(sender: UISwitch) {
        careItemDictionary[sender.tag]?.sendNotification = sender.on
        self.careItemTableView.reloadData()
    }
    
    //date picker 預設停留的時間區塊 (00分 or 30分)
    func pickerDefault(currentTime: NSDate) -> NSDate {
        var minuteDefault: Int?
        let calendar = NSCalendar.currentCalendar()
        let componentsYMD = calendar.components([.Month, .Day, .Year, .Hour, .Minute], fromDate: currentTime)
        
        if componentsYMD.minute == 0 || componentsYMD.minute == 30 {
            return currentTime
        } else {
            if componentsYMD.minute > 0 && componentsYMD.minute < 30 {
                minuteDefault = 0
            } else if componentsYMD.minute > 31 && componentsYMD.minute <= 59 {
                minuteDefault = 30
            }
            
            let components = NSDateComponents()
            components.year = componentsYMD.year
            components.month = componentsYMD.month
            components.day = componentsYMD.day
            components.hour = componentsYMD.hour
            components.minute = minuteDefault!
            components.second = 0
            components.timeZone = NSTimeZone(abbreviation: "GMT+8")
            return calendar.dateFromComponents(components)!
        }
    }
    
    func fetchItemList() {
        
        print("\(#function) application_token = \(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)")
        print("\(#function) care_date = \(careDate!)")
        print("\(#function) requester_id = \(inputRequesterId!)")
        
        let urlString: String = "\(TechCareDef.HOST)/api/v1/itemsList"
        Alamofire.request(.POST, urlString, parameters: [
            "application_token" : "\(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)",
            "care_date" : "\(careDate!)",
            "requester_id" : "\(inputRequesterId!)"
            ]).responseJSON(){
                response in
                if let jsonData = response.result.value {
                    print("itemsList api response : \(jsonData)")
                    let json = JSON(jsonData)
                    let status = json["status"].stringValue
                    let message = json["message"].stringValue
                    if status == "200" {
                        
                        if message == "No data" {
                            self.initSettingData()
                            self.saveBtn.enabled = true
                        } else {
                            let jsonList = json["items_data"].arrayValue
                            for data in jsonList {
                                let requesterId = data["requester_id"].stringValue
                                let requesterName = data["requester_name"].stringValue
                                let eventId = data["event_id"].stringValue
                                let operationTime = data["operation_time"].stringValue
                                let itemId = data["item_id"].stringValue
                                let itemName = data["name"].stringValue
                                let completeTime = data["complete_time"].stringValue
                                let sendNotification = data["important"].boolValue
                                var note = data["note"].stringValue
                                if itemId == "26" {  //26:服藥，note欄位存放藥品url
                                    note += "\(TechCareDef.HOST)\(note)"
                                }
                                
                                self.careItemDictionary[Int(itemId)!] = CareItemModel(requesterId: requesterId, requesterName: requesterName, itemId: itemId, itemName: itemName, eventId: eventId, operationTime: operationTime, sendNotification: sendNotification, completeTime: completeTime, note: note)
                            }
                            self.saveBtn.enabled = false
                        }
                        
                    } else {
                        let alert = UIAlertController(title: "App異常終止", message: nil, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(ok)
                        self.presentViewController(alert, animated: true, completion: nil)
                        print("\(#function) error : api response message = \(message)")
                        
                    }
                    
                }
                
                self.careItemTableView.reloadData()
        }
    }
    
    //回傳值
//    func fetchRequesterList(requesterId: String,careDate: String) -> [Bool:Bool] {
//        var returnkey: Bool = false
//        var returnVal: Bool = false
//        
//        print("\(#function) application_token = \(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)")
//        print("\(#function) query_date = \(careDate)")
//        
//        //透過API取得資料
//        let urlString: String = "\(TechCareDef.HOST)/api/v1/requesterList"
//        Alamofire.request(.POST, urlString, parameters: [
//            "application_token" : "\(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)",
//            "query_date" : "\(careDate)"
//            ]).responseJSON(){
//                response in
//                if let jsonData = response.result.value {
//                    print("requesterList api response : \(jsonData)")
//                    let json = JSON(jsonData)
//                    let status = json["status"].stringValue
//                    let message = json["message"].stringValue
//                    if status == "200" {
//                        returnkey = true
//                        
//                        let jsonList = json["requester_data"].arrayValue
//                        for data in jsonList {
//                            if requesterId == data["requester_id"].stringValue {
//                                let isSet = data["isSet"].boolValue
//                                returnVal = isSet
//                            }
//                        }
//                    } else {
//                        let alert = UIAlertController(title: "App異常終止", message: nil, preferredStyle: .Alert)
//                        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                        alert.addAction(ok)
//                        self.presentViewController(alert, animated: true, completion: nil)
//                        print("\(#function) error : api response message = \(message)")
//                    }
//                }
//        }
//        return [returnkey : returnVal]
//    }
    
    func insertData() {
        
        
        print("\(#function) application_token = \(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)")
        print("\(#function) care_date = \(careDate!)")
        print("\(#function) requester_id = \(inputRequesterId!)")
        print("\(#function) items_data = \(convertSetting2JSON(careItemDictionary))")
        
        let urlString: String = "\(TechCareDef.HOST)/api/v1/setItems"
        Alamofire.request(.POST, urlString, parameters: [
            "application_token" : "\(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)",
            "care_date" : "\(careDate!)",
            "requester_id" : "\(inputRequesterId!)",
            "items_data" : "\(convertSetting2JSON(careItemDictionary))"
            ]).responseJSON(){
                response in
                if let jsonData = response.result.value {
                    print("requesterList api response : \(jsonData)")
                    let json = JSON(jsonData)
                    let status = json["status"].stringValue
                    let message = json["message"].stringValue
                    if status == "200" {

                        let alert = UIAlertController(title: "照顧事項已完成設定", message: nil, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) in
                            //self.navigationController?.popViewControllerAnimated(true);
                            self.fetchItemList()
                        }
                        alert.addAction(ok)
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "App異常終止", message: nil, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(ok)
                        self.presentViewController(alert, animated: true, completion: nil)
                        print("\(#function) error : api response message = \(message)")
                        
                    }
                    
                }
                self.careItemTableView.reloadData()
        }
        
    }
    
    
    func convertSetting2JSON(settingsData: [Int:CareItemModel]) -> String {
        var completeJSON: String = ""
        var segmentJSON: String = ""
        for careItemModel in settingsData.values {
            if careItemModel.operationTime != nil && careItemModel.operationTime?.characters.count > 0 {
                segmentJSON += "\(segmentJSON.characters.count > 0 ?",":"") {\"item_id\" : \"\(careItemModel.itemId!)\",\"operation_time\" : \"\(DateUtil.operationTimeFormat(careItemModel.operationTime!))\",\"important\" : \"\(careItemModel.sendNotification)\"}"
            }
        }
        
        completeJSON = "{\"items_data\" : [\(segmentJSON)]}"
        print("completeJSON = \(completeJSON)")
        
        return completeJSON
    }
    
    @IBAction func saveSetting(sender: AnyObject) {
        for (itemId, careItemObj) in careItemDictionary {
            print("itemId=\(itemId),itemName=\(careItemObj.itemName!),operationTime=\(careItemObj.operationTime),sendNotification=\(careItemObj.sendNotification)")
        }
        
        insertData()
    }
    
    
}

extension AddSettingsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CalendarCollectionViewCell

        cell.calendarLabel.text = "\(calendar.component(.Day, fromDate: dateArray[indexPath.row]))"
        cell.dayOfWeek.text = "\(DateUtil.convertWeekdayToTC(calendar.component(.Weekday, fromDate: dateArray[indexPath.row])))"
        cell.dateObject = dateArray[indexPath.row]

        
        //點選的那一個日期改底色，其他的底色設為透明
        if indexPath.row == dateHighlightCurrentIndex {
            cell.backgroundColor = dateBackgroundUIColor
            cell.dayOfWeek.textColor = UIColor.whiteColor()
            cell.calendarLabel.textColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.clearColor()
            cell.dayOfWeek.textColor = UIColor.grayColor()
            cell.calendarLabel.textColor = UIColor.blackColor()
        }
        
        //變更年月Label
        let date = dateArray[indexPath.row]
        self.yearMonth.text = "\(calendar.component(.Year, fromDate: date))年\(calendar.component(.Month, fromDate: date))月"
        return cell
    }
}

extension AddSettingsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //變更新點選日期底色 (記得要reloadData)
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundColor = dateBackgroundUIColor
        
        
        let date = dateArray[indexPath.row]
        yearMonth.text = "\(calendar.component(.Year, fromDate: date))年\(calendar.component(.Month, fromDate: date))月"
        
        collectionView.reloadData()
        
        dateHighlightCurrentIndex = indexPath.row
        careDate = dateFormatter.stringFromDate(dateArray[dateHighlightCurrentIndex!])
        
        
        
//        let result: [Bool: Bool] = fetchRequesterList(inputRequesterId!, careDate: careDate!)
//        for (foundRequester,isSet) in result {
//            if foundRequester == true {
//                if isSet == true {
//                    fetchItemList()
//                    self.saveBtn.enabled = false
//                } else {
//                    initSettingData()
//                    self.careItemTableView.reloadData()
//                    self.saveBtn.enabled = true
//                }
//            } else {
//                initSettingData()
//                self.careItemTableView.reloadData()
//                self.saveBtn.enabled = false
//                
//            }
//        }
        
        fetchItemList()
        
        
    }
}

extension AddSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careItemDictionary.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CareItemCell", forIndexPath: indexPath) as! AddSettingsTableViewCell
        cell.careItemName.text = careItemDictionary[indexPath.row + 1]?.itemName
        cell.operationTimeTextField.tag = indexPath.row + 1
        cell.operationTimeTextField.addTarget(self, action: #selector(openDatePicker(_:)), forControlEvents: .EditingDidBegin)
        cell.operationTimeTextField.text = careItemDictionary[indexPath.row + 1]?.operationTime
        cell.sendNotification.tag = indexPath.row + 1
        cell.sendNotification.addTarget(self, action: #selector(changeSwitch(_:)), forControlEvents: .TouchUpInside)
        cell.sendNotification.on = (careItemDictionary[indexPath.row + 1]?.sendNotification)!
        return cell
    }
    
    
}

