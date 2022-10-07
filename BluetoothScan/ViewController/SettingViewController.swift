//
//  SettingViewController.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 08/08/22.
//

import UIKit
var hideBLE = false
var TurnSound = true
class SettingViewController: UIViewController {
    
    @IBOutlet weak var SwitchOutlet: UISwitch!
    @IBOutlet weak var SoundSwitchOutlet: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        SwitchOutlet.layer.borderWidth = 0
        self.title = "Setting"
        SwitchOutlet.layer.cornerRadius = 16
        SoundSwitchOutlet.layer.cornerRadius = 16
        if hideBLE == true
        {
            SwitchOutlet.setOn(true, animated: true)
            
        }
        else
        {
            SwitchOutlet.setOn(false, animated: true)
        }
        if TurnSound == true
        {
            SoundSwitchOutlet.setOn(true, animated: true)
        }
        else
        {
            SoundSwitchOutlet.setOn(false, animated: true)
        }
        
        SwitchOutlet.layer.borderColor = UIColor.green.cgColor
        SoundSwitchOutlet.layer.borderColor = UIColor.green.cgColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction func StatusAction(_ sender: Any) {
        if SwitchOutlet.isOn
        {
            hideBLE = true
            UserDefaults.standard.set(true, forKey: "hideBLE")
        }
        else
        {
            hideBLE = false
            UserDefaults.standard.set(false, forKey: "hideBLE")
        }
    }
    @IBAction func SoundAction(_ sender: Any) {
        if SoundSwitchOutlet.isOn
        {
            TurnSound = true
            UserDefaults.standard.set(true, forKey: "sound")
        }
        else
        {
            TurnSound = false
            UserDefaults.standard.set(false, forKey: "sound")
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
