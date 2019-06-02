//
//  LactateViewController.swift
//  TBI_Tracker
//
//  Created by Aishwarya Pattar on 03/02/2019.
//  Copyright © 2019 Aishwarya Pattar. All rights reserved.
//

import UIKit
import Charts

class LactateViewController: UIViewController {

    var myArr: [Double] = []
    var myTime: [Double] = []
    var myLCal1: String = ""
    var myLCal2: String = ""
    var myLCal3: String = ""
    var Larr: [Double] = []
    var timeL: [Double] = []
    
    // IBOutlets
    @IBOutlet weak var lactateLineChartView: LineChartView!
    @IBOutlet weak var LLabel: UILabel!
    
    // IBActions
    @IBAction func Ltoggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // segmented control on voltage
            LLabel.text = "Voltage (mV) vs. Time (ms)"
            LLabel.textColor = UIColor.black
            setChartValues()
        }
        else {
            // segmented control on concentration
            if myLCal1 == "" || myLCal2 == "" || myLCal1 == "" {
                // calibration value missing
                LLabel.text = "Please insert calibration values on previous page"
                LLabel.textColor = UIColor.red
            }
            else {
                // calibration values provided
                LLabel.text = "Concentration (mM) vs. Time (ms)"
                LLabel.textColor = UIColor.black
                
                let Cal1 : Double = Double(myLCal1)!
                let Cal2 : Double = Double(myLCal2)!
                let Cal3 : Double = Double(myLCal3)!
                setConcValues(p1 : Cal1, p2: Cal2, p3: Cal3)
            }
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Larr = myArr
        timeL = myTime
        
        // initialise graph
        setChartValues()
        
        // makes bubbles appear when you click on data
        let marker:BalloonMarker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                                 font: .systemFont(ofSize: 12),
                                                 textColor: .white,
                                                 insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = lactateLineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        lactateLineChartView.marker = marker
        
        // modify the LineChartView
        self.lactateLineChartView.dragYEnabled = false
        self.lactateLineChartView.rightAxis.enabled = false
        self.lactateLineChartView.backgroundColor = .white
        self.lactateLineChartView.legend.enabled = false
    }
    
    func setChartValues() {
        
        // sets x and y values for Glucose
        let entriesL = (0..<Larr.count).map { (i) -> ChartDataEntry in
            let Lval = Larr[i]
            let timeValL = timeL[i]
            return ChartDataEntry(x: timeValL, y: Lval)
        }
        let setL = LineChartDataSet(values: entriesL, label: "[Lactate]")
        
        // set line features
        let dataSets = [setL]
        let data = LineChartData(dataSets: dataSets)
        self.lactateLineChartView.data = data
        
        // modify line plots
        setL.drawCirclesEnabled = false
        setL.drawValuesEnabled = false
        setL.lineWidth = 2
        setL.setColor(.blue)
    }
    
    func setConcValues(p1 : Double, p2 : Double, p3 : Double) {
        
        // find calibration equation: y = mx + c
        
        
        // sets x and y values for Glucose
        let entriesL = (0..<Larr.count).map { (i) -> ChartDataEntry in
            let Lval = Larr[i]
            let timeValL = timeL[i]
            return ChartDataEntry(x: timeValL, y: Lval)
        }
        let setL = LineChartDataSet(values: entriesL, label: "[Lactate]")
        
        // set line features
        let dataSets = [setL]
        let data = LineChartData(dataSets: dataSets)
        self.lactateLineChartView.data = data
        
        // modify line plots
        setL.drawCirclesEnabled = false
        setL.drawValuesEnabled = false
        setL.lineWidth = 2
        setL.setColor(.blue)
    }
    
    
    
    
    
    /*
    var myArr: [Double] = []
    var myTime: [Double] = []
    var myLCal1: String = ""
    var myLCal2: String = ""
    var myLCal3: String = ""
    var Larr: [Double] = []
    var timeL: [Double] = []
    
    
    // IBOutlets
    @IBOutlet weak var lactateLineChartView: LineChartView!
    @IBOutlet weak var LLabel: UILabel!
    
    //IBActions
    @IBAction func Ltoggle(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            // segmented control on voltage
            LLabel.text = "Voltage (mV) vs. Time (ms)"
            LLabel.textColor = UIColor.black
            setChartValues()
        }
        else {
            // segmented control on concentration
            if myLCal1 == "" || myLCal2 == "" || myLCal1 == "" {
                // calibration value missing
                LLabel.text = "Please insert calibration values on previous page"
                LLabel.textColor = UIColor.red
            }
            else {
                // calibration values provided
                LLabel.text = "Concentration (mM) vs. Time (ms)"
                LLabel.textColor = UIColor.black
                
                let Cal1 : Double = Double(myLCal1)!
                let Cal2 : Double = Double(myLCal2)!
                let Cal3 : Double = Double(myLCal3)!
                setConcValues(p1 : Cal1, p2: Cal2, p3: Cal3)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Larr = myArr
        timeL = myTime
        
        // initialise graph
        setChartValues()
        
        // makes bubbles appear when you click on data
        let marker:BalloonMarker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                                 font: .systemFont(ofSize: 12),
                                                 textColor: .white,
                                                 insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = lactateLineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        lactateLineChartView.marker = marker
        
        // modify the LineChartView
        self.lactateLineChartView.dragYEnabled = false
        self.lactateLineChartView.rightAxis.enabled = false
        self.lactateLineChartView.backgroundColor = .white
        self.lactateLineChartView.legend.enabled = false
    }
    
    func setChartValues() {

        // sets x and y values for Lactate
        let entriesL = (0..<Larr.count).map { (i) -> ChartDataEntry in
            let Lval = Larr[i]
            let timeValL = timeL[i]
            return ChartDataEntry(x: timeValL, y: Lval)
        }
        let setL = LineChartDataSet(values: entriesL, label: "[Lactate]")
        
        // set line features
        let dataSets = [setL]
        let data = LineChartData(dataSets: dataSets)
        self.lactateLineChartView.data = data
        
        // modify line plots
        setL.drawCirclesEnabled = false
        setL.drawValuesEnabled = false
        setL.lineWidth = 2
        setL.setColor(.blue)
    }
    
    func setConcValues(p1 : Double, p2 : Double, p3 : Double) {
        
        // find line of best fit: y = mx + c
        
        // sets x and y values for Lactate
        let entriesL = (0..<Larr.count).map { (i) -> ChartDataEntry in
            let Lval = Larr[i]
            let timeValL = timeL[i]
            return ChartDataEntry(x: timeValL, y: Lval)
        }
        let setL = LineChartDataSet(values: entriesL, label: "[Lactate]")
        
        // set line features
        let dataSets = [setL]
        let data = LineChartData(dataSets: dataSets)
        self.lactateLineChartView.data = data
        
        // modify line plots
        setL.drawCirclesEnabled = false
        setL.drawValuesEnabled = false
        setL.lineWidth = 2
        setL.setColor(.blue)
    }
 */
    
}
