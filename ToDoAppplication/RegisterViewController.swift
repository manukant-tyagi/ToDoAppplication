//
//  RegisterViewController.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 09/11/21.
//

import UIKit

class RegisterViewController: UIViewController {
    var dbHelper = DBHelper()
    var isAllFieldsOK : Bool = false
    
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(firstNameErrorLabel)
        stackView.addArrangedSubview(lastNameTextField)
        stackView.addArrangedSubview(lastNameErrorLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(emailErrorLabel)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordErrorLabel)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(confirmPasswordErrorLabel)
        stackView.addArrangedSubview(signUpButton)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
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
    

    lazy var firstNameTextField : UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.placeholder = "First Name"
        return textField
    }()
    
    
    var firstNameErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .right
        label.text = "Please enter the first name"
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    
    
    lazy var lastNameTextField : UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Last Name"
        return textField
    }()
    
    var lastNameErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .right
        label.text = "Please enter the last name"
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email Address"
        return textField
    }()
    
    
    var emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .right
        label.text = "Please enter the firstName"
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "New Password"
        return textField
    }()
    
    
    var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .right
        label.text = "This is error label"
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    
    
    lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(didStartEditing), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Confirm Password"
        return textField
    }()
    
    
    
    var confirmPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .right
        label.text = "This is error label"
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(signupButtonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SignUp"
        view.backgroundColor = .white
        view.addSubview(stackView)
        setupView()
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func didStartEditing(){
//        errorLabel.alpha = 0
    }
   
    
    @objc fileprivate func signupButtonPressed(){
        firstNameErrorLabel.isHidden = true
        lastNameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
        isAllFieldsOK = true
        if firstNameTextField.text == "" {
            firstNameErrorLabel.isHidden = false
            isAllFieldsOK = false
        }
        
        if lastNameTextField.text == "" {
            lastNameErrorLabel.isHidden = false
            isAllFieldsOK = false
        }
        
        if emailTextField.text == "" {
            emailErrorLabel.isHidden = false
            emailErrorLabel.text = "Please enter the email adderess"
            isAllFieldsOK = false
            
        }else if !Universal.isValidEmail(emailTextField.text ?? ""){
            emailErrorLabel.isHidden = false
            isAllFieldsOK = false
            emailErrorLabel.text = "Please enter the valid email adderess"
        }
        
        if passwordTextField.text == ""{
            passwordErrorLabel.isHidden = false
            isAllFieldsOK = false
            passwordErrorLabel.text = "Please enter the new password"
        }else if !Universal.isValidPassword(password: passwordTextField.text ?? ""){
            passwordErrorLabel.isHidden = false
            isAllFieldsOK = false
            passwordErrorLabel.text = "Password should contain at least 8 characters, 1 alphabet, 1 number and 1 special character"
        }
        
        
        
        if confirmPasswordTextField.text == ""{
            isAllFieldsOK = false
            confirmPasswordErrorLabel.text = "Please enter the confirm password"
            confirmPasswordErrorLabel.isHidden = false
            
        } else if confirmPasswordTextField.text != passwordTextField.text{
            confirmPasswordErrorLabel.text = "Password Doesn't Match"
            isAllFieldsOK = false
            confirmPasswordErrorLabel.isHidden = false
        }
        
        if !isAllFieldsOK{
            return
        }
        
        if let firstName = firstNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let lastName = lastNameTextField.text{
            let isInserted = dbHelper.insert(firstName: firstName, lastName: lastName,  email: email, password: password)
            if isInserted{
                let alert = UIAlertController(title: "Register successfully", message: "", preferredStyle: .alert)
                
                let anotherAction = UIAlertAction(title: "Login", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(anotherAction)
                
                self.present(alert, animated: true, completion: nil)
            }else {
                emailErrorLabel.isHidden = false
                emailErrorLabel.text = "Email is already exist"
            }
            
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
