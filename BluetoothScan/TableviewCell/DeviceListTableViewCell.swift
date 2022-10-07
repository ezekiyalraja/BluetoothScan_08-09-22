//
//  DeviceListTableViewCell.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 21/07/22.
//

import UIKit

class DeviceListTableViewCell: UITableViewCell {
    @IBOutlet weak var TagNameLable: UILabel!
    @IBOutlet weak var CheckImageview: UIImageView!
    @IBOutlet weak var Info_Button: UIButton!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var Location_Button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
