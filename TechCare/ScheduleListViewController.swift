//
//  RequesterListViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/6.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit

class ScheduleListViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var CareItemTableView: UITableView!
    @IBOutlet weak var yearMonth: UILabel!
    
    
    var dateArray: [NSDate] = []
    var dateHighlightCurrentIndex: Int? //記錄目前是點選哪一個
    
    let dateBackgroundUIColor: UIColor = UIColor(red:1.00, green:0.41, blue:0.52, alpha:1.0)
    let calendar = NSCalendar.currentCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let width = (UIScreen.mainScreen().bounds.width - 5 * 8) / 7
        print("UIScreen.mainScreen().bounds.width = \(UIScreen.mainScreen().bounds.width) , width = \(width)")
        layout.itemSize = CGSize(width: width, height: width)
        
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        
        //設定系統時間的時分秒為00:00:00
        let today = calendar.dateBySettingHour(8, minute: 0, second: 0, ofDate: NSDate(), options: [])
        
        //比對今日日期在陣列中是第幾個
        let index = dateArray.indexOf(today!)
print("index = \(index)")
        
        //滾動到今天日期，並置於最左側
        let indexPath = NSIndexPath(forItem: index!, inSection: 0)
        self.calendarCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        
        dateHighlightCurrentIndex = indexPath.row
        
        let date = dateArray[indexPath.row]
print("today date = \(date)")
        yearMonth.text = "\(calendar.component(.Year, fromDate: date))/\(calendar.component(.Month, fromDate: date))"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishItemBtn(sender: UIButton) {
        //button disabled
        sender.enabled = false
        
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        let cell = CareItemTableView.cellForRowAtIndexPath(indexPath) as! CareItemTableViewCell
        
        //Label換顏色以表示完成
        cell.careItem.textColor = UIColor(red:0.73, green:0.92, blue:0.70, alpha:1.0)
        cell.operationTime.textColor = UIColor(red:0.73, green:0.92, blue:0.70, alpha:1.0)
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
        cell.dateObject = dateArray[indexPath.row]
print("cell date = \(dateArray[indexPath.row]) , day = \(calendar.component(.Day, fromDate: dateArray[indexPath.row]))")

        
        
        //點選的那一個日期改底色，其他的底色設為透明
        if indexPath.row == dateHighlightCurrentIndex {
print("cell select date = \(dateArray[indexPath.row]) , select day = \(calendar.component(.Day, fromDate: dateArray[indexPath.row]))")
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

extension ScheduleListViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //變更新點選日期底色 (記得要reloadData)
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundColor = dateBackgroundUIColor
        
        
        let date = dateArray[indexPath.row]
print("didselect date = \(date) , yearMonth = \(yearMonth.text)")
        yearMonth.text = "\(calendar.component(.Year, fromDate: date))/\(calendar.component(.Month, fromDate: date))"
        
        collectionView.reloadData()
        
        dateHighlightCurrentIndex = indexPath.row
    }
}

extension ScheduleListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CareItemTableViewCell
        cell.finishItem.tag = indexPath.row
        cell.finishItem.addTarget(self, action: #selector(finishItemBtn(_:)), forControlEvents: .TouchUpInside)
        return cell

    }
    
}



