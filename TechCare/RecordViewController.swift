//
//  RecordViewController.swift
//  TechCare
//
//  Created by Chiu Chih-Che on 2016/10/19.
//  Copyright © 2016年 Jeff. All rights reserved.
//

import UIKit
import Charts

class RecordViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //var months: [String]!
    var recordItemArray: [String] = ["--請選擇--","收縮壓","舒張壓","心跳","血糖"]
    var days = ["10/1", "10/2", "10/3", "10/4", "10/5", "10/6", "10/7", "10/8", "10/9", "10/10", "10/11", "10/12", "10/13", "10/14", "10/15", "10/16", "10/17", "10/18", "10/19", "10/20", "10/21", "10/22", "10/23", "10/24", "10/25"]
    let unitsSold = [122.0, 93.0, 100.0, 110.0, 103.0, 122.0, 99.0, 130.0, 108.0, 131.0, 139.0, 145.0, 99.0, 119.0, 127.0, 108.0, 109.0, 116.0, 124.0, 118.0, 142.0, 144.0, 116.0, 94.0, 118.0]
    let upperLimitArray = [140,90,0,125]
    let lowerLimitArray = [90,60,0,100]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.dataSource = self
        pickerView.delegate = self
        
        barChartView.noDataText = "尚無資料可顯示圖表。"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double], upperLimit: Int, lowerLimit: Int, rowName: String) {
        
        
        //清空界線
        barChartView.rightAxis.removeAllLimitLines()
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: rowName)
        let chartData = BarChartData(xVals: days, dataSet: chartDataSet)
        barChartView.data = chartData
        
        //右下角Description字眼清除
        barChartView.descriptionText = ""
        
        //變更資料柱顏色
        chartDataSet.colors = [UIColor(red:0.62, green:0.89, blue:0.42, alpha:1.0)]
        
        //變更背景顏色
//        barChartView.backgroundColor = UIColor(red:0.35, green:0.73, blue:0.27, alpha:1.0)
        
        //變更x軸標籤的位置
        barChartView.xAxis.labelPosition = .Bottom

        //改變圖表背景顏色
        //barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //動畫
        barChartView.animate(yAxisDuration: 1.5, easingOption: .Linear)
        
        //界線
        var ll = ChartLimitLine(limit: Double(lowerLimit), label: "下限")
        barChartView.rightAxis.addLimitLine(ll)
        
        ll = ChartLimitLine(limit: Double(upperLimit), label: "上限")
        barChartView.rightAxis.addLimitLine(ll)
        
    }

}

extension RecordViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recordItemArray.count
    }
}

extension RecordViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recordItemArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Componet: \(component) , row : \(row)")
        
        if row != 0 {
            setChart(days, values: unitsSold, upperLimit: upperLimitArray[row-1], lowerLimit: lowerLimitArray[row-1], rowName: recordItemArray[row])
        }
    }
}