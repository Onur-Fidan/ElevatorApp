//
//  DetailsVC.swift
//  Elevatorr
//
//  Created by Onur Fidan on 27.07.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate{
    

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var choosenElevatorId = ""
    
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        getDataFromParse()
        mapView.delegate = self
        
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenElevatorId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            } else {
                if objects != nil {
                    let chosenPlaceObject = objects![0]
                    
                    //Object
                    
                    if let placeName = chosenPlaceObject.object(forKey:"buildingName") as? String {
                        self.nameLabel.text = placeName
                    }
                    
                    if let placeType = chosenPlaceObject.object(forKey:"type") as? String {
                        self.typeLabel.text = placeType
                    }
                    
                    if let status = chosenPlaceObject.object(forKey:"status") as? String {
                        self.statusLabel.text = status
                        
                    }
                    
                    if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                        if let placeLatitudeDouble = Double(placeLatitude) {
                            self.choosenLatitude = placeLatitudeDouble
                        }
                        
                    }
                    
                    if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                        if let placeLongitudeDouble = Double(placeLongitude) {
                            self.choosenLongitude = placeLongitudeDouble
                        }
                    }
                    
                    if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                        imageData.getDataInBackground { data, error in
                            if error == nil {
                                if data != nil {
                                    self.imageView.image = UIImage(data: data!)
                                }
                                
                            }
                        }
                    }
                    
                    
                    //Map
                    let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.mapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.nameLabel.text!
                    annotation.subtitle = self.typeLabel.text!
                    self.mapView.addAnnotation(annotation)
                    
                }
                
            }
        }
        
    }
 
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    
   
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLongitude != 0.0 && self.choosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.nameLabel.text
                        let launchOption = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOption)
                    }
                }
            }
            
        }
    }

    

}
