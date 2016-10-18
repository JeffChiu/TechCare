//
//  AddSettingsViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/6.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit

class AddSettingsViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var careItemTableView: UITableView!
    @IBOutlet weak var yearMonth: UILabel!
    
    
    var dateArray: [NSDate] = []
    var dateHighlightCurrentIndex: Int? //記錄目前是點選哪一個
    var inputDate: NSDate?
    var careItemArray: [String] = []
    var careItemDictionary: [Int:CareItemModel] = [:] //[itemId:CareItemModel物件]
    
    let dateBackgroundUIColor: UIColor = UIColor(red:1.00, green:0.41, blue:0.52, alpha:1.0) //紅色
    let calendar = NSCalendar.currentCalendar()
    
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 200))
    var currentTextField: UITextField?
    var currentTextFieldIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        careItemTableView.dataSource = self
        
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
        careItemDictionary[22] = CareItemModel(itemId: "22", itemName: "陪同散步")
        careItemDictionary[23] = CareItemModel(itemId: "23", itemName: "陪同散步")
        careItemDictionary[24] = CareItemModel(itemId: "24", itemName: "閱讀書報")
        
        //準備照顧事項
        careItemArray.append("陪伴")
        careItemArray.append("情緒支持")
        careItemArray.append("盥洗")
        careItemArray.append("入浴")
        careItemArray.append("如廁")
        careItemArray.append("更衣")
        careItemArray.append("餵食")
        careItemArray.append("餵藥")
        careItemArray.append("肢體關節運動")
        careItemArray.append("翻身")
        careItemArray.append("拍背")
        careItemArray.append("洗衣")
        careItemArray.append("服務對象起居環境清潔")
        careItemArray.append("陪同或代理購物")
        careItemArray.append("備餐(購買)")
        careItemArray.append("備餐(煮食)")
        careItemArray.append("協助申請社會福利服務")
        careItemArray.append("代寫書信及聯絡親友")
        careItemArray.append("陪同就醫")
        careItemArray.append("代領藥品")
        careItemArray.append("量血壓/心跳")
        careItemArray.append("量血糖")
        careItemArray.append("陪同散步")
        careItemArray.append("閱讀書報")
        
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        var startDateTime = dateFormatter.dateFromString("2016-09-01")
//        startDateTime = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: startDateTime!, options: [])
        
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
        let width = (UIScreen.mainScreen().bounds.width - 5 * 8) / 7
        print("UIScreen.mainScreen().bounds.width = \(UIScreen.mainScreen().bounds.width) , width = \(width)")
        layout.itemSize = CGSize(width: width, height: width)
        
        
        
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

        yearMonth.text = "\(calendar.component(.Year, fromDate: selectDate!))/\(calendar.component(.Month, fromDate: selectDate!))"
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
    }
    
    func pickerDone() {
        let df = NSDateFormatter()
        df.dateFormat = "HH:mm"
        careItemDictionary[currentTextFieldIndex!]?.operationTime = df.stringFromDate(pickerDefault(datePicker.date))
        
        self.careItemTableView.reloadData()
        currentTextField?.resignFirstResponder()
    }
    
    func pickerCancel() {
        currentTextField?.resignFirstResponder()
    }
    
    func changeSwitch(sender: UISwitch) {
        careItemDictionary[sender.tag]?.sendNotification = sender.on
        self.careItemTableView.reloadData()
    }
    
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
    
    
    @IBAction func saveSetting(sender: AnyObject) {
        for (itemId, careItemObj) in careItemDictionary {
            print("itemId=\(itemId),itemName=\(careItemObj.itemName!),operationTime=\(careItemObj.operationTime),sendNotification=\(careItemObj.sendNotification)")
        }

        //alert關閉後不能pop回去
//        let alert = UIAlertController(title: "照顧事項已更新", message: nil, preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: {
//            self.navigationController?.popViewControllerAnimated(true)
//        })
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.dateObject = dateArray[indexPath.row]

        
        //點選的那一個日期改底色，其他的底色設為透明
        if indexPath.row == dateHighlightCurrentIndex {
            cell.backgroundColor = dateBackgroundUIColor
        } else {
            cell.backgroundColor = UIColor.clearColor()
        }
        
        //變更年月Label
        let date = dateArray[indexPath.row]
        self.yearMonth.text = "\(calendar.component(.Year, fromDate: date))/\(calendar.component(.Month, fromDate: date))"
        return cell
    }
}

extension AddSettingsViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //變更新點選日期底色 (記得要reloadData)
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundColor = dateBackgroundUIColor
        
        
        let date = dateArray[indexPath.row]
        yearMonth.text = "\(calendar.component(.Year, fromDate: date))/\(calendar.component(.Month, fromDate: date))"
        
        collectionView.reloadData()
        
        dateHighlightCurrentIndex = indexPath.row
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

