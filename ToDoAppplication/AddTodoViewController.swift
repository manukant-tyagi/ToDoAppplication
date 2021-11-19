//
//  AddTodoViewController.swift
//  ToDoAppplication
//
//  Created by manukant tyagi on 17/11/21.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    var credentialID: Int?
    
    var db = DBHelper()
    
    var selectedString: String?
    
    var arr:[Categories] = []
    
    var selectedCategoryId: Int?
    
    var imageArray: [UIImage] = []
    
    var datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
    
    let imagePicker = UIImagePickerController()
    
    var shouldSave = false
    
    lazy var categoryStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.addArrangedSubview(selectCategoryTextfield)
        view.addArrangedSubview(categoryErrorlabel)
        view.spacing = 3
        return view
    }()
    
    lazy var selectCategoryTextfield: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.text = "Select"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var categoryErrorlabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.isHidden = true
        label.text = "this is category label"
        label.textAlignment = .right
        return label
    }()
    
    
    lazy var todoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.addArrangedSubview(todoTitle)
        view.addArrangedSubview(todoTitleErrorlabel)
        view.spacing = 3
        return view
    }()
    
    
    lazy var todoTitle: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.placeholder = "title"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var todoTitleErrorlabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.isHidden = true
        label.text = "this is the error label text for title"
        label.textAlignment = .right
        return label
    }()
    
    lazy var DueDatePicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.preferredDatePickerStyle = .automatic
        return datepicker
    }()
    
    
    
    
    lazy var collectionContainerView = UIView()
    
    lazy var ImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 80, height: 80)
        print(self.view.frame)
        print(self.collectionContainerView.frame)
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 300) , collectionViewLayout: layout)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2
        view.backgroundColor = .white
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addImageButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    lazy var dateTextField: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.placeholder = "Due Date (Optional)"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    
    lazy var dueDateStackView: UIStackView = {
        let view = UIStackView()
//        view.addArrangedSubview(dueDateLabel)
        view.addArrangedSubview(dateTextField)
        view.axis = .horizontal
        view.spacing = 5
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
        
    }()
    

   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupview()
        imagePicker.delegate = self
        if let credentialID = credentialID{
            arr = db.readCategoryTable(credentialID: credentialID)
        }
        
        createPickerView()
        dismissPickerView()
        createDatePicker()
        dismissDatePicker()
        
        // Do any additional setup after loading the view.
    }
    func createDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        dateTextField.inputView = datePicker
        
    }
    
    func dismissDatePicker(){
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(action))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([doneButton, cancelButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        dateTextField.inputAccessoryView = toolBar
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        selectCategoryTextfield.inputView = pickerView
    }
    
        
    func dismissPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(action))
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        selectCategoryTextfield.inputAccessoryView = toolbar
    }
    
    @objc func action(){
        
        view.endEditing(true)
    }
    
    @objc func cancel(){
        dateTextField.text = ""
        view.endEditing(true)
    }
    
    @objc func dateChanged(){
        dateTextField.text = Universal.converDateFormatter(datePicker.date)
    }
    
    
    @objc func saveButtonPressed(){
        shouldSave = true
        categoryErrorlabel.isHidden = true
        todoTitleErrorlabel.isHidden = true
        if selectedCategoryId == nil{
            categoryErrorlabel.text = "This field should not be empty."
            categoryErrorlabel.isHidden = false
            shouldSave = false
        }
        if todoTitle.text == ""{
            todoTitleErrorlabel.isHidden = false
            todoTitleErrorlabel.text = "This field should not be empty."
            shouldSave = false
        }
        
        if shouldSave {
            guard let categoryID = selectedCategoryId, let credentialID = credentialID else {return}
            let hasSaved = db.insertTodo(categoryID: categoryID, credentialID: credentialID, todoName: todoTitle.text ?? "", isCompleted: 0, dueDate: dateTextField.text ?? "")
            if hasSaved{
                let alertController = UIAlertController(title: "Done", message: "Todo has save successfully!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }else{
                todoTitleErrorlabel.isHidden = false
                todoTitleErrorlabel.text = "\(todoTitle.text ?? "" ) has already exist."
                
            }
        }
//        navigationController?.popViewController(animated: true)
    }
    
    @objc func addImageButtonPressed(){
        print("Button pressed")
        let alertController : UIAlertController = {
            let controller = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.openCamera()
            }
            let gallaryAction = UIAlertAction(title: "Gallery", style: .default) { (UIAlertAction) in
                self.openGallary()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cameraAction)
            controller.addAction(gallaryAction)
            controller.addAction(cancelAction)
            return controller
        }()
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }else{
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
                }()
                self.present(alertController, animated: true)
        }
    }
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }else{
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have photo Gallery", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
                }()
                self.present(alertController, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
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



extension AddTodoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
            guard let image = info[.originalImage] as? UIImage else {
                        fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                    }
            self.imageArray.append(image)
        ImageCollectionView.reloadData()
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
            self.dismiss(animated: true, completion: { () -> Void in

            })
        imageArray.append(image)
        }
    
}




extension AddTodoViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        arr[row].categoryName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategoryId = arr[row].id
        selectCategoryTextfield.text = arr[row].categoryName
    }
    
}


class ImageCollectionViewCell: UICollectionViewCell{
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension ImageCollectionViewCell{
    func setupView(){
        contentView.addSubview(imageView)
        imageView.edgesToSuperview()
    }
    
}
