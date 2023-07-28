//
//  MapVC.swift
//  Elevatorr
//
//  Created by Onur Fidan on 27.07.2023.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - Mavigation Buttons
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        //MARK: - Get location
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
       
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
       
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = ElevatorModel.elevator.buildingname
            annotation.subtitle = ElevatorModel.elevator.elevatorType
            
            
            self.mapView.addAnnotation(annotation)
            
            ElevatorModel.elevator.placeLatitude = String(coordinates.latitude)
            ElevatorModel.elevator.placeLongitude = String(coordinates.longitude)
            
        }
    }
    
    
    

    @objc func saveButtonClicked() {
        //Parse
        let placeModel = ElevatorModel.elevator
        let object = PFObject(className: "Places")
        object["status"] = placeModel.elevatorStatus
        object["buildingName"] = placeModel.buildingname
        object["type"] = placeModel.elevatorType
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.elevatorImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground { success, error in
            if error != nil {
                  let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoArchivesVC", sender: nil)
            }
        }    }
    
    @objc func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

}


//MARK: - LOCATİON
extension MapVC: MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locationManager.stopUpdatingLocation() //Sadece bir kere lokasyonu günceller.
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}
