//
//  RegisterViewController + setupViews.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 09/11/21.
//

import TinyConstraints
extension RegisterViewController{
    
   func setupView(){
    stackView.centerInSuperview()
    emailTextField.size(CGSize(width: UIScreen.main.bounds.width - 40, height: 40))
    passwordTextField.size(CGSize(width: UIScreen.main.bounds.width - 40, height: 40))
    userNameTextField.size(CGSize(width: UIScreen.main.bounds.width - 40, height: 40))
    signUpButton.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 40))
    }
}
