//
//  ToDoViewController.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 12/11/21.
//

import UIKit

class ToDoViewController: UIViewController {
    
    var db = DBHelper()
    var todos:[Todo] = []
    var categoryID: Int?
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.register(ToDoTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    lazy var addTodoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Todo", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(todoAddButtonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(addTodoButton)
        setupView()
        tableView.dataSource = self
        
        navigationItem.title = "Todo"
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        if let categoryID = categoryID, let credentialId = Universal.credentialID{
            todos = db.readTodoTable(categoryID: categoryID, credentialID: credentialId)
        }
        tableView.reloadData()
    }
    
    @objc fileprivate func todoAddButtonPressed(){
        let vc = AddTodoViewController()
        vc.credentialID = Universal.credentialID
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

extension ToDoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ToDoTableViewCell
        cell.textLabel?.text = todos[indexPath.row].todoText
        cell.accessoryType = todos[indexPath.row].isCompleted == 0 ? .none: .checkmark
        return cell
    }
    
    
}



extension ToDoViewController {
    func setupView() {
        addTodoButton.topToSuperview(offset: 12, usingSafeArea: true)
        addTodoButton.rightToSuperview(offset: -12, usingSafeArea: true)
        addTodoButton.width(150)
        tableView.topToBottom(of: addTodoButton, offset: 10)
        tableView.edgesToSuperview(excluding: .top, usingSafeArea: true)
    }
}



class ToDoTableViewCell: UITableViewCell{
    
}
