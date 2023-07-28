//
//  ViewController.swift
//  Elevatorr
//
//  Created by Onur Fidan on 27.07.2023.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.setupUpImage(ImageName: "username")
        passwordTextField.setupUpImage(ImageName: "password")
    }
    
    
    
    @IBAction func signInClicked(_ sender: UIButton) {
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: " Email / Password ??")
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        
        if usernameTextField.text != "" && passwordTextField.text != ""{
            let user = PFUser()
            user.username = usernameTextField.text!
            user.password = passwordTextField.text!
            
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: " Email / Password ??")
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    


}

extension UITextField {
    
    func setupUpImage(ImageName : String) {
        
        let imageView = UIImageView(frame: CGRect(x: 17, y: 17, width: 20, height: 20))
        imageView.image = UIImage(named: ImageName)
        let imageViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        imageViewContainer.addSubview(imageView)
        leftView = imageViewContainer
        leftViewMode = .always
        self.tintColor = .lightGray
    }
}

