//
//  RequesterListViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/6.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ScheduleListViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var CareItemTableView: UITableView!
    @IBOutlet weak var yearMonth: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    
    var dateArray: [NSDate] = []
    var dateHighlightCurrentIndex: Int? //記錄目前是點選哪一個
    var currentMonth: Int? //記錄目前月份
    
    let dateBackgroundUIColor: UIColor = UIColor(red:0.27, green:0.80, blue:0.73, alpha:1.0) //tiffany green
    let userDefault = NSUserDefaults.standardUserDefaults()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    let calendar = NSCalendar.currentCalendar()
    var dateFormatter = NSDateFormatter()
    var selectDate: NSDate?
    var careDate: String?
    
    var careItemArray: [CareItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.color = TechCareDef.SYSTEM_TINT
        
        self.headerView.layer.borderWidth = 0.5
        self.headerView.layer.borderColor = UIColor.blackColor().CGColor
        
        //Navigation Item UI
        let label: UILabel = UILabel.init(frame: TechCareDef.NAVIGATION_LABEL_RECT_SIZE)
        label.text = "我的服務"
        label.textAlignment = .Center
        label.font = TechCareDef.NAVIGATION_LABEL_FONT_SIZE
        self.navigationItem.titleView = label
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        CareItemTableView.dataSource = self
        
        
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
        
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        
        if let dateHighlightCurrentIndex = dateHighlightCurrentIndex {
            selectDate = dateArray[dateHighlightCurrentIndex]
        } else {
            //設定目前系統時間的時分秒為00:00:00
            selectDate = calendar.dateBySettingHour(8, minute: 0, second: 0, ofDate: NSDate(), options: [])
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        careDate = dateFormatter.stringFromDate(selectDate!)
        currentMonth = NSCalendar.currentCalendar().component(.Month, fromDate: selectDate!)
        
        //比對今日日期在陣列中是第幾個
        let index = dateArray.indexOf(selectDate!)
        
        //滾動到今天日期，並置於最左側
        let indexPath = NSIndexPath(forItem: index!, inSection: 0)
        self.calendarCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        
        dateHighlightCurrentIndex = indexPath.row
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        careDate = dateFormatter.stringFromDate(dateArray[dateHighlightCurrentIndex!])
        yearMonth.text = "\(calendar.component(.Year, fromDate: selectDate!))年\(calendar.component(.Month, fromDate: selectDate!))月"
        
        fetchItemList()
    }
    
    
    func fetchItemList() {
        //indicator
        self.view.addSubview(self.activityIndicatorView)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        //清空資料
        self.CareItemTableView.backgroundView = nil
        careItemArray.removeAll()
        
        print("\(#function) application_token = \(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)")
        print("\(#function) care_date = \(careDate!)")
        
        let urlString: String = "\(TechCareDef.HOST)/api/v1/itemsList"
        Alamofire.request(.POST, urlString, parameters: [
            "application_token" : "\(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)",
            "care_date" : "\(careDate!)",
            "requester_id" : ""
            ]).responseJSON(){
                response in
                if let jsonData = response.result.value {
                    print("itemsList api response : \(jsonData)")
                    let json = JSON(jsonData)
                    let status = json["status"].stringValue
                    let message = json["message"].stringValue
                    if status == "200" {
                        
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
                            if itemId == "25" || itemId == "26" || itemId == "27" || itemId == "28" || itemId == "29" || itemId == "30" || itemId == "31" {  //itemId 25~31，note欄位存放藥品url
                                note = "\(TechCareDef.HOST)\(note)"
                            }
                        
                            self.careItemArray.append(CareItemModel(requesterId: requesterId, requesterName: requesterName, itemId: itemId, itemName: itemName, eventId: eventId, operationTime: operationTime, sendNotification: sendNotification, completeTime: completeTime, note: note))
                        }
                        
                    } else {
                        let alert = UIAlertController(title: "系統連線異常", message: nil, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(ok)
                        self.presentViewController(alert, animated: true, completion: nil)
                        print("\(#function) error : api response message = \(message)")
                        
                    }
                    
                    
                    //如果沒資料，顯示特定文字（取資料時注意背景要先清空）
                    if self.careItemArray.count == 0 {
                        let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.CareItemTableView.bounds.size.width, self.CareItemTableView.bounds.size.height))
                        noDataLabel.text             = "本日無照顧事項"
                        noDataLabel.textColor        = UIColor.blackColor()
                        noDataLabel.textAlignment    = .Center
                        self.CareItemTableView.backgroundView = noDataLabel
                        self.CareItemTableView.separatorStyle = .None
                        
                    }
                    self.activityIndicatorView.removeFromSuperview()
                    
                }
                self.CareItemTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishItemBtn(sender: UIButton) {
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        //let cell = CareItemTableView.cellForRowAtIndexPath(indexPath) as! CareItemTableViewCell
        
        var careItemModel: CareItemModel = careItemArray[indexPath.row]
        
        //[重要]檢查user default是否有由SpecialItemViewController的暫存資料，與欲更新的CareItemModel比對是否為同一Event ID，是的話，代表為含有額外輸入的資料，則使用此最新資料，並在user default清空
//        if userDefault.objectForKey("SpecificCareItem") != nil {
//            let tempCareItemModel: CareItemModel = (userDefault.objectForKey("SpecificCareItem") as? CareItemModel)!
//            if tempCareItemModel.eventId == careItemModel.eventId {
//                careItemModel = tempCareItemModel
//                userDefault.setObject(nil, forKey: "SpecificCareItem")
//            }
//        }
        
    print("careItemModel.itemId = \(careItemModel.itemId!) , careItemModel.systolic = \(careItemModel.systolic)")
        if (careItemModel.itemId! == "21" && (careItemModel.systolic == "null" || careItemModel.diastolic == "null" || careItemModel.heartRate == "null")) || (careItemModel.itemId! == "22" && careItemModel.bloodSugar == "null") {
            let vc =  storyboard!.instantiateViewControllerWithIdentifier("SpecialItem") as! SpecialItemViewController
            vc.itemId = careItemModel.itemId!
            vc.inputCareItemModel = careItemModel
            
            //for demo day
            careItemModel.systolic = "130"
            careItemModel.diastolic = "80"
            careItemModel.heartRate = "80"
            careItemModel.bloodSugar = "100"
            
            self.presentViewController(vc, animated: true, completion: nil)
        } else if careItemModel.itemId! == "25" || careItemModel.itemId! == "26" || careItemModel.itemId! == "27" ||
            careItemModel.itemId! == "28" || careItemModel.itemId! == "29" || careItemModel.itemId! == "30" ||
            careItemModel.itemId! == "31" {
            let vc =  storyboard!.instantiateViewControllerWithIdentifier("PhotoConfirm") as! PhotoConfirmViewController
            vc.itemId = careItemModel.itemId!
            vc.photoUrl = careItemModel.note!
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        
        //更新資料
        updateItemData(careItemModel.requesterId!,careItemModel: careItemModel)
        
    }
    
    func updateItemData(requeseterId: String, careItemModel: CareItemModel) {
        
        print("application_token = \(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)")
        print("care_date = \(careDate!)")
        print("requester_id = \(requeseterId)")
        print("items_data = \(convertModel2JSON(careItemModel))")
        
        let urlString: String = "\(TechCareDef.HOST)/api/v1/updateItem"
        Alamofire.request(.POST, urlString, parameters: [
            "application_token" : "\(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)",
            "care_date" : "\(careDate!)",
            "requester_id" : "\(requeseterId)",
            "items_data" : "\(convertModel2JSON(careItemModel))"
            ]).responseJSON(){
                response in
                if let jsonData = response.result.value {
                    print("updateItemData api response : \(jsonData)")
                    let json = JSON(jsonData)
                    let status = json["status"].stringValue
                    let message = json["message"].stringValue
                    if status == "200" {
                        print("message = \(message)")
                        
                        //刷新頁面資料
                        self.fetchItemList()
                    } else {
                        let alert = UIAlertController(title: "系統連線異常", message: nil, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(ok)
                        self.presentViewController(alert, animated: true, completion: nil)
                        print("\(#function) error : api response message = \(message)")
                    }
                }
        }
    }
    
    func convertModel2JSON(careItemModel: CareItemModel) -> String {
        let currentTime: String?
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        currentTime = dateFormatter.stringFromDate(NSDate())
        return "{\"event_id\" : \"\(careItemModel.eventId!)\",\"complete_time\" : \"\(currentTime!)\",\"systolic_record\" : \"\(careItemModel.systolic)\",\"diastolic_record\" : \"\(careItemModel.diastolic)\",\"heart_rate\" : \"\(careItemModel.heartRate)\",\"blood_sugar\" : \"\(careItemModel.bloodSugar)\"}"
    }
    
}

extension ScheduleListViewController: UICollectionViewDataSource {
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
        let scrollNewMonth = NSCalendar.currentCalendar().component(.Month, fromDate: date)
        let scrollNewDay = NSCalendar.currentCalendar().component(.Day, fromDate: date)
        if (scrollNewMonth > currentMonth && scrollNewDay > 3) || (scrollNewMonth < currentMonth && scrollNewDay < 27) {
            currentMonth = scrollNewMonth
            self.yearMonth.text = "\(calendar.component(.Year, fromDate: date))年\(scrollNewMonth)月"
        }
        
        return cell
    }
}

extension ScheduleListViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //變更新點選日期底色 (記得要reloadData)
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundColor = dateBackgroundUIColor
        
        
        let date = dateArray[indexPath.row]
        yearMonth.text = "\(calendar.component(.Year, fromDate: date))年\(calendar.component(.Month, fromDate: date))月"
        
        collectionView.reloadData()
        
        dateHighlightCurrentIndex = indexPath.row
        careDate = dateFormatter.stringFromDate(dateArray[dateHighlightCurrentIndex!])
        currentMonth = NSCalendar.currentCalendar().component(.Month, fromDate: dateArray[dateHighlightCurrentIndex!])
        
        fetchItemList()
    }
}

extension ScheduleListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careItemArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CareItemTableViewCell
        var startSinbol = ""
        if careItemArray[indexPath.row].sendNotification == true {
            startSinbol = "*"
        }
        
        cell.requesterName.text = careItemArray[indexPath.row].requesterName
        cell.careItem.text = careItemArray[indexPath.row].itemName! + startSinbol
        cell.operationTime.text = DateUtil.operationTimeFormat2(careItemArray[indexPath.row].operationTime!)
        print("careItemArray[indexPath.row].completeTime = \(careItemArray[indexPath.row].completeTime!)")
        print(careItemArray[indexPath.row].completeTime!.characters.count)
        print("itemId = \(careItemArray[indexPath.row].itemId!) , note = \(careItemArray[indexPath.row].note!)")
        if careItemArray[indexPath.row].completeTime!.characters.count == 0 {
            cell.finishItem.tag = indexPath.row
            cell.finishItem.addTarget(self, action: #selector(finishItemBtn(_:)), forControlEvents: .TouchUpInside)
            cell.finishItem.enabled = true
        } else {
            cell.finishItem.enabled = false
        }
        
        return cell

    }

}

extension ScheduleListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}



