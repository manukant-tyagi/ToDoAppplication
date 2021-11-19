//
//  AddAndEditCategoryViewController.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 11/11/21.
//

import UIKit

class AddAndEditCategoryViewController: UIViewController {
    var text: String = ""
    var isEditEnable = false
    var completionHandler :((String) -> ())?
    
    lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.text = text
        textField.placeholder = "Add Category"
        textField.addTarget(self, action: #selector(didStartEditng), for: .editingChanged)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "This field should not be empty"
        label.textAlignment = .left
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
        lazy var addAndEditButton: UIButton = {
        let button = UIButton()
            isEditEnable ? button.setTitle("Edit", for: .normal): button.setTitle("Add", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(addAndEditButtonPressed), for: .touchUpInside)
        return button
    }()
        lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
            view.spacing = 5
        view.addArrangedSubview(categoryTextField)
            view.addArrangedSubview(errorLabel)
            view.addArrangedSubview(addAndEditButton)
        return view
    }()
//    let c

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        view.backgroundColor = .white
        setupView()

        // Do any additional setup after loading the view.
    }
    
    
    @objc fileprivate func didStartEditng(){
        errorLabel.isHidden = true
    }
    
    @objc fileprivate func addAndEditButtonPressed(){
        if let text = categoryTextField.text{
            if text != "" {
                completionHandler?(text)
            }else {
                errorLabel.isHidden = false
                return
            }
            
            
        }
        navigationController?.popViewController(animated: false)
        
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
