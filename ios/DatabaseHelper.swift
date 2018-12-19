//
//  DatabaseHelper.swift
//  Mast
//
//  Created by Nishant Jha on 12/17/18.
//  Copyright © 2017 Nishant Jha. All rights reserved.
//

import Foundation
import FMDB

class DatabaseHelper {
    
    private let dbFileName = "HermesDatabase.db"
    private var localDatabase:FMDatabase!
    private var remoteDatabase:FMDatabase!
    private var myAWSHelper:AWSHelper!
    
    init() {
        self.myAWSHelper = AWSHelper()
        _ = loadLocalDatabase()
        //_ = loadRemoteDatabase() // Loads everytime - consider optimizing
    }
    
    func updateLocalDatabase() {
        debugPrint("Updating!")
    }
    
//    func loadRemoteDatabase() -> Bool{
//        let s3BucketName = "mast-assets"
//        let s3KeyName = "database/Allergens.db"
//        let fileUrl: String = Bundle.main.path(forResource: "Allergens", ofType: "db")!
//        myAWSHelper.downloadFromS3(s3BucketName: s3BucketName, s3KeyName: s3KeyName, fileURL: fileUrl)
//        return true
//    }
    
    func loadLocalDatabase() -> Bool{
        let dbPath = Bundle.main.url(forResource: "Hermes", withExtension: "db")
        let database = FMDatabase(path: dbPath!.absoluteString)
        /* Open database read-only. */
        if (!database.open(withFlags: 1)) {
            print("Could not open database at \(dbPath!.absoluteString).")
            return false
        } else {
            self.localDatabase = database;
            return true
        }
    }
    
    func reloadDatabase(db:FMDatabase) {
        db.close()
        _ = loadLocalDatabase()
    }
    
    func runQueryGetAllergens(queryString:String) -> [[String]] {
        var response = [[String]]()
        do {
            let rs = try localDatabase.executeQuery(queryString, values: nil)
            while rs.next() {
                var entry = [String]()
                entry.append(rs.string(forColumn: "Name")!)
                entry.append(rs.string(forColumn: "Source")!)
                entry.append(rs.string(forColumn: "Order")!)
                entry.append(rs.string(forColumn: "Species")!)
                entry.append(rs.string(forColumn: "BiochemicalName")!)
                entry.append(rs.string(forColumn: "MW(SDS-PAGE)")!)
                entry.append(rs.string(forColumn: "Allergenicity")!)
                entry.append(rs.string(forColumn: "Allergenicityref.:")!)
                entry.append(rs.string(forColumn: "FoodAllergen")!)
                entry.append(rs.string(forColumn: "PDBID") ?? "None")
                entry.append(rs.string(forColumn: "Sold") ?? "No" )
                entry.append(rs.string(forColumn: "Category") ?? "None")
                entry.append(rs.string(forColumn: "Sponsor") ?? "None")
                response.append(entry)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        return response
    }
    
    func buildAllergenQuery(query: String, fields: [String]) -> String {
        
        var sql = "SELECT * FROM Allergens WHERE \"" + fields[0] + "\" LIKE '%" + query
        
        for field in fields.dropFirst() {
            sql += "%' OR \"" + field + "\" LIKE '%" + query
        }
        sql += "%'"
        debugPrint("SQL Query: " + sql)
        return sql
    }
}

