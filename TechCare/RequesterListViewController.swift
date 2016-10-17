//
//  RequesterListViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/6.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit

class RequesterListViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var RequestTableView: UITableView!
    @IBOutlet weak var yearMonth: UILabel!
    
    var dateArray: [NSDate] = []
    var dateHighlightCurrentIndex: Int? //記錄目前是點選哪一個
    
    let dateBackgroundUIColor: UIColor = UIColor(red:1.00, green:0.41, blue:0.52, alpha:1.0) //紅色
    let calendar = NSCalendar.currentCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        RequestTableView.dataSource = self
        
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
    
    
}

extension RequesterListViewController: UICollectionViewDataSource {
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

extension RequesterListViewController: UICollectionViewDelegate {
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

extension RequesterListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RequestTableViewCell
        cell.personalBackgroundImageView.backgroundColor = UIColor(red:0.73, green:0.92, blue:0.70, alpha:1.0) //綠色
        return cell
//        var product = Product()
//        
//        if isFilter {
//            product = filterProductArray[indexPath.row]
//        } else {
//            product = productArray[indexPath.row]
//        }
//        return self.getProductCellWithTableView(tableView, indexPath: indexPath, product: product)
    }
    
//    func getProductCellWithTableView(tableView: UITableView, indexPath: NSIndexPath, product: Product) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("ProductListTableViewCell", forIndexPath: indexPath) as! ProductTableViewCell
//        cell.productImageView?.sd_setImageWithURL(NSURL(string: product.packageUrl))
//        cell.productName.text = product.productName
//        cell.productPrice.text = "$ " + product.singlePrice + "/片"
//        return cell
//    }
}

