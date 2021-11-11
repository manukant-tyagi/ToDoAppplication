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
        createTable()
        createCategoryTable()
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
        let createTableString = "CREATE TABLE IF NOT EXISTS credentials(userID Integer Primary Key AutoIncrement, username TEXT,email TEXT, password TEXT);"
               var createTableStatement: OpaquePointer? = nil
               if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
               {
                   if sqlite3_step(createTableStatement) == SQLITE_DONE
                   {
                       print("credential table created.")
                   } else {
                       print("credential table could not be created.")
                   }
               } else {
                   print("CREATE TABLE statement could not be prepared.")
               }
               sqlite3_finalize(createTableStatement)
        
    }
    func createCategoryTable(){
        let query = "CREATE TABLE IF NOT EXISTS category(categoryID Integer Primary Key AutoIncrement, userID Integer, categoryName TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &createTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("Category table created")
            }else{
                print("Category table could not be created.")
            }
        }else{
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func readCategoryTable(userID: Int) -> [Categories]{
        let query = "SELECT * FROM category where userID = '\(userID)';"
        var queryStaatement:OpaquePointer? = nil
        var categories : [Categories] = []
        if sqlite3_prepare_v2(db, query, -1, &queryStaatement, nil) == SQLITE_OK{
            while sqlite3_step(queryStaatement) == SQLITE_ROW{
                let categoryName = String(describing: String(cString: sqlite3_column_text(queryStaatement, 2)))
                let id = sqlite3_column_int(queryStaatement, 0)
                categories.append(Categories(id: Int(id), category: categoryName))
                
            }
        }else{
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStaatement)
        return categories
        
    }
    
    func read(username: String , password: String) -> [Credentials] {
           let queryStatementString = "SELECT * FROM credentials WHERE username = '\(username)' AND password = '\(password)';"
           var queryStatement: OpaquePointer? = nil
           var credentials : [Credentials] = []
           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let id = sqlite3_column_int(queryStatement, 0)
                   let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                
                  let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
                credentials.append(Credentials(userId: Int(id), username: username, email: email, password: password))
                   print("Query Result:")
                   print("\(username) | \(email) | \(password)")
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           return credentials
       }
    
    func insertCategory(userID: Int, categoryName: String){
        
        let categories = readCategoryTable(userID: userID)
        for c in categories{
            if c.categoryName == categoryName{
                return
            }
        }
        
        let query = "INSERT INTO category(userID, categoryName) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK{
            sqlite3_bind_int(insertStatement, 1, Int32(userID))
            sqlite3_bind_text(insertStatement, 2, (categoryName as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Successfully inserted row")
            }else{
                print("Could not insert row.")
            }
            
        }else{
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    func insert(username: String, email: String, password: String) {
        
        let credentials = read(username:username, password:password)
        if credentials.count > 0 {
            return
        }
            let query = "INSERT INTO credentials (username, email, password) VALUES (?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, (username as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (email as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (password as NSString).utf8String, -1, nil)
                
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
}

