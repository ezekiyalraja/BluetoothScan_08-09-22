//
//  Objects.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 27/08/22.
//

import Foundation
import UIKit

struct PheripheralObj
{
    var id = Int()
    var name = String()
    var identifier = String()
    var distance = Double()
    var rssi = Int()
    var InfoButton = UIButton()
    var BviewLable = UILabel()
    var DistanceLable = UILabel()
    var TagImageView = UIImageView()
    var positionTag = 0
    var checkTag = 0
    var soundTag = 0
    var TagImage = UIImage()
    var Latitude = Double()
    var Longitude = Double()
    var registerDateTime = String()
    var LostAssetTag = 0
    var Notes = String()
}
struct RegisterObject
{
    var phonenumber = String()
    var password = String()
}
struct DeviceUpdate
{
    var Identifier = String()
    var Coordinates = String()
    var DateTime = String()
}
struct Reference
{
    var Identifier = String()
    var Name = String()
    var Distance = Double()
    var Coordinates = String()
    var DateTime = String()
}
