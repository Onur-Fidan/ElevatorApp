//
//  Archives.swift
//  Elevatorr
//
//  Created by Onur Fidan on 27.07.2023.
//

import UIKit
import Parse

class ArchivesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedElevatorId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDatafromParse()
        
    }
    
    
    func getDatafromParse(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }else {
                if objects != nil {
                    
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    for object in objects! {
                        if let name = object.object(forKey: "buildingName") as? String {
                            if let placeId = object.objectId {
                                self.placeNameArray.append(name)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    
    @objc func addButtonClicked() {
        tabBarController?.selectedIndex = 1
    }
    
    
    
    func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}




//MARK: - TableView
extension ArchivesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC" {
            let destinations = segue.destination as! DetailsVC
            destinations.choosenElevatorId = selectedElevatorId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedElevatorId = placeIdArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
}
