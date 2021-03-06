//
//  StatsView.swift
//  Skybar
//
//  Created by Christopher Nassar on 9/30/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import Charts

class StatsView: UIView,ChartViewDelegate {
     //MARK:- outlets
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var lastVisitLbl: UILabel!
    @IBOutlet weak var visitsLbl: UILabel!
    @IBOutlet weak var complementaryLbl: UILabel!
    @IBOutlet weak var paidConsumptionLbl: UILabel!
    @IBOutlet weak var consumptionLbl: UILabel!
    @IBOutlet weak var innerView: UIView!
    
     //MARK:- variables
    var info:[Any]! = nil
    var layerCorners:UIView! = nil
    var dates = [String]()
    var consumption = [Float]()
    var complementary = [Float]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupChart()
    }
    
   
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if let _ = layerCorners{}else{
            self.layoutIfNeeded()
            layerCorners = UIView(frame: self.innerView.frame)
            layerCorners.layer.cornerRadius = 13
            layerCorners.backgroundColor = UIColor.white
            layerCorners.layer.shadowOffset = CGSize.zero
            layerCorners.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.11).cgColor
            layerCorners.layer.shadowOpacity = 1
            layerCorners.layer.shadowRadius = 10
            self.addSubview(layerCorners)
            self.sendSubviewToBack(layerCorners)

            innerView.layer.masksToBounds = true
            innerView.layer.cornerRadius = 13
        }
    }
    
    func populateInfo(info:[Any]){
        self.info = info
        dates.removeAll()
        consumption.removeAll()
        complementary.removeAll()
        
        var totalConsumption:Float = 0
        var totalComplementary:Float = 0
        var totalPaidConsumption:Float = 0
        
        visitsLbl.text = "\(info.count) Visits"
        self.visitsLbl.textColor =  UIColor.black
        
        for entry in info{
            if let entry = entry as? [String:Any]{
                if let dateVisited = entry["DateVisited"] as? String{
                    if let date = Date(jsonDate: dateVisited){
                        let formatter = DateFormatter()
                        // initially set the format based on your datepicker date / server String
                        formatter.dateFormat = "ddMMM"
                        
                        let str = formatter.string(from: date) // string purpose I add here
                        dates.append(str.uppercased())
                        
                        formatter.dateFormat = "dd MMM, yyyy"
                        
                        let strDate = formatter.string(from: date) // string purpose I add here
                        lastVisitLbl.text = "Last visit, \(strDate)"
                    }
                }
                
                if let consum = entry["TotalPaid"] as? Float{
                    totalPaidConsumption += consum
                    consumption.append(consum)
                }
                
                if let bill = entry["TotalConsumption"] as? Float{
                    totalConsumption += bill
                }
                
                if let discount = entry["DiscountProvided"] as? Float{
                    totalComplementary += discount
                    complementary.append(discount)
                }
            }
        }
        
        self.consumptionLbl.text = totalConsumption.toCurrencyNoPrefix()
        self.complementaryLbl.text = totalComplementary.toCurrencyNoPrefix()
        self.paidConsumptionLbl.text = totalPaidConsumption.toCurrencyNoPrefix()
        
        chartAction()
    }
    
    func chartAction(){
        
       let xaxis = chartView.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.dates)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 2
        
        let yaxis = chartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        chartView.rightAxis.enabled = false
        
        setChart()
    }
    
    func setupChart(){
        chartView.delegate = self
        chartView.noDataText = "You need to provide data for the chart."
        chartView.chartDescription?.text = nil
        
        
        //legend
        let legend = chartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
    }
    
     //MARK:- set chart
    func setChart() {
        chartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<self.dates.count {
            
            if consumption.count > i {
                let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(self.consumption[i]))
                dataEntries.append(dataEntry)
            }
            
            if complementary.count > i {
                let dataEntry1 = BarChartDataEntry(x: Double(i) , y: Double(self.complementary[i]))
                dataEntries1.append(dataEntry1)
            }
            
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Paid consumption")
        chartDataSet.setColor(UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1))
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Discount")
        chartDataSet1.setColor(UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1))
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        
        let groupSpace = 0.8
        let barSpace = 0.0
        let barWidth = 0.1
        
        let groupCount = self.dates.count
        let startYear = 0
        
        
        chartData.barWidth = barWidth;
        chartView.xAxis.axisMinimum = Double(startYear)
        let temp = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(temp)")
        chartView.xAxis.axisMaximum = Double(startYear) + temp * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        chartView.notifyDataSetChanged()
        
        chartView.data = chartData
        
        //background color
        chartView.backgroundColor = .white
        
        //chart animation
        chartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .linear)
        
        
    }

}
