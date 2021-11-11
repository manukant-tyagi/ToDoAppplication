//
//  Credentials.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 10/11/21.
//

import Foundation
class Credentials{
    var userId: Int
    var username: String
    var email: String
    var password: String
    init(userId: Int, username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
        self.userId = userId
    }
}
