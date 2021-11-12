//
//  MainViewController + setupViews.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 11/11/21.
//

import Foundation
import TinyConstraints
extension MainViewController{
    func setupView(){
        addCategoryButton.topToSuperview( offset: 12, usingSafeArea: true)
        addCategoryButton.rightToSuperview( offset: -12, usingSafeArea: true)
        addCategoryButton.height(40)
        
        noItemLabel.centerInSuperview()
        
        tableView.topToBottom(of: addCategoryButton, offset: 10)
        tableView.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), usingSafeArea: true)
    }
}
