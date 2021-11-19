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
        createTodoTable()
    }
    
    func createDB() -> OpaquePointer?{
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        let docsDir = dirPaths[0]

        print(docsDir)
        
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
        let createTableString = "CREATE TABLE IF NOT EXISTS credentials(credentialID Integer Primary Key AutoIncrement, firstName VARCHAR, lastName VARCHAR ,email VARCHAR, password VARCHAR, createdAt DATETIME, updatedAt DATETIME);"
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
    
    
    
    func read(email: String) -> [Credentials] {
        let queryStatementString = "SELECT * FROM credentials WHERE email = '\(email.lowercased())';"
           var queryStatement: OpaquePointer? = nil
           var credentials : [Credentials] = []
           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let id = sqlite3_column_int(queryStatement, 0)
                   let firstName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                let lastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                  let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                
                credentials.append(Credentials(credentialID: Int(id), firstName: firstName, lastName: lastName, email: email, password: password))
                   print("Query Result:")
                   print("\(firstName)| \(lastName) | \(email) | \(password)")
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           return credentials
       }
    
    
    func insert(firstName: String, lastName: String, email: String, password: String) -> Bool {
        
        let credentials = read(email: email.lowercased())
        if credentials.count > 0 {
            return false
        }
            let query = "INSERT INTO credentials (firstName, lastName, email, password, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, (firstName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (lastName as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (email.lowercased() as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, (password as NSString).utf8String, -1, nil)
                sqlite3_bind_double(insertStatement, 5, Date().timeIntervalSinceReferenceDate)
                sqlite3_bind_null(insertStatement, 6)
                
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                    
                } else {
                    print("Could not insert row.")
                    return false
                }
            } else {
                print("INSERT statement could not be prepared.")
                return false
            }
            sqlite3_finalize(insertStatement)
        return true
        }
    
    
    
    func update(email: String, password: String) -> Bool {
        let query = "UPDATE credentials SET password = '\(password)', updatedAt = '\(Date().timeIntervalSinceReferenceDate)' WHERE email = '\(email.lowercased())';"
        
        let array = read(email: email.lowercased())
        if array.count == 0{
            return false
        }
            var statement : OpaquePointer? = nil
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Data updated success")
                }else {
                    print("Data is not updated in table")
                    return false
                }
            }
        return true
        }
    
    
    
    func createCategoryTable(){
        let query = "CREATE TABLE IF NOT EXISTS categories(categoryID Integer Primary Key AutoIncrement, credentialID Integer, categoryName  VARCHAR, createdAt DATETIME, updatedAt DATETIME);"
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
    
    func readCategoryTable(credentialID: Int) -> [Categories]{
        let query = "SELECT * FROM categories where credentialID = '\(credentialID)';"
        var queryStaatement:OpaquePointer? = nil
        var categories : [Categories] = []
        if sqlite3_prepare_v2(db, query, -1, &queryStaatement, nil) == SQLITE_OK{
            while sqlite3_step(queryStaatement) == SQLITE_ROW{
                let categoryName = String(describing: String(cString: sqlite3_column_text(queryStaatement, 2)))
                let createdTime = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStaatement, 3))
                let updatedTime = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStaatement, 4))
                  print(createdTime)
                print(updatedTime)
                let id = sqlite3_column_int(queryStaatement, 0)
                categories.append(Categories(id: Int(id), category: categoryName))
                
            }
        }else{
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStaatement)
        return categories
        
    }
    
    
    
    func insertCategory(credentialID: Int, categoryName: String) -> Bool{
        
        let categories = readCategoryTable(credentialID: credentialID)
        for c in categories{
            if c.categoryName == categoryName{
                return false
            }
        }
        
        let query = "INSERT INTO categories(credentialID, categoryName, createdAt, updatedAt) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK{
            sqlite3_bind_int(insertStatement, 1, Int32(credentialID))
            sqlite3_bind_text(insertStatement, 2, (categoryName as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 3, Date().timeIntervalSinceReferenceDate)
            sqlite3_bind_null(insertStatement, 4)
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Successfully inserted row")
            }else{
                print("Could not insert row.")
                return false
            }
            
        }else{
            print("INSERT statement could not be prepared.")
            return false
            
        }
        sqlite3_finalize(insertStatement)
        return true
    }
    
    
    
    
    func updateCategory(credentialID: Int, changeCategory categoryName: String,toNewCategory newCategoryName: String) -> Bool{
        let categories = readCategoryTable(credentialID: credentialID)
        for c in categories{
            if c.categoryName == newCategoryName{
                return false
            }
        }
        let query = "UPDATE categories SET categoryName = '\(newCategoryName)', updatedAt = '\(Date().timeIntervalSinceReferenceDate)' WHERE categoryName = '\(categoryName)' AND credentialID = '\(credentialID)';"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Data updated success")
            }else{
                print("Data is not updated in table")
            }
        }
        return true
    }
    
    func deleteByCategory(credentialID: Int, categoryName: String) {
            let deleteStatementStirng = "DELETE FROM categories WHERE credentialID = '\(credentialID)' AND categoryName = '\(categoryName)';"
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
//                sqlite3_bind_int(deleteStatement, 1, Int32(id))
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
    
    
    

}

extension DBHelper{
    
    func createTodoTable(){
        
        let query = "CREATE TABLE IF NOT EXISTS todos(todoID Integer Primary Key AutoIncrement, categoryID Integer, credentialID Integer, todoName VARCHAR, isCompleted INTEGER, dueDate String, createdAt DATETIME, updatedAt DATETIME);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare(db, query, -1, &createTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("Todo table created")
            }else{
                print("todo table could not be created")
            }
        }else{
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
        
    }
    
    
    
//    func readCategoryTable(credentialID: Int) -> [Categories]{
//        let query = "SELECT * FROM categories where credentialID = '\(credentialID)';"
//        var queryStaatement:OpaquePointer? = nil
//        var categories : [Categories] = []
//        if sqlite3_prepare_v2(db, query, -1, &queryStaatement, nil) == SQLITE_OK{
//            while sqlite3_step(queryStaatement) == SQLITE_ROW{
//                let categoryName = String(describing: String(cString: sqlite3_column_text(queryStaatement, 2)))
//                let createdTime = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStaatement, 3))
//                let updatedTime = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStaatement, 4))
//                  print(createdTime)
//                print(updatedTime)
//                let id = sqlite3_column_int(queryStaatement, 0)
//                categories.append(Categories(id: Int(id), category: categoryName))
//
//            }
//        }else{
//            print("SELECT statement could not be prepared")
//        }
//        sqlite3_finalize(queryStaatement)
//        return categories
//
//    }
    
    func readTodoTable(categoryID: Int, credentialID: Int) -> [Todo]{
        let query = "SELECT * FROM todos where categoryID = '\(categoryID)' AND credentialID = '\(credentialID)';"
        var queryStatement: OpaquePointer? = nil
        var todos : [Todo] = []
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK{
            while sqlite3_step(queryStatement) == SQLITE_ROW{
                let todoID = Int(sqlite3_column_int(queryStatement, 0))
                let categoryId = Int(sqlite3_column_int(queryStatement, 1))
                let credentialId = Int(sqlite3_column_int(queryStatement, 2))
                let todoName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let isCompleted: Int = Int(sqlite3_column_int(queryStatement, 4))
                let dueDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                todos.append(Todo(todoID: todoID, todoText: todoName, isCompleted: isCompleted, credentialID: credentialId, categoryID: categoryId, dueDate: dueDate))
                
                print(" \(todoID) | \(todoName) | \(credentialId) | \(categoryId)")
            }
        }else{
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return todos
    }
    

    
    
    
    func insertTodo(categoryID: Int, credentialID: Int, todoName: String, isCompleted: Int, dueDate: String) -> Bool{
        let todos = readTodoTable(categoryID: categoryID, credentialID: credentialID)
        for t in todos {
            if t.todoText == todoName{
                return false
            }
        }
        
        let query = "INSERT INTO todos(categoryID, credentialID, todoName, isCompleted, dueDate, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK{
            sqlite3_bind_int(insertStatement, 1, Int32(categoryID))
            sqlite3_bind_int(insertStatement, 2, Int32(credentialID))
            sqlite3_bind_text(insertStatement, 3, (todoName as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(isCompleted))
            sqlite3_bind_text(insertStatement, 5, (dueDate as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 5, Date().timeIntervalSinceReferenceDate)
            sqlite3_bind_null(insertStatement, 6)
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("successfully inserted row")
            }else{
                print("Could not insert row")
                return false
            }
        }else{
            print("INSERT statement could not be prepared")
            return false
        }
        sqlite3_finalize(insertStatement)
        return true
    }
    
    
    
//    func updateCategory(credentialID: Int, changeCategory categoryName: String,toNewCategory newCategoryName: String) -> Bool{
//        let categories = readCategoryTable(credentialID: credentialID)
//        for c in categories{
//            if c.categoryName == newCategoryName{
//                return false
//            }
//        }
//        let query = "UPDATE categories SET categoryName = '\(newCategoryName)', updatedAt = '\(Date().timeIntervalSinceReferenceDate)' WHERE categoryName = '\(categoryName)' AND credentialID = '\(credentialID)';"
//        var statement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
//            if sqlite3_step(statement) == SQLITE_DONE{
//                print("Data updated success")
//            }else{
//                print("Data is not updated in table")
//            }
//        }
//        return true
//    }
    
    
    
}

extension DBHelper{
    
    func createImageTable(){
    let query = "CREATE TABLE IF NOT EXISTS images(imageID integer Primary key AutoIncrement, todoID Integer, categoryID Integer, credentialID Integer, imageName varchar, createdAt DATETIME, updatedAt DATETIME);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &createTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("images table created")
            }else{
                print("images table could not be created")
            }
        }else{
            print("create table statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    
//    func readTodoTable(categoryID: Int, credentialID: Int) -> [Todo]{
//        let query = "SELECT * FROM todos where categoryID = '\(categoryID)' AND credentialID = '\(credentialID)';"
//        var queryStatement: OpaquePointer? = nil
//        var todos : [Todo] = []
//        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK{
//            while sqlite3_step(queryStatement) == SQLITE_ROW{
//                let todoID = Int(sqlite3_column_int(queryStatement, 0))
//                let categoryId = Int(sqlite3_column_int(queryStatement, 1))
//                let credentialId = Int(sqlite3_column_int(queryStatement, 2))
//                let todoName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
//                let isCompleted: Int = Int(sqlite3_column_int(queryStatement, 4))
//                let dueDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
//                todos.append(Todo(todoID: todoID, todoText: todoName, isCompleted: isCompleted, credentialID: credentialId, categoryID: categoryId, dueDate: dueDate))
//
//                print(" \(todoID) | \(todoName) | \(credentialId) | \(categoryId)")
//            }
//        }else{
//            print("SELECT statement could not be prepared")
//        }
//        sqlite3_finalize(queryStatement)
//        return todos
//    }
    
//    func readImagesTable(credentialId: Int, categoryId: Int, todoId: Int) -> [Image]{
//        let query = "SELECT * FROM images where todoID = '\(todoId)' AND categoryID = '\(categoryId)' AND credentialID = '\(credentialId)'"
//        var readTableStatement: OpaquePointer? = nil
//        var images : [Image] = []
//        
//    }
}

