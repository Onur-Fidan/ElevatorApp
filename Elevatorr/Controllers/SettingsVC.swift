//
//  Settings.swift
//  Elevatorr
//
//  Created by Onur Fidan on 27.07.2023.
//

import UIKit
import Parse

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                self.performSegue(withIdentifier: "toSignUpVCfromSettings", sender: nil)
            }
        }
    }
    
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    
}
