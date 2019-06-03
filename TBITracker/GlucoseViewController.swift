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
    var myTime: [Date] = []
    var myGCal1: String = ""
    var myGCal2: String = ""
    var myGCal3: String = ""
    var Garr: [Double] = []
    var timeG: [Date] = []

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
                setConcValues(v1 : Cal1, v2: Cal2, v3: Cal3)
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
        self.glucoseLineChartView.xAxis.labelPosition = .bottom
        let xValuesNumberFormatter = DateValueFormatter()
        self.glucoseLineChartView.xAxis.valueFormatter = xValuesNumberFormatter
    }
    
    func setChartValues() {

        // sets x and y values for Glucose
        let entriesG = (0..<Garr.count).map { (i) -> ChartDataEntry in
            let Gval = Garr[i]
            let timeValG = timeG[i].timeIntervalSince1970
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
    
    func setConcValues(v1 : Double, v2 : Double, v3 : Double) {
        
        // find line of best fit to find conversion from voltage -> conc in form conc = m*voltage + c
        let voltage = [v1, v2, v3] // mV
        let conc = [0.0, 1.0, 2.0] // mM
        let mean_voltage: Double = (v1 + v2 + v3)/3
        let mean_conc: Double = 1 //(0 + 1 + 2)/3
        var num: Double = 0
        var den: Double = 0
        
        // using least squares method
        for i in 0...2 {
            num = num + (voltage[i] - mean_voltage)*(conc[i] - mean_conc)
            den = den + pow((voltage[i] - mean_voltage), 2)
        }
        
        let m = num/den
        let c = mean_conc - m*mean_voltage
        
        
        // sets x and y values for Glucose
        let entriesG = (0..<Garr.count).map { (i) -> ChartDataEntry in
            let GConcval = m*Garr[i] + c
            let timeValG = timeG[i].timeIntervalSince1970
            return ChartDataEntry(x: timeValG, y: GConcval)
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

