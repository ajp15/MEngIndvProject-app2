//
//  FirstViewController.swift
//  TBI_Tracker
//
//  Created by Aishwarya Pattar on 31/01/2019.
//  Copyright © 2019 Aishwarya Pattar. All rights reserved.
//

import UIKit
import Charts

class PotassiumViewController: UIViewController {
    
    var myArr: [Double] = []
    var myTime: [Double] = []
    var myKCal1: String = ""
    var Karr: [Double] = []
    var timeK: [Double] = []
    
    // IBOutlets
    @IBOutlet weak var kLineChartView: LineChartView!
    @IBOutlet weak var KLabel: UILabel!
    
    //IBActions
    @IBAction func Ktoggle(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            // segmented control on voltage
            KLabel.text = "Voltage (mV) vs. Time (ms)"
            KLabel.textColor = UIColor.black
            setChartValues()
        }
        else {
            // segmented control on concentration
            if myKCal1 == "" {
                // no calibration values provided
                KLabel.text = "Please insert calibration values on previous page"
                KLabel.textColor = UIColor.red
            }
            else {
                // calibration values provided
                KLabel.text = "Concentration (mM) vs. Time (ms)"
                KLabel.textColor = UIColor.black
                // already in mV as voltage recordings received are in mV
                let KCal1 : Double = Double(myKCal1)!
                setConcValues(Kacsf: KCal1)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Karr = myArr
        timeK = myTime
        
        // initialise graph
        setChartValues()
        
        // makes bubbles appear when you click on data
        let marker:BalloonMarker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                                 font: .systemFont(ofSize: 12),
                                                 textColor: .white,
                                                 insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = kLineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        kLineChartView.marker = marker
        
        // modify the LineChartView
        self.kLineChartView.dragYEnabled = false
        self.kLineChartView.rightAxis.enabled = false
        self.kLineChartView.backgroundColor = .white
        self.kLineChartView.legend.enabled = false
    }
    
    func setChartValues() {
        
        // sets x and y values for K+
        let entriesK = (0..<Karr.count).map { (i) -> ChartDataEntry in
            let Kval = Karr[i]
            let timeValK = timeK[i]
            return ChartDataEntry(x: timeValK, y: Kval)
        }
        let setK = LineChartDataSet(values: entriesK, label: "[K+]")
        
        // set line features
        let dataSets = [setK]
        let data = LineChartData(dataSets: dataSets)
        self.kLineChartView.data = data
        
        // modify line plots
        setK.drawCirclesEnabled = false
        setK.drawValuesEnabled = false
        setK.lineWidth = 2
        setK.setColor(.red)
    }
    
    func setConcValues(Kacsf: Double) {
        
        // sets x and y values for K+ IN CONC
        let entriesK = (0..<Karr.count).map { (i) -> ChartDataEntry in
            let KConcval = pow(10, (Karr[i]/1000 - (Kacsf - 59*log10(2.7)))/59)
            let timeValK = timeK[i]
            return ChartDataEntry(x: timeValK, y: KConcval)
        }
        let setK = LineChartDataSet(values: entriesK, label: "[K+]")
        
        // set line features
        let dataSets = [setK]
        let data = LineChartData(dataSets: dataSets)
        self.kLineChartView.data = data
        
        // modify line plots
        setK.drawCirclesEnabled = false
        setK.drawValuesEnabled = false
        setK.lineWidth = 2
        setK.setColor(.red)
    }

}

