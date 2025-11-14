//
//  DBManager.swift
//  eServiceDemoApp
//
//  Created by Bhavik Baraiya on 12/11/25.
//

import Foundation
import SQLite

class DBManager {

    static let shared = DBManager()
    private let db : Connection
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask, true
        ).first!
        print("DB Connection Location : \(path)/eServiceAppDB.db")
        db = try! Connection("\(path)/OrderDatabase.db")
    }
    
    func getDb() -> Connection {
        return db
    }
}
