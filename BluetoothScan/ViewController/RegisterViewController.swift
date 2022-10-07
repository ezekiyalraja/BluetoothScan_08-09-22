//
//  RegisterViewController.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 18/08/22.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var RegisterBackgroundView: UIView!
    @IBOutlet weak var phoneTextfield: FloatingTextField!
    @IBOutlet weak var RegisterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowDrop(view: RegisterBackgroundView)
        shadowDrop(view: RegisterButton)
        phoneTextfield.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
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
extension UIViewController
{
    func shadowDrop(view:UIView)
    {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.cornerRadius = 7
        view.layer.shadowRadius = 3
    }
}
