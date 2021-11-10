//
//  dbHelper.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 10/11/21.
//
import Foundation
import SQLite3

class DBHelper{
    var db: OpaquePointer?
    var path = "myDB.sqlite"
    
    
    init() {
        self.db = createDB()
    }
    
    func createDB() -> OpaquePointer?{
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("there is error in creating Database")
            return nil
        } else {
            print("DB has been created")
            return db
        }
    }
    
    
    func createTable(){
        let createTableString = "CREATE TABLE IF NOT EXISTS credentials(username TEXT PRIMARY KEY,email TEXT,password TEXT);"
               var createTableStatement: OpaquePointer? = nil
               if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
               {
                   if sqlite3_step(createTableStatement) == SQLITE_DONE
                   {
                       print("person table created.")
                   } else {
                       print("person table could not be created.")
                   }
               } else {
                   print("CREATE TABLE statement could not be prepared.")
               }
               sqlite3_finalize(createTableStatement)
        
    }
    func read() -> [Credentials] {
           let queryStatementString = "SELECT * FROM credentials;"
           var queryStatement: OpaquePointer? = nil
           var credentials : [Credentials] = []
           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                   let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                
                
                  let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
                   credentials.append(Credentials(username: username, email: email, password: password))
                   print("Query Result:")
                   print("\(username) | \(email) | \(password)")
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           return credentials
       }
    
    
    func insert(){
        
    }
}

