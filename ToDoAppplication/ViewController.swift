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
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(loginAndRegisterButtonStackView)
        stackView.addArrangedSubview(forgotPassWordButton)
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var loginAndRegisterButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(loginButton)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        return stackView
    }()
    
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "This is error label"
        label.textAlignment = .right
        label.isHidden = true
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
    
    lazy var usernameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var passwordTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var forgotPassWordButton: UIButton = {
        let button = UIButton()
        button.setTitle("forgot Password?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(forgotButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: View Controller Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textFieldStackView)
        setupview()
        // Do any additional setup after loading the view.
    }

    @objc fileprivate func forgotButtonPressed(){
        print(dbHelper.read())
        if let username = usernameTextField.text, let password = passwordTextField.text{
            dbHelper.update(username: username, password: password)
            errorLabel.text = "Updated password"
            errorLabel.textColor = .green
            print(dbHelper.read())
        }
        
        
    }
    
    @objc fileprivate func loginButtonPressed(){
        errorLabel.isHidden = false
        credentials = dbHelper.read()
        for c in credentials{
            if c.username == usernameTextField.text{
                if c.password == passwordTextField.text{
                    errorLabel.text = "Approved Login"
                    errorLabel.textColor = .green
                    return
                }else{
                    errorLabel.text = "Incorrect Password"
                    errorLabel.textColor = .red
                    return
                }
            }else{
                errorLabel.text = "username not found"
                errorLabel.textColor = .red
            }
            
        }
        
        
    }
    
    @objc fileprivate func registerButtonPressed(_ sender: UIButton){
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

