//
//  MainViewController.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 11/11/21.
//

import UIKit
protocol categoryTableViewCellDelegate {
    func didTapEditButton(text: String)
}

class MainViewController: UIViewController, categoryTableViewCellDelegate {
   
    
    
    var dbHelper = DBHelper()
    var categories: [Categories] = []
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        return table
    }()
    
    
    lazy var noItemLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No category found"
        return label
    }()
    
    lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.setTitle("Add Categories", for: .normal)
        button.addTarget(self, action: #selector(addCategoriesButtonPressed), for: .touchUpInside)
        return button
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.title = "Category"
        navigationItem.title = "Category"
        if let credentialID = Universal.credentialID{
            categories = dbHelper.readCategoryTable(credentialID: credentialID)
        }
        tableView.register(categoriesTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
       
        view.backgroundColor = .white
        view.addSubview(addCategoryButton)
        view.addSubview(tableView)
        view.addSubview(noItemLabel)
        setupView()
        
        createLogoutButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func createLogoutButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(LogoutButtonPressed))
    }
    
    
    
    @objc func LogoutButtonPressed(){
        UserDefaults.standard.setValue(false, forKey: Constants.loginKey)
        navigationController?.setViewControllers([ViewController()], animated: false)
    }
    
    @objc fileprivate func addCategoriesButtonPressed(){
        let vc = AddAndEditCategoryViewController()
        vc.completionHandler = { (text) in
            guard let credentialID = Universal.credentialID else {return}
            let isInserted = self.dbHelper.insertCategory(credentialID: credentialID, categoryName: text)
            if isInserted{
                self.categories = self.dbHelper.readCategoryTable(credentialID: credentialID)
                self.tableView.reloadData()
            }else {
                let alert = UIAlertController(title: "This Category name is already exist", message: "", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            print(text)
        }
        navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func didTapEditButton(text: String) {
        let vc = AddAndEditCategoryViewController()
        vc.text = text
        print(text)
        
        vc.isEditEnable = true
        
        vc.completionHandler = { (newText) in
            guard let credentialID = Universal.credentialID else {return}
            let isInserted = self.dbHelper.updateCategory(credentialID: credentialID, changeCategory: text, toNewCategory: newText)
            
            if isInserted{
                self.categories = self.dbHelper.readCategoryTable(credentialID: credentialID)
                self.tableView.reloadData()
            }else {
                let alert = UIAlertController(title: "This Category name is already exist", message: "", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if categories.count > 0 {
            tableView.isHidden = false
            noItemLabel.isHidden = true
        }else{
            tableView.isHidden = true
            noItemLabel.isHidden = false
            
        }
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            guard let credentialID = Universal.credentialID else {return}
            self.deleteCategory(categoryName: self.categories[indexPath.row].categoryName, credentialID: credentialID )
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    private func deleteCategory(categoryName: String, credentialID: Int){
        let alert = UIAlertController(title: categoryName, message: "are you sure? ", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            self.dbHelper.deleteByCategory(credentialID: credentialID, categoryName: categoryName)
            self.categories = self.dbHelper.readCategoryTable(credentialID: credentialID)
            self.tableView.reloadData()
        
        }
        alert.addAction(alertAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
       
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! categoriesTableViewCell
        cell.categoryNameLabel.text = categories[indexPath.row].categoryName
        cell.editImageView.image = #imageLiteral(resourceName: "images")
        cell.editButton.tag = indexPath.row
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ToDoViewController()
        vc.categoryID = categories[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}



import TinyConstraints
class categoriesTableViewCell: UITableViewCell{
    
    var delegate: categoryTableViewCellDelegate?
    lazy var editImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: "cell")
        isUserInteractionEnabled = true
        addSubview(editImageView)
//        addSubview(editButton)
        contentView.addSubview(editButton)
        addSubview(categoryNameLabel)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func editButtonPressed(sender: UIButton){
        print("Hello Button")
        delegate?.didTapEditButton(text: categoryNameLabel.text ?? "")
    }
    
//    let cell : UITableViewCell = {
//        let cell = UITableViewCell()
//        return cell
//    }()
}


extension categoriesTableViewCell {
    
    func setupViews(){
        
        editButton.size(CGSize(width: 40, height: superview?.bounds.height ?? 20))
        editButton.centerYToSuperview()
        editButton.rightToSuperview(offset: -10, usingSafeArea: true)
        
        categoryNameLabel.leftToSuperview(offset: 10, usingSafeArea: true)
        categoryNameLabel.centerYToSuperview()
        categoryNameLabel.right(to: editButton, offset: 10)
        
        editImageView.size(CGSize(width: 20, height: 20))
        editImageView.rightToSuperview(offset: -10, usingSafeArea: true)
        editImageView.centerYToSuperview()
    }
}
