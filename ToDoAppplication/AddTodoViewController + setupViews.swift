//
//  File.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 17/11/21.
//

import UIKit
import TinyConstraints
extension AddTodoViewController{
    func setupview(){
        view.backgroundColor = .white
        view.addSubview(categoryStackView)
        view.addSubview(todoStackView)
        view.addSubview(dueDateStackView)
        view.addSubview(collectionContainerView)
        view.addSubview(addImageButton)
        view.addSubview(saveButton)

        
    

        collectionContainerView.addSubview(ImageCollectionView)
        
        saveButton.bottomToSuperview(offset: -40, usingSafeArea: true)
        saveButton.centerXToSuperview()
        saveButton.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 50))
        
        addImageButton.topToBottom(of: ImageCollectionView, offset: -60)
        addImageButton.size(CGSize(width: 50, height: 50))
        addImageButton.leadingToTrailing(of: ImageCollectionView, offset: -60)
        
        collectionContainerView.topToBottom(of: dueDateStackView, offset: 20)
        collectionContainerView.centerXToSuperview()
        collectionContainerView.size(CGSize(width: UIScreen.main.bounds.width - 20, height: 80))
//        ImageCollectionView.centerXToSuperview()

        
        dueDateStackView.topToBottom(of: todoStackView, offset: 20)
        dueDateStackView.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 50))
        dueDateStackView.centerXToSuperview()
        
        categoryStackView.topToSuperview(offset: 20, usingSafeArea: true)
        categoryStackView.centerXToSuperview()
        selectCategoryTextfield.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 50))
        
        todoStackView.topToBottom(of: categoryStackView, offset: 20)
        todoStackView.centerXToSuperview()
        todoTitle.size(CGSize(width: UIScreen.main.bounds.width - 100, height: 50))
    }
}
