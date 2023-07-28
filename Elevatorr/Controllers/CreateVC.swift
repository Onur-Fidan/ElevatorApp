//
//  CreateVC.swift
//  Elevatorr
//
//  Created by Onur Fidan on 27.07.2023.
//

import UIKit


class CreateVC: UIViewController{
    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var buildingNametextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    let typeOfElevatorArray = ["İnsan Asansörü", "Yük Asansörü", "Sedye Asansörü", "Araç Asansörü", "Panaromik Asansör", "Engelli Asansörü", "Yemek Asansörü"]
    
    var pickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
      
        
        pickerView.delegate = self
        pickerView.dataSource = self
        typeTextField.inputView = pickerView
        
        

        
    }
    
   
    @IBAction func continueClicked(_ sender: Any) {
        
        if typeTextField.text != "" && statusTextField.text != "" {
            if let choosenImage = imageView.image {
                let elevatorModel = ElevatorModel.elevator
                elevatorModel.elevatorType = typeTextField.text!
                elevatorModel.elevatorStatus = statusTextField.text!
                elevatorModel.buildingname = buildingNametextField.text!
                elevatorModel.elevatorImage = choosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            makeAlert(titleInput: "Error", messageInput: "Type / Status / İmage ??")
        }
        
    }
    
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}

//MARK: - UIPickerView Setting
extension CreateVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfElevatorArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfElevatorArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = typeOfElevatorArray[row]
        typeTextField.resignFirstResponder()
        
    }
    
}



//MARK: - Image
extension CreateVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func chooseImage() {
       let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    

    
}
