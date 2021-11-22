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
        tableView.delegate = self
        
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
        vc.selectedCategoryId = categoryID
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

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ToDoTableViewCell
        cell.textLabel?.text = todos[indexPath.row].todoText
        cell.accessoryType = todos[indexPath.row].isCompleted == 0 ? .none: .checkmark
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let vc = AddTodoViewController()
            vc.editEnable = true
            if let credentialId = Universal.credentialID, let categoryId = self.categoryID{
                vc.oldTodo = Todo(todoID: self.todos[indexPath.row].todoID, todoText: self.todos[indexPath.row].todoText, isCompleted: self.todos[indexPath.row].isCompleted, credentialID: credentialId, categoryID: categoryId, dueDate: self.todos[indexPath.row].dueDate)
            }
            
            vc.selectedCategoryId = self.categoryID
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [action])
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
