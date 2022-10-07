//
//  DeviceListViewController.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 21/07/22.
//

import UIKit
import CoreBluetooth
import Photos
import SQLite3
import CoreLocation

var SelectedPeripherals = [PheripheralObj]()

class DeviceListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var TagImageOutlet: UIImageView!
    var selectedRow = 0
    var selected = false
    var locationManager = CLLocationManager()
    var alert = UIAlertController()
    var centralManager: CBCentralManager?
    var peripherals = [PheripheralObj]()
    var timer = Timer()
    var RegisterCurrentImage = UIImage()
    
    @IBOutlet weak var AlertMessageLable: UILabel!
    @IBOutlet weak var AlertTagTextField: UITextField!
    @IBOutlet var AlertBlurView: UIView!
    
    @IBOutlet weak var DeviceListTableView: UITableView!
    @IBOutlet weak var MenuWidth: NSLayoutConstraint!
    @IBOutlet weak var MenuHeight: NSLayoutConstraint!
    @IBOutlet weak var MenuTopConstraint: NSLayoutConstraint!
    @IBOutlet var SortMenuView: UIView!
    @IBOutlet weak var SortOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AlertTagTextField.addtoolbar()
        
        TagImageOutlet.layer.cornerRadius = (TagImageOutlet.frame.size.width) / 2
        TagImageOutlet.clipsToBounds = true
        TagImageOutlet.layer.borderColor = UIColor.systemTeal.cgColor
        TagImageOutlet.backgroundColor = .clear
        TagImageOutlet.layer.borderWidth = 1
        MenuWidth.constant = 0
        MenuHeight.constant = 0
        MenuTopConstraint.constant = UIApplication.shared.statusBarFrame.size.height +
        (self.navigationController?.navigationBar.frame.height ?? 0.0) + 50
        //        SelectedPeripherals.removeAll()
        print("Done")
        
        // Do any additional setup after loading the view.
        //        if #available(iOS 14.0, *) {
        //            var menuItems: [UIAction] {
        //                return [
        //                    UIAction(title: "Standard item", image: UIImage(systemName: "sun.max"), handler: { (_) in
        //                    }),
        //                    UIAction(title: "Disabled item", image: UIImage(systemName: "moon"), attributes: .disabled, handler: { (_) in
        //                    }),
        //                    UIAction(title: "Delete..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
        //                    })
        //                ]
        //            }
        //            var demoMenu: UIMenu {
        //                return UIMenu(title: "My menu", image: nil, identifier: nil, options: [], children: menuItems)
        //            }
        //            SortOutlet.menu = demoMenu
        //            SortOutlet.showsMenuAsPrimaryAction = true
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        centralManager = CBCentralManager(delegate: self, queue:DispatchQueue.main)
        timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        centralManager?.stopScan()
    }
    
    @IBAction func RescanAction(_ sender: Any) {
        //        SelectedPeripherals.removeAll()
        peripherals.removeAll()
        centralManager = CBCentralManager(delegate: self, queue:DispatchQueue.main)
        timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
    }
    @IBAction func DoneAction(_ sender: Any) {
        //        })
        ScanTag = 1
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
        
    }
    
    
    @objc func update() {
        //        print("hello")
        centralManager = CBCentralManager(delegate: self, queue:DispatchQueue.main)
        
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
                if let index = SelectedPeripherals.firstIndex(where: {$0.identifier == peripheral.identifier.uuidString}){
                    obj.name = SelectedPeripherals[index].name
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
        //        print("Array",)
        DeviceListTableView.reloadData()
        
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn){
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selected == true
        {
            return SelectedPeripherals.count
        }
        else
        {
            return peripherals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceListTableViewCell", for: indexPath) as! DeviceListTableViewCell
        if selected == true
        {
            let distance = SelectedPeripherals[indexPath.row].distance
            cell.TagNameLable.text = SelectedPeripherals[indexPath.row].name + "\n" + "\(distance.roundedDecimal(to: 2))" + "m"
            cell.TagNameLable.attributedText  = NSMutableAttributedString()
                .bold(SelectedPeripherals[indexPath.row].name)
                .orangeHighlight("\n" + "\(distance.roundedDecimal(to: 2))" + "m")
            cell.TagNameLable.numberOfLines = 4
            if SelectedPeripherals[indexPath.row].checkTag == 0
            {
                cell.CheckImageview.image = UIImage(named: "")
            }
            else if SelectedPeripherals[indexPath.row].checkTag == 1
            {
                cell.CheckImageview.image = UIImage(named: "Check1")
            }
            
            cell.layoutIfNeeded()
        }
        else
        {
            let distance = peripherals[indexPath.row].distance
            cell.TagNameLable.text = peripherals[indexPath.row].name + "\n" + "\(distance.roundedDecimal(to: 2))" + "m"
            cell.TagNameLable.attributedText  = NSMutableAttributedString()
                .bold(peripherals[indexPath.row].name)
                .orangeHighlight("\n" + "\(distance.roundedDecimal(to: 2))" + "m")
            cell.TagNameLable.numberOfLines = 4
            if let index = SelectedPeripherals.firstIndex(where: {$0.identifier == peripherals[indexPath.row].identifier })
            {
                if SelectedPeripherals[index].checkTag == 0
                {
                    peripherals[indexPath.row].checkTag = 0
                    cell.CheckImageview.image = UIImage(named: "")
                }
                else if SelectedPeripherals[index].checkTag == 1
                {
                    peripherals[indexPath.row].checkTag = 1
                    cell.CheckImageview.image = UIImage(named: "Check1")
                }
            }
            else
            {
                
                if peripherals[indexPath.row].checkTag == 0
                {
                    cell.CheckImageview.image = UIImage(named: "")
                }
                else if peripherals[indexPath.row].checkTag == 1
                {
                    cell.CheckImageview.image = UIImage(named: "Check1")
                }
            }
            cell.layoutIfNeeded()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if selected == true
        {
            AlertTagTextField.text = ""
            RegisterCurrentImage = UIImage(named: "BLE_50") ?? UIImage()
            UIApplication.shared.keyWindow?.addSubview(AlertBlurView)
            AlertBlurView.frame = UIScreen.main.bounds
            
            selectedRow = indexPath.row
            
        }
        else
        
        {
            if peripherals[indexPath.row].checkTag == 0
            {
                
                AlertTagTextField.text = peripherals[indexPath.row].name
                RegisterCurrentImage = UIImage(named: "BLE_50") ?? UIImage()
                AlertMessageLable.text = "Do you want to Register \n\(peripherals[indexPath.row].name)?"
                TagImageOutlet.image = UIImage(named: "AddImage")
                UIApplication.shared.keyWindow?.addSubview(AlertBlurView)
                AlertBlurView.frame = UIScreen.main.bounds
                selectedRow = indexPath.row
                
            }
            else
            {
                
                let alert = UIAlertController(title: "Alert", message: "Do you want to Remove \n\(peripherals[indexPath.row].name) from registered device?", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "Remove", style: .default, handler: { action in
                    
                    DBcall.deleteByID(id: self.peripherals[indexPath.row].identifier)
                    SelectedPeripherals = DBcall.readDeviceTable()
                    //                    self.removeImage(itemName: self.peripherals[indexPath.row].identifier)
                    //                                         }
                    self.peripherals[indexPath.row].checkTag = 0
                    
                })
                alert.addAction(ok)
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    
                })
                alert.addAction(cancel)
                self.present(alert, animated: true)
                
                
                
            }
        }
        self.view.endEditing(true)
        DeviceListTableView.reloadData()
        
    }
    
    
    
    
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
            self?.RegisterCurrentImage = image
            self?.TagImageOutlet.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func AddPhotoAction(_ sender: Any) {
        print("click")
        self.getImage(fromSourceType: .camera)
    }
    @objc func click(sender: UIButton) {
        print("click")
        self.getImage(fromSourceType: .camera)
        
    }
    @IBAction func AlertRegisterAction(_ sender: Any) {
        var Lat = Double()
        var Long = Double()
        var currentLocation:CLLocation!
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)
        {
            currentLocation = locationManager.location
            Lat = currentLocation.coordinate.latitude
            Long = currentLocation.coordinate.longitude
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        let RegisterDate = formatter.string(from: Date())
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm:ss a"
        let RegisterTime = formatter2.string(from: Date())
        var Referencestring = ""
        for i in peripherals
        {
            if !SelectedPeripherals.contains(where: {$0.identifier == i.identifier}) && i.identifier != self.peripherals[selectedRow].identifier
            {
                Referencestring += i.name + ","
                //                Referencestring += String("\(i.distance.roundedDecimal(to: 2))")
                Referencestring += i.identifier
                
                Referencestring += ","
            }
            
            
        }
        for obj in peripherals
        {
            
            
            var obj = obj
            
            //        obj.identifier = self.peripherals[selectedRow].identifier
            //        obj.distance = self.peripherals[selectedRow].distance
            
            obj.Latitude = Lat
            obj.Longitude = Long
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM yyyy"
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "hh:mm:ss a"
            obj.registerDateTime = formatter.string(from: Date())
            + ", "
            + formatter2.string(from: Date())
            if obj.identifier == self.peripherals[selectedRow].identifier
            {
                obj.name = AlertTagTextField.text ?? ""
                saveImageToDocumentDirectory(image: self.RegisterCurrentImage, fileName: self.peripherals[selectedRow].identifier)
                DBcall.insertIntoDeviceTable(object: obj, MobileNo: UserMobileNumber, imageString: "")
            }
            if DBcall.CheckAlreadyExists(id: obj.identifier) == 1
            {
                if obj.identifier == self.peripherals[selectedRow].identifier
                {
                    obj.name = AlertTagTextField.text ?? ""
                    saveImageToDocumentDirectory(image: self.RegisterCurrentImage, fileName: self.peripherals[selectedRow].identifier)
                    DBcall.UpdateHistoryTable(obj: obj,Status: "Registered")
                }
                
            }
            else
            {
                if obj.identifier == self.peripherals[selectedRow].identifier
                {
                    obj.name = AlertTagTextField.text ?? ""
                    DBcall.insertIntoHistoryTable(object: obj, MobileNo: UserMobileNumber, NearByDevices: Referencestring, Status: "Registered")
                }
                else
                {
                    DBcall.insertIntoHistoryTable(object: obj, MobileNo: UserMobileNumber, NearByDevices: Referencestring, Status: "Not Registered")
                }
            }
           
            if obj.identifier == self.peripherals[selectedRow].identifier
            {
                DBcall.insertIntoDeviceUpdateTable(ID: obj.identifier, Coordinates: "\(Lat), \(Long)", DateTime: "\(RegisterDate) \(RegisterTime)")
                print("Saved ")
                Started = 1
            }
            else
            {
                
                DBcall.insertIntoReferenceTable(name: obj.name, Identifier: obj.identifier, Coordinates: "\(Lat.roundedDecimal(to: 7)), \(Long.roundedDecimal(to: 7))", DateTime: "\(RegisterDate) \(RegisterTime)", Distance: obj.distance, ReferenceIdentifier: self.peripherals[selectedRow].identifier)
                
                
            }
                
            
        }
        
        
        self.peripherals[selectedRow].name = AlertTagTextField.text ?? ""
        self.peripherals[selectedRow].checkTag = 1
        self.peripherals[selectedRow].TagImage = self.RegisterCurrentImage
        SelectedPeripherals = DBcall.readDeviceTable()
        //        SelectedPeripherals.append(self.peripherals[selectedRow])
        AlertBlurView.removeFromSuperview()
        self.view.endEditing(true)
        DeviceListTableView.reloadData()
        
    }
    
    @IBAction func AlertCancelAction(_ sender: Any) {
        AlertBlurView.removeFromSuperview()
        
    }
    
    @IBOutlet weak var SortMenuList: CustomView!
    @IBAction func SortAction(_ sender: Any) {
        
        
        SortMenuView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.MenuWidth.constant = 150
            
            self.MenuHeight.constant = 80
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    @IBAction func RemoveMenuView(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.MenuWidth.constant = 0
            
            self.MenuHeight.constant = 0
            self.view.layoutIfNeeded()
        }){ (finished) in
            self.SortMenuView.isHidden = true
        }
    }
    
    @IBAction func AllPheripheralsAction(_ sender: Any) {
        SortOutlet.setTitle("All", for: .normal)
        SortMenuView.isHidden = false
        self.MenuWidth.constant = 0
        self.MenuHeight.constant = 0
        selected = false
        DeviceListTableView.reloadData()
    }
    
    @IBAction func SelectedPheripheralsAction(_ sender: Any) {
        SortMenuView.isHidden = true
        self.MenuWidth.constant = 0
        self.MenuHeight.constant = 0
        SortOutlet.setTitle("Registered", for: .normal)
        selected = true
        DeviceListTableView.reloadData()
    }
    func saveImageToDocumentDirectory(image: UIImage,fileName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = fileName // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func removeImage(itemName:String) {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName)"
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension UITextField{
    func addtoolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(clickeddone))
        let spacebut = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spacebut,done], animated: true)
        self.inputAccessoryView = toolbar
        
    }
    
    
    
    @objc func clickeddone(){
        
        self.endEditing(true)
        
    }
}
extension UITextView{
    func addtoolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(clickeddone))
        let spacebut = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spacebut,done], animated: true)
        self.inputAccessoryView = toolbar
        
    }
    
    
    
    @objc func clickeddone(){
        
        self.endEditing(true)
        
    }
}
extension NSMutableAttributedString {
    var fontSize:CGFloat { return 12 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: 14) }
    var normalFont:UIFont { return UIFont.systemFont(ofSize: fontSize)}
    var semiBoldFont:UIFont { return UIFont.systemFont(ofSize: fontSize, weight: .semibold)}
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func Semibold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : semiBoldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.systemTeal,
            .backgroundColor : UIColor.white
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
@IBDesignable
class CustomView: UIView{
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        
        didSet{
            
            self.layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        
        didSet {
            
            self.layer.shadowColor = borderColor.cgColor
        }
    }
    @IBInspectable var shadowOffset: CGSize = .zero {
        
        didSet {
            
            self.layer.shadowOffset = CGSize.zero
            
        }
    }
    @IBInspectable var shadowRadius: NSNumber = 0 {
        
        didSet {
            
            self.layer.shadowRadius = 10
            
        }
    }
    @IBInspectable var shadowOpacity: CGFloat = 0.7 {
        
        didSet {
            
            self.layer.shadowOpacity = 0.7
            
        }
    }
    
    
    override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
    }
    
}
