//
//  SecondViewController.swift
//  TBI_Tracker
//
//  Created by Aishwarya Pattar on 31/01/2019.
//  Copyright © 2019 Aishwarya Pattar. All rights reserved.
//

import UIKit
import Charts

class GlucoseViewController: UIViewController {
    
    var myArr: [Double] = []
    var myTime: [Double] = []
    var myGCal1: String = ""
    var myGCal2: String = ""
    var myGCal3: String = ""
    var Garr: [Double] = []
    var timeG: [Double] = []

    // IBOutlets
    @IBOutlet weak var glucoseLineChartView: LineChartView!
    @IBOutlet weak var GLabel: UILabel!
    
    // IBActions
    @IBAction func Gtoggle(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            // segmented control on voltage
            GLabel.text = "Voltage (mV) vs. Time (ms)"
            GLabel.textColor = UIColor.black
            setChartValues()
        }
        else {
            // segmented control on concentration
            if myGCal1 == "" || myGCal2 == "" || myGCal1 == "" {
                // calibration value missing
                GLabel.text = "Please insert calibration values on previous page"
                GLabel.textColor = UIColor.red
            }
            else {
                // calibration values provided
                GLabel.text = "Concentration (mM) vs. Time (ms)"
                GLabel.textColor = UIColor.black
                
                let Cal1 : Double = Double(myGCal1)!
                let Cal2 : Double = Double(myGCal2)!
                let Cal3 : Double = Double(myGCal3)!
                setConcValues(p1 : Cal1, p2: Cal2, p3: Cal3)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Garr = myArr
        timeG = myTime
        
        // initialise graph
        setChartValues()
        
        // makes bubbles appear when you click on data
        let marker:BalloonMarker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                                 font: .systemFont(ofSize: 12),
                                                 textColor: .white,
                                                 insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = glucoseLineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        glucoseLineChartView.marker = marker
        
        // modify the LineChartView
        self.glucoseLineChartView.dragYEnabled = false
        self.glucoseLineChartView.rightAxis.enabled = false
        self.glucoseLineChartView.backgroundColor = .white
        self.glucoseLineChartView.legend.enabled = false
    }
    
    func setChartValues() {

        // sets x and y values for Glucose
        let entriesG = (0..<Garr.count).map { (i) -> ChartDataEntry in
            let Gval = Garr[i]
            let timeValG = timeG[i]
            return ChartDataEntry(x: timeValG, y: Gval)
        }
        let setG = LineChartDataSet(values: entriesG, label: "[Glucose]")

        // set line features
        let dataSets = [setG]
        let data = LineChartData(dataSets: dataSets)
        self.glucoseLineChartView.data = data
        
        // modify line plots
        setG.drawCirclesEnabled = false
        setG.drawValuesEnabled = false
        setG.lineWidth = 2
        setG.setColor(.green)
    }
    
    func setConcValues(p1 : Double, p2 : Double, p3 : Double) {
        
        // find calibration equation: y = mx + c
        
        
        // sets x and y values for Glucose
        let entriesG = (0..<Garr.count).map { (i) -> ChartDataEntry in
            let Gval = Garr[i]
            let timeValG = timeG[i]
            return ChartDataEntry(x: timeValG, y: Gval)
        }
        let setG = LineChartDataSet(values: entriesG, label: "[Glucose]")
        
        // set line features
        let dataSets = [setG]
        let data = LineChartData(dataSets: dataSets)
        self.glucoseLineChartView.data = data
        
        // modify line plots
        setG.drawCirclesEnabled = false
        setG.drawValuesEnabled = false
        setG.lineWidth = 2
        setG.setColor(.green)
    }

}

