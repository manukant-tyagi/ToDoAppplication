//
//  RegisterViewController.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 09/11/21.
//

import UIKit

class RegisterViewController: UIViewController {
    var dbHelper = DBHelper()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(userNameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(signUpButton)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
//    lazy var firstNameTextField: UITextField = {
//        let textField = UITextField()
//        return textField
//    }()
//
//    lazy var lastNametextField: UITextField = {
//        let textField = UITextField()
//        return textField
//    }()
//
//    lazy var phoneNumberTextField: UITextField = {
//        let textField = UITextField()
//        return textField
//    }()
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .right
        label.text = "This is error label"
        label.isHidden = true
        return label
    }()
    lazy var userNameTextField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Username"
        return textField
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email Address"
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New Password"
        return textField
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(signupButtonPressed), for: .touchUpInside)
        
        return button
    }()
     
//    lazy var firstNameLabel : UILabel = {
//        let label = UILabel()
//        label.text = "First Name"
//        return label
//    }()
//
//    lazy var lastNameLabel : UILabel = {
//        let label = UILabel()
//        label.text = "Last Name"
//        return label
//    }()
//
//    lazy var phoneNumberLabel : UILabel = {
//       let label = UILabel()
//        label.text = "Phone Number"
//        return label
//    }()
//
//    lazy var emailLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Email"
//        return label
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SignUp"
        view.backgroundColor = .white
        view.addSubview(stackView)
        setupView()
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func signupButtonPressed(){
        errorLabel.isHidden = false
        if userNameTextField.text == "" {
            errorLabel.text = "Please enter the username"
            errorLabel.textColor = .red
            return
        }
        
        if emailTextField.text == "" {
            errorLabel.text = "Please enter the email adderess"
            errorLabel.textColor = .red
            return
        }
        
        if passwordTextField.text == ""{
            errorLabel.text = "Please enter the new password"
            errorLabel.textColor = .red
            return
        }
        if let username = userNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text{
            dbHelper.insert(username: username, email: email, password: password)
            errorLabel.textColor = .green
            errorLabel.text = "Resgister successfully"
        }
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
