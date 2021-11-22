//
//  DocumentDirectory.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 19/11/21.
//

import Foundation
import UIKit
class documentDirectory{
    let db = DBHelper()
        func saveImageAtDocumentDirectory(image : UIImage, imageName: String){
        let document = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageurl = document.appendingPathComponent(imageName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: imageurl.path){
            do {
                
                try image.jpegData(compressionQuality: 1.0)?.write(to: imageurl)
                print("image added successfully")
    
                
                
            }catch{
                print("error saving imge to document", error)
            }
        }
    }
}
