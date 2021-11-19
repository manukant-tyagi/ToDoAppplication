//
//  Credentials.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 10/11/21.
//

import Foundation
class Credentials{
    var credentialID: Int
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    init(credentialID: Int, firstName: String, lastName: String, email: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.credentialID = credentialID
    }
}
