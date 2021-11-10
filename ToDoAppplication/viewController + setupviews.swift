//
//  viewController + setupviews.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 09/11/21.
//

import TinyConstraints
extension ViewController{
    func setupview()  {
        errorLabel.width(UIScreen.main.bounds.width - 50)
        usernameTextField.size(CGSize(width: UIScreen.main.bounds.width - 50, height: 50))
        passwordTextField.size(CGSize(width: UIScreen.main.bounds.width - 50, height: 50))
        loginAndRegisterButtonStackView.size(CGSize(width: UIScreen.main.bounds.width - 50, height: 40))
        textFieldStackView.centerInSuperview()
        textFieldStackView.leftToSuperview(offset: 20)
        textFieldStackView.rightToSuperview(offset: -20)
        LogoImageView.height(200)
        LogoImageView.aspectRatio(1)
        
        
    }
    
}
