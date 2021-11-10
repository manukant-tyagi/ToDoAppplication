//
//  RegisterViewController.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 09/11/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(userNameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
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
        view.backgroundColor = .white
        view.addSubview(stackView)
        setupView()
        // Do any additional setup after loading the view.
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
