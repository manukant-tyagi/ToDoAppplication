//
//  viewController + setupviews.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 09/11/21.
//

import TinyConstraints
extension ViewController{
    func setupview()  {
        usernameTextField.height(50)
        passwordTextField.height(50)
        loginAndRegisterButtonStackView.height(40)
        usernameTextField.width(UIScreen.main.bounds.width - 50)
        passwordTextField.width(UIScreen.main.bounds.width - 50)
        loginAndRegisterButtonStackView.width(UIScreen.main.bounds.width - 50)
        textFieldStackView.centerInSuperview()
        textFieldStackView.leftToSuperview(offset: 20)
        textFieldStackView.rightToSuperview(offset: -20)
        LogoImageView.height(200)
        LogoImageView.aspectRatio(1)
        
        
    }
    
}
