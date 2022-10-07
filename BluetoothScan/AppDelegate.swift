//
//  AppDelegate.swift
//  BluetoothScan
//
//  Created by IOS Developer on 13/07/22.
//

import UIKit
import CoreLocation
import CoreData

var addStatusBar = UIView()
var db: OpaquePointer?
var locationManager = CLLocationManager()
let reloadVC = RegisteredHistoryViewController()
//let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BluetoothScanDataBase.sqlite")
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Coredata")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {

                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        print("Filepath: ", fileURL!.path)
      print("AZARUDEEN")
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        addStatusBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.size.height)
        addStatusBar.backgroundColor = UIColor(named: "Navigation color")
        self.window?.rootViewController?.view .addSubview(addStatusBar)
        return true
    }

    // MARK: UISceneSession Lifecycle

    
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

