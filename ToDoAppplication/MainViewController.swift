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
    var UserID: Int?
    var categories: [Categories] = []
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.register(categoriesTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Add Categories", for: .normal)
        button.addTarget(self, action: #selector(addCategoriesButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let userId = UserID{
            categories = dbHelper.readCategoryTable(userID: userId)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        view.addSubview(addCategoryButton)
        view.addSubview(tableView)
        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    @objc fileprivate func addCategoriesButtonPressed(){
        let vc = AddAndEditCategoryViewController()
        vc.completionHandler = { (text) in
            guard let userId = self.UserID else {return}
            self.dbHelper.insertCategory(userID: userId, categoryName: text)
            self.categories = self.dbHelper.readCategoryTable(userID: userId)
            self.tableView.reloadData()
            print(text)
        }
        navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func didTapEditButton(text: String) {
        let vc = AddAndEditCategoryViewController()
        vc.text = text
        
        vc.isEditEnable = true
        
        vc.completionHandler = { (newText) in
            guard let userID = self.UserID else {return}
            self.dbHelper.updateCategory(userId: userID, changeCategory: text, toNewCategory: newText)
            self.categories = self.dbHelper.readCategoryTable(userID: userID)
            self.tableView.reloadData()
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
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! categoriesTableViewCell
        cell.textLabel?.text = categories[indexPath.row].categoryName
        cell.editImageView.image = #imageLiteral(resourceName: "images")
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    
}

import TinyConstraints
class categoriesTableViewCell: UITableViewCell{
    
    var delegate: categoryTableViewCellDelegate?
    lazy var editImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: "cell")
        isUserInteractionEnabled = true
        addSubview(editImageView)
        addSubview(editButton)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func editButtonPressed(){
        delegate?.didTapEditButton(text: textLabel?.text ?? "")
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
        
        
        editImageView.size(CGSize(width: 20, height: 20))
        editImageView.rightToSuperview(offset: -10, usingSafeArea: true)
        editImageView.centerYToSuperview()
    }
}
