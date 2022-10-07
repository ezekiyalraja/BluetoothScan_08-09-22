//
//  LoginViewController.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 17/08/22.
//

import UIKit
import NotificationCenter
import SQLite3
import MapKit
import CoreData

var UserMobileNumber = ""

internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
var Default = UserDefaults()
class LoginViewController: UIViewController, FloatingTextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet var RegisterPopUP: UIView!
    @IBOutlet weak var BackgroundView: UIView!
    @IBOutlet weak var RegisterView: UIView!
    @IBOutlet weak var BAckgroundViewCenterCo0nstraint: NSLayoutConstraint!
    @IBOutlet weak var SwitchOutlet: UISwitch!
    @IBOutlet weak var PhoneTextfield: FloatingTextField!
    @IBOutlet weak var PasswordTextfield: FloatingTextField!
    @IBOutlet weak var RegisterTextfield: FloatingTextField!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var accountinfoLable: UILabel!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var RegisterVerticalConstan: NSLayoutConstraint!
    
    @IBOutlet weak var registerOutlet: UIButton!
    @IBOutlet weak var BackgroundMap: MKMapView!
    @IBOutlet weak var LoginTopConstraint: NSLayoutConstraint!
    var Login = true
    var UserArray = [RegisterObject]()
//    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        BLe.value(forKey: "name") as! String
        let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest

            // Check for Location Services
            if (CLLocationManager.locationServicesEnabled()) {
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }

            //Zoom to user location
            if let userLocation = locationManager.location?.coordinate {
                var viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
//                var span = MKCoordinateSpan()
//                span.longitudeDelta = (span.longitudeDelta) / 1
                
                viewRegion.span = MKCoordinateSpan(latitudeDelta: (viewRegion.span.latitudeDelta), longitudeDelta: (viewRegion.span.longitudeDelta))
                BackgroundMap.setRegion(viewRegion, animated: false)
            }
        hideBLE = UserDefaults.standard.bool(forKey: "hideBLE")
        TurnSound = UserDefaults.standard.bool(forKey: "sound")
        
        shadowDrop(view: BackgroundView)
        shadowDrop(view: RegisterView)
        shadowDrop(view: LoginBtn)
        shadowDrop(view: registerOutlet)
        PhoneTextfield.addDoneButtonOnKeyboard()
        PasswordTextfield.addDoneButtonOnKeyboard()
        
        //        self.view.set
        // Do any additional setup after loading the view.
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        //        setGradientBackground()
        super.viewWillAppear(true)
        UserArray = DBcall.readRegister()
        print(UserArray)
        self.title = "Personal Asset Tracker"
        let  USername = UserDefaults.standard.string(forKey: "CurrentUser")
        let  USerPassword = UserDefaults.standard.string(forKey: "CurrentUserPassword")
        print("username==>",USername)
        if UserArray.count > 0
        {
            
            PhoneTextfield.text = USername
            PasswordTextfield.text = USerPassword
            SwitchOutlet.setOn(true, animated: true)
            Login = true
            RegisterView.isHidden = true
            BackgroundView.isHidden = false
//            BAckgroundViewCenterCo0nstraint.constant = -50
//            RegisterVerticalConstan.constant = 110
//            LoginTopConstraint.constant = 55
//            LoginBtn.setTitle("Login", for: .normal)
//            RegisterButton.setTitle("Register Now", for: .normal)
//            accountinfoLable.text = "Don't have an account?"
            
            
            
        }
        else
        {
            
            RegisterTextfield.text = USername
            PhoneTextfield.text = USername
            Login = false
            
            RegisterView.isHidden = false
            BackgroundView.isHidden = true
//            BAckgroundViewCenterCo0nstraint.constant = -100
//            RegisterVerticalConstan.constant = 125
//            LoginBtn.setTitle("Register", for: .normal)
//            LoginTopConstraint.constant = 25
//            RegisterButton.setTitle("Login Now", for: .normal)
//            accountinfoLable.text = "Already have an account?"
        }
        PhoneTextfield.placeHolderSetup()
        PasswordTextfield.placeHolderSetup()
    }
    
    
    func floatingTextFieldRightViewClick(_ textField: UITextField) {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        
        
        if let view = textField.rightView as? UIButton {
            if view.tag == 0 {
                if #available(iOS 13.0, *) {
                    view.tag = 1
                    view.setImage(UIImage(named: "ShowPassword"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
            } else {
                view.tag = 0
                if #available(iOS 13.0, *) {
                    view.setImage(UIImage(named: "HidePassword"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    @IBAction func RegisterAction(_ sender: Any) {
        //        retrieveRegisterDetails()
        if Login == true
        {
            Login = false
            RegisterView.isHidden = false
            BackgroundView.isHidden = true
//            BAckgroundViewCenterCo0nstraint.constant = -100
//            RegisterVerticalConstan.constant = 125
//            LoginBtn.setTitle("Register", for: .normal)
//            LoginTopConstraint.constant = 25
//            RegisterButton.setTitle("Login Now", for: .normal)
//            accountinfoLable.text = "Already have an account?"
        }
        else
        {
            
            Login = true
            RegisterView.isHidden = true
            BackgroundView.isHidden = false
//            BAckgroundViewCenterCo0nstraint.constant = -50
//            RegisterVerticalConstan.constant = 110
//            LoginTopConstraint.constant = 55
//            LoginBtn.setTitle("Login", for: .normal)
//            RegisterButton.setTitle("Register Now", for: .normal)
//            accountinfoLable.text = "Don't have an account?"
        }
        
    }
    
    @IBAction func LoginAction(_ sender: UIButton) {
        
        
        if sender.tag == 2
        {
            if UserArray.contains(where: { $0.phonenumber == PhoneTextfield.text }) {
                if let index = UserArray.firstIndex(where: {$0.phonenumber == PhoneTextfield.text})
                {
                    if PhoneTextfield.text == UserArray[index].phonenumber && PasswordTextfield.text == UserArray[index].password
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier:"ViewController") as! ViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else
                    {
                        Alert(title: "Alert", message: "Please enter valid password")
                    }
                }
                
            } else {
                Alert(title: "Alert", message: "Please enter Registered Mobile Number")
                
            }
            
        }
        else
        {
            if (RegisterTextfield.text ?? "").count < 10
            {
                let alert = UIAlertController(title: "Alert", message: "Mobile number must have 10 digits!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
            else
            {
                RegisterPopUP.frame = UIScreen.main.bounds
                UIApplication.shared.keyWindow?.addSubview(RegisterPopUP)
            }
            
            
        }
        
    }
    
    @IBAction func CloseRegisterPopUp(_ sender: Any) {
        RegisterPopUP.removeFromSuperview()
    }
    
    @IBAction func RegisterPopupAction(_ sender: Any) {
        
        RegisterPopUP.removeFromSuperview()
        let number = RegisterTextfield.text ?? ""
        //        insert(mobileNo: number, password: String((RegisterTextfield.text)?.suffix(4) ?? ""))
        if !UserArray.contains(where: {$0.phonenumber == number}){
            DBcall.insertIntoRegister(MobileNo: number, Password: String((RegisterTextfield.text)?.suffix(4) ?? ""))
        }
        else
        {
            self.Alert(title: "Alert", message: "User already registered.")
            return
        }
        
        UserDefaults.standard.set(RegisterTextfield.text, forKey: "CurrentUser")
        UserDefaults.standard.set((RegisterTextfield.text)?.suffix(4), forKey: "CurrentUserPassword")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        UserMobileNumber = number
        self.navigationController?.pushViewController(next, animated: true)
        
        let  USername = UserDefaults.standard.string(forKey: "CurrentUser")
        let  USerPassword = UserDefaults.standard.string(forKey: "CurrentUserPassword")
        RegisterTextfield.text = USername
        
        
    }
    
    
    func setGradientBackground() {
        let colorTop =  UIColor.white.cgColor
        let colorBottom = UIColor.systemTeal.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.opacity = 1
        gradientLayer.locations = [0.3, 0.5]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.view.frame.origin.y -= 100
//            self.view.layoutIfNeeded()
//
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                self.view.frame.origin.y = 0
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
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
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}

extension UIResponder {
    
    static weak var responder: UIResponder?
    
    static func currentFirst() -> UIResponder? {
        responder = nil
        UIApplication.shared.sendAction(#selector(trap), to: nil, from: nil, for: nil)
        return responder
    }
    
    @objc private func trap() {
        UIResponder.responder = self
    }
}
extension UIViewController
{
    func Alert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}
extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(named: "ic_password_visible"), for: .normal)
        }else{
            button.setImage(UIImage(named: "ic_password_invisible"), for: .normal)
            
        }
    }
    
    func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
}
