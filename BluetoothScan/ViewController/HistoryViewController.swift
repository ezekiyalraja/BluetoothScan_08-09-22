//
//  HistoryViewController.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 23/08/22.
//

import UIKit
import CoreBluetooth

class HistoryViewController: UIViewController,CBCentralManagerDelegate, registerdevice {
  
    
    func locationButtonClicked(Index: Int) {
        AllDeviceHistoryView.isHidden = false
        RegisteredDeviceHistory.isHidden = true
        HistorySegmentController.selectedSegmentIndex = 1
        if let mapVC = mapVC{
            mapVC.showData(Multiple_Pin: false, index: Index)
        }
    }
    
    @IBOutlet weak var AllDeviceHistoryView: UIView!
    @IBOutlet weak var RegisteredDeviceHistory: UIView!
    @IBOutlet weak var HistorySegmentController: UISegmentedControl!
    var peripherals = [PheripheralObj]()
    var centralManager: CBCentralManager?
    var mapVC : AllHistoryViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        RegisteredDeviceHistory.isHidden = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeDown)
        HistorySegmentController.selectedSegmentIndex = 0
        switch HistorySegmentController.selectedSegmentIndex
        {
        case 0:
            AllDeviceHistoryView.isHidden = true
            RegisteredDeviceHistory.isHidden = false
        case 1:
            AllDeviceHistoryView.isHidden = false
            RegisteredDeviceHistory.isHidden = true
            
        default:
            break;
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapVC"{
            if let vc = segue.destination as? AllHistoryViewController{
                self.mapVC = vc
            }
        }
        else
        {
            if let vc = segue.destination as? RegisteredHistoryViewController, segue.identifier == "RegisterDeviceVC"{
                vc.delegate = self
            }
        }
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl)
    {
        switch HistorySegmentController.selectedSegmentIndex
        {
        case 0:
            
            AllDeviceHistoryView.isHidden = true
            RegisteredDeviceHistory.isHidden = false
        case 1:
            if let mapVC = mapVC{
                mapVC.showData(Multiple_Pin: true, index: 0)
            }
            AllDeviceHistoryView.isHidden = false
            RegisteredDeviceHistory.isHidden = true
            
        default:
            break;
        }
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                HistorySegmentController.selectedSegmentIndex = 0
                AllDeviceHistoryView.isHidden = true
                RegisteredDeviceHistory.isHidden = false
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                if let mapVC = mapVC{
                    mapVC.showData(Multiple_Pin: true, index: 0)
                }
                HistorySegmentController.selectedSegmentIndex = 1
                AllDeviceHistoryView.isHidden = false
                RegisteredDeviceHistory.isHidden = true
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString})
        {
            
            
            if peripheral.name != nil && peripheral.name != ""
            {
                var obj = PheripheralObj()
                
                if (peripheral.name ?? "").contains("iTAG")
                {
                    if !peripherals.contains(where: {$0.name == "iTAG1"}){
                        obj.name = "iTAG1"
                    }else{
                        obj.name = "iTAG2"
                    }
                }else{
                    obj.name = peripheral.name ?? ""
                }
                
                obj.identifier = peripheral.identifier.uuidString
                obj.checkTag = 0
                obj.distance = Double(pow(10, ((-69-Double(truncating: RSSI))/(10*2))))
                peripherals.append(obj)
                print("====",obj)
            }
        }
        else
        {
            if let index = peripherals.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                peripherals[index].distance = Double(pow(10, ((-69-Double(truncating: RSSI))/(10*2))))
                
            }
            if let index = SelectedPeripherals.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                SelectedPeripherals[index].distance = Double(pow(10, ((-69-Double(truncating: RSSI))/(10*2))))
                
            }
        }
        centralManager = CBCentralManager(delegate: self, queue:DispatchQueue.main)
        //        print("Array",)
        //        AllTableView.reloadData()
        
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      Get the new view controller using segue.destination.
      Pass the selected object to the new view controller.
     }
     */
    
}
