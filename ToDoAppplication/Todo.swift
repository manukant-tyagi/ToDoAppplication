//
//  todo.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 16/11/21.
//

import Foundation
class Todo{
    var todoID: Int
    var todoText: String
    var isCompleted: Int
    var credentialID: Int
    var categoryID: Int
    var dueDate: String
    
    init(todoID: Int, todoText:String, isCompleted: Int, credentialID : Int, categoryID: Int, dueDate: String){
        self.todoID = todoID
        self.todoText = todoText
        self.isCompleted = isCompleted
        self.credentialID = credentialID
        self.categoryID = categoryID
        self.dueDate = dueDate
        
    }
}
