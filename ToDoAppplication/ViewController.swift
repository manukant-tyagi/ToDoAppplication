//
//  ViewController.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 09/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    var credentials:[Credentials] = []
    var dbHelper = DBHelper()
    
    
    //MARK: Properties
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(LogoImageView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(forgotPassWordButton)
        stackView.addArrangedSubview(registerButton)
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "This is error label"
        label.textAlignment = .right
        label.alpha = 0.0
        return label
    }()
    
    lazy var LogoImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "logo")
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 100
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var emailTextField : UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var forgotPassWordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(forgotButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("New? Create an account.", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
//        button.layer.cornerRadius = 5
//        button.layer.masksToBounds = true
//        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: View Controller Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
        view.backgroundColor = .white
        view.addSubview(textFieldStackView)
        setupview()
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func didStartEditing(){
        errorLabel.alpha = 0
    }

    @objc fileprivate func forgotButtonPressed(){
        errorLabel.alpha = 1
        if let email = emailTextField.text, let password = passwordTextField.text{

            if passwordTextField.text == "" {
                errorLabel.text = "Please enter the new password"
            }
            let isUpdated = dbHelper.update(email: email, password: password)
            if isUpdated {
                errorLabel.text = "Updated password"
                errorLabel.textColor = .green
            }else{
                errorLabel.text = "invalid email"
            }

        }
        
//        let vc = popupWindowController()
//        vc.modalPresentationStyle = .overCurrentContext
//        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func loginButtonPressed(){
        errorLabel.alpha = 1
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        credentials = dbHelper.read(email: email)
        if credentials.count > 0{
            if credentials[0].password == password{
                errorLabel.text = "Approved login"
                errorLabel.textColor = .green
                let vc = MainViewController()
                Universal.credentialID = credentials[0].credentialID
                navigationController?.pushViewController(vc, animated: true)
            }else{
                errorLabel.text = "password is invalid"
                errorLabel.textColor = .red
            }
        }else {
            errorLabel.text = "email is invalid"
            errorLabel.textColor = .red
        }
        
//            if c.username == usernameTextField.text{
//                if c.password == passwordTextField.text{
//                    errorLabel.text = "Approved Login"
//                    errorLabel.textColor = .green
//                    navigationController?.pushViewController(MainViewController(), animated: true)
//                    return
//                }else{
//                    errorLabel.text = "Incorrect Password"
//                    errorLabel.textColor = .red
//                    return
//                }
//            }else{
//                errorLabel.text = "username not found"
//                errorLabel.textColor = .red
//            }
//
//        }
        
        
    }
    
    @objc fileprivate func registerButtonPressed(_ sender: UIButton){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


class popupWindowController: UIViewController {
    
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(updateButton)
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    lazy var updateButton:UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(updateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "This is error label"
        label.textAlignment = .right
        label.alpha = 0.0
        return label
    }()
    
    lazy var emailTextField : UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textFieldStackView)
    }
    
    @objc fileprivate func updateButtonPressed() {
        if emailTextField.text == ""{
            errorLabel.text = "please enter the email"
            return
        }
        if  passwordTextField.text == "" {
            errorLabel.text = "Please enter the password"
            return
        }
    }
    
    @objc fileprivate func didStartEditing(){
        errorLabel.alpha = 0
    }
}



extension popupWindowController{
    
    func setupview()  {
        textFieldStackView.centerInSuperview()
        
        errorLabel.width(UIScreen.main.bounds.width - 100)
        emailTextField.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 50))
        passwordTextField.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 50))
    }
}

