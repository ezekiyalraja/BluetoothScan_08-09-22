//
//  ViewController.swift
//  BluetoothSampleApp
//
//  Created by TechUnity IOS Developer on 27/06/22.
//

import UIKit
import Pulsator
import CoreBluetooth
import AVFoundation
import SQLite3
import CoreLocation
import CoreData
var peripheralObject = [PheripheralObj]()
var ScanTag = 0
var DBcall:DBHelper = DBHelper()
var Started = 0
var UpdateTimer = Timer()
class ViewController: UIViewController,CBCentralManagerDelegate,UITableViewDelegate,UITableViewDataSource{
   
    weak var reloadDelegate: DeviceReloadTable?
    var ShowTag = false
    var PlayBeep = false
    var player: AVAudioPlayer?
    var player1 : AVAudioPlayer?
    
    var equalval = 0.0
    var startIndex = 0.0
    var endindex = 0.0
    var counttimer = Timer()
    var positionTag = 0
    var increaseCount = 0.0
    var devName = ""
    var tag = 0
    var Mode = 0
    var show = false
    var centralManager: CBCentralManager?
    var peripherals = [CBPeripheral]()
    
    var Scanperipherals = [PheripheralObj]()
    let geoCoder = CLGeocoder()
    
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MenuWidth: NSLayoutConstraint!
    @IBOutlet weak var MenuHeight: NSLayoutConstraint!
    @IBOutlet weak var ChangeModeOutlet: UIBarButtonItem!
    @IBOutlet weak var locationlabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var DeviceView: UIView!
    @IBOutlet weak var DistanceLable: UILabel!
    @IBOutlet weak var IDLable: UILabel!
    @IBOutlet weak var TagnameLable: UILabel!
    @IBOutlet var SelectedDetailView: UIView!
    @IBOutlet weak var DeviceListTableView: UITableView!
    var timer = Timer()
    var dateTimer = Timer()
    var Soundtimer = Timer()
    @IBOutlet var DeviceListView: UIView!
    @IBOutlet weak var ScanButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet var meter: [UILabel]!
    @IBOutlet weak var Centerview: UIView!
    @IBOutlet weak var centerview4: UIView!
    @IBOutlet weak var centerview1: UIView!
    @IBOutlet weak var centerview2: UIView!
    @IBOutlet weak var centerview3: UIView!
    @IBOutlet weak var centerview5: UIView!
    @IBOutlet weak var TagProfileImageView: UIImageView!
    @IBOutlet weak var coordinateLabel: UILabel!
    let locationManager = CLLocationManager()
    @IBOutlet weak var topStack: UIStackView!
    var location = CLLocation()
    var currentLocation:CLLocation!
    var Lat = CLLocationDegrees()
    var Long = CLLocationDegrees()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheralObject.removeAll()
        peripherals.removeAll()
        
        
        
        for v in view.subviews{
            let views = [Centerview,centerview1,centerview2,centerview3,centerview4,centerview5,DeviceListView,DeviceView,locationView,meter[0] as UILabel, meter[1] as UILabel, meter[2] as UILabel, meter[3] as UILabel]
            //            let Buttons = [ScanButton,centerButton]
            let TopArray = [dateLabel, timeLabel, coordinateLabel] as [UIView]
            if views.contains(v) || v == ScanButton || v == centerButton || v is UIStackView || v == meter[1] || TopArray.contains(v)
            {
                print("Not removed",v)
            }
            else
            {
                v.removeFromSuperview()
            }
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)
        {
            currentLocation = locationManager.location
            
            Lat = currentLocation.coordinate.latitude
            Long = currentLocation.coordinate.longitude
            print("lat",Lat,"long",Long)
        }
        
        location = CLLocation(latitude: Lat, longitude:  Long)
        coordinateLabel.text = "\(Lat.roundedDecimal(to: 7)), \(Long.roundedDecimal(to: 7))"
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            
            placemarks?.forEach { (placemark) in
                
                if let city = placemark.subLocality {
                    print("city",city)
                    self.locationlabel.text = placemark.subLocality
                }
            }
        })
        usernameLabel.text = "Manoj"
        dateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.liveDate) , userInfo: nil, repeats: true)
        UpdateTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector:#selector(self.UpdateHistory) , userInfo: nil, repeats: true)
        DeviceListView.isHidden = true
        DeviceView.isHidden = true
        self.MenuWidth.constant = 0
        
        self.MenuHeight.constant = 0
        TagProfileImageView.layer.cornerRadius = 7
        
        
        
        RoundViewAnimate(ContentView: centerview1)
        RoundViewAnimate(ContentView: centerview2)
        RoundViewAnimate(ContentView: centerview3)
        RoundViewAnimate(ContentView: centerview4)
        RoundViewAnimate(ContentView: centerview5)
        centerButton.layer.cornerRadius = (centerButton.frame.size.width) / 2
        centerButton.clipsToBounds = true
        
        
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        SelectedPeripherals = DBcall.readHistoryTable()
        
        //        checkArray = DBcall.readHistoryTable()
        if SelectedPeripherals.count > 0 && ScanTag == 0
        {
            ShowTag = true
            ScanTag = 1
        }
        else if ScanTag == 1
        {
            ShowTag = false
        }
        
        
        
        /* For Remove view
         //        peripheralObject.removeAll()
         //        peripherals.removeAll()
         
         
         
         //        for v in view.subviews{
         //            let views = [Centerview,centerview1,centerview2,centerview3,centerview4,centerview5,DeviceListView,DeviceView,meter[0] as UILabel, meter[1] as UILabel, meter[2] as UILabel, meter[3] as UILabel]
         //            //            let Buttons = [ScanButton,centerButton]
         //
         //            if views.contains(v) || v == ScanButton || v == centerButton || v is UIStackView || v == meter[1]
         //            {
         //                print("Not removed",v)
         //            }
         //            else
         //            {
         //                v.removeFromSuperview()
         //            }
         //        }
         */
        
        for _ in 0...1-1{
            let pulsator = Pulsator()
            Centerview.layer.addSublayer(pulsator)
            pulsator.backgroundColor = UIColor.systemTeal.cgColor
            pulsator.start()
            pulsator.numPulse = 4
            pulsator.radius = 300
        }
        
        centralManager = CBCentralManager(delegate: self, queue:DispatchQueue.main)
        timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        timer.invalidate()
        centralManager?.stopScan()
        player?.stop()
    }
    
    @objc func liveDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        dateLabel.text = formatter.string(from: Date())
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm:ss a"
        timeLabel.text = formatter2.string(from: Date())
        if Started == 1
        {
            UpdateTimer.invalidate()
            UpdateTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector:#selector(ViewController.UpdateHistory) , userInfo: nil, repeats: true)
            Started = 0
        }
    }
    @objc func UpdateHistory() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        let RegisterDate = formatter.string(from: Date())
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm:ss a"
        let RegisterTime = formatter2.string(from: Date())
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)
        {
            currentLocation = locationManager.location
            
            Lat = currentLocation.coordinate.latitude
            Long = currentLocation.coordinate.longitude
            print("lat",Lat,"long",Long)
        }
        location = CLLocation(latitude: Lat, longitude:  Long)
        coordinateLabel.text = "\(Lat.roundedDecimal(to: 7)), \(Long.roundedDecimal(to: 7))"
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            
            placemarks?.forEach { (placemark) in
                
                if let city = placemark.subLocality {
//                    print("city",city)
                    self.locationlabel.text = placemark.subLocality
                }
            }
        })
       
        for obj in peripheralObject
        {
            
            
            if SelectedPeripherals.contains(where: {$0.identifier == obj.identifier}){
                //                    if SelectedObj.identifier == obj.identifier
                //                    {
                DBcall.UpdateCoordinate(Lat: "\(Lat)", Long: "\(Long)", DateTime: "\(RegisterDate) \(RegisterTime)", Identifier: obj.identifier)
                DBcall.insertIntoDeviceUpdateTable(ID: obj.identifier, Coordinates: "\(Lat), \(Long)", DateTime: "\(RegisterDate) \(RegisterTime)")
                print("Saved ")
                //                    }
                //                    else
                //                    {
                for SelectedObj in peripheralObject
                {
                    if obj.identifier != SelectedObj.identifier{
                    DBcall.insertIntoReferenceTable(name: SelectedObj.name, Identifier: SelectedObj.identifier, Coordinates: "\(Lat.roundedDecimal(to: 7)), \(Long.roundedDecimal(to: 7))", DateTime: "\(RegisterDate) \(RegisterTime)", Distance: SelectedObj.distance, ReferenceIdentifier: obj.identifier)
                    }
                    //                    }
                }
            }
            
            
        }
        reloadDelegate?.didUpdate()
        
        
    }
    
    
    
    
    @objc func update() {
        
        centralManager = CBCentralManager(delegate: self, queue:DispatchQueue.main)
        
    }
    
    
    @IBAction func AddBleDevicesAction(_ sender: Any) {
        
        //        DeviceListView.frame = self.view.bounds
        //        self.view.addSubview(DeviceListView)
        DeviceListView.isHidden = false
        self.view.bringSubviewToFront(DeviceView)
        self.view.bringSubviewToFront(DeviceListView)
    }
    @IBAction func DoneAction(_ sender: Any) {
        DeviceListView.isHidden = true
    }
    
    @IBAction func BleDevicesAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"DeviceListViewController") as! DeviceListViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //        SelectedPeripherals
        DeviceListView.isHidden = true
    }
    @IBAction func Change_modeAction(_ sender: Any) {
        if Mode == 0
        {
            ChangeModeOutlet.image = UIImage(named: "List_view")
            Mode = 1
            DeviceView.isHidden = false
            self.title = "List"
            self.view.bringSubviewToFront(DeviceView)
            self.view.bringSubviewToFront(DeviceListView)
        }
        else
        {
            ChangeModeOutlet.image = UIImage(named: "Radar_view")
            Mode = 0
            DeviceView.isHidden = true
            self.title = "Radar"
            //            self.view.bringSubviewToFront(DeviceView)
        }
        
    }
    @IBAction func LogoutBarAction(_ sender: Any) {
        let alert  = UIAlertController(title: "Alert", message: "Are you sure you want to Logout?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func SettingsAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //        DeviceListView.removeFromSuperview()
        DeviceListView.isHidden = true
    }
    
    @IBAction func removeDetailViewAction(_ sender: Any) {
        SelectedDetailView.removeFromSuperview()
    }
    @IBAction func locationAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AllHistoryViewController") as! AllHistoryViewController
        vc.initialLocation = location
        vc.fromDashboard = true
        self.navigationController?.pushViewController(vc, animated: true)
        DeviceListView.isHidden = true
    }
    
    @IBAction func HistoryAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"HistoryViewController") as! HistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
        DeviceListView.isHidden = true
    }
    
    @IBAction func MenuAction(_ sender: Any) {
        DeviceListView.isHidden = false
        //        DeviceListView.frame = self.view.bounds
        //        self.view.addSubview(DeviceListView)
        MenuView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.MenuWidth.constant = 170
            
            self.MenuHeight.constant = 130
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func RemoveMenuView(_ sender: Any) {
        //        DeviceListView.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.MenuWidth.constant = 0
            
            self.MenuHeight.constant = 0
            self.view.layoutIfNeeded()
        }){ (finished) in
            self.MenuView.isHidden = true
        }
        DeviceListView.isHidden = true
        
    }
    
    @IBAction func Scan(_ sender: Any) {
        centralManager?.stopScan()
        peripherals.removeAll()
        peripheralObject.removeAll()
        timer.invalidate()
        
        for v in view.subviews{
            let views = [Centerview,centerview1,centerview2,centerview3,centerview4,centerview5]
            //            let Buttons = [ScanButton,centerButton]
            if views.contains(v) || v == ScanButton || v == centerButton || v is UIStackView
            {
                print("Not removed",v)
            }
            else
            {
                
                v.removeFromSuperview()
                
            }
        }
        centralManager = CBCentralManager(delegate: self, queue:DispatchQueue.main)
        self.timer = Timer.scheduledTimer(timeInterval:3.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    func save(name: String,Identifier:String) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Device",in: managedContext)!
        
        let person = NSManagedObject(entity: entity,insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        person.setValue(Identifier, forKeyPath: "identifier")
        // 4
        do {
            try managedContext.save()
//            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func RoundViewAnimate(ContentView: UIView)
    {
        
        ContentView.layer.cornerRadius = (ContentView.frame.size.width) / 2
        ContentView.clipsToBounds = true
        ContentView.layer.borderColor = UIColor.black.cgColor
        ContentView.backgroundColor = .white
        ContentView.layer.borderWidth = 1
    }
    func playSound(){
        if TurnSound == true
        {
            guard let path = Bundle.main.path(forResource: "BEEPMed_67 hz electrocardiogram (ID 0456)_BSB", ofType:"mp3") else {
                return }
            let url = URL(fileURLWithPath: path)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1
                player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func playSingleBeepSound(){
        if TurnSound == true
        {
            PlayBeep = true
            guard let path = Bundle.main.path(forResource: "beep-07a", ofType:"wav") else {
                return }
            let url = URL(fileURLWithPath: path)
            
            do {
                player1 = try AVAudioPlayer(contentsOf: url)
                player1?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    @objc func buttonAction(sender:UIButton) {
        print("Button tapped ",sender.titleLabel!)
        if sender.tag == 1
        {
            
            for obj in SelectedPeripherals
            {
                if obj.identifier == sender.titleLabel?.text
                {
                    
                    TagProfileImageView.image = obj.TagImage
                    TagnameLable.text = obj.name
                    IDLable.text = obj.identifier
                    if let index = peripheralObject.firstIndex(where: {$0.identifier == sender.titleLabel?.text}){
                        DistanceLable.text = "\(peripheralObject[index].distance.roundedDecimal(to: 2))m"
                    }
                }
            }
            UIApplication.shared.keyWindow?.addSubview(SelectedDetailView)
            
            SelectedDetailView.frame = UIScreen.main.bounds
        }
        
    }
    
    @IBAction func RemoveDetailView(_ sender: Any) {
        SelectedDetailView.removeFromSuperview()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if ScanTag == 1
        {
            
            
            
            if !peripherals.contains(where: { $0.identifier.uuidString == peripheral.identifier.uuidString }){
                
                if peripheral.name == nil || peripheral.name == ""
                {
                }
                else
                {
                    
                    
                    var obj = PheripheralObj()
                    positionTag += 1
                    if positionTag == 9{
                        positionTag = 1
                    }
                    
                    if let index = SelectedPeripherals.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                        obj.name = SelectedPeripherals[index].name
                        print("advertisement Data==>\(obj.name)",advertisementData)
                        print("pheripheral==>\(obj.name)",peripheral)
                    }
                    else{
                        obj.name = peripheral.name ?? ""
                    }
                    
                    obj.identifier = peripheral.identifier.description
                    obj.distance = Double(pow(10, ((-69-Double(truncating: RSSI))/(10*2))))
                    obj.rssi = Int(truncating: RSSI)
                    obj.positionTag = positionTag
                    obj.checkTag = 0
                    save(name: obj.name, Identifier: obj.identifier)
                    
                    self.peripherals.append(peripheral)
                    DeviceListTableView.reloadData()
                    var randomX = 0.0
                    var randomY = 0.0
                    
                    var height = CGFloat()
                    var width = CGFloat()
                    var viewcolor = UIColor()
                    //                    if ScanTag == 1
                    //                    {
                    if SelectedPeripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString})
                    {
                        height = 60
                        width = 60
                        //                        viewcolor = UIColor.white
                        if obj.distance > 12.0
                        {
                            viewcolor = UIColor.red
                            
                        }
                        else if obj.distance < 3.0
                        {
                            
                            viewcolor = UIColor.green
                            
                        }
                        else
                        {
                            viewcolor = UIColor.yellow
                            
                        }
                        
                    }
                    else
                    {
                        height = 10
                        width = 10
                        viewcolor = UIColor.systemTeal
                    }
                    if obj.positionTag == 1{
                        randomX = Double(self.centerButton.frame.origin.x) - height/2 + 5
                        randomY = Double(self.centerButton.frame.origin.y-(height/2)) - (obj.distance*6) + 5
                    }else if obj.positionTag == 2{
                        randomX = Double(self.centerButton.frame.origin.x-(height/2)) + (obj.distance*6) + 5
                        randomY = Double(self.centerButton.frame.origin.y-(height/2)) - (obj.distance*6) + 5
                    }else if obj.positionTag == 3{
                        randomX = Double(self.centerButton.frame.origin.x-(height/2)) + (obj.distance*6) + 5
                        randomY = Double(self.centerButton.frame.origin.y) - (height/2) + 5
                    }else if obj.positionTag == 4{
                        randomX = Double(self.centerButton.frame.origin.x-(height/2)) + (obj.distance*6) + 5
                        randomY = Double(self.centerButton.frame.origin.y-(height/2)) + (obj.distance*6) + 5
                    }else if obj.positionTag == 5{
                        randomX = Double(self.centerButton.frame.origin.x) - (height/2) + 5
                        randomY = Double(self.centerButton.frame.origin.y) + (obj.distance*6) + 5
                    }else if obj.positionTag == 6{
                        randomX = Double(self.centerButton.frame.origin.x-(height/2)) - (obj.distance*6) + 5
                        randomY = Double(self.centerButton.frame.origin.y) + (obj.distance*6) + 5
                    }else if obj.positionTag == 7{
                        randomX = Double(self.centerButton.frame.origin.x-(height/2)) - (obj.distance*6) + 5
                        randomY = Double(self.centerButton.frame.origin.y-(height/2)) - 30 + 5
                    }else{
                        randomX = Double(self.centerButton.frame.origin.x-(height/2)) - (obj.distance*6) + 5
                        randomY = Double(self.centerButton.frame.origin.y-(height/2)) - (obj.distance*6) + 5
                    }
                    
                    let InfoButton = UIButton()
                    
                    var frame = CGRect()
                    frame.size.width = width
                    frame.size.height = height
                    frame.origin.x = CGFloat(randomX)
                    frame.origin.y = CGFloat(randomY)
                    InfoButton.frame = frame
                    let BviewLable = UILabel(frame: (CGRect(x: InfoButton.frame.origin.x, y: InfoButton.frame.origin.y, width: width, height: height)))
                    var TagImageView = UIImageView()
                    var distanceLabel = UILabel()
                    if height == 60
                    {
                        TagImageView = UIImageView(frame: (CGRect(x: InfoButton.frame.origin.x + 5, y: InfoButton.frame.origin.y + 5, width: 50, height: 50)))
                        distanceLabel = UILabel(frame: (CGRect(x: InfoButton.frame.origin.x + 10, y: InfoButton.frame.origin.y + 10, width: 40, height: 15)))
                    }
                    else
                    {
                        TagImageView = UIImageView(frame: (CGRect(x: InfoButton.frame.origin.x, y: InfoButton.frame.origin.y, width: 0, height: 0)))
                        distanceLabel = UILabel(frame: (CGRect(x: InfoButton.frame.origin.x, y: InfoButton.frame.origin.y + 65, width: 0, height: 0)))
                    }
                    BviewLable.backgroundColor = viewcolor
                    
                    if SelectedPeripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString})
                    {
                        InfoButton.tag = 1
                    }
                    else
                    {
                        InfoButton.tag = 0
                    }
                    BviewLable.frame = InfoButton.frame
                    //                InfoButton.tag = tag+1
                    //-----------------------------------------
                    InfoButton.setTitle(peripheral.identifier.uuidString, for: .normal)
                    InfoButton.setTitleColor(.clear, for: .normal)
                    BviewLable.numberOfLines = 4
                    InfoButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                    let distance = obj.distance
                    
                    BviewLable.textAlignment = .center
                    
                    BviewLable.font = UIFont.systemFont(ofSize: 8, weight: .bold)
                    BviewLable.textColor = UIColor.black
                    BviewLable.layer.borderColor = UIColor.black.cgColor
                    BviewLable.layer.borderWidth = 1
                    
                    BviewLable.layer.cornerRadius = (BviewLable.frame.size.width) / 2
                    BviewLable.clipsToBounds = true
                    distanceLabel.textAlignment = .center
                    
                    distanceLabel.font = UIFont.systemFont(ofSize: 8, weight: .bold)
                    distanceLabel.textColor = UIColor.black
                    distanceLabel.layer.borderColor = UIColor.black.cgColor
                    distanceLabel.layer.borderWidth = 1
                    distanceLabel.layer.cornerRadius = 5
                    distanceLabel.clipsToBounds = true
                    distanceLabel.backgroundColor = .white
                    TagImageView.layer.cornerRadius = (TagImageView.frame.size.width) / 2
                    TagImageView.clipsToBounds = true
                    TagImageView.layer.masksToBounds = true
                    
                    if let index = SelectedPeripherals.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                        let compareImage = UIImage(named: "BLE_50")
                        if compareImage == SelectedPeripherals[index].TagImage{
                            TagImageView.backgroundColor = .clear
                        }else{
                            TagImageView.image = SelectedPeripherals[index].TagImage
                            TagImageView.backgroundColor = .black
                        }
                        self.view.layoutIfNeeded()
                        
                        distanceLabel.text = "\(distance.roundedDecimal(to: 2))" + "m"
                    }
                    
                    self.view.addSubview(InfoButton)
                    self.view.addSubview(BviewLable)
                    self.view.addSubview(TagImageView)
                    self.view.addSubview(distanceLabel)
                    if ShowTag == true
                    {
                        if !SelectedPeripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString})
                        {
                            
                            InfoButton.isHidden = true
                            BviewLable.isHidden = true
                            TagImageView.isHidden = true
                            
                        }
                    }
                    if hideBLE == true
                    {
                        if !SelectedPeripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString})
                        {
                            //
                            InfoButton.isHidden = true
                            BviewLable.isHidden = true
                            TagImageView.isHidden = true
                        }
                    }
                    else
                    {
                        InfoButton.isHidden = false
                        BviewLable.isHidden = false
                        TagImageView.isHidden = false
                        
                    }
                    
                    if let lostIndex = SelectedPeripherals.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                        if SelectedPeripherals[lostIndex].LostAssetTag == 1{
                            InfoButton.isHidden = true
                            BviewLable.isHidden = true
                            TagImageView.isHidden = true
                            distanceLabel.isHidden = true
                        }else{
                            InfoButton.isHidden = false
                            BviewLable.isHidden = false
                            TagImageView.isHidden = false
                            distanceLabel.isHidden = false
                        }
                    }
                    
                    
                    obj.BviewLable = BviewLable
                    obj.InfoButton = InfoButton
                    obj.TagImageView = TagImageView
                    obj.DistanceLable = distanceLabel
                    peripheralObject.append(obj)
                    
                }
                
            }else{
                if peripheralObject.count > 0{
                    if let index = peripheralObject.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                        
                        let currentDistance = peripheralObject[index].distance
                        let distance = Double(pow(10, ((-69-Double(truncating: RSSI))/(10*2))))
                        let rssi = Int(truncating: RSSI)
                        let name = peripheralObject[index ].name
                        peripheralObject[index ].distance = distance
                        peripheralObject[index ].rssi = rssi
                        let obj = peripheralObject[index ]
                        var randomX = 0.0
                        var randomY = 0.0
                        if obj.positionTag == 1{
                            randomX = Double(self.centerButton.frame.origin.x-peripheralObject[index ].BviewLable.frame.size.width/2) + 5
                            randomY = Double(self.centerButton.frame.origin.y-peripheralObject[index ].BviewLable.frame.size.width/2) - (obj.distance*6) + 5
                        }else if obj.positionTag == 2{
                            randomX = Double(self.centerButton.frame.origin.x-peripheralObject[index ].BviewLable.frame.size.width/2) + (obj.distance*6) + 5
                            randomY = Double(self.centerButton.frame.origin.y-peripheralObject[index ].BviewLable.frame.size.width/2) - (obj.distance*6) + 5
                        }else if obj.positionTag == 3{
                            randomX = Double(self.centerButton.frame.origin.x-peripheralObject[index ].BviewLable.frame.size.width/2) + (obj.distance*6) + 5
                            randomY = Double(self.centerButton.frame.origin.y-peripheralObject[index ].BviewLable.frame.size.width/2) + 5
                        }else if obj.positionTag == 4{
                            randomX = Double(self.centerButton.frame.origin.x-peripheralObject[index ].BviewLable.frame.size.width/2) + (obj.distance*6) + 5
                            randomY = Double(self.centerButton.frame.origin.y-peripheralObject[index ].BviewLable.frame.size.width/2) + (obj.distance*6) + 5
                        }else if obj.positionTag == 5{
                            randomX = Double(self.centerButton.frame.origin.x-peripheralObject[index ].BviewLable.frame.size.width/2) + 5
                            randomY = Double(self.centerButton.frame.origin.y-peripheralObject[index ].BviewLable.frame.size.width/2) + (obj.distance*6) + 5
                        }else if obj.positionTag == 6{
                            randomX = Double(self.centerButton.frame.origin.x-peripheralObject[index ].BviewLable.frame.size.width/2) - (obj.distance*6) + 5
                            randomY = Double(self.centerButton.frame.origin.y-peripheralObject[index ].BviewLable.frame.size.width/2) + (obj.distance*6) + 5
                        }else if obj.positionTag == 7{
                            randomX = Double(self.centerButton.frame.origin.x-peripheralObject[index ].BviewLable.frame.size.width/2) - (obj.distance*6) + 5
                            randomY = Double(self.centerButton.frame.origin.y-peripheralObject[index ].BviewLable.frame.size.width/2) + 5
                        }else{
                            randomX = Double(self.centerButton.frame.origin.x-peripheralObject[index ].BviewLable.frame.size.width/2) - (obj.distance*6) + 5
                            randomY = Double(self.centerButton.frame.origin.y-peripheralObject[index ].BviewLable.frame.size.width/2) - (obj.distance*6) + 5
                        }
                        
                        
                        let updateddistance = obj.distance
                        var diffDistance = 0.0
                        
                        
                        if hideBLE == true
                        {
                            if !SelectedPeripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString})
                            {
                                //
                                peripheralObject[index ].InfoButton.isHidden = true
                                peripheralObject[index ].BviewLable.isHidden = true
                                peripheralObject[index ].TagImageView.isHidden = true
                            }
                        }
                        else
                        {
                            peripheralObject[index ].InfoButton.isHidden = false
                            peripheralObject[index ].BviewLable.isHidden = false
                            peripheralObject[index ].TagImageView.isHidden = false
                            
                        }
                        
                        
                        if SelectedPeripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString}){
                            if obj.distance > 12.0
                            {
                                peripheralObject[index ].soundTag = 2
                                
                            }
                            else if obj.distance < 3.0
                            {
                                
                                peripheralObject[index ].soundTag = 0
                                
                            }
                            else
                            {
                                peripheralObject[index ].soundTag = 1
                                
                            }
                            DeviceListTableView.reloadData()
                        }
                        
                        //            let InfoButton = peripheralObject[index ?? 0].InfoButton
                        
                        
                        if SelectedPeripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString}){
                            if peripheralObject[index ].InfoButton.frame.size.width != 60
                            {
                                peripheralObject[index ].BviewLable.isHidden = true
                                var frame = CGRect()
                                frame.origin.x = CGFloat(randomX)
                                frame.origin.y = CGFloat(randomY)
                                
                                
                                frame.size.width = 60
                                frame.size.height = 60
                                peripheralObject[index ].TagImageView.backgroundColor = .black
                                peripheralObject[index ].TagImageView.layer.cornerRadius = 50 / 2
                                peripheralObject[index ].TagImageView.clipsToBounds = true
                                peripheralObject[index ].TagImageView.layer.masksToBounds = true
                                peripheralObject[index ].InfoButton.frame = frame
                                peripheralObject[index ].BviewLable.frame = frame
                                peripheralObject[index ].BviewLable.layer.cornerRadius = peripheralObject[index ].BviewLable.frame.size.width / 2
                                peripheralObject[index ].TagImageView.frame = CGRect (x: randomX + 5, y: randomY + 5, width: 50, height: 50)
                                
                                peripheralObject[index ].DistanceLable.frame = CGRect (x: randomX + 10, y: randomY + 10, width: 40, height: 15)
                                if let index = SelectedPeripherals.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                                    peripheralObject[index ].TagImageView.image = SelectedPeripherals[index].TagImage
                                }
                                
                            }
                            peripheralObject[index ].BviewLable.isHidden = false
                        }
                        
                        
                        UIView.animate(withDuration: 2.0, animations: { [self] in
                            
                            self.view.layoutIfNeeded() // add this
                            //                ContentView.frame = ContentView.frame
                            var frame = CGRect()
                            frame.origin.x = CGFloat(randomX)
                            frame.origin.y = CGFloat(randomY)
                            
                            
                            frame.size.width = peripheralObject[index ].BviewLable.frame.size.width
                            frame.size.height = peripheralObject[index ].BviewLable.frame.size.height
                            peripheralObject[index ].TagImageView.frame = CGRect (x: randomX + 5, y: randomY + 5, width: peripheralObject[index ].TagImageView.frame.size.width, height: peripheralObject[index ].TagImageView.frame.size.height)
                            
                            peripheralObject[index ].DistanceLable.frame = CGRect (x: randomX + 10, y: randomY + 10, width: peripheralObject[index ].DistanceLable.frame.size.width, height: peripheralObject[index ].DistanceLable.frame.size.height)
                            
                            
                            peripheralObject[index ].InfoButton.frame = frame
                            peripheralObject[index ].BviewLable.frame = frame
                            
                            if SelectedPeripherals.contains(where: {$0.identifier == peripheral.identifier.uuidString}){
                                
                                startIndex = 0.0
                                endindex = 0.0
                                var distanceTag = 0
                                if currentDistance >= updateddistance{
                                    diffDistance = currentDistance - updateddistance
                                    startIndex = currentDistance
                                    distanceTag = 1
                                    
                                }else{
                                    diffDistance = updateddistance - currentDistance
                                    startIndex = currentDistance
                                    distanceTag = 0
                                    
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                                    
                                    if obj.distance > 12{
                                        if (self.player?.rate != 0){
                                            playSound()
                                        }
                                    }
                                    
                                    if currentDistance > 3 && obj.distance < 3{
                                        playSingleBeepSound()
                                    }
                                    if !peripheralObject.contains(where: {$0.soundTag == 2}){
                                        player?.stop()
                                        //
                                    }
                                    
                                }
                                
                                equalval = (diffDistance / 20.0)
//                                print("startIndex--",startIndex)
//                                print("endindex--",endindex)
//                                print("equalval--",equalval)
                                increaseCount = 0.0
                                
                                for _ in 0...19{
                                    if peripheralObject.count > 0{
                                        if distanceTag == 1
                                        {
                                            startIndex -= equalval
                                        }
                                        else
                                        {
                                            startIndex += equalval
                                        }
                                        
                                        let discalc = startIndex
                                        
                                        
                                        
                                        var labeltext = "\(name)\n"
                                        labeltext = ""
                                        labeltext = labeltext + String(Double(round(100 * startIndex) / 100))
                                        labeltext = labeltext + "m"
                                        DispatchQueue.main.asyncAfter(deadline: .now() + increaseCount) { [self] in
//                                            print("startIndex after updated",discalc)
                                            // distance in lable
                                            peripheralObject[index].DistanceLable.text = labeltext
                                            
                                            if discalc > 12.0
                                            {
                                                peripheralObject[index ].BviewLable.backgroundColor = UIColor.red
                                                
                                            }
                                            else if discalc < 3.0
                                            {
                                                
                                                peripheralObject[index ].BviewLable.backgroundColor = UIColor.green
                                                
                                            }
                                            else
                                            {
                                                peripheralObject[index ].BviewLable.backgroundColor = UIColor.yellow
                                                
                                            }
                                            
                                            
                                        }
                                        increaseCount = increaseCount + 0.1
                                        
                                        
                                        
                                    }
                                    
                                }
                            }
                            
                            
                        }) { [self] (success) in
                            self.view.layoutIfNeeded()
                            
                            if peripheralObject.count>0{
                                //                            peripheralObject[index ].BviewLable.text = (name ?? "") + " \(obj.distance.roundedDecimal(to: 2)) m"
                                //                            peripheralObject[index ].BviewLable.text = (name ?? "") + "\n" + "\(obj.distance.roundedDecimal(to: 2))" + "m"
                                peripheralObject[index ].BviewLable.layer.cornerRadius = (peripheralObject[index ].BviewLable.frame.size.width) / 2
                                peripheralObject[index ].BviewLable.clipsToBounds = true
                            }
                        }
                        if let lostIndex = SelectedPeripherals.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                            if SelectedPeripherals[lostIndex].LostAssetTag == 1{
                                peripheralObject[index ].InfoButton.isHidden = true
                                peripheralObject[index ].BviewLable.isHidden = true
                                peripheralObject[index ].TagImageView.isHidden = true
                                peripheralObject[index ].DistanceLable.isHidden = true
                            }else{
                                peripheralObject[index ].InfoButton.isHidden = false
                                peripheralObject[index ].BviewLable.isHidden = false
                                peripheralObject[index ].TagImageView.isHidden = false
                                peripheralObject[index ].DistanceLable.isHidden = false
                            }
                        }
                        
                    }else{
                        print("nothing")
                    }
                }
                
            }
            
            
            
            
        }
        self.view.bringSubviewToFront(DeviceView)
        self.view.bringSubviewToFront(DeviceListView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectedPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceListTableViewCell", for: indexPath) as! DeviceListTableViewCell
        var distance = Double()
        if let index = peripheralObject.firstIndex(where: {$0.identifier == SelectedPeripherals[indexPath.row].identifier}){
            distance = peripheralObject[index].distance
        }
        
        cell.TagNameLable.text = SelectedPeripherals[indexPath.row].name + "\n" + "\(distance.roundedDecimal(to: 2))" + "m"
        cell.TagNameLable.attributedText  = NSMutableAttributedString()
            .bold(SelectedPeripherals[indexPath.row].name)
            .orangeHighlight("\n" + "\(distance.roundedDecimal(to: 2))" + "m")
        cell.TagNameLable.numberOfLines = 4
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}






extension Double {
    /// Convert `Double` to `Decimal`, rounding it to `scale` decimal places.
    ///
    /// - Parameters:
    ///   - scale: How many decimal places to round to. Defaults to `0`.
    ///   - mode:  The preferred rounding mode. Defaults to `.plain`.
    /// - Returns: The rounded `Decimal` value.
    
    func roundedDecimal(to scale: Int = 0, mode: NSDecimalNumber.RoundingMode = .plain) -> Decimal {
        var decimalValue = Decimal(self)
        var result = Decimal()
        NSDecimalRound(&result, &decimalValue, scale, mode)
        
        return result
    }
}
