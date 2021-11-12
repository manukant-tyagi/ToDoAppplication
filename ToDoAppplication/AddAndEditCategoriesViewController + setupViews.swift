//
//  AddAndEditCategoriesViewController + setupViews.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 11/11/21.
//

import Foundation
import TinyConstraints
extension AddAndEditCategoryViewController{
    func setupView(){
        stackView.centerInSuperview()
        addAndEditButton.size(CGSize(width: UIScreen.main.bounds.width - 300, height: 40))
        categoryTextField.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 50))
    }
}
