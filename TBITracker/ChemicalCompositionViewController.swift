//
//  ChemicalCompositionViewController.swift
//  TBI_Tracker
//
//  Created by Aishwarya Pattar on 03/02/2019.
//  Copyright © 2019 Aishwarya Pattar. All rights reserved.
//

import UIKit
import Charts
import CoreBluetooth

class ChemicalCompositionViewController: UIViewController {
    
    // initialise arrays
    var timeK : [Date] = []
    var Karr : [Double] = []
    var timeG : [Date] = []
    var Garr : [Double] = []
    var timeL : [Date] = []
    var Larr : [Double] = []
    
    // Initialise variables
    var centralManager: CBCentralManager!
    var bluefruitPeripheral: CBPeripheral!
    var txCharacteristic : CBCharacteristic?
    var rxCharacteristic : CBCharacteristic?
    var rxString = String()
    var globalBootTime = Date()
    
    // IBOutlets
    @IBOutlet weak var chemCompLineChartView: LineChartView!
    @IBOutlet weak var KCal1: UITextField!
    @IBOutlet weak var GCal1: UITextField!
    @IBOutlet weak var GCal2: UITextField!
    @IBOutlet weak var GCal3: UITextField!
    @IBOutlet weak var LCal1: UITextField!
    @IBOutlet weak var LCal2: UITextField!
    @IBOutlet weak var LCal3: UITextField!
    
    // IBActions
    @IBAction func refreshButton(_ sender: Any) {
        setChartValues()
    }
    @IBAction func kButton(_ sender: Any) {
        performSegue(withIdentifier: "potassium", sender: self)
    }
    @IBAction func gButton(_ sender: Any) {
        performSegue(withIdentifier: "glucose", sender: self)
    }
    @IBAction func lButton(_ sender: Any) {
        performSegue(withIdentifier: "lactate", sender: self)
    }
    
    
    override func viewDidLoad() {
        // Initialise the CentralManager for BLE
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        super.viewDidLoad()
        
        // initialise graph
        setChartValues()
        
        // makes bubbles appear when you click on data
        let marker:BalloonMarker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                                 font: .systemFont(ofSize: 12),
                                                 textColor: .white,
                                                 insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chemCompLineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chemCompLineChartView.marker = marker
        
        // modify the LineChartView
        self.chemCompLineChartView.dragYEnabled = false
        self.chemCompLineChartView.rightAxis.enabled = false
        self.chemCompLineChartView.backgroundColor = .white
        self.chemCompLineChartView.legend.enabled = false
        self.chemCompLineChartView.xAxis.labelPosition = .bottom
        let xValuesNumberFormatter = DateValueFormatter()
        self.chemCompLineChartView.xAxis.valueFormatter = xValuesNumberFormatter
        
    }
    
    
    // send data to other view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "potassium" {
            let KController = segue.destination as! PotassiumViewController
            KController.myArr = Karr
            KController.myTime = timeK
            KController.myKCal1 = KCal1.text ?? ""
        }
        else if segue.identifier == "glucose" {
            let GController = segue.destination as! GlucoseViewController
            GController.myArr = Garr
            GController.myTime = timeG
            GController.myGCal1 = GCal1.text ?? ""
            GController.myGCal2 = GCal2.text ?? ""
            GController.myGCal3 = GCal3.text ?? ""
            
        }
        else if segue.identifier == "lactate" {
            let LController = segue.destination as! LactateViewController
            LController.myArr = Larr
            LController.myTime = timeL
            LController.myLCal1 = LCal1.text ?? ""
            LController.myLCal2 = LCal2.text ?? ""
            LController.myLCal3 = LCal3.text ?? "" 
        }
    }
    

    func setChartValues() {
        
        // sets x and y values for K+
        let entriesK = (0..<Karr.count).map { (i) -> ChartDataEntry in
            let Kval = Karr[i]
            let timeValK = timeK[i].timeIntervalSince1970
            return ChartDataEntry(x: timeValK, y: Kval)
        }
        let setK = LineChartDataSet(values: entriesK, label: "[K+]")
        
        // sets x and y values for Glucose
        let entriesG = (0..<Garr.count).map { (i) -> ChartDataEntry in
            let Gval = Garr[i]
            let timeValG = timeG[i].timeIntervalSince1970
            return ChartDataEntry(x: timeValG, y: Gval)
        }
        let setG = LineChartDataSet(values: entriesG, label: "[Glucose]")
        
        // sets x and y values for Lactate
        let entriesL = (0..<Larr.count).map { (i) -> ChartDataEntry in
            let Lval = Larr[i]
            let timeValL = timeL[i].timeIntervalSince1970
            return ChartDataEntry(x: timeValL, y: Lval)
        }
        let setL = LineChartDataSet(values: entriesL, label: "[Lactate]")
        
        // set line features
        let dataSets = [setK, setG, setL]
        let data = LineChartData(dataSets: dataSets)
        self.chemCompLineChartView.data = data
        
        // modify line plots
        setK.drawCirclesEnabled = false
        setK.drawValuesEnabled = false
        setK.lineWidth = 2
        //setK.setColor(UIColor.red)
        setK.setColor(.red)
        //setK.colors = [UIColor(red: 1, green: 0, blue: 0, alpha: 1)]
        
        setG.drawCirclesEnabled = false
        setG.drawValuesEnabled = false
        setG.lineWidth = 2
        setG.setColor(.green)
        
        setL.drawCirclesEnabled = false
        setL.drawValuesEnabled = false
        setL.lineWidth = 2
        setL.setColor(.blue)
    }
}



// Establish BLE Communication
extension ChemicalCompositionViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            //centralManager.scanForPeripherals(withServices: nil)
            centralManager?.scanForPeripherals(withServices: [BLEService_UUID] , options: nil)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        bluefruitPeripheral = peripheral
        bluefruitPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral)
    }
    
    // connects to BLE module
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        bluefruitPeripheral.discoverServices(nil)
    }
    
}


extension ChemicalCompositionViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
            //print(service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        //print("Found \(characteristics.count) characteristics!")
        
        for characteristic in characteristics {
            //looks for the right characteristic
            
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Rx)  {
                rxCharacteristic = characteristic
                
                //Once found, subscribe to the this particular characteristic...
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                // We can return after calling CBPeripheral.setNotifyValue because CBPeripheralDelegate's
                // didUpdateNotificationStateForCharacteristic method will be called automatically
                peripheral.readValue(for: characteristic)
                //print("Rx Characteristic: \(characteristic.uuid)")
            }
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Tx){
                txCharacteristic = characteristic
                //print("Tx Characteristic: \(characteristic.uuid)")
            }
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic == rxCharacteristic {
            if let ASCIIstring = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) {
                
                rxString = ASCIIstring as String
                    /*print(rxString)
                    print(rxString.count)
                    let char = rxString.last
                    print(char?.unicodeScalars)*/
                
                
                /*characteristicASCIIValue = ASCIIstring
                print("Value Recieved: \((characteristicASCIIValue as String))")*/
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: nil)
            }
        }
        
        // categorise NSString
        // check is last character is \r\n to ensure string is not fragmented. if fragmented the value is discarded
        
        if rxString.last == "\n" && rxString.count > 5 {

            // store the first letter
            let firstLetter = rxString.first
            
            // remove first and last character
            rxString.remove(at: rxString.startIndex)
            rxString.remove(at: rxString.index(before: rxString.endIndex))
            
            // extract time stamp and values
            let space = rxString.firstIndex(of: " ") ?? rxString.endIndex
            let time = rxString[..<space] // time in ms written as string
            let val = rxString.dropFirst(time.count + 1)
            
            // set global boot time in ms
            if timeK.isEmpty && timeG.isEmpty && timeL.isEmpty {
                let now = Date()
                globalBootTime = now - Double(time)!/1000 // subtract time in seconds
            }
            
            // find real time and convert to NSDate
            let realTime = globalBootTime + Double(time)!/1000 // add time in seconds
            
            // store in corresponding array depending on firstLetter
            if firstLetter == "K" {
                timeK.append(realTime) // time in seconds
                Karr.append(Double(val)!)
            } else if firstLetter == "G" {
                timeG.append(realTime) // time in seconds
                Garr.append(Double(val)!)
            } else if firstLetter == "L" {
                timeL.append(realTime) // time in seconds
                Larr.append(Double(val)!)
                setChartValues()
            }
            
            
            /*if firstLetter == "K" {
                timeK.append(Double(time)!/1000) // time in seconds
                Karr.append(Double(val)!)
            } else if firstLetter == "G" {
                timeG.append(Double(time)!/1000) // time in seconds
                Garr.append(Double(val)!)
            } else if firstLetter == "L" {
                timeL.append(Double(time)!/1000) // time in seconds
                Larr.append(Double(val)!)
                setChartValues()
            }*/
        }
    }
}
