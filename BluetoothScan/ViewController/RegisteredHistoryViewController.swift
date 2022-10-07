//
//  RegisteredHistoryViewController.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 23/08/22.
//

import UIKit
//struct ReferenceDeviceObj{
//    var name = String()
//    var distance = String()
//}
protocol registerdevice:HistoryViewController{
    func locationButtonClicked(Index:Int)
}
protocol DeviceReloadTable:RegisteredHistoryViewController{
    func didUpdate()
}
class RegisteredHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DeviceReloadTable{
    func didUpdate() {
        ReferenceTableview.reloadData()
        print("table reloaded successfully----")
    }
    @IBOutlet weak var NotesTitleLable: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var DeviceInformationView: UIView!
    @IBOutlet weak var RegisteredTableView: UITableView!
    @IBOutlet weak var ReferenceTableview: UITableView!
    @IBOutlet weak var referenceInfoTableView: UITableView!
    
    @IBOutlet weak var assetHisBack: UIButton!
    @IBOutlet weak var viewComplaint: UIButton!
    @IBOutlet weak var referenceInfoView: UIView!
    @IBOutlet weak var deviceHistoryView: UIView!
    @IBOutlet weak var LostAssetView: UIView!
    @IBOutlet weak var ReisterName_lable: UILabel!
    @IBOutlet weak var Identifier_Lable: UILabel!
    @IBOutlet weak var TagImageView: UIImageView!
    @IBOutlet weak var SubmitandShareOutlet: UIButton!
    @IBOutlet weak var BackOutlet: UIButton!
    
    weak var delegate: registerdevice? = nil
    var HistoryLocalArray = [PheripheralObj]()
    var HistoryReferenceArray = [PheripheralObj]()
    var DeviceUpdateArray = [DeviceUpdate]()
    var ReferenceArray = [Reference]()
    var Index = 0
    //    var referenceDeviceArray = [ReferenceDeviceObj]()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shadowDrop(view: TagImageView)
        TagImageView.layer.borderWidth = 1
        TagImageView.layer.borderColor = UIColor.black.cgColor
        TagImageView.clipsToBounds = true
        HistoryLocalArray = DBcall.readHistoryTable()
        notesTextView.layer.borderColor = UIColor.black.cgColor
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.cornerRadius = 5
//        LostAssetView.layer.cornerRadius = 7
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ReferenceTableview
        {
           
                return DeviceUpdateArray.count
            
        }
        else if tableView == referenceInfoTableView
        {
            if ReferenceArray.count > 5
            {
                return 5
            }
            return ReferenceArray.count
        }
        else
        {
            return HistoryLocalArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ReferenceTableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeviceListTableViewCell
            let CoordinateArray = DeviceUpdateArray[indexPath.row].Coordinates.components(separatedBy: ", ")
            cell.TagNameLable.attributedText  = NSMutableAttributedString()
//                .bold(HistoryReferenceArray[indexPath.row].name)
//                .normal("\n" + (HistoryReferenceArray[indexPath.row].identifier) )
                .Semibold((DeviceUpdateArray[indexPath.row].DateTime) )
                .Semibold("\n" + "\((Double(CoordinateArray[0]) ?? 0.00).roundedDecimal(to:7)), " + "\(Double(CoordinateArray[1])?.roundedDecimal(to:7) ?? 0.00)" )
                
            cell.TagNameLable.numberOfLines = 9
//            cell.layoutIfNeeded()
            return cell
        }
        else if tableView == referenceInfoTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeviceListTableViewCell
            
              cell.TagNameLable.attributedText  = NSMutableAttributedString()
                  .bold(ReferenceArray[indexPath.row].Name)
                  .Semibold("\n" + (ReferenceArray[indexPath.row].Identifier) )
                  .Semibold("\n" + (ReferenceArray[indexPath.row].DateTime) )
                  .Semibold("\n" + "\((ReferenceArray[indexPath.row].Coordinates))" )
                  
              cell.TagNameLable.numberOfLines = 9
//              cell.layoutIfNeeded()
              return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeviceListTableViewCell
            let distance = HistoryLocalArray[indexPath.row].distance
            //            cell.TagNameLable.text = HistoryLocalArray[indexPath.row].name + "\n" + "\(HistoryLocalArray[indexPath.row].identifier)" + "m"
            cell.TagNameLable.attributedText  = NSMutableAttributedString()
                .bold(HistoryLocalArray[indexPath.row].name)
                .normal("\n" + HistoryLocalArray[indexPath.row].identifier)
                
                		
            cell.TagNameLable.numberOfLines = 6
            cell.tagImageView.image = HistoryLocalArray[indexPath.row].TagImage
//            cell.layoutIfNeeded()
            cell.tagImageView.layer.cornerRadius = 25
            
            if HistoryLocalArray[indexPath.row].LostAssetTag == 0{
                cell.tagImageView.layer.borderColor = UIColor.black.cgColor
                cell.tagImageView.layer.borderWidth = 1
            }else{
                cell.tagImageView.layer.borderColor = UIColor.red.cgColor
                cell.tagImageView.layer.borderWidth = 2
            }
            cell.tagImageView.clipsToBounds = true
            cell.Info_Button.addTarget(self, action: #selector(Detail), for: .touchUpInside)
            cell.Location_Button.addTarget(self, action: #selector(LocationobjFunction), for: .touchUpInside)
            cell.Info_Button.tag = indexPath.row
            cell.Location_Button.tag = indexPath.row
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == ReferenceTableview{
            return 50
        }else if tableView == referenceInfoTableView{
            return 80
        }
        return 60
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ReferenceTableview{
            deviceHistoryView.isHidden = true
            LostAssetView.isHidden = true
            referenceInfoView.isHidden = false
            ReferenceArray = DBcall.readReferenceTable(DateTime: DeviceUpdateArray[indexPath.row].DateTime, identifier: DeviceUpdateArray[indexPath.row].Identifier)
            referenceInfoTableView.reloadData()
        }
        
        
    }
    
    @objc func LocationobjFunction(sender: UIButton)
    {
        delegate?.locationButtonClicked(Index: sender.tag)
    }
    @objc func Detail(sender: UIButton)
    {
        Index = sender.tag
        referenceInfoView.isHidden = true
        LostAssetView.isHidden = true
        deviceHistoryView.isHidden = false
        TagImageView.image = HistoryLocalArray[sender.tag].TagImage
        ReisterName_lable.text = HistoryLocalArray[sender.tag].name
        Identifier_Lable.text = HistoryLocalArray[sender.tag].identifier
        let coordinateStr = "\(HistoryLocalArray[sender.tag].Latitude.roundedDecimal(to: 7)), \(HistoryLocalArray[sender.tag].Longitude.roundedDecimal(to: 7))"
        print(coordinateStr)
        DeviceUpdateArray = DBcall.readDeviceUpdateTable(identifier: HistoryLocalArray[sender.tag].identifier)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy hh:mm:ss a"
        DeviceUpdateArray = DeviceUpdateArray.sorted(by: {dateFormatter.date(from: $0.DateTime)! > (dateFormatter.date(from: $1.DateTime)!)})
//        { dateFormatter.date(from: $0.date ?? "")! < dateFormatter.date(from: $1.date ?? "")!}
        ReferenceTableview.reloadData()
        HistoryReferenceArray = DBcall.readReferenceListFromHistoryTable()
        if HistoryLocalArray[sender.tag].LostAssetTag == 0{
            TagImageView.layer.borderWidth = 1
            TagImageView.layer.borderColor = UIColor.black.cgColor
            viewComplaint.isHidden = true
            
        }else{
            TagImageView.layer.borderWidth = 2
            TagImageView.layer.borderColor = UIColor.red.cgColor
            viewComplaint.isHidden = false
            
        }
        ReferenceTableview.reloadData()
        DeviceInformationView.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(DeviceInformationView)
    }
    @IBAction func RemoveViewAction(_ sender: Any) {
        DeviceInformationView.removeFromSuperview()
    }
    @IBAction func RemoveLostAssetViewAction(_ sender: Any) {
        LostAssetView.isHidden = true
    }
    
    @IBAction func SubmitComplaint(_ sender: Any) {
        notesTextView.addtoolbar()
        notesTextView.isEditable = true
        notesTextView.text = ""
        NotesTitleLable.text = "Lost Asset"
        BackOutlet.isHidden = true
        SubmitandShareOutlet.isHidden = false
        deviceHistoryView.isHidden = true
        LostAssetView.isHidden = false
        referenceInfoView.isHidden = false
    }
    
    @IBAction func referenceDeviceCloseAction(_ sender: Any) {
        deviceHistoryView.isHidden = false
        LostAssetView.isHidden = true
        referenceInfoView.isHidden = true
    }
    @IBAction func shareAction(_ sender: Any) {
        if notesTextView.text != ""{
            var referenceDevices = "Reference Devices:-"
            for i in HistoryReferenceArray
            {
                referenceDevices = referenceDevices + "\nDevice Name: \(i.name)\nIdentifier: \(i.identifier)\nCoordinates: \(i.Latitude.roundedDecimal(to:7)), \(i.Longitude.roundedDecimal(to:7))\nDate and Time: \(i.registerDateTime)\n"
            }
            
//            let sharetext = "Lost Asset:-\nDevice Name: \(ReisterName_lable.text!)\nIdentifier: \(Identifier_Lable.text!)\nCoordinates: \(coordinateLabel.text!)\nDate and Time: \(Distance_Lable.text!)\n\n\(referenceDevices)\nNotes:-\n\(notesTextView.text!)"
            let sharetext = "Lost Asset:-\nDevice Name: \(ReisterName_lable.text!)\nIdentifier: \(Identifier_Lable.text!)\n\n\(referenceDevices)\n\nNotes:-\n\(notesTextView.text!)"
            
//             let sharedObjects:[AnyObject] = [someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : [sharetext], applicationActivities: nil)
             activityViewController.popoverPresentationController?.sourceView = self.view

            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]
 
             self.present(activityViewController, animated: true, completion: nil)
            activityViewController.completionWithItemsHandler = { activity, completed, items, error in
                    if !completed {
                        // handle task not completed
                        print("share failure")
                        return
                    }
                    print("successfully shared")
                self.DeviceInformationView.removeFromSuperview()
                DBcall.updateLostAssetinHistory(tag: 1, Notes: self.notesTextView.text!, identifier: self.Identifier_Lable.text!)
                self.HistoryLocalArray = DBcall.readHistoryTable()
                self.RegisteredTableView.reloadData()
                }
            
        }
    }
    
    @IBAction func viewComplaintAction(_ sender: Any) {
        notesTextView.text = HistoryLocalArray[Index].Notes
        notesTextView.inputAccessoryView = nil
        notesTextView.isEditable = false
        NotesTitleLable.text = "Complaint Notes"
        BackOutlet.isHidden = false
        SubmitandShareOutlet.isHidden = true
        deviceHistoryView.isHidden = false
        LostAssetView.isHidden = false
        referenceInfoView.isHidden = true
    }
    
    @IBAction func viewComplaintBack(_ sender: Any) {
        LostAssetView.isHidden = true
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
