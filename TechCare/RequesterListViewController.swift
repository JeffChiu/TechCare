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
import SDWebImage

class RequesterListViewController: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var RequestTableView: UITableView!
    @IBOutlet weak var yearMonth: UILabel!
    
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    var dateArray: [NSDate] = []
    var dateHighlightCurrentIndex: Int? //記錄目前是點選哪一個
    var currentMonth: Int? //記錄目前月份
    var selectDate: NSDate?
    var careDate: String?
    var dateFormatter = NSDateFormatter()
    
    
    let dateBackgroundUIColor: UIColor = UIColor(red:0.27, green:0.80, blue:0.73, alpha:1.0) //tiffany green
    let calendar = NSCalendar.currentCalendar()
    let userDefault = NSUserDefaults.standardUserDefaults()
    var requsterModelArray: [RequesterModel] = []
    var selectRequsterMdoel: RequesterModel?
    
    var test: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let app_token = userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN) {
                print("\(#function) , token =  \(app_token)")
        }
        
        activityIndicatorView.color = TechCareDef.SYSTEM_TINT
        
        //Navigation Item UI
        let label: UILabel = UILabel.init(frame: TechCareDef.NAVIGATION_LABEL_RECT_SIZE)
        label.text = "服務對象"
        label.textAlignment = .Center
        label.font = TechCareDef.NAVIGATION_LABEL_FONT_SIZE
        self.navigationItem.titleView = label
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        RequestTableView.dataSource = self
        RequestTableView.delegate = self
        
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
        
        
        
        //製造N天的日期
        for day in 1...450 {
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

        
        //滾動到今天日期，並置於中間
        let indexPath = NSIndexPath(forItem: index!, inSection: 0)
        self.calendarCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        
        dateHighlightCurrentIndex = indexPath.row
        
        yearMonth.text = "\(calendar.component(.Year, fromDate: selectDate!))年\(calendar.component(.Month, fromDate: selectDate!))月"
        
        
        fetchRequesterList()
    }
    
    func fetchRequesterList() {
        //indicator
        self.view.addSubview(self.activityIndicatorView)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        
        //資料清空
        self.RequestTableView.backgroundView = nil
        requsterModelArray.removeAll()
        
        //透過API取得資料
        let urlString: String = "\(TechCareDef.HOST)/api/v1/requesterList"
        Alamofire.request(.POST, urlString, parameters: [
            "application_token" : "\(userDefault.objectForKey(TechCareDef.APPLICATION_TOKEN)!)",
            "query_date" : "\(careDate)"
            ]).responseJSON(){
                response in
                if let jsonData = response.result.value {
                    print("requesterList api response : \(jsonData)")
                    let json = JSON(jsonData)
                    let status = json["status"].stringValue
                    let message = json["message"].stringValue
                    if status == "200" {
                        
                        let jsonList = json["requester_data"].arrayValue
                        for data in jsonList {
                            let id = data["requester_id"].stringValue
                            let name = data["name"].stringValue
                            let photoUrl = "\(TechCareDef.HOST)\(data["photo_url"].stringValue)"
                            let info = data["status_info"].stringValue
                            let isSet = data["isSet"].boolValue
                            self.requsterModelArray.append(RequesterModel(id: id, name: name, photoUrl: photoUrl, info: info, isSet: isSet))
                        }
                        
                        
                        
                    } else {
                        let alert = UIAlertController(title: "系統連線異常", message: nil, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(ok)
                        self.presentViewController(alert, animated: true, completion: nil)
                        print("\(#function) error : api response message = \(message)")
                        
                    }

                    self.activityIndicatorView.removeFromSuperview()
                }
                
                //如果沒資料，顯示特定文字（取資料時注意背景要先清空）
                if self.requsterModelArray.count == 0 {
                    let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.RequestTableView.bounds.size.width, self.RequestTableView.bounds.size.height))
                    noDataLabel.text             = "本日無照顧對象"
                    noDataLabel.textColor        = UIColor.blackColor()
                    noDataLabel.textAlignment    = .Center
                    self.RequestTableView.backgroundView = noDataLabel
                    self.RequestTableView.separatorStyle = .None
                    
                }
                
                self.RequestTableView.reloadData()
        }
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

extension RequesterListViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //變更新點選日期底色 (記得要reloadData)
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundColor = dateBackgroundUIColor
        
        
        let date = dateArray[indexPath.row]
        yearMonth.text = "\(calendar.component(.Year, fromDate: date))年\(calendar.component(.Month, fromDate: date))月"
        
        collectionView.reloadData()
        
        dateHighlightCurrentIndex = indexPath.row
        dateFormatter.dateFormat = "yyyy-MM-dd"
        careDate = dateFormatter.stringFromDate(dateArray[dateHighlightCurrentIndex!])
        currentMonth = NSCalendar.currentCalendar().component(.Month, fromDate: dateArray[dateHighlightCurrentIndex!])
        
        fetchRequesterList()
    }
}

extension RequesterListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requsterModelArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RequestTableViewCell
        let requesterModel = requsterModelArray[indexPath.row]
        //cell.personalBackgroundImageView.backgroundColor = UIColor(red:0.73, green:0.92, blue:0.70, alpha:1.0) //綠色
        if let url = requesterModel.photoUrl where (!url.isEmpty && url != "http://techcare.twblank.png") {
            cell.personalImageView.sd_setImageWithURL(NSURL(string: url))
        } else {
            cell.personalImageView.image = UIImage(named: "requester")
        }
        
        cell.requesterName.text = requesterModel.name
        cell.requesterInfo.text = requesterModel.info
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddSettingSegue" {
            let vc = segue.destinationViewController as! AddSettingsViewController
            vc.inputDate = dateArray[dateHighlightCurrentIndex!]
            
            //Alex貢獻idea
            let indexPath = self.RequestTableView.indexPathForSelectedRow
            vc.inputRequesterName = requsterModelArray[indexPath!.row].name!
            vc.inputRequesterId = requsterModelArray[indexPath!.row].id
            vc.inputIsSet = requsterModelArray[indexPath!.row].isSet
        }
    }
}

extension RequesterListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

