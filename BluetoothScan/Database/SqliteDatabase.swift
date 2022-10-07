//
//  SqliteDatabase.swift
//  BluetoothScan
//
//  Created by TechUnity IOS Developer on 18/08/22.
//

import Foundation
import SQLite3
import UIKit

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "BlueToothScan.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            print("Path:- \(fileURL.path)")
            return db
        }
    }
    
    func createTable() {
        
        var createTableString = "CREATE TABLE IF NOT EXISTS RegisterTable (MobileNO TEXT, Password TEXT)"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("register table created.")
            } else {
                print("register table could not be created.")
            }
            
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        createTableString = "CREATE TABLE IF NOT EXISTS DeviceTable (MobileNO TEXT, Identifier TEXT, TagName TEXT, Image TEXT)"
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("DeviceTable table created.")
            } else {
                print("DeviceTable table could not be created.")
            }
            
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        createTableString = "CREATE TABLE IF NOT EXISTS HistoryTable (MobileNO TEXT, Identifier TEXT, TagName TEXT, Distance TEXT, Latitude Text, Longitude TEXT, NearByDevices Text, RegisterDateTime Text, LostAssetTag INTEGER, Status TEXT, Notes TEXT)"
                if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
                {
                    if sqlite3_step(createTableStatement) == SQLITE_DONE
                    {
                        print("HistoryTable table created.")
                    } else {
                        print("HistoryTable table could not be created.")
                    }
                    
                } else {
                    print("CREATE TABLE statement could not be prepared.")
                }
        createTableString = "CREATE TABLE IF NOT EXISTS DeviceUpdateTable (Identifier TEXT, Coordinates TEXT, DateandTime TEXT)"
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("DeviceTable table created.")
            } else {
                print("DeviceTable table could not be created.")
            }
            
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        createTableString = "CREATE TABLE IF NOT EXISTS ReferenceTable (Identifier TEXT, TagName TEXT, Distance TEXT, Coordinates TEXT, DateandTime TEXT, ReferenceIdentifier TEXT)"
                if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
                {
                    if sqlite3_step(createTableStatement) == SQLITE_DONE
                    {
                        print("ReferenceTable table created.")
                    } else {
                        print("ReferenceTable table could not be created.")
                    }
                    
                } else {
                    print("CREATE TABLE statement could not be prepared.")
                }
        sqlite3_finalize(createTableStatement)
        
    }
    
    
    func insertIntoRegister(MobileNo:String, Password:String)
    {

        let insertStatementString = "INSERT INTO RegisterTable (MobileNO, Password) VALUES (?,?)"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (MobileNo as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (Password as NSString).utf8String, -1, nil)
            
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertIntoDeviceTable(object: PheripheralObj, MobileNo:String, imageString: String)
    {

        let insertStatementString = "INSERT INTO DeviceTable (MobileNO, Identifier, TagName, Image) VALUES (?,?,?,?)"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (MobileNo as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (object.identifier as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (object.name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (imageString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    func insertIntoDeviceUpdateTable(ID:String, Coordinates:String, DateTime:String)
    {

        let insertStatementString = "INSERT INTO DeviceUpdateTable (Identifier, Coordinates, DateandTime) VALUES (?,?,?)"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (ID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (Coordinates as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (DateTime as NSString).utf8String, -1, nil)
            
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    func insertIntoHistoryTable(object: PheripheralObj, MobileNo:String, NearByDevices: String, Status: String)
        {

            let insertStatementString = "INSERT INTO HistoryTable (MobileNO, Identifier, TagName, Distance, Latitude, Longitude, NearByDevices, RegisterDateTime, LostAssetTag, Status, Notes) VALUES (?,?,?,?,?,?,?,?,?,?,?)"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_text(insertStatement, 1, (MobileNo as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (object.identifier as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (object.name as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, (String("\(object.distance.roundedDecimal(to: 2))") as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (String(object.Latitude) as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, (String(object.Longitude) as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 7, (NearByDevices as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 8, (object.registerDateTime as NSString).utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 9, Int32(0))
                sqlite3_bind_text(insertStatement, 10, (Status as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 11, " ", -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("HistoryTable Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
    func insertIntoReferenceTable(name: String,Identifier: String, Coordinates:String, DateTime: String, Distance: Double, ReferenceIdentifier:String)
        {

            let insertStatementString = "INSERT INTO ReferenceTable (Identifier , TagName , Distance , Coordinates , DateandTime , ReferenceIdentifier) VALUES (?,?,?,?,?,?)"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_text(insertStatement, 1, (Identifier as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (String("\(Distance.roundedDecimal(to: 2))") as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, (Coordinates as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (DateTime as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, (ReferenceIdentifier as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("HistoryTable Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
    func updateLostAssetinHistory(tag: Int, Notes: String, identifier: String){
        let updateStatementString = "UPDATE HistoryTable SET LostAssetTag = '\(tag)', Notes = '\(Notes)' WHERE Identifier = '\(identifier)';"
         var updateStatement: OpaquePointer? = nil
         if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                       print("Successfully updated row.")
                } else {
                       print("Could not update row.")
                }
              } else {
                    print("UPDATE statement could not be prepared")
              }
              sqlite3_finalize(updateStatement)
    }
    func readRegister() -> [RegisterObject] {
        let queryStatementString = "SELECT * FROM RegisterTable;"
        var queryStatement: OpaquePointer? = nil
        var obj = RegisterObject()
        var array : [RegisterObject] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                obj.phonenumber = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                obj.password = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                array.append(obj)
                print("Query Result:")
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return array
    }
    
    func readDeviceTable() -> [PheripheralObj] {
        let queryStatementString = "SELECT * FROM DeviceTable;"
        var queryStatement: OpaquePointer? = nil
        var obj = PheripheralObj()
        var array : [PheripheralObj] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                obj.identifier = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                obj.name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                obj.checkTag = 1
                obj.TagImage = loadImageFromDocumentDirectory(nameOfImage: obj.identifier)
                array.append(obj)
                print("Query Result:")
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return array
    }
    
    func readReferenceTable(DateTime: String,identifier:String) -> [Reference] {
        let queryStatementString = "SELECT * FROM ReferenceTable WHERE DateandTime = '\(DateTime)' AND ReferenceIdentifier = '\(identifier)';"
        var queryStatement: OpaquePointer? = nil
        var obj = Reference()
        var array : [Reference] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                obj.Identifier = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                obj.Name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                obj.Coordinates = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                obj.DateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                array.append(obj)
                print("Query Result:")
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return array
    }
    func readDeviceUpdateTable(identifier:String) -> [DeviceUpdate] {
        let queryStatementString = "SELECT * FROM DeviceUpdateTable WHERE Identifier = '\(identifier)';"
        var queryStatement: OpaquePointer? = nil
        var obj = DeviceUpdate()
        var array : [DeviceUpdate] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                obj.Identifier = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                obj.Coordinates = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                obj.DateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
                array.append(obj)
                print("Query Result:")
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return array
    }
    func readHistoryTable() -> [PheripheralObj] {
            let queryStatementString = "SELECT * FROM HistoryTable WHERE Status = 'Registered';"
            var queryStatement: OpaquePointer? = nil
            var obj = PheripheralObj()
            var array : [PheripheralObj] = []
           
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    obj.identifier = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    obj.name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    obj.checkTag = 1
                    obj.TagImage = loadImageFromDocumentDirectory(nameOfImage: obj.identifier)
                    obj.distance = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))) ?? 0.0
                    obj.Latitude = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))) ?? 0.0
                    obj.Longitude = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))) ?? 0.0
                    obj.registerDateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                    obj.LostAssetTag = Int(sqlite3_column_int(queryStatement, 8))
                    obj.Notes = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                    array.append(obj)
                    print("Query Result:")
                    
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
            return array
        }
    func readReferenceListFromHistoryTable() -> [PheripheralObj] {
            let queryStatementString = "SELECT * FROM HistoryTable WHERE Status = 'Not Registered';"
        var queryStatement: OpaquePointer? = nil
        var obj = PheripheralObj()
        var array : [PheripheralObj] = []
       
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                obj.identifier = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                obj.name = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                obj.checkTag = 1
//                obj.TagImage = loadImageFromDocumentDirectory(nameOfImage: obj.identifier)
                obj.distance = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))) ?? 0.0
                obj.Latitude = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))) ?? 0.0
                obj.Longitude = Double(String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))) ?? 0.0
                obj.registerDateTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                obj.LostAssetTag = Int(sqlite3_column_int(queryStatement, 8))
                array.append(obj)
                print("Query Result:")
                
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return array
        }
    
    func CheckAlreadyExists(id:String) -> Int {
            let queryStatementString = "SELECT COUNT(*) FROM HistoryTable WHERE Identifier = '\(id)';"
            var queryStatement: OpaquePointer? = nil
            var Count = Int()
            if sqlite3_prepare(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
        {
                while sqlite3_step(queryStatement) == SQLITE_ROW
                {
                    Count = Int(sqlite3_column_int(queryStatement, 0))
                }
            }
            sqlite3_finalize(queryStatement)
            return Count
        }
    func deleteByID(id:String) {
        let deleteStatementStirng = "DELETE FROM DeviceTable WHERE Identifier = '\(id)';"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
//            sqlite3_bind_int(deleteStatement, 1, Int32(id))
//            sqlite3_bind_text(db, 2, id, -1, nil)
//            sqlite3_bind_text(deleteStatement, 2, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    func UpdateHistoryTable(obj:PheripheralObj, Status: String)
    {
       let distance = String("\(obj.distance.roundedDecimal(to: 2))")
        let Lat = String(obj.Latitude)
        let Long = String(obj.Longitude)
        
        let UpdateQuery = "UPDATE HistoryTable SET TagName = '\(obj.name)', Distance = '\(distance)', Latitude = '\(Lat)', RegisterDateTime = '\(obj.registerDateTime)', Longitude = '\(Long)', Status = '\(Status)' WHERE Identifier = '\(obj.identifier)'"
        var UpdateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, UpdateQuery, -1, &UpdateStatement, nil) == SQLITE_OK {
               if sqlite3_step(UpdateStatement) == SQLITE_DONE {
                      print("Successfully updated row.")
               } else {
                      print("Could not update row.")
               }
             } else {
                   print("UPDATE statement could not be prepared")
             }
             sqlite3_finalize(UpdateStatement)
    }
    func UpdateCoordinate(Lat:String, Long: String, DateTime: String,Identifier:String)
    {
        let UpdateQuery = "UPDATE HistoryTable SET Latitude = '\(Lat)', RegisterDateTime = '\(DateTime)', Longitude = '\(Long)' WHERE Identifier = '\(Identifier)'"
        var UpdateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, UpdateQuery, -1, &UpdateStatement, nil) == SQLITE_OK {
               if sqlite3_step(UpdateStatement) == SQLITE_DONE {
                      print("Successfully updated row.")
               } else {
                      print("Could not update row.")
               }
             } else {
                   print("UPDATE statement could not be prepared")
             }
             sqlite3_finalize(UpdateStatement)
    }
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return UIImage.init(named: "default.png")!
    }
}
