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
    firstNameErrorLabel.width(UIScreen.main.bounds.width - 40)
    lastNameErrorLabel.width(UIScreen.main.bounds.width - 40)
    emailErrorLabel.width(UIScreen.main.bounds.width - 40)
    passwordErrorLabel.width(UIScreen.main.bounds.width - 40)
    confirmPasswordErrorLabel.width(UIScreen.main.bounds.width - 40)
    emailTextField.size(CGSize(width: UIScreen.main.bounds.width - 40, height: 40))
    passwordTextField.size(CGSize(width: UIScreen.main.bounds.width - 40, height: 40))
    confirmPasswordTextField.size(CGSize(width: UIScreen.main.bounds.width - 40, height: 40))
    firstNameTextField.size(CGSize(width: UIScreen.main.bounds.width - 40, height: 40))
    lastNameTextField.size(CGSize(width: UIScreen.main.bounds.width - 40, height: 40))
    signUpButton.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 40))
    }
}
